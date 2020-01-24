 function collectResp(appHandle)

global connected debug in
global responseBoxHandler
global print_var
global startPressStartTime
global portAudio
global responseCorrectnessFeedback

% Received legit answer sound
a = [ones(22,200);zeros(22,200)];
a_legit = a(:)';
% Time Out Sound
a = [ones(220,25);zeros(220,25)];
a_timeout = a(:)';

responseTime = -1;
confidenceResponseTime = -1;

if debug
    disp('Entering collectResp')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp; % ---Jing and added 01/29/07---
confidenceResponse = 0;
flagdata = getappdata(appHandle,'flagdata');
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;
if(motiontype == 3)
    is2Interval = true;
else
    is2Interval = false;
end

if connected && ~debug
    % Configure Port
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
%         disp(['WRONG cbDConfigPort ' str])
    end
    
    tic
    display('======================');
    display('waiting for answer');
    display('======================');
    response = 0;
    %if there was not response in the middle of the movement and it was enabled
    %so wait for a resposne
    if(cldata.resp == 0)
        while(toc <= cldata.respTime)
            press = CedrusResponseBox('GetButtons', responseBoxHandler);
            if(~isempty(press))
                if (strcmp(press.buttonID , 'left') && ~is2Interval)
                    response = 1;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Left');
                    break;
                elseif (strcmp(press.buttonID , 'right') && ~is2Interval)
                    response = 2;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Right');
                    break;
                elseif (strcmp(press.buttonID , 'top') && is2Interval)
                    response = 3;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Up');
                    break;
                elseif (strcmp(press.buttonID , 'bottom') && is2Interval)
                    response = 4;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Down');
                    break;
                end
                fprintf('byteas available but not a red press!!!!\n')
            end
        end

%%%%%%%%%%%         avi add that for automatic answer.
%         timeToWait  = rand;
%         elapsedTime = tic;
%         while(toc(elapsedTime) < timeToWait)
%         end
%         
%         response = randi(2);
        
        if(response == 0)   %no choice or pressed an illegal button
            display('R/L Choice timeout');
        end
        
        %%
        %make the sound of given answr or not, only if not giving feedback
        %correctness in the analyze stage.
        if  responseCorrectnessFeedback == 0
            if response == 1 || response == 2 || response == 3 || response == 4
                % Received legit answer sound
                PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
                PsychPortAudio('Start', portAudio, 1,0);
            else
                % Time Out Sound
                 PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
                 PsychPortAudio('Start', portAudio, 1,0);
            end
        end
        %%
        
        %if a answer was made and the option for confidence answer is on.
        if(response ~= 0 && flagdata.enableConfidenceChoice == 1)
            tic
            while(toc <=  cldata.respTime)
                press = CedrusResponseBox('GetButtons', responseBoxHandler);
                if(~isempty(press))
                    if strcmp(press.buttonID , 'top')            
                        confidenceResponse = 3;
                        confidenceResponseTime = toc(startPressStartTime);
                        display('Confidence choice  =  High');
                        break;
                    elseif strcmp(press.buttonID , 'bottom')
                        confidenceResponse = 4;
                        display('Confidence choice = Low');
                        confidenceResponseTime = toc(startPressStartTime);
                        break;
                        
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
            end
            
            if(confidenceResponse == 0) %no choice or pressed an illegal button
                display('Confidence Choice Timeout');
            end
        end
        
    else
        %reset the flag for the next iteration
        response = cldata.resp;
        cldata.in_the_middle_response = 0;
        setappdata(appHandle,'ControlLoopData',cldata);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new changes%%%%%%%%%%%%%%%%
    %s = CBWDReadString(0 ,2 , 500);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end of changes%%%%%%%%%%%%%
    
    if(print_var)
        fprintf('The result at the end is hell of is %d \n',response);
    end
elseif (connected && debug) || (~connected && debug)
    in = '';
    disp('Press Left/Right Button in Debug Window for response');
    tic
    response = 0;
    while  (toc <= cldata.respTime)
        pause(0.1);
        debugResponse = getappdata(appHandle , 'debugResponse');
        if (strcmp(debugResponse,'f') && ~is2Interval) %right
            display('Choice = Right' );
            response = 2;
            break;
        elseif (strcmp(debugResponse,'d') && ~is2Interval) %left
            display('Choice = Left');
            response = 1;
            break;
        elseif (strcmp(debugResponse,'e') && is2Interval) %up
            display('Choice = Up');
            response = 3;
            break;
        elseif (strcmp(debugResponse,'x') && is2Interval) %down
            display('Choice = Down');
            response = 4;
            break;
        elseif strcmp(debugResponse,'i')
            response = 5;
            break;
        end
        %pause(cldata.respTime);
    end
    
    debugResponse = ''; 
    setappdata(appHandle , 'debugResponse' , debugResponse);
    
    %%
    %make the sound of given answr or not, only if not giving feedback
    %correctness in the analyze stage.
    if  responseCorrectnessFeedback == 0
        if response == 1 || response == 2 || response == 3 || response == 4
            PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
            PsychPortAudio('Start', portAudio, 1,0);
        else
             PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
             PsychPortAudio('Start', portAudio, 1,0);
        end
    end
    %%
    

    %if a answer was made and the option for confidence answer is on.
    if(response ~= 0 && flagdata.enableConfidenceChoice == 1)
        confidenceResponse = 0; 
        tic
        while(toc <= cldata.respTime)
          pause(0.1);
          debugResponse = getappdata(appHandle , 'debugResponse');
          if strcmp(debugResponse,'e') %up buttom
              confidenceResponse = 3;
              display('Confidence choice  =  High');
              break;
          elseif strcmp(debugResponse,'x')  %down buttom
              confidenceResponse = 4;
              display('Confidence choice = Low');
              break;
          end
        end
    end
    
    debugResponse = ''; 
    setappdata(appHandle , 'debugResponse' , debugResponse);
    

    if(confidenceResponse == 0) %no choice or pressed an illegal button
        display('Confidence Choice Timeout');
    end
end


% Feedback for 'Received Answer' case ++++++++++
if(flagdata.enableConfidenceChoice)
    if confidenceResponse == 3 || confidenceResponse == 4 
        % Received legit answer sound
        PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
        PsychPortAudio('Start', portAudio, 1,0);
    else
        % Time Out Sound
         PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
         PsychPortAudio('Start', portAudio, 1,0);
    end
end
%++++++++++++++++++++++++++++++++++
fprintf('THE RESPONSE IS %d\n' , response);

activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
activeRule = data.activeRule;
savedInfo(activeStair,activeRule).Resp(data.repNum).responseTime(trial(activeStair,activeRule).cntr) = responseTime;
savedInfo(activeStair,activeRule).Resp(data.repNum).confidenceResponseTime(trial(activeStair,activeRule).cntr) = confidenceResponseTime;
savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
savedInfo(activeStair,activeRule).Resp(data.repNum).confidence(trial(activeStair,activeRule).cntr) = confidenceResponse;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp')
end
