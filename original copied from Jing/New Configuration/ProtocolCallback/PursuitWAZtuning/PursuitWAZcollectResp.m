function PursuitWAZcollectResp(appHandle)

global connected debug in
if debug
    disp('PursuitWAZcollectResp')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp;

if connected && ~debug

    tic
    moogsent='';
    if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')
        outString='BACKGROUND_ON 0';
        disp(outString)

        if connected
            cbDWriteString(0, sprintf('%s\n', outString),5);
        end
        
        outString='FP_ON 0';
        disp(outString)

        if connected
            cbDWriteString(0, sprintf('%s\n', outString),5);
        end
        
        outString='ENABLE_CYLINDERS 1';
        disp(outString)

        if connected
            cbDWriteString(0, sprintf('%s\n', outString),5);
        end
    end
    
    while  (toc <= cldata.respTime) && isempty(moogsent)
        moogsent=CBWDReadString(0, 5, 512*12); 
        if ~isempty(moogsent)
            disp(moogsent);
            break;
        end
    end

    response=str2double(moogsent(strfind(moogsent,'CYLINDER_DEGREE=')+max(size('CYLINDER_DEGREE=')):end));
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

% % Feedback for 'Received Answer' case ++++++++++
% %%%if response == 1 || response == 2
% %%%    % Received legit answer sound
% %%%    a = [ones(1,200); zeros(1,200)];
% %%%    a = a(:)';
% %%%    soundsc(a,2000);
% elseif response == 4
% else
%     % Time Out Sound
%     a = [ones(10,25); zeros(10,25)];
%     a = a(:)';
%     soundsc(a,2000);
%end
%++++++++++++++++++++++++++++++++++
activeStair = data.activeStair;
activeRule = data.activeRule;
savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('PursuitWAZcollectResp')
end
