 function collectRespFourResponses(appHandle)

global connected debug in
global responseBoxHandler
global print_var
global startPressStartTime
global portAudio
global responseCorrectnessFeedback
global basicfig

% Received legit answer sound
a = [ones(22,200);zeros(22,200)];
a_legit = a(:)';
% Time Out Sound
a = [ones(220,25);zeros(220,25)];
a_timeout = a(:)';

responseTime = -1;
confidenceResponseTime = -1;

feedback1String = 'null feedback 1'
feedback2String = 'null feedback 2'

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

i_RESPONSE_BUTTON_MAPPINGS = strmatch('RESPONSE_BUTTON_MAPPINGS',{char(data.configinfo.name)},'exact');
if ~isempty(i_RESPONSE_BUTTON_MAPPINGS)
    responseButtonOption = data.configinfo(i_RESPONSE_BUTTON_MAPPINGS).parameters;    
else
    responseButtonOption = 1;
end    
[enable_right, enable_left , enable_up ,enable_down] = GetResponseOptionalButtons(responseButtonOption , is2Interval);

if connected && ~debug
    % Configure Port
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
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
                if (strcmp(press.buttonID , 'left') && press.action == 1)
                    response = 1;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Left');
                    feedback1String = 'Choice = Left';
                    break;
                elseif (strcmp(press.buttonID , 'right') && press.action == 1)
                    response = 2;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Right');
                    feedback1String = 'Choice = Right';
                    break;
                elseif (strcmp(press.buttonID , 'top') && press.action == 1)
                    response = 3;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Up');
                    feedback1String = 'Choice = Up';
                    break;
                elseif (strcmp(press.buttonID , 'bottom') && press.action == 1)
                    response = 4;
                    responseTime = toc(startPressStartTime);
                    display('Choice = Down');
                    feedback1String = 'Choice = Down';
                    break;
                end
                fprintf('byteas available but not a red press!!!!\n')
            end
        end
        
        if(response == 0)   %no choice or pressed an illegal button
            display('R/L Choice timeout');
            feedback1String = 'R/L Choice timeout';
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
    else
        %reset the flag for the next iteration
        response = cldata.resp;
        cldata.in_the_middle_response = 0;
        setappdata(appHandle,'ControlLoopData',cldata);
    end
    
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
        if (strcmp(debugResponse,'f') && enable_right) %right
            display('Choice = Right' );
            feedback1String = 'Choice = Right';
            response = 2;
            break;
        elseif (strcmp(debugResponse,'d') && enable_left) %left
            display('Choice = Left');
            feedback1String = 'Choice = Left';
            response = 1;
            break;
        elseif (strcmp(debugResponse,'e') && enable_up) %up
            display('Choice = Up');
            feedback1String = 'Choice = Up';
            response = 3;
            break;
        elseif (strcmp(debugResponse,'x') && enable_down) %down
            display('Choice = Down');
            feedback1String = 'Choice = Down';
            response = 4;
            break;
        elseif strcmp(debugResponse,'i')
            response = 0;
            break;
        end
        %pause(cldata.respTime);
    end
    
    %reset the debug response
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
        high_confidence_response = 'e'; %default
        low_confidence_response = 'x'; %default
        middle_confidence_response = 'empty'; %default
        
        iCONFIDENCE_BUTTON_RESPONSE_OPTION = strmatch('CONFIDENCE_BUTTON_RESPONSE_OPTION',{char(data.configinfo.name)},'exact');
        if ~isempty(iCONFIDENCE_BUTTON_RESPONSE_OPTION)
            button_option = data.configinfo(iCONFIDENCE_BUTTON_RESPONSE_OPTION).parameters;
            if button_option == 1
                high_confidence_response = 'e';
                low_confidence_response = 'x';
                middle_confidence_response = 'empty';
            elseif button_option == 2
                high_confidence_response = 'x';
                low_confidence_response = 'e';
                middle_confidence_response = 'empty';
            elseif button_option == 3
                high_confidence_response = 'f';
                low_confidence_response = 'd';
                middle_confidence_response = 'empty';
            elseif button_option == 4
                high_confidence_response = 'd';
                low_confidence_response = 'f';
                middle_confidence_response = 'empty';

            elseif button_option == 5
                high_confidence_response = 'e';
                low_confidence_response = 'x';
                middle_confidence_response = 's';
            elseif button_option == 6
                high_confidence_response = 'x';
                low_confidence_response = 'e';
                middle_confidence_response = 's';
            elseif button_option == f
                high_confidence_response = 'f';
                low_confidence_response = 'd';
                middle_confidence_response = 's';
            elseif button_option == 8
                high_confidence_response = 'd';
                low_confidence_response = 'f';
                middle_confidence_response = 's';
            end
        end  
        
        confidenceResponse = 0; 
        tic
        while(toc <= cldata.respTime)
          pause(0.1);
          debugResponse = getappdata(appHandle , 'debugResponse');
          if strcmp(debugResponse, high_confidence_response) %up buttom
              confidenceResponse = 3;
              display('Confidence choice  =  High');
              feedback2String = 'Confidence choice  =  High';
              break;
          elseif strcmp(debugResponse, low_confidence_response)  %down buttom
              confidenceResponse = 4;
              display('Confidence choice = Low');
              feedback2String = 'Confidence choice = Low';
              break;
          elseif strcmp(debugResponse, middle_confidence_response)  %down buttom
              confidenceResponse = 5;
              display('Confidence choice = Center');
              feedback2String = 'Confidence choice = Center';
              break;
          end
        end
    end
    
    debugResponse = ''; 
    setappdata(appHandle , 'debugResponse' , debugResponse);
    

    if(confidenceResponse == 0) %no choice or pressed an illegal button
        display('Confidence Choice Timeout');
        feedback2String = 'Confidence Choice Timeout';
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

%update feedback window

trialfeedbackInfo = get(findobj(basicfig,'Tag','listBoxFeedbackTrial') , 'String');
trialfeedbackInfo{end+1} = feedback1String;
trialfeedbackInfo{end+1} = feedback2String;
set(findobj(basicfig,'Tag','listBoxFeedbackTrial') , 'String' , trialfeedbackInfo);

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
