function oneincollectResp(appHandle)

global connected debug
if debug
    disp('Entering oneincollectResp')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
Resp = getappdata(appHandle,'ResponseInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp; 

if connected
    % Configure Port
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
        disp(['WRONG cbDConfigPort ' str])
    end
    
    tic
    while  (toc <= cldata.respTime) && (response == 0)   
        response = cbDIn(boardNum, portNum);% boardNum = 1, DigPort = 1
        % Response 1 = left,down, 2 = right,up, 4 = Don't Know, 0 = no answer, Other =
        % something's messed up (Two buttons, or other bits high)
    end
else            
    in = input('Left[d] or Right[f]? ', 's');
    if strcmp(in,'f')
        response = 2;
    elseif strcmp(in,'d')
        response = 1;
    elseif strcmp(in,'i')
        response = 4;
    else
        response = 0;
    end
end
% disp(response)
% Feedback for 'Received Answer' case ++++++++++
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
end
%++++++++++++++++++++++++++++++++++
Resp(data.repNum).response(trial.cntr) = response;
setappdata(appHandle,'ResponseInfo',Resp);


if debug
    disp('Exiting oneincollectResp')
end
