function Stim0CollectResponse( appHandle )

global connected debug in
global responseBoxHandler
global print_var
global portAudio
global responseCorrectnessFeedback

% Received legit answer sound
 a = [ones(22,200);zeros(22,200)];
 a_legit = a(:)';
% Time Out Sound
a = [ones(220,25);zeros(220,25)];
a_timeout = a(:)';
% received non legit answer sound
a = [ones(110,50);zeros(110,50)];
a_non_legit = a(:)';

        

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
            end
        end
    end

%%%%%%%%%%%         avi add that for automatic answer.
% % % % % % % %         timeToWait  = rand;
% % % % % % % %         elapsedTime = tic;
% % % % % % % %         while(toc(elapsedTime) < timeToWait)
% % % % % % % %         end
% % % % % % % %         
% % % % % % % %         response = randi(2);
        
        if(response == 0)   %no choice or pressed an illegal button
            display('R/L Choice timeout');
        end
        
        %%
        %make the sound of given answr or not, only if not giving feedback
        %correctness in the analyze stage.
        if  responseCorrectnessFeedback == 0
            if response == 1 || response == 2 
                PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
                PsychPortAudio('Start', portAudio, 1,0);
            elseif response == 0
                PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
                PsychPortAudio('Start', portAudio, 1,0);
            else 
                 PsychPortAudio('FillBuffer', portAudio, [a_non_legit;a_non_legit]);
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
if(flagdata.enableConfidenceChoice)
    if confidenceResponse == 3 || confidenceResponse == 4 
        PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
        PsychPortAudio('Start', portAudio, 1,0);
    else 
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
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp')
end


end

