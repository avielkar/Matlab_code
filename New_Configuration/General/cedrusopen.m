function cedrusopen
% Get button presses from Cedrus button box in XID mode.
%
% Typical Usage:
%
% cedrusopen;      % always call first to init structure and open port
% while <something>
%   cedrus.resettimer();
%   disp 'press a button'
%   [button time] = cedrus.waitpress(5);
%   if button == 0
%     disp 'No button pressed in 5 seconds'
%   else
%     fprintf('Button %d - Reaction Time: %d ms', button, time);
%   end
% end
% cedrus.releases = 1;  % record presses and releases
% while <something>
%   cedrus.resettimer();
%   disp 'press a button'
%   <do something else>
%   [button time press] = cedrus.getpress()
%   if button == 0
%     disp 'No button presses available'
%   else
%     pr = {"release", "press"};
%     fprintf('Button %d %s - Reaction Time: %d ms', button, pr{press+1}, time);
%   end
% end
% cedrus.close();   % close port and remove control structure
%
% Program Notes:
% Any button use creates 2 events, press and release.
% Set cedrus.releases = 1 to return releases and presses.
% By default it is 0, only presses are returned.
% Button events are stored in a FIFO stack.
% resettimer clears any events left unread and zeros the timer.
% cedrus.count = number of events on the stack.
% event parameters returned by waitpress and getpress: 
%   button = 1-6 representing button pressed
%   press = true or false: true = press, false = release 
%   time = time of the event in milliseconds since last resettimer call
% getpress returns first event on the stack or button = 0 if there are no 
%   events on the stack.
% waitpress(<t>) waits for a button event or times out after <t> sec.
%   <t> defaults to 60 sec. Returns button = 0 if timeout with no event.

% other functions:
% info - return string with type of response box and firmware rev
% trip - measures round trip delay time of USB
% stream - run stream test - doesn't seem to work - Cedrus problem

% XID mode notes:
% on any button event, device sends six bytes in the following format:
% k<KeyInfo><ReactionTime>:
% The first character is simply the letter k, lower case
% The second character is Key Info, divided as follows:
% Bits 0-3 (LSB 0 numbering) = port number.
%  Lumina LP-400: 0 = push buttons & scanner trigger; 1 = RJ45.
%  SV?1: no port 0, 1 = RJ45, 2 = voice key.
%  RB-x30 response pads: 0 = push buttons, 1 = RJ45.
% Bit 4 = action flag. set = button pressed, clear = button released.
% Bits 5-7 indicate which push button was pressed.
% Reaction time = four bytes - time elapsed (ms) since reaction time timer
% was last reset. Command "e5" resets timer.
% Information taken from http://www.cedrus.com/xid/protocols.htm
% and http://www.cedrus.com/xid/timing.htm

% MATLAB notes:
% if the program fails leaving the cedrus box port open do the following
% to close it rather than restarting Matlab:
%   if the global cedrus is defined in user workspace use:
%     cedrus.close()
%   if the global cedrus is not there or the above fails use:
%     a = instrfind; fclose(a);

%% find cedrus box
global cedrus;
if isstruct (cedrus) && isfield (cedrus, 'port') 
    errordlg ('cedrus already open');
    return
end
evalin ('caller', 'global cedrus'); % define the cedrus global in caller
switch computer('arch')
    case {'maci', 'maci64'}   % device name is different for each Cedrus box
        cedrus.dev = 0;
        s = instrhwinfo ('serial');
        for p = 1:length(s.AvailableSerialPorts)
            if (strfind (s.AvailableSerialPorts{p}, ...
                    '/dev/tty.usbserial-FT') == 1)
                cedrus.dev = s.AvailableSerialPorts{p};
                break
            end
        end
        if (~ cedrus.dev)
            errordlg ('Can''t find Cedrus response box')
            return
        end
        clear s p;
    case {'win32', 'win64'} % all our PC's have Cedrus box on COM9
        cedrus.dev = 'COM9'; % others may need to change
    otherwise
        errordlg ('Unsupported OS %s', computer('arch'))
        return
end

%% init struct with callbacks, event queue, releases flag, timer callback
% port framing, open port, set to XID mode, reset the timer
cedrus.getpress = @cedrusgetpress;
cedrus.resettimer = @cedrusresettimer;
cedrus.waitpress = @cedruswaitpress;
cedrus.close = @cedrusclose;
cedrus.info = @cedrusinfo;
cedrus.trip = @cedrustrip;
cedrus.stream = @cedrusstream;
cedrus.event = {};
cedrus.releases = 0;  % by default, return only presses
% timer: executes TimerFcn (null function) 60 sec after timer start
cedrus.timer = timer('TimerFcn', @(~,~)0, 'StartDelay', 60);
% set so cedrusread is called whenever 6 bytes are in the buffer
cedrus.port = serial(cedrus.dev, 'BaudRate', 115200, 'DataBits', 8, ...
    'StopBits', 1, 'FlowControl', 'none', 'Parity', 'none', ...
    'BytesAvailableFcnMode', 'byte', 'BytesAvailableFcnCount', 6, ...
    'BytesAvailableFcn', @cedrusread);
