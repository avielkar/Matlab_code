function priorCollectResp(appHandle)

global connected debug in
global bxbport
global print_var
global startTime

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
                if(bxbport.BytesAvailable() >= 6)
                    r = uint32(fread(bxbport,6));
                    %uint32(fread(bxbport,6));
                    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                    if press
                          response = bitshift (r(2), -5);    %leftmost 3 bits
                          if(response == 3) %left buttom
                              response = 1;
                              responseTime = toc(startTime);
                          elseif(response == 5)  %right buttom
                              response = 2;
                              responseTime = toc(startTime);
                          else
                              response = 0; 
                          end
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
            even_button = 5;    %right button
            odd_button = 3;     %left button
            if(button_option == 1)
                %even - right ,odd - left
                even_button = 5;    %right button
                odd_button = 3;     %left button
            elseif(button_option == 2)
                %even - left ,odd - right
                even_button = 3;    %left button
                odd_button = 5;     %right button
            elseif(button_option == 3)
                %even - up ,odd - down
                even_button = 1;    %up button
                odd_button = 6;     %down button
            elseif(button_option == 4)
                %even - down ,odd - up
                even_button = 6;    %down button
                odd_button = 1;     %up button
            end
            while(toc <= cldata.respTime)
                if(bxbport.BytesAvailable() >= 6)
                    r = uint32(fread(bxbport,6));
                    %uint32(fread(bxbport,6));
                    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                    if press
                          response = bitshift (r(2), -5);    %leftmost 3 bits
                          if(response == even_button) %even button response.
                              response = 1;     % '1' means odd response.
                              responseTime = toc(startTime);
                          elseif(response == odd_button)  %odd button response.
                              response = 2;     % '2' means even response.
                              responseTime = toc(startTime);
                          else
                              response = 0;     % '0' means no response (yet).
                          end
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
fprintf('THE RESPONSE IS %d\n' , response);

activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
activeRule = data.activeRule;
%activePrior = data.activePrior;

if( connected && ~debug)
    if(response == 1 || response == 2)
       if(press ==5)    %right press
           response =2;
       elseif press == 3    %left press
           response = 1;
       elseif press == 1 %up press
           response = 3;
       elseif press == 6    %down press
           response = 4;
       end
    else
        response = 0;
    end
elseif(connected && debug) || (~connected && debug)
    if(response == 1 || response == 2)
        if(press =='f')    %right press
           response =2;
       elseif press == 'd'    %left press
           response = 1;
       elseif press == 'e' %up press
           response = 3;
       elseif press == 'x'    %down press
           response = 4;
       end
    else
        response = 0;
    end
else
    response = 0;
end


savedInfo(activeStair,activeRule).PriorResp.responseTime(trial(activeStair,activeRule).priorCntr) = responseTime;
savedInfo(activeStair,activeRule).PriorResp.response(trial(activeStair,activeRule).priorCntr) = response;
%%Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp')
end
