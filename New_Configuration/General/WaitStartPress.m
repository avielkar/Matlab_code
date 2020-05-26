function pressInTime = WaitStartPress(appHandle , start_mode , round_number)

global basicfig
global responseBoxHandler
global startPressStartTime
global startSoundStartTime
global connected
global debug
global portAudio
global thrustmasterJoystick
global UseThrustmasterJoystick
global pedalThresholdPressValue

    data = getappdata(appHandle, 'protinfo');
    cldata = getappdata(appHandle, 'ControlLoopData');
    flagdata = getappdata(basicfig,'flagdata');
    trial = getappdata(appHandle,'trialInfo');
    
    iCOUNT_FROM = strmatch('COUNT_FROM' ,{char(data.configinfo.name)},'exact');
    iCOUNT_TIME = strmatch('COUNT_TIME' ,{char(data.configinfo.name)},'exact');
    iWINDOW_SIZE = strmatch('WINDOW_SIZE' ,{char(data.configinfo.name)},'exact');
    
    % Time Out Sound
    a = [ones(220,25);zeros(220,25)];
    a_timeout = a(:)';
    
    if(start_mode == 1)
        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav;cldata.beginWav]);
        PsychPortAudio('Start', portAudio, 1,0);
        %press has no time limit.
        pressInTime = 1;
        %% Wait for red button to be pressed to start movement for sending the command to MoogDots(int the next section) to make it's commands(visual and vistibula options).
        % Wait for red button to be pressed to start movement
        if connected && ~debug
            response = 0; % No response yet
            if(flagdata.isAutoStart)
                response = 4;
                cldata.go = 1;
                setappdata(appHandle,'ControlLoopData',cldata);
            end
            try
                CedrusResponseBox('FlushEvents', responseBoxHandler);
            catch
            end
            while(response ~= 4 && (flagdata.isStopButton ~= 1)) %Jing 01/05/09---)
                flagdata = getappdata(basicfig,'flagdata');
                if ~UseThrustmasterJoystick
                    press = CedrusResponseBox('GetButtons', responseBoxHandler);
                    if(~isempty(press))
                        if strcmp(press.buttonID , 'middle')
                             response = 4;
                        end
                        fprintf('byteas available but not a red press!!!!\n')
                    end
                else
                    axis_values = read(thrustmasterJoystick);
                    pedal_value = axis_values(3);
                    if(pedal_value ~=0 && pedal_value ~=1 && pedal_value < pedalThresholdPressValue)
                        response = 4;
                    end
                end
                if response == 4  %---Jing for light control 12/03/07---
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    startPressStartTime = tic;
                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    cldata = getappdata(appHandle, 'ControlLoopData');
                    if cldata.movdelaycontrol && cldata.startbeep == 0
                        cldata.preTrialTime = GenVariableDelayTime;
                        tic
                        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav;cldata.beginWav]);
                        PsychPortAudio('Start', portAudio, 1,0);
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
            if(flagdata.isAutoStart)
                response = 4;
            end
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
                        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav;cldata.beginWav]);
                        PsychPortAudio('Start', portAudio, 1,0);
                    end
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
                pause(0.01);
            end
        end
        %%
    elseif (start_mode == 2)
        disp('Entering start mode 2');
        checkIfWasResponseWhenNotNeeded = 0;
        count_from = data.configinfo(iCOUNT_FROM).parameters;
        count_time = data.configinfo(iCOUNT_TIME).parameters;
        window_size = data.configinfo(iWINDOW_SIZE).parameters;
        
        %sound the countdown sounds.
        %soundsc(cldata.beginWav2);
        disp('Filling buffer...');
        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav2;cldata.beginWav2]);
        disp('Starting sound...');
        PsychPortAudio('Start', portAudio, 1,0);
        %wait the sound to over
        disp('Making pause...');
        pause(count_time*count_from - window_size/2);
        %wait half of the imaginary window start response
        %flush all the input from the board because we dont want to start
        %before the beep
        disp('Flushing events...');
        try
            CedrusResponseBox('FlushEvents', responseBoxHandler);
        catch
        end
        %start the timer for the window.
        disp('Reseting RTT timer');
        startWindowTime = tic;
        CedrusResponseBox('ResetRTTimer', responseBoxHandler);
        
        disp('Entering while function.');
        while(checkIfWasResponseWhenNotNeeded ~=4 && toc(startWindowTime) < window_size / 2)
            if ~UseThrustmasterJoystick
                press = CedrusResponseBox('GetButtons', responseBoxHandler);
                if(~isempty(press))
                    if strcmp(press.buttonID , 'middle')
                         checkIfWasResponseWhenNotNeeded = 4;
                    end
                    fprintf('byteas available but not a red press!!!!\n')
                end
            else
                axis_values = read(thrustmasterJoystick);
                pedal_value = axis_values(3);
                if(pedal_value ~=0 && pedal_value ~=1 && pedal_value < pedalThresholdPressValue)
                    checkIfWasResponseWhenNotNeeded = 4;
                end  
            end
        end

        disp('Entering final of start mode 2...');
        %the user press start , altough no need to press , failure
        if(checkIfWasResponseWhenNotNeeded == 4)
            pressInTime = 0;            
            PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
            PsychPortAudio('Start', portAudio, 1,0);
            
            
            cldata.go = 0;
            %cldata = getappdata(appHandle,'ControlLoopData');
            cldata.stage = 'InitializationStage';
            cldata.initStage = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
        else
            %automatic response
            pressInTime = 1;
            response = 4;
            startPressStartTime = tic;
            cldata = getappdata(appHandle, 'ControlLoopData');
            cldata.go = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
        end
        %%
    elseif(start_mode == 3)
        disp('Entering start mode 3');
        response = 0; % reset the reponse flag.
        disp('Cheking auto start');
        if(flagdata.isAutoStart)
            response = 4;
            cldata = getappdata(appHandle, 'ControlLoopData');
            % got response -> go to next stage
            cldata.go = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
        end
        %% self-countdown and user start
        count_from = data.configinfo(iCOUNT_FROM).parameters;
        count_time = data.configinfo(iCOUNT_TIME).parameters;
        window_size = data.configinfo(iWINDOW_SIZE).parameters;
        
        disp('Fillng buffer...');
        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav3;cldata.beginWav3]);
        
        
        %sounds the countdown sounds.
        startSoundStartTime = tic;
        disp('Make sound...');
        PsychPortAudio('Start', portAudio, 1,0);
        %soundsc(cldata.beginWav3);
        sound_command_duration = toc(startSoundStartTime);
        try
            CedrusResponseBox('ResetRTTimer', responseBoxHandler);
        catch
        end
        matlab_timer = tic;
        disp('Making pause...');
        pause(count_time*count_from - window_size/2);
        %%
        %%Wait for the start press.
        %flush all the input from the board because we dont want to start
        %before the beep
        disp('Flusshing events...');
        try
            CedrusResponseBox('FlushEvents', responseBoxHandler);
        catch
        end
        %also for the debug, flush the inputs.
        setappdata(appHandle , 'debugResponse' , 0);
        window_size_timer = tic;
        fprintf('waiting for red press\n');
        while(response == 0 && flagdata.isStopButton == 0 && toc(window_size_timer) <= window_size)%not /2 for the prior beep response and post response.)
            flagdata = getappdata(basicfig,'flagdata');
            %wait fot the start response in the window time.
             if connected && ~debug
                if ~UseThrustmasterJoystick
                    % byte 2 determines button number, press/release and port
                    press = CedrusResponseBox('GetButtons', responseBoxHandler);
                    if(~isempty(press))                    
                        if strcmp(press.buttonID , 'middle')
                             response = 4;
                        end
                        fprintf('byteas available but not a red press!!!!\n')
                    end
                else
                  axis_values = read(thrustmasterJoystick);
                    pedal_value = axis_values(3);
                    if(pedal_value ~=0 && pedal_value ~=1 && pedal_value < pedalThresholdPressValue)
                        response = 4;
                    end  
                end
                if response == 4  %---Jing for light control 12/03/07---
                    %startPressStartTimeSave = toc(startSoundStartTime);
                    if ~UseThrustmasterJoystick
                        startPressStartTimeSave = press.rawtime;
                    else
                        startPressStartTimeSave = toc(window_size_timer);
                    end
                    
                    fprintf('YESSSSSSSSSSSSS RED BUTTON\n')
                    activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
                    activeRule = data.activeRule;
                    savedInfo = getappdata(appHandle,'SavedInfo');
                    savedInfo(activeStair,activeRule).Resp(data.repNum).startPressTime(trial(activeStair,activeRule).cntr) = startPressStartTimeSave;
                    savedInfo(activeStair,activeRule).Resp(data.repNum).startPressTimeOld(trial(activeStair,activeRule).cntr) = toc(startSoundStartTime);
                    savedInfo(activeStair,activeRule).Resp(data.repNum).soundCommadDuration(trial(activeStair,activeRule).cntr) = sound_command_duration;
                    savedInfo(activeStair,activeRule).Resp(data.repNum).matlabStartPressTime(trial(activeStair,activeRule).cntr) = toc(matlab_timer);
                    setappdata(appHandle,'SavedInfo',savedInfo );
                    startPressStartTime = tic;
                    %---Jing for Reaction_time_task Protocol 11/10/08-----
                    cldata = getappdata(appHandle, 'ControlLoopData');
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
                        PsychPortAudio('FillBuffer', portAudio, [cldata.beginWav;cldata.beginWav]);
                        PsychPortAudio('Start', portAudio, 1,0);
                    end
                    setappdata(appHandle,'ControlLoopData',cldata);
                    %---End 11/10/08-----
                end
             end
            %pause(0.01);
        end
        if(response == 4)
            pressInTime = 1;
        else
            pressInTime = 0;
            % Time Out Sound
             PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
             PsychPortAudio('Start', portAudio, 1,0);
        end
        %if eh cldata.go = 0 (means timeout for the press), make the cldata.initStage True, in order to
        %randomiza the intOrder and the trajectory again.
        if(pressInTime ~= 1)
            %it is only for 2I , in order to offsets between the beeps
            %because immediatley goes to the initial stage.
            % Time Out Sound
            %soundsc(a_timeout,2000);
            cldata = getappdata(appHandle,'ControlLoopData');
            cldata.stage = 'InitializationStage';
            cldata.initStage = 1;
            setappdata(appHandle, 'ControlLoopData' , cldata);
        end
    elseif(start_mode == 4)
        disp('Entering start mode 3');
        window_size_timer = tic;
        while(toc(window_size_timer) <= 0.5)
        end
        pressInTime = 1;
    end
    
    savedInfo = getappdata(appHandle,'SavedInfo');
    activeStair = data.activeStair;
    activeRule = data.activeRule;
    if UseThrustmasterJoystick
        savedInfo(activeStair,activeRule).Resp(data.repNum).startPressType = 'Pedal';
    else
        savedInfo(activeStair,activeRule).Resp(data.repNum).startPressType = 'CedrusBox';
    end
    setappdata(appHandle,'SavedInfo',savedInfo );  