fopen(cedrus.port);
fprintf(cedrus.port,['c10', char(13)]); %XID mode
cedrusresettimer

%% reset reaction timer - also clears button event queue
function cedrusresettimer
global cedrus;
fprintf(cedrus.port,['e5',char(13)]);
cedrus.count = 0;

%% read button press and store in event fifo
% this is a serial callback when 6 chars are in serial buffer
function cedrusread (~, ~)
global cedrus;
global cedrus_result;
r = uint32(fread(cedrus.port,6));
% byte 2 determines button number, press/release and port
press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
if press || cedrus.releases
  button = bitshift (r(2), -5);    %leftmost 3 bits
  % skip the port since we always use the buttons
  % port = bitand(r(2), 15);       %binary 01111 bottom 4 bits
  % bytes 3-6 - the time elapsed in milliseconds 
  time = ((r(6) * 256 + r(5)) * 256 + r(4)) * 256 + r(3);
%   cedrus.count = cedrus.count + 1;
%   cedrus.event{cedrus.count} = [button time press];
  cedrus_result = button;
  % stop timer if it's running (cedruswaitpress) so wait completes
  if strcmp(get(cedrus.timer, 'Running'), 'on') == 1
      stop (cedrus.timer);
  end
end

%% get first event off fifo, extract info and return it
% use circshift but count makes it work like a fifo
function [button time press] = cedrusgetpress
global cedrus;
if cedrus.count > 0
  button = cedrus.event{1}(1);
  time   = cedrus.event{1}(2);
  press  = cedrus.event{1}(3);
  cedrus.event = circshift(cedrus.event, [0,-1]);
  cedrus.count = cedrus.count - 1;
else
  button = 0; time = 0; press = 0;
end

%% wait for a button event
function [button time press] = cedruswaitpress (varargin)
global cedrus;
% any events already stored?
[button time press] = cedrusgetpress;
% if not, wait for timeout time or button event whichever comes first
if button == 0
  % change delay if user supplied one
  if ~isempty(varargin)
      set(cedrus.timer, 'StartDelay', varargin{1});
  end
  start (cedrus.timer);
  wait (cedrus.timer);
  %[button time press] = cedrusgetpress;
end

%% close port
function cedrusclose
global cedrus;
if ~isfield (cedrus, 'port') 
    errordlg ('cedrus not open');
    return
end
fclose(cedrus.port);
clear global cedrus;

%% get box info
function cedrusinfo
global cedrus;
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', '');
set(cedrus.port, 'TimeOut', 5);
set(cedrus.port, 'Terminator', 13);
fopen(cedrus.port);
% send query command
fprintf(cedrus.port,['_d1',char(13)]);
r1 = fgets(cedrus.port);
r2 = fgets(cedrus.port);
cedrus.r = [r1, r2];
fprintf(cedrus.port,['_d3',char(13)]);
r1 = fread(cedrus.port,1);
fprintf(cedrus.port,['_d4',char(13)]);
r2 = fread(cedrus.port,1);
cedrus.r = [cedrus.r, 'Firmware: ', r1, '.', r2];
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', @cedrusread);
fopen(cedrus.port);


%% cedrus test code - not completely implemented by Cedrus - seems to work
function cedrustrip(n)
global cedrus;
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', '');
fopen(cedrus.port);
times = zeros(1,n);
for i = 1:n
    % send trip test command
    fprintf(cedrus.port,['e4',char(13)]);
    % read X back from box
    r = uint32(fread(cedrus.port,1));
    % send the X back to the box
    fprintf(cedrus.port,[r(1),char(13)]);
    % read reply from box containing time from when it sent the X to when it
    % got the X back - round trip delay time
    r = uint32(fread(cedrus.port,4));
    if (r(1) ~= 80) && (r(2) ~= 84) % PT
        %cedrusclose();
        error ('invalid reply (PT)')
    end
    times(i) = double(r(4) * 256 + r(3));
    pause(1);
end
times
fprintf ('Average Round Trip Delay: %6.3f +- %6.3fms\n', mean(times), ...
    std(times));
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', @cedrusread);
fopen(cedrus.port);

function cedrusstreamerr(~,~)
global cedrus
cedrus.run = 0;
disp 'timeout error'

%% another cedrus test function - not completely implemented by Cedrus
% does not seem to work at all
function cedrusstream
global cedrus
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', '');
set(cedrus.port, 'InputBufferSize', 2000);
set(cedrus.port, 'Timeout', 2);
set(cedrus.port, 'ErrorFcn', @cedrusstreamerr);
fopen(cedrus.port);
i = 0;
c{2233} = 0;
t = zeros(1,2233);
cedrus.run = 20;
fprintf(cedrus.port,['e6',char(13)]);
tic;
while cedrus.run
    k = get(cedrus.port,'BytesAvailable');
    if (k == 0)
        cedrus.run = cedrus.run - 1;
    else
        r = fread(cedrus.port, k);
        i = i + 1;
        t(i) = toc;
        c{i} = r;
    end
end
cedrus.t = t;
cedrus.c = c;
fclose(cedrus.port);
set(cedrus.port, 'BytesAvailableFcn', @cedrusread);
set(cedrus.port, 'ErrorFcn', '');
fopen(cedrus.port);
