function collectResp(appHandle)

global connected debug in
global bxbport
global print_var

% Received legit answer sound
a = [ones(1,200); zeros(1,200)];
a_legit = a(:)';
% Time Out Sound
a = [ones(10,25); zeros(10,25)];
a_timeout = a(:)';

        

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
            if(bxbport.BytesAvailable() >= 6)
                r = uint32(fread(bxbport,6));
                %uint32(fread(bxbport,6));
                press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                if press
                    responseBox = bitshift (r(2), -5);    %leftmost 3 bits
                    if(responseBox == 3) %left buttom
                        response = 1;
                        display('Choice = Left');
                        break;
                    elseif(responseBox == 5)  %right buttom
                        response = 2;
                        display('Choice = Right');
                        break;
                    else
                        response = 0;
                    end
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
        if response == 1 || response == 2 
        % Received legit answer sound
        %         a = [ones(1,200); zeros(1,200)];
        %         a = a(:)';
        %         soundsc(a,2000);
        soundsc(a_legit,2000);
        else
            % Time Out Sound
            %             a = [ones(10,25); zeros(10,25)];
            %             a = a(:)';
            %             soundsc(a,2000);
            soundsc(a_timeout,2000);
        end
        %%
        
        %if a answer was made and the option for confidence answer is on.
        if(response ~= 0 && flagdata.enableConfidenceChoice == 1)
            tic
            while(toc <=  cldata.respTime)
                if(bxbport.BytesAvailable() >= 6)
                    r = uint32(fread(bxbport,6));
                    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                    if press
                          confidenceResponseBox = bitshift (r(2), -5);    %leftmost 3 bits
                          if(confidenceResponseBox == 1) %up buttom
                              confidenceResponse = 3;
                              display('Confidence choice  =  High');
                              break;
                          elseif(confidenceResponseBox == 6)  %down buttom
                              confidenceResponse = 4;
                              display('Confidence choice = Low');
                              break;
                          else
                              confidenceResponse = 0; 
                          end
                    end
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
        % Received legit answer sound
        %     a = [ones(1,200); zeros(1,200)];
        %     a = a(:)';
        %     soundsc(a,2000);
        soundsc(a_legit,2000);
    else
        % Time Out Sound
        %     a = [ones(10,25); zeros(10,25)];
        %     a = a(:)';
        %     soundsc(a,2000);
        soundsc(a_timeout,2000);
    end
end
%++++++++++++++++++++++++++++++++++
fprintf('THE RESPONSE IS %d\n' , response);

activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
activeRule = data.activeRule;
savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = response;
savedInfo(activeStair,activeRule).Resp(data.repNum).confidence(trial(activeStair,activeRule).cntr) = confidenceResponse;
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting collectResp')
end
