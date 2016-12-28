function Conflict_collectResp(appHandle)

global connected debug isTimeout
if debug
    disp('Entering Conflict_CollectResp')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
activeStair = data.activeStair; 
activeRule = data.activeRule;

COMBOARDNUM = 0;

outString= 'FP_ON 0';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end
if debug
    disp(outString);
end

response = getResponse(appHandle);

savedInfo(activeStair,activeRule).Resp(data.repNum).response1(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if ~isTimeout
    tic
    while toc < 0.3
    end;
    outString = 'FP_COLOR 0 1 0';
    if connected
        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    end
    if debug
        disp(outString);
    end

    response = getResponse(appHandle);
end

outString = 'FP_COLOR 1 1 0';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end
if debug
    disp(outString);
end

savedInfo(activeStair,activeRule).Resp(data.repNum).response2(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting Conflict_CollectResp')
end



function response = getResponse(appHandle)
global connected debug in isTimeout

cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp; 
COMBOARDNUM = 0;

outString = 'TARG1_ON 1';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end

if debug
    disp(outString);
end

outString = 'TARG2_ON 1';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end

if debug
    disp(outString);
end

if connected && ~debug    
    % Configure Port
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
        disp(['WRONG cbDConfigPort ' str])
    end
    
    tic
    while  (toc <= cldata.respTime) && (response == 0)
        response = cbDIn(boardNum, portNum);% boardNum = 1, DigPort = 1
        response = mod(response, 8);%---Jing for light control 12/03/07
        % Response 1 = left,down, 2 = right,up, 4 = Don't Know, 0 = no answer, 
        % Other = something's messed up (Two buttons, or other bits high)
    end
elseif (connected && debug) || (~connected && debug)           
    disp('Press Left/Right Button in Debug Window for response');
    tic
    while  (toc <= cldata.respTime) && (strcmp(in,'')==1)
        DebugWindow;
        pause(cldata.respTime);
    end
    if strcmp(in,'f')
        response = 2;
    elseif strcmp(in,'d')
        response = 1;
    elseif strcmp(in,'i')
        response = 4;
    else
        response = 0;
    end
    in = '';  
end

% Feedback for 'Received Answer' case ++++++++++
isTimeout = 0; 
if response == 1 || response == 2
    % Received legit answer sound
    a = [ones(1,200); zeros(1,200)];
    a = a(:)';
    soundsc(a,2000);
elseif response == 4 
else
    % Time Out Sound
    a = [ones(10,25); zeros(10,25)];
    a = a(:)';
    soundsc(a,2000);
    isTimeout = 1;  
end

outString = 'TARG1_ON 0';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end
if debug
    disp(outString);
end

outString = 'TARG2_ON 0';
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end
if debug
    disp(outString);
end
