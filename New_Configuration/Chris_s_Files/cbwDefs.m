% Port ID's
FIRSTPORTA = 10;
FIRSTPORTB = 11;
FIRSTPORTCL = 12;
FIRSTPORTCH = 13;
SECONDPORTA = 14;
SECONDPORTB = 15;
SECONDPORTCL = 16;
SECONDPORTCH = 17;

% Status values
IDLE = 0;
RUNNING = 1;

% Option Flags
FOREGROUND = hex2dec('0000');    % Run in foreground, don't return till done
BACKGROUND = hex2dec('0001');    % Run in background, return immediately

SINGLEEXEC = hex2dec('0000');    % One execution
CONTINUOUS = hex2dec('0002');    % Run continuously until cbstop() called

TIMED = hex2dec('0000');    	 % Time conversions with internal clock
EXTCLOCK = hex2dec('0004');      % Time conversions with external clock

NOCONVERTDATA = hex2dec('0000'); % Return raw data
CONVERTDATA = hex2dec('0008');   % Return converted A/D data

NODTCONNECT = hex2dec('0000');   % Disable DT Connect
DTCONNECT = hex2dec('0010');     % Enable DT Connect

DEFAULTIO = hex2dec('0000');     % Use whatever makes sense for board
SINGLEIO = hex2dec('0020');      % Interrupt per A/D conversion
DMAIO = hex2dec('0040');         % DMA transfer
BLOCKIO = hex2dec('0060');       % Interrupt per block of conversions
BURSTIO = hex2dec('10000');      % Transfer upon scan completion
RETRIGMODE = hex2dec('20000');   % Re-arm trigger upon acquiring trigger count samples

BYTEXFER = hex2dec('0000');      % Digital IN/OUT a byte at a time
WORDXFER = hex2dec('0100');      % Digital IN/OUT a word at a time

INDIVIDUAL = hex2dec('0000');    % Individual D/A output
SIMULTANEOUS = hex2dec('0200');  % Simultaneous D/A output

FILTER = hex2dec('0000');        % Filter thermocouple inputs
NOFILTER = hex2dec('0400');      % Disable filtering for thermocouple

NORMMEMORY = hex2dec('0000');    % Return data to data array
EXTMEMORY = hex2dec('0800');     % Send data to memory board ia DT-Connect

BURSTMODE = hex2dec('1000');     % Enable burst mode

NOTODINTS = hex2dec('2000');     % Disbale time-of-day interrupts

EXTTRIGGER = hex2dec('4000');    % A/D is triggered externally

NOCALIBRATEDATA = hex2dec('8000');  % Return uncalibrated PCM data
CALIBRATEDATA = hex2dec('0000');    % Return calibrated PCM A/D data

ENABLED = 1;
DISABLED = 0;

UPDATEIMMEDIATE = 0;
UPDATEONCOMMAND = 1;

% Types of digital input ports
DIGITALOUT = 1;
DIGITALIN = 2;