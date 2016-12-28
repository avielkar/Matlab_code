function collectResp_Rot(appHandle)

global connected debug in
if debug
    disp('Entering collectResp_Rot')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp; % ---Jing and added 01/29/07---

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
if (response == 1 || response == 2) && cldata.responeInMiddle == 1
    % Received legit answer sound
    a = [ones(1,200); zeros(1,200)];
    a = a(:)';
    soundsc(a,2000);
    disp('time out 1');
elseif response == 4 
else
    % Time Out Sound
    a = [ones(10,25); zeros(10,25)];
    a = a(:)';
    soundsc(a,2000);
    disp('time out 2');
end
%++++++++++++++++++++++++++++++++++
activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
activeRule = data.activeRule;
savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp_Rot')
end
