function WaitStartPress1st(appHandle , start_mode)

global basicfig
global bxbport
global startTime
global connected
global debug
    data = getappdata(appHandle, 'protinfo');
    cldata = getappdata(appHandle, 'ControlLoopData');
    flagdata = getappdata(basicfig,'flagdata');
    
    iCOUNT_FROM = strmatch('COUNT_FROM' ,{char(data.configinfo.name)},'exact');
    iCOUNT_TIME = strmatch('COUNT_TIME' ,{char(data.configinfo.name)},'exact');
    iWINDOW_SIZE = strmatch('WINDOW_SIZE' ,{char(data.configinfo.name)},'exact');
    
    % Time Out Sound
    a = [ones(10,25); zeros(10,25)];
    a_timeout = a(:)';
    
    if(start_mode == 1)
        soundsc(cldata.beginWav,100000);
        fprintf('sound!!!!!!!!!!!!\n')
        %% Wait for red button to be pressed to start movement for sending the command to MoogDots(int the next section) to make it's commands(visual and vistibula options).
        % Wait for red button to be pressed to start movement
        if connected && ~debug
            response = 0; % No response yet
            flushinput(bxbport);
            while(response ~= 4 && flagdata.isStopButton ~= 1) %Jing 01/05/09---)
            %    response = 4;
                flagdata = getappdata(basicfig,'flagdata');
                % byte 2 determines button number, press/release and port
                if(bxbport.BytesAvailable() >= 6)
                    r = uint32(fread(bxbport,6)); % reads 6 first bytes
                    %uint32(fread(bxbport,6));
                    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                    if press
                         response = bitshift (r(2), -5);    %leftmost 3 bits
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
                % Checks which button was pressed (3-left, 4-center, 5-right) --shir
                if response == 4  %---Jing for light control 12/03/07---
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    startTime = tic;
                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    cldata = getappdata(appHandle, 'ControlLoopData');
                    if cldata.movdelaycontrol && cldata.startbeep == 0
                        cldata.preTrialTime = GenVariableDelayTime;
                        tic
                        soundsc(cldata.beginWav,200000)     %---Jing 11/12/08-----
                        cldata.startbeep = 1;
                    end
                    % got response -> go to next stage
                    cldata.go = 1;
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
                pause(0.01);
            end

        elseif (connected && debug) || (~connected && debug)
            response = 0;
            while(response ~= 4 && flagdata.isStopButton ~= 1) %Jing 01/05/09---)
                DebugWindow(appHandle);
                debugResponse = getappdata(appHandle , 'debugResponse');
                if strcmp(debugResponse,'s')
                    response = 4;
                    cldata.go = 1;
                    debugResponse = '';  %---Jing 3/11/2008---
                    setappdata(appHandle , 'debugResponse' , debugResponse);

                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    if cldata.movdelaycontrol
                        cldata.preTrialTime = GenVariableDelayTime;
                        tic
                        soundsc(cldata.beginWav,200000)     %---Jing 11/12/08-----
                    end
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
                pause(0.01);
            end
        end
        %%
    elseif (start_mode == 2)
        %% robot-countdown and automatic-start
        count_from = data.configinfo(iCOUNT_FROM).parameters;
        count_time = data.configinfo(iCOUNT_TIME).parameters;
        %sound the countdown sounds.
        for i =1:1:count_from
            %sounds the countdown sound.
            soundsc(cldata.beginWav2,100000);
            intervalTime = tic;
            %time to wait betweeen count sound.
            while(toc(intervalTime) < count_time)
            end
        end
        %automatic response
        response = 4;
        startTime = tic;
        cldata = getappdata(appHandle, 'ControlLoopData');
        cldata.go = 1;
        setappdata(appHandle,'ControlLoopData',cldata);
        %%
    elseif(start_mode == 3)
        %% self-countdown and user start
        count_from = data.configinfo(iCOUNT_FROM).parameters;
        count_time = data.configinfo(iCOUNT_TIME).parameters;
        window_size = data.configinfo(iWINDOW_SIZE).parameters;              
        %sounds the countdown sounds.
        for i =1:1:count_from+1 %plus 1 because the press should be at the last non sound beep (interval).
            intervalTime = tic;
            %time to wait betweeen count sound.
            if(i <= count_from)
                %sounds the countdown sound.
                soundsc(cldata.beginWav3,100000);
                while(toc(intervalTime) < count_time)
                end
            else
                %for begining waiting for a response a window_size/2 before
                %the time.
                while(toc(intervalTime) < count_time - window_size/2)
                end
            end
        end
        %%
        %%Wait for the start press.
        response = 0; % reset the reponse flag.
        %flush all the input from the board because we dont want to start
        %before the beep
        flushinput(bxbport);
        %also for the debug, flush the inputs.
        setappdata(appHandle , 'debugResponse' , 0);
        window_size_timer = tic;
        while(response == 0 && flagdata.isStopButton == 0 && toc(window_size_timer) <= window_size)%not /2 for the prior beep response and post response.)
            flagdata = getappdata(basicfig,'flagdata');
            %wait fot the start response in the window time.
             if connected && ~debug
                % byte 2 determines button number, press/release and port
                if(bxbport.BytesAvailable() >= 6)
                    r = uint32(fread(bxbport,6)); % reads 6 first bytes
                    %uint32(fread(bxbport,6));
                    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
                    if press
                         response = bitshift (r(2), -5);    %leftmost 3 bits
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
                if response == 4  %---Jing for light control 12/03/07---
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    startTime = tic;
                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    cldata = getappdata(appHandle, 'ControlLoopData');
                        if cldata.movdelaycontrol && cldata.startbeep == 0
                            cldata.preTrialTime = GenVariableDelayTime;
                            tic
                            soundsc(cldata.beginWav,200000)     %---Jing 11/12/08-----
                            cldata.startbeep = 1;
                        end
                    % got response -> go to next stage
                    cldata.go = 1;
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
             elseif (connected && debug) || (~connected && debug)
                DebugWindow(appHandle);
                debugResponse = getappdata(appHandle , 'debugResponse');
                if strcmp(debugResponse,'s')
                    response = 4;
                    cldata.go = 1;
                    debugResponse = '';  %---Jing 3/11/2008---
                    setappdata(appHandle , 'debugResponse' , debugResponse);

                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    if cldata.movdelaycontrol
                        cldata.preTrialTime = GenVariableDelayTime;
                        tic
                        soundsc(cldata.beginWav,200000)     %---Jing 11/12/08-----
                    end
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
             end
            pause(0.01);
        end
        %%
        %%
        %test line
% % % % % % % % % % % % %         secondPressInTime = 2 - randi(2) ;
% % % % % % % % % % % % %         cldata.go = secondPressInTime;
% % % % % % % % % % % % %         setappdata(appHandle,'ControlLoopData',cldata);
        %if eh cldata.go = 0 (means timeout for the press), make the cldata.initStage True, in order to
        %randomiza the intOrder and the trajectory again.
        if(cldata.go == 0)
            %it is only for 2I , in order to offsets between the beeps
            %because immediatley goes to the initial stage.
            % Time Out Sound
            soundsc(a_timeout,2000);
            cldata = getappdata(appHandle,'ControlLoopData');
            cldata.stage = 'InitializationStage';
            cldata.initStage = 1;
            setappdata(appHandle, 'ControlLoopData' , cldata);
        end
    end