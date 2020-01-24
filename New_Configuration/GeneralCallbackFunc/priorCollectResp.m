function priorCollectResp(appHandle)

global connected debug in
global responseBoxHandler
global print_var
global startPressStartTime
global portAudio
global responseCorrectnessFeedback

if debug
    disp('Entering PriorCollectResp')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
cldata = getappdata(appHandle,'ControlLoopData');
boardNum = 1; % Acquistion board
portNum = 1; % Dig Port #
direction = 1;
response = cldata.resp; % ---Jing and added 01/29/07---
press = 0;
debugResponse = 0;
responseTime = -1;

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
    press = 0;
    %if there was not response in the middle of the movement and it was enabled
    %so wait for a resposne
    if(cldata.resp == 0)
        if(cldata.is_flashing_priors == false)
            %if not a flashing prior type trial.
            while(toc <= cldata.respTime)
                press = CedrusResponseBox('GetButtons', responseBoxHandler);
                if(~isempty(press))
                      response = press.buttonID;
                      if(strcmp(response , 'left')) %left buttom
                          response = 1;
                          responseTime = toc(startPressStartTime);
                      elseif(strcmp(response , 'right'))  %right buttom
                          response = 2;
                          responseTime = toc(startPressStartTime);
                      else
                          response = 0; 
                      end
                end

                if(response ~= 0)
                    display('YESSSSSSSSSSSSSSSSSSSSS');
                    break;
                end
            end
        else
            %if does a flashing prior trial type.
            %decode which of the buttons is for even and which is for odd.
            iBUTTON_RESPONSE_OPTION = strmatch('BUTTON_RESPONSE_OPTION',{char(data.configinfo.name)},'exact');
            button_option = data.configinfo(iBUTTON_RESPONSE_OPTION).parameters;
            %default values for buttons press odd and even.
            even_button = 'right';    %right button
            odd_button ='left';     %left button
            if(button_option == 1)
                %even - right ,odd - left
                even_button = 'right';    %right button
                odd_button = 'left';     %left button
            elseif(button_option == 2)
                %even - left ,odd - right
                even_button = 'left';    %left button
                odd_button = 'right';     %right button
            elseif(button_option == 3)
                %even - up ,odd - down
                even_button = 'top';    %up button
                odd_button = 'bottom';     %down button
            elseif(button_option == 4)
                %even - down ,odd - up
                even_button = 'bottom';    %down button
                odd_button = 'top';     %up button
            end
            while(toc <= cldata.respTime)
                press = CedrusResponseBox('GetButtons', responseBoxHandler); 
                if(~isempty(press))
                    response = press.buttonID;
                    if(strcmp(response , even_button)) %even button response.
                      response = 1;     % '1' means odd response.
                      responseTime = toc(startPressStartTime);
                    elseif(strcmp(response , odd_button))  %odd button response.
                      response = 2;     % '2' means even response.
                      responseTime = toc(startPressStartTime);
                    else
                      response = 0;     % '0' means no response (yet).
                    end
                end
                if(response ~= 0)
                    display('YESSSSSSSSSSSSSSSSSSSSS');
                    break;
                end
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
    response = 0;
    debugResponse = 0;
    if(cldata.is_flashing_priors == false)
        %if no flushing prior type trial.
        while  (toc <= cldata.respTime)
            pause(0.1);
            debugResponse = getappdata(appHandle , 'debugResponse');
            if strcmp(debugResponse,'f') %right
                display('Choice = Right');
                response = 2;
                break;
            elseif strcmp(debugResponse,'d') %left
                display('Choice = Left');
                response = 1;
                break;
            elseif strcmp(debugResponse,'i')
                response = 4;
                break;
            end
            %pause(cldata.respTime);
        end
    else
        %if does a flashing prior trial type.
        %decode which of the buttons is for even and which is for odd.
        iBUTTON_RESPONSE_OPTION = strmatch('BUTTON_RESPONSE_OPTION',{char(data.configinfo.name)},'exact');
        button_option = data.configinfo(iBUTTON_RESPONSE_OPTION).parameters;
        %default values for buttons press odd and even.
        even_button = 'f';    %right button
        odd_button = 'd';     %left button
        if(button_option == 1)
            %even - right ,odd - left
            even_button = 'f';    %right button
            odd_button = 'd';     %left button
        elseif(button_option == 2)
            %even - left ,odd - right
            even_button = 'd';    %left button
            odd_button = 'f';     %right button
        elseif(button_option == 3)
            %even - up ,odd - down
            even_button = 'e';    %up button
            odd_button = 'x';     %down button
        elseif(button_option == 4)
            %even - down ,odd - up
            even_button = 'x';    %down button
            odd_button = 'e';     %up button
        end
        while  (toc <= cldata.respTime)
            pause(0.1);
            debugResponse = getappdata(appHandle , 'debugResponse');
            if strcmp(debugResponse,even_button)    %choose even number.
                press = debugResponse;
                display('Choice = Even');
                response = 2;
                break;
            elseif strcmp(debugResponse,odd_button')    %choose odd number.
                press = debugResponse;
                display('Choice = Odd');
                response = 1;
                break;
            end
            %pause(cldata.respTime);
        end
    end
        debugResponse = ''; 
        setappdata(appHandle , 'debugResponse' , debugResponse);
end
% Feedback for 'Received Answer' case ++++++++++

%make the sound of given answr or not, only if not giving feedback
%correctness in the analyze stage.
if  responseCorrectnessFeedback == 0
    if response == 1 || response == 2 
        % Received legit answer sound 
         a = [ones(22,200);zeros(22,200)];
         a_legit = a(:)';
         PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
         PsychPortAudio('Start', portAudio, 1,0);
    elseif response == 4 
    else
        % Time Out Sound
         a = [ones(220,25);zeros(220,25)];
         a_timeout = a(:)';
         PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
         PsychPortAudio('Start', portAudio, 1,0);
    end
end
%++++++++++++++++++++++++++++++++++
fprintf('THE RESPONSE IS %d\n' , response);

activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
activeRule = data.activeRule;


savedInfo(activeStair,activeRule).PriorResp.responseTime(trial(activeStair,activeRule).priorCntr) = responseTime;
savedInfo(activeStair,activeRule).PriorResp.response(trial(activeStair,activeRule).priorCntr) = response;
%%Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp')
end
