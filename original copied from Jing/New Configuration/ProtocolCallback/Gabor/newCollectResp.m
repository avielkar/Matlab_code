function collectResp(appHandle)

global connected debug
if debug
    disp('Entering collectResp new')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
stairInfo = getappdata(appHandle,'stairInfo');
%crossVals = getappdata(appHandle,'CrossVals');----jing comment out.01/16/07
Resp = getappdata(appHandle,'ResponseInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
%response = 0; % init %---Jing comment out  01/29/07---
response = cldata.resp; % ---Jing and added 01/29/07---


% connected = 1;
if connected
    % Configure Port
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
        disp(['WRONG cbDConfigPort ' str])
    end
    
    tic
    while  (toc <= cldata.respTime) && (response == 0)
    %while  (toc <= cldata.respTime) && (response ~= 1) && (response ~= 2)
        response = cbDIn(boardNum, portNum);% boardNum = 1, DigPort = 1
        % Response 1 = left,down, 2 = right,up, 4 = Don't Know, 0 = no answer, Other =
        % something's messed up (Two buttons, or other bits high)
    end
else            
    in = input('Right[j], Left[f], Don''t Know[i]?','s');
    if strcmp(in,'j')
        response = 2;
    elseif strcmp(in,'f')
        response = 1;
    elseif strcmp(in,'i')
        response = 4;
    else
        response = 0;
    end
end
% disp(response)
% Feedback for 'Received Answer' case ++++++++++
if response == 1 || response == 2 || response == 4 
    % Received legit answer sound
    a = [ones(1,200); zeros(1,200)];
    a = a(:)';
    soundsc(a,2000);
else
    % Time Out Sound
    a = [ones(10,25); zeros(10,25)];
    a = a(:)';
    soundsc(a,2000);
end
%++++++++++++++++++++++++++++++++++
Resp(stairInfo.currStair).response(stairInfo.trialCount(stairInfo.currStair)) = response;
setappdata(appHandle,'ResponseInfo',Resp);

if debug
    disp('Exiting collectResp new')
end
