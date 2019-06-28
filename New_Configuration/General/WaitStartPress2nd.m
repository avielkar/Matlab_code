function secondPressInTime = WaitStartPress2nd(appHandle , start_mode)

global basicfig
global responseBoxHandler
global startPressStartTime
global startSoundStartTime
global connected
global debug
    data = getappdata(appHandle, 'protinfo');
    cldata = getappdata(appHandle, 'ControlLoopData');
    flagdata = getappdata(basicfig,'flagdata');
    trial = getappdata(appHandle,'trialInfo');
    
        
    iCOUNT_FROM = strmatch('COUNT_FROM' ,{char(data.configinfo.name)},'exact');
    iCOUNT_TIME = strmatch('COUNT_TIME' ,{char(data.configinfo.name)},'exact');
    iWINDOW_SIZE = strmatch('WINDOW_SIZE' ,{char(data.configinfo.name)},'exact');
    
    % Time Out Sound
    a = [ones(10,25);zeros(10,25)];
    a_timeout = a(:)';
    
    if(start_mode == 1)
        soundsc(cldata.beginWav,100000);
        %press has no time limit.
        secondPressInTime = 1;
        %% Wait for red button to be pressed to start movement for sending the command to MoogDots(int the next section) to make it's commands(visual and vistibula options).
        % Wait for red button to be pressed to start movement
        if connected && ~debug
            response = 0; % No response yet
            try
                CedrusResponseBox('FlushEvents', responseBoxHandler);
            catch
            end
            while(response ~= 4)
                press = CedrusResponseBox('GetButtons', responseBoxHandler);
                if(~isempty(press))
                    if strcmp(press.buttonID , 'middle')
                         response = 4;
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
                if response == 4  %---Jing for light control 12/03/07---
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    startPressStartTime = tic;
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
        %%
    elseif (start_mode == 2)
        checkIfWasResponseWhenNotNeeded = 0;
        window_size = data.configinfo(iWINDOW_SIZE).parameters;
        
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
        
        %wait half of the imaginary window start response
        %flush all the input from the board because we dont want to start
        %before the beep
        try
            CedrusResponseBox('FlushEvents', responseBoxHandler);
        catch
        end
        startWindowTime = tic;
        while(checkIfWasResponseWhenNotNeeded ~=4 && toc(startWindowTime) < window_size / 2)
            press = CedrusResponseBox('GetButtons', responseBoxHandler);
            if(~isempty(press))
                if strcmp(press.buttonID , 'middle')
                     checkIfWasResponseWhenNotNeeded = 4;
                end
                fprintf('byteas available but not a red press!!!!\n')
            end
        end

        %the user press start , altough no need to press , failure
        if(checkIfWasResponseWhenNotNeeded == 4)
            secondPressInTime = 0;
            soundsc(a_timeout,2000);
            cldata.go = 0;
            %cldata = getappdata(appHandle,'ControlLoopData');
            cldata.stage = 'InitializationStage';
            cldata.initStage = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
        else
            %automatic response
            secondPressInTime = 1;
            response = 4;
            startPressStartTime = tic;
            cldata = getappdata(appHandle, 'ControlLoopData');
            cldata.go = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
        end
        %%
    elseif(start_mode == 3)
        response = 0; % reset the reponse flag.
        
        %% self-countdown and user start
        count_from = data.configinfo(iCOUNT_FROM).parameters;
        count_time = data.configinfo(iCOUNT_TIME).parameters;
        window_size = data.configinfo(iWINDOW_SIZE).parameters;
        %sounds the countdown sounds.
        startSoundStartTime = tic;
        %reset the timer zero based time
        try
            CedrusResponseBox('ResetRTTimer', responseBoxHandler);
        catch
        end
        for i =1:1:count_from %plus 1 because the press should be at the last non sound beep (interval).
            intervalTime = tic;
            %time to wait betweeen count sound.
            if(i < count_from)
                %sounds the countdown sound.
                soundsc(cldata.beginWav3,100000);
                while(toc(intervalTime) < count_time)
                end
            else
                soundsc(cldata.beginWav3,100000);
                %for begining waiting for a response a window_size/2 before
                %the time.
                while(toc(intervalTime) < count_time - window_size/2)
                end
            end
        end
        %%
        %%Wait for the start press.
        %flush all the input from the board because we dont want to start
        %before the beep
        try
            CedrusResponseBox('FlushEvents', responseBoxHandler);
        catch
        end
        %also for the debug, flush the inputs.
        setappdata(appHandle , 'debugResponse' , 0);
        window_size_timer = tic;
        while(response == 0 && flagdata.isStopButton == 0 && toc(window_size_timer) <= window_size)%not /2 for the prior beep response and post response.)
            flagdata = getappdata(basicfig,'flagdata');
            %wait fot the start response in the window time.
             if connected && ~debug
                press = CedrusResponseBox('GetButtons', responseBoxHandler);
                if(~isempty(press))                    
                    if strcmp(press.buttonID , 'middle')
                         response = 4;
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
                if response == 4  %---Jing for light control 12/03/07---
                    %startPressStartTimeSave = toc(startSoundStartTime);
                    startPressStartTimeSave = press.rawtime;
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
                    activeRule = data.activeRule;
                    savedInfo = getappdata(appHandle,'SavedInfo');
                    savedInfo(activeStair,activeRule).Resp(data.repNum).startPressResponseTime(trial(activeStair,activeRule).cntr) = startPressStartTimeSave;
                    setappdata(appHandle,'SavedInfo',savedInfo );
                    startPressStartTime = tic;
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
        if(response == 4)
            secondPressInTime = 1;
        else
            secondPressInTime = 0;
            % Time Out Sound
            soundsc(a_timeout,2000);
        end
        %%test line:
% % % % % % % % % % % % % % % % % % %         secondPressInTime = 2 - randi(2) ;
        %%
        %if eh cldata.go = 0 (means timeout for the press), make the cldata.initStage True, in order to
        %randomiza the intOrder and the trajectory again.
        if(cldata.go == 0)
            %it is only for 2I , in order to offsets between the beeps
            %because immediatley goes to the initial stage.
            cldata.stage = 'InitializationStage';
            cldata.initStage = 1;
            cldata = getappdata(appHandle,'ControlLoopData');
            cldata.initStage = 1;
            setappdata(appHandle, 'ControlLoopData' , cldata);
        end
    end
    