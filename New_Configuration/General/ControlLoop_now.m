% ControlLoop(obj, event, appHandle)
% Main control loop for the Human Moog Matlab control system.
function ControlLoop(obj, event, appHandle)

% Grab the current stage and execute it.
cldata = getappdata(appHandle, 'ControlLoopData');
eval([cldata.stage, '(appHandle)']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% InitializationStage
%   Initialization stage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InitializationStage(appHandle)

global connected debug PLOTS  %pogen_oddity
global in   %---Jing added 03/11/08---

data = getappdata(appHandle, 'protinfo');
cldata = getappdata(appHandle, 'ControlLoopData');
crossvals = getappdata(appHandle,'CrossVals');

%------Jing for combine multistair 12/01/08---------
varying = data.condvect.varying;
within = data.condvect.withinStair;
across = data.condvect.acrossStair;
%------End 12/01/08--------

paused = get(findobj(appHandle,'Tag','PauseButton'),'Value');
if ~paused
    if cldata.initStage
        tic % Start for PreTrialTime
        cldata.initStage = 0;
        cldata.go = 0;

        %---Jing for Reaction_time_task Protocol 11/12/08-----
        if cldata.movdelaycontrol
            cldata.startbeep = 0;
        end
        %----End 11/12/08-----

        %---Jing for StepVelocity Protocol 12/01/09-----
        if cldata.enableRespBeep
            cldata.respBeep = 1;
            i = strmatch('RESPONSE_BEEP_TIME',{char(data.configinfo.name)},'exact');
            cldata.respBeepTime=data.configinfo(i).parameters;
        end
        %----End 12/01/09-----

        setappdata(appHandle,'ControlLoopData',cldata);
        data = getappdata(appHandle, 'protinfo');
        COMBOARDNUM = 0;

        %---Jing for handling para pogen_oddity in data structure protinfo.03/27/08---
        if isfield(data, 'pogen_oddity')
            data.pogen_oddity=0;      %---set it back to 0----
            setappdata(appHandle,'protinfo',data);
        end

        data = getappdata(appHandle, 'protinfo');
        trial = getappdata(appHandle,'trialInfo');

        disp(['Rep ' num2str(data.repNum)])
        %-------Jing for combine multistair 12/01/08---------
        if cldata.staircase
            activeStair = data.activeStair;
            activeRule = data.activeRule;
            disp(['Staircase Value ' num2str(trial(activeStair,activeRule).acrossVal)...
                ', Trial ' num2str(trial(activeStair,activeRule).cntr)])
        else   %----End 12/01/08--------
            disp(['Trial ' num2str(trial.cntr)])
        end

        %---Jing added on 12/20/08.
        %In staircase mode, if we also have varying parameters, we need to randomly pick out
        %a value from the 'crossvals' list and keep the index of the value in 'cldata' data structure.
        if cldata.staircase && ~isempty(varying)
            cldata.varyingCurrInd = ceil(rand*length(crossvals));
            setappdata(appHandle,'ControlLoopData',cldata);
        end
        %---End 12/20/08------

        % create trajectory for this trial
        eval(['trajinfo = ' data.functions.TrajectoryCreation '(appHandle);']);

        data = getappdata(appHandle, 'protinfo');   %---Jing for Reaction_time_task Protocol 11/10/08-----
        cldata = getappdata(appHandle, 'ControlLoopData');

        %Send over all the variables to the slave.
        %      Kludges -- necessary to ensure the trasnlation protocol works
        %      correctly need to redo into the main code
        iBackground = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');%---jing 02/06/07---
        iORIGIN = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
        iINT_ORDER_2I = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
        iPRED_OFFSET = strmatch('PRED_OFFSET',{char(data.configinfo.name)},'exact');
        iCORR_ALT_PROB = strmatch('CORR_ALT_PROB',{char(data.configinfo.name)},'exact');
        iERR_ALT_PROB = strmatch('ERR_ALT_PROB',{char(data.configinfo.name)},'exact');
        iGAUSSIAN_SEED = strmatch('GAUSSIAN_SEED',{char(data.configinfo.name)},'exact');
        iMOTION_TYPE = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
        iRAND_METHOD = strmatch('RAND_METHOD',{char(data.configinfo.name)},'exact');
        iSTAIRCASE = strmatch('STAIRCASE',{char(data.configinfo.name)},'exact');
        iSTAIR_DOWN_PCT = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
        iSTAIR_UP_PCT = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
        iSTIMULUS_TYPE = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
        iTT_MODE = strmatch('TT_MODE',{char(data.configinfo.name)},'exact');
        iPOST_TRIAL_TIME = strmatch('POST_TRIAL_TIME',{char(data.configinfo.name)},'exact');
        iPRE_TRIAL_TIME = strmatch('PRE_TRIAL_TIME',{char(data.configinfo.name)},'exact');
        iWAIT_FOR_RESP = strmatch('WAIT_FOR_RESP',{char(data.configinfo.name)},'exact');
        iROT_ORIGIN = strmatch('ROT_ORIGIN',{char(data.configinfo.name)},'exact');

        iD_PRIME = strmatch('D_PRIME',{char(data.configinfo.name)},'exact');  %---Jing added for targetshow 09/03/2008
        iTARG_YCTR = strmatch('TARG_YCTR',{char(data.configinfo.name)},'exact');  %---Jing added for targetshow 09/03/2008

        i_DUR = strmatch('DUR_SWEEPING_TARGET',{char(data.configinfo.name)},'exact');
        if isempty(i_DUR)
            i_DUR = strmatch('DURATION',{char(data.configinfo.name)},'exact'); %---Jing added for targetshow 11/10/2008
        end

        for i = 1:length(data.configinfo)
            if data.configinfo(i).active && ~isfield(data.configinfo(i).parameters, 'moog') && i~=iBackground
                if data.configinfo(i).status == 0 || data.configinfo(i).status == 1
                    if i == iORIGIN
                        outString = ['M_ORIGIN' ' ' num2str(data.configinfo(i).parameters/100)]; %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
                        if debug
                            disp(outString)
                        end
                        if connected
                            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                        end
                        %                       this needed to be done so Moogdots gets the
                        %                       correctly named parameter

                    elseif i == iINT_ORDER_2I || i == iPRED_OFFSET || i == iCORR_ALT_PROB || i == iERR_ALT_PROB || i == iGAUSSIAN_SEED || i == iMOTION_TYPE ...
                            || i == iRAND_METHOD || i == iSTAIRCASE || i == iSTAIR_DOWN_PCT || i == iSTAIR_UP_PCT || i == iSTIMULUS_TYPE || i == iTT_MODE ...
                            || i == iPOST_TRIAL_TIME || i == iPRE_TRIAL_TIME || i == iWAIT_FOR_RESP
                        %                         do nothing i.e. print nothing to moogdots

                        %---Jing added for targetshow 09/03/2008--------------------------
                    elseif i == iTARG_YCTR %&& ~isempty(iD_PRIME)    %---Jing 01/06/09--------
                        if ~isempty(iD_PRIME)   %---Jing 01/06/09--------
                            if data.configinfo(iD_PRIME).status == 0 || data.configinfo(iD_PRIME).status == 1
                                outString = [data.configinfo(i).name ' ' num2str(data.configinfo(iD_PRIME).parameters) ' ' num2str(data.configinfo(i).parameters(2:3))];
                            else
                                if data.configinfo(iD_PRIME).status == 2
                                    ii=strmatch(data.configinfo(iD_PRIME).nice_name,{char(varying.name)},'exact');
                                    if cldata.staircase   %---Jing 12/20/08
                                        valStr = num2str(crossvals(cldata.varyingCurrInd,ii));
                                    else  %---End 12/20/08
                                        valStr = num2str(crossvals(trial.list(trial.cntr),ii));
                                    end
                                elseif data.configinfo(iD_PRIME).status == 3
                                    ii=strmatch(data.configinfo(iD_PRIME).nice_name,{char(across.name)},'exact');
                                    valStr = num2str(across(ii).parameters(activeStair));
                                elseif data.configinfo(iD_PRIME).status == 4
                                    ii=strmatch(data.configinfo(iD_PRIME).nice_name,{char(within.name)},'exact');
                                    valStr = num2str(within(ii).parameters(trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr)));
                                end
                                outString = [data.configinfo(i).name ' ' valStr ' ' num2str(data.configinfo(i).parameters(2:3))];
                            end
                        else %---Jing 01/06/09--------
                            outString = [data.configinfo(i).name ' ' num2str(data.configinfo(i).parameters)];%---Jing 01/06/09--------
                        end%---Jing 01/06/09--------

                        if debug
                            disp(outString)
                        end

                        if connected
                            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                        end
                        %-----Jing end 09/03/2008-----------------------
                    else
                        outString = [data.configinfo(i).name ' ' num2str(data.configinfo(i).parameters)];
                        if debug
                            disp(outString)
                        end

                        if connected
                            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                        end
                    end
                    %----Jing for combine multi-staircase 12/01/08-------
                elseif data.configinfo(i).status == 2    %varying
                    i1 = strmatch(data.configinfo(i).nice_name,{char(varying.name)},'exact');
                    valStr = [];
                    valLen = size(varying(i1).parameters,1);
                    if cldata.staircase
                        for iVal = 1:valLen
                            valStr = [valStr ' ' num2str(crossvals(cldata.varyingCurrInd,i1))];
                        end
                    else
                        for iVal = 1:valLen
                            valStr = [valStr ' ' num2str(crossvals(trial.list(trial.cntr),i1))];
                        end
                    end
                    outString = [data.configinfo(i).name ' ' valStr];

                    if debug
                        disp(outString)
                    end
                    if connected
                        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                    end
                elseif data.configinfo(i).status == 3  % acrossStair
                    i1 = strmatch(data.configinfo(i).nice_name,{char(across.name)},'exact');
                    if isfield(across(i1).parameters, 'moog')
                        tmpVal = across(i1).parameters.moog(activeStair);
                    else
                        tmpVal = across(i1).parameters(activeStair);
                    end

                    valStr = [];
                    valLen = size(across(i1).parameters,1);
                    for iVal = 1:valLen
                        valStr = [valStr ' ' num2str(tmpVal)];
                    end
                    outString = [data.configinfo(i).name ' ' valStr];

                    if debug
                        disp(outString)
                    end
                    if connected
                        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                    end
                else    %withinStair
                    i1 = strmatch(data.configinfo(i).nice_name,{char(within.name)},'exact');
                    if isfield(within(i1).parameters, 'moog')   % some vars don't have both 'moog' and 'openGL' fields.
                        tmpVal = within(i1).parameters.moog(trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr));   % just making it a column vector instead of a row vector (Jimmy 1/24/2008).
                    else
                        tmpVal = within(i1).parameters(trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr));
                    end

                    valStr = [];
                    valLen = size(within(i1).parameters,1);
                    for iVal = 1:valLen
                        valStr = [valStr ' ' num2str(tmpVal)];
                    end
                    outString = [data.configinfo(i).name ' ' valStr];

                    if debug
                        disp(outString)
                    end
                    if connected
                        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                    end
                end

            end

            if i == iROT_ORIGIN
                outString = ['ROT_ORIGIN' ' ' num2str(data.configinfo(i).parameters.moog)];
                if connected
                    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                    disp(outString)
                end
            end

            %---Jing added for targetshow 11/10/2008
            if i == i_DUR

                jjjkkk = strmatch('DUR_SWEEPING_TARGET',{char(data.configinfo.name)},'exact');

                if isempty(jjjkkk)
                    outString = ['DURATION' ' ' num2str(data.configinfo(i).parameters.moog*1000)];
                else
                    outString = ['DURATION' ' ' num2str(data.configinfo(jjjkkk).parameters*1000)];
                end

                if debug
                    disp(outString)
                end
                if connected
                    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                end
            end
            %--------Jing end 11/10/2008
        end

        %         GeneratePredictedData
        % Send trajectories
        for i1 = 1:size(trajinfo,2)
            a = sprintf('%2.3f ',trajinfo(i1).data);
            if debug
                outString = [trajinfo(i1).name ' ' a sprintf('\n')]
            else
                outString = [trajinfo(i1).name ' ' a sprintf('\n')];
            end
            if connected
                % Newline added before b/c strange symbol seen on client
                % before first command
                if i1 == 1 % first time send newline before data to separate junk from commands
                    cbDWriteString(COMBOARDNUM, sprintf('\n%s\n', outString), 5);
                else
                    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                end
            end
        end

        if debug
            if PLOTS == 1
                % Plots of trajectories
                % Moog X,Y,Z
                figure(4)
                plotMoogTrans = subplot(221);
                plot(trajinfo(1).data)
                hold on
                plot(trajinfo(2).data,'+')
                plot(trajinfo(3).data,'r')
                title(plotMoogTrans, 'Moog Translation')
                ylabel(plotMoogTrans, 'Postion')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % MOOG YAW, PITCH, ROLL
                %                 figure(2)
                plotMoogRot = subplot(222);
                plot(trajinfo(4).data)
                hold on
                plot(trajinfo(5).data,'+')
                plot(trajinfo(6).data,'r')
                title(plotMoogRot, 'Moog Rotation')
                ylabel(plotMoogRot, 'Postion')
                legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                hold off

                % OPENGL X,Y,Z
                %                 figure(3)
                plotOpenGLTrans = subplot(223);
                plot(trajinfo(7).data)
                hold on
                plot(trajinfo(8).data,'+')
                plot(trajinfo(9).data,'r')
                title(plotOpenGLTrans, 'OpenGL Translation')
                ylabel(plotOpenGLTrans, 'Postion')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % figure(5)
                % plot(trajinfo(7).data,trajinfo(8).data)

                % OpenGL AzAxis, ElAxis, Angle About Axis
                %                 figure(4)
                plotOpenGLRot = subplot(224);
                plot(trajinfo(10).data)
                hold on
                plot(trajinfo(11).data,'+')
                plot(trajinfo(12).data,'r')
                title(plotOpenGLRot, 'OpenGL Rotation')
                ylabel(plotOpenGLRot, 'Postion')
                %                 legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                legend('ROT_ELE', 'ROT_AZ', 'ROT_DATA', 'Location', 'Best')
                hold off


                %velocity plots
                figure(5)
                % Plots of trajectories
                % Moog X,Y,Z
                plotMoogTrans = subplot(221);
                plot(diff(trajinfo(1).data)/0.1667)
                hold on
                plot(diff(trajinfo(2).data)/0.1667,'+')
                plot(diff(trajinfo(3).data)/0.1667,'r')
                title(plotMoogTrans, 'Moog Translation Vel')
                ylabel(plotMoogTrans, 'Velocity')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % MOOG YAW, PITCH, ROLL
                %                 figure(2)
                plotMoogRot = subplot(222);
                plot(diff(trajinfo(4).data)/0.1667)
                hold on
                plot(diff(trajinfo(5).data)/0.1667,'+')
                plot(diff(trajinfo(6).data)/0.1667,'r')
                title(plotMoogRot, 'Moog Rotation Vel')
                ylabel(plotMoogRot, 'Velocity')
                legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                hold off

                % OPENGL X,Y,Z
                %                 figure(3)
                plotOpenGLTrans = subplot(223);
                plot(diff(trajinfo(7).data)/0.1667)
                hold on
                plot(diff(trajinfo(8).data)/0.1667,'+')
                plot(diff(trajinfo(9).data)/0.1667,'r')
                title(plotOpenGLTrans, 'OpenGL Translation Vel')
                ylabel(plotOpenGLTrans, 'Velocity')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % figure(5)
                % plot(trajinfo(7).data,trajinfo(8).data)

                % OpenGL AzAxis, ElAxis, Angle About Axis
                %                 figure(4)
                plotOpenGLRot = subplot(224);
                plot(diff(trajinfo(10).data)/0.1667)
                hold on
                plot(diff(trajinfo(11).data)/0.1667,'+')
                plot(diff(trajinfo(12).data)/0.1667,'r')
                title(plotOpenGLRot, 'OpenGL Rotation Vel')
                ylabel(plotOpenGLRot, 'Velocity')
                %                 legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                legend('ROT_ELE', 'ROT_AZ', 'ROT_DATA', 'Location', 'Best')
                hold off

                figure(6)
                %acceleration plots
                % Plots of trajectories
                % Moog X,Y,Z
                plotMoogTrans = subplot(221);
                plot(trajinfo(1).data)
                hold on
                plot(trajinfo(2).data,'+')
                plot(trajinfo(3).data,'r')
                title(plotMoogTrans, 'Moog Translation')
                ylabel(plotMoogTrans, 'Postion')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % MOOG YAW, PITCH, ROLL
                %                 figure(2)
                plotMoogRot = subplot(222);
                plot(trajinfo(4).data)
                hold on
                plot(trajinfo(5).data,'+')
                plot(trajinfo(6).data,'r')
                title(plotMoogRot, 'Moog Rotation')
                ylabel(plotMoogRot, 'Postion')
                legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                hold off

                % OPENGL X,Y,Z
                %                 figure(3)
                plotOpenGLTrans = subplot(223);
                plot(trajinfo(7).data)
                hold on
                plot(trajinfo(8).data,'+')
                plot(trajinfo(9).data,'r')
                title(plotOpenGLTrans, 'OpenGL Translation')
                ylabel(plotOpenGLTrans, 'Postion')
                legend('Lateral', 'Surge', 'Heave', 'Location', 'Best')
                hold off

                % figure(5)
                % plot(trajinfo(7).data,trajinfo(8).data)

                % OpenGL AzAxis, ElAxis, Angle About Axis
                %                 figure(4)
                plotOpenGLRot = subplot(224);
                plot(trajinfo(10).data)
                hold on
                plot(trajinfo(11).data,'+')
                plot(trajinfo(12).data,'r')
                title(plotOpenGLRot, 'OpenGL Rotation')
                ylabel(plotOpenGLRot, 'Postion')
                %                 legend('Yaw', 'Pitch', 'Roll', 'Location', 'Best')
                legend('ROT_ELE', 'ROT_AZ', 'ROT_DATA', 'Location', 'Best')
                hold off

            end
        end
        
        if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')
            COMBOARDNUM = 0;
            outString = 'GO_TO_ZERO 1.0';
            disp(outString)
            if connected
                cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString),5);
            end
            
            pause(0.2);
        end

        % Ready to start sound
        soundsc(cldata.beginWav,100000)

        %----Jing added 0n 02/06/07---
        outString = [data.configinfo(iBackground).name ' ' num2str(data.configinfo(iBackground).parameters)];
        if debug
            disp(outString)
        end

        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString),5);
        end
        %-----Jing end-------

        %---- for adira using tomomoogdots  09/05/2012--------
        if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')
            COMBOARDNUM = 0;
            outString = 'DO_MOVEMENT -1.0';
            disp(outString)
   
            if connected
                cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString),5);
            end
        end
        
        
    end


    % Wait for red button to be pressed to start movement
    if connected && ~debug

        if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')

            if strcmp(CBWDReadString(0, 5, 512*12),'STARTED')
                response = 4;
            else
                response = 0;
            end
        else
            % Configure Port
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            response = cbDIn(boardNum, portNum); % boardNum = 1, DigPort = 1
            %         response = 4;   %%%% automatic start!
        end

        if response == 4 || response == 12  %---Jing for light control 12/03/07---
            %---Jing for Reaction_time_task Protocol 11/10/08-----
            cldata = getappdata(appHandle, 'ControlLoopData');
            if cldata.movdelaycontrol && cldata.startbeep == 0
                cldata.preTrialTime = GenVariableDelayTime;
                tic
                soundsc(cldata.beginWav,200000)     %---Jing 11/12/08-----
                cldata.startbeep = 1;
            end
            cldata.go = 1;
            setappdata(appHandle,'ControlLoopData',cldata);
            %---End 11/10/08-----
        end

    elseif (connected && debug) || (~connected && debug)
        DebugWindow;

        if strcmp(in,'s')
            response = 4;
            cldata.go = 1;
            in = '';  %---Jing 3/11/2008---

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

    cldata = getappdata(appHandle, 'ControlLoopData');

    % Pause before movement
    if toc >= cldata.preTrialTime && cldata.go == 1 %-----Jing for debug, 01/04/07---

        %===========Setup eyeTracking. Jing 01/27/09================
        flagdata = getappdata(appHandle,'flagdata');
        if flagdata.isEyeTracking
            initEyeTracking;
        end
        %=======End 01/27/09=========================================

        %-----Jing 11/12/08
        if cldata.movdelaycontrol
            cldata.preTrialTime = toc;
        end
        %-----End 11/12/08
        COMBOARDNUM = 0;
        outString = 'DO_MOVEMENT 1.0';

        if debug
            disp(outString)
        end

        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString),5);
        end

        %---Jing for light control. Turn off the light any way when trial starts. 12/03/07---
        if connected
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            cbDOut(boardNum, portNum, 0);
            cldata.lightflag = 0;

            %Jing 02/09/10 for mandy  %Jian modified 08/10/12 for Ardom
            if cldata.fpcontrol ~= 0
                COMBOARDNUM = 0;
                outString = 'FP_ON 0.0';
                cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString),5);
            end

            %if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')
            %    outString='ENABLE_CYLINDERS 1';
            %    if debug
            %        disp(outString)
            %    end

            %    if connected
            %        cbDWriteString(0, sprintf('%s\n', outString),5);
            %   end
            %end

        end
        %----Jing end 12/03/07---

        % Increment the stage.
        cldata.stage = 'MainTimerStage';
        cldata.initStage = 1;
        setappdata(appHandle, 'ControlLoopData', cldata);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MainTimerStage
%   Acts as the main timer for the protocol.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MainTimerStage(appHandle)

global connected debug %pogen_oddity %----Jing 01/29/07---

data = getappdata(appHandle, 'protinfo');%---Jing for handling para pogen_oddity in data structure protinfo. 03/27/08---
timeOffset=0;%---Jing added for delay time offset 02/06/07---
% if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')  %----Jian 09/20/2012
%      timeOffset=1;
% end
paused = get(findobj(appHandle,'Tag','PauseButton'),'Value');
if ~paused
    cldata = getappdata(appHandle, 'ControlLoopData');
    % If this is the first time in the stage, do the initialization stuff.
    if cldata.initStage
        cldata.initStage = 0;
        %----Jing 11/12/08
        if cldata.movdelaycontrol
            disp(cldata.stage)
            cldata.responeTime = toc;
            cldata.responeInMiddle = 0;
        end
        %----End 11/12/08----

        %---Jing for Monocular Protocol 03/06/09-----
        if cldata.enablemonocular
            cldata.monocularflag = 1;
        end
        %----End 03/06/09-----

        setappdata(appHandle, 'ControlLoopData', cldata);

        % Start the timer.
        tic;
        if isfield(data, 'pogen_oddity') %---Jing for handling para pogen_oddity in data structure protinfo only in pogen's protocol. 03/27/08---
            if (data.pogen_oddity == 1)
                soundsc(cldata.beginWav,100000) % Sound before first movement
                beep_count=1;
                setappdata(appHandle, 'BeepCount', beep_count);
            end
        end
    end

    if isfield(data, 'pogen_oddity') %---Jing for handling para pogen_oddity in data structure protinfo. 03/27/08---
        beep_count = getappdata(appHandle, 'BeepCount');
        if (data.pogen_oddity==1) && (beep_count==1) && (toc >= (cldata.firstIntTime + cldata.delayTime))
            soundsc(cldata.beginWav,100000) % Sound before second movement
            beep_count=2;
            setappdata(appHandle, 'BeepCount', beep_count);
        end

        if (data.pogen_oddity==1) && (beep_count==2) && ( floor(toc) == floor(2*cldata.firstIntTime + 2*cldata.delayTime))
            soundsc(cldata.beginWav,100000) % Sound before third movement
            beep_count=3;
            setappdata(appHandle, 'BeepCount', beep_count);
        end
    end

    %----Jing for light control between 1I and 2I or 2I and 3I movement  12/03/07----
    if cldata.lightcontrol == 2 && connected
        if toc >= cldata.firstIntTime+timeOffset && cldata.lightflag == 0 %---1I end---
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            cbDOut(boardNum, portNum, 8);  %---Turn on the light ---
            cldata.lightflag = 1;
            setappdata(appHandle, 'ControlLoopData', cldata);
        end

        if toc >= cldata.firstIntTime+cldata.delayTime+timeOffset && cldata.lightflag == 1 %---2I start---
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            cbDOut(boardNum, portNum, 0);  %---Turn off the light---
            cldata.lightflag = 2;
            setappdata(appHandle, 'ControlLoopData', cldata);
        end
    end
    %----Jing end 12/03/07-----


    %----Jing added here for collect response during movement. 01/29/07. Change a little on 02/06/07---
    COMBOARDNUM = 0; %added by Tunde due to error during reaction time task
    if toc >= cldata.firstIntTime+cldata.delayTime+timeOffset && cldata.resp == 0
        if connected
            % Configure Port
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            response = cbDIn(boardNum, portNum);
            response = mod(response, 8);   %---Jing for light control 12/03/07---
            %             response = 1; %%%automatic response !
            if response == 1 || response == 2
                cldata.resp = response;
                setappdata(appHandle, 'ControlLoopData', cldata);

                %---Jing for Reaction_time_task Protocol 11/10/08-----
                if cldata.movdelaycontrol
                    cldata = getappdata(appHandle, 'ControlLoopData');
                    cldata.responeTime = cldata.responeTime + toc;
                    toc
                    cldata.responeInMiddle = 1;
                    %---Jian for RTT Rot Prot 06/02/2010----
                    if cldata.responeTime-cldata.preTrialTime > cldata.mainStageTime*cldata.resptimepct/100
                        cldata.responeInMiddle = 2;
                    end
                    %--- End 06/02/2010 ----
                    setappdata(appHandle, 'ControlLoopData', cldata);

                    cbDOut(boardNum, portNum, 8); % Send out 5v to stop the moog. Jing01/28/09
                    %                     estop_time = [0 0];
                    %                     estop_time(1) = toc;
                    %                     for estop_counter = 1:1000
                    %                         estop_time(2) = toc;
                    %                         diff_estop_time = estop_time(2) - estop_time(1)
                    %                         if ( diff_estop_time > 1) % 1 sec
                    %                             break
                    %                         end
                    %                     end
                    pause(1)
                    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
                    outString = 'GO_TO_ORIGIN 1';
                    if connected
                        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                    end
                    %
                    %                     if debug
                    %                         disp(outString)
                    %                     end
                    %commented out temporarily as this produced
                    %bumps in the middle of the trajectory. Need to
                    %find a way to fix this..... Tunde -- 01/7/09
                    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
                end
                %---End 11/10/08-----
            end
        end
    end
    %----Jing end---------------

    %---Jing for StepVelocity Protocol 12/01/09-----
    if cldata.enableRespBeep && cldata.respBeep && toc > cldata.respBeepTime
        cldata.respBeep = 0;
        soundsc(cldata.beginWav,200000);
        setappdata(appHandle, 'ControlLoopData', cldata);
    end
    %---End 12/01/09

    %---Jing for Monocular Protocol 03/06/09-----
    if cldata.enablemonocular && toc > cldata.firstIntTime && cldata.monocularflag
        cldata.monocularflag = 0;
        setappdata(appHandle, 'ControlLoopData', cldata);
        COMBOARDNUM = 0;
        outString = 'STAR_LEYE_COLOR 1 0 0';%%%%%%
        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        end
        if debug
            disp(outString)
        end

        outString = 'STAR_REYE_COLOR 1 0 0';%%%%%%
        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        end
        if debug
            disp(outString)
        end

        % Pogen added
        i = strmatch('WALL_DENSITY2I',{char(data.configinfo.name)},'exact');
        WallDensity=data.configinfo(i).parameters;
        i = strmatch('WALL_DIMS2I',{char(data.configinfo.name)},'exact');
        WallDims=data.configinfo(i).parameters;
        i = strmatch('WALL_ORIGIN2I',{char(data.configinfo.name)},'exact');
        WallOrigin=data.configinfo(i).parameters;
        outString = ['WALL_ORIGIN 0 ',num2str(WallOrigin),' 0'];
        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        end
        if debug
            disp(outString)
        end
        outString = ['WALL_DIMS_N_DENSITY ',num2str(WallDims),' ',num2str(WallDensity)];
        if connected
            cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        end
        if debug
            disp(outString)
        end
        %         outString = ['WALL_DENSITY 0.00000001'];
        %         if connected
        %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %         end
        %         if debug
        %             disp(outString)
        %         end
        %         outString = ['WALL_DIMS ',num2str(WallDims)];
        %         if connected
        %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %         end
        %         if debug
        %             disp(outString)
        %         end
        %         outString = ['WALL_DENSITY ',num2str(WallDensity)];
        %         if connected
        %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %         end
        %         if debug
        %             disp(outString)
        %         end

    end
    %---End 03/06/09-----


    %=======Jimmy for Randomizing Cylinders [4/22/08]=====%Jing 12/01/08
    %     data = getappdata(appHandle,'protinfo');
    %
    %     i = strmatch('CYLINDERS_XPOS',{char(data.configinfo.name)},'exact');
    %     if ~isempty(i)
    %         tmp = cldata.cylinders_xpos;    % get starting values from cldata.
    %         tmp = [tmp(1)+(rand*20-10), tmp(2)+(rand*20-10), tmp(3)+(rand*20-10)];
    %         data.configinfo(i).parameters = tmp;
    %     end
    %
    %     i = strmatch('CYLINDERS_YPOS',{char(data.configinfo.name)},'exact');
    %     if ~isempty(i)
    %         tmp = cldata.cylinders_ypos;
    %         tmp = [tmp(1)+(rand*20-10), tmp(2)+(rand*20-10), tmp(3)+(rand*20-10)];
    %         data.configinfo(i).parameters = tmp;
    %     end
    %
    %     setappdata(appHandle, 'protinfo', data);
    %=======Jimmy End===============%

    %==========Jimmy for Randomizing Seed of Noise Param [6/5/08]========%
    i = strmatch('NOISE_PARAMS',{char(data.configinfo.name)},'exact');
    if ~isempty(i)
        tmp = data.configinfo(i).parameters;
        tmp(7) = floor(rand*2000);
        data.configinfo(i).parameters = tmp;

        setappdata(appHandle, 'protinfo', data);
    end
    %===============Jimmy End==========%Jing end 12/01/08

    %=======Setup eyeTracking. Jing 01/27/09====================
    flagdata = getappdata(appHandle,'flagdata');
    if flagdata.isEyeTracking
        getEyeTrackingData;
    end
    %=======End 01/27/09===========

    % if the timer is done, go to the next stage.
    if toc >= cldata.mainStageTime+timeOffset %----Jing added time offset 02/06/07---
        cldata.stage = 'PostTrialStage';
        cldata.initStage = 1;
        setappdata(appHandle, 'ControlLoopData', cldata);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PostTrialStage
%   Does any post trial cleanup, like saving out the log file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostTrialStage(appHandle)

global connected debug

paused = get(findobj(appHandle,'Tag','PauseButton'),'Value');
if ~paused

    cldata = getappdata(appHandle, 'ControlLoopData');
    data = getappdata(appHandle, 'protinfo');
    trial = getappdata(appHandle,'trialInfo');
    %crossvals = getappdata(appHandle,'CrossVals');
    CLoop = getappdata(appHandle,'Timer');

    if cldata.initStage
        %----Set the bit to 0v. Jing 01/28/09
        if cldata.movdelaycontrol
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            cbDOut(boardNum, portNum, 0);
        end  %End 01/08/09

        disp(['Answer Now you have ' num2str(cldata.respTime) ' seconds'])
        % Collect Response
        eval([data.functions.CollectResponse '(appHandle);']);

        %=======Setup eyeTracking. Jing 01/27/09====================
        flagdata = getappdata(appHandle,'flagdata');
        if flagdata.isEyeTracking
            cleanUpEyeTracking;
        end
        %========End Jing 01/27/09=================================

        %-----Jing 11/12/08-----
        if cldata.movdelaycontrol && cldata.responeInMiddle == 0
            cldata.responeTime = cldata.responeTime + cldata.mainStageTime + toc;
            setappdata(appHandle, 'ControlLoopData', cldata);
        end
        %----End 11/12/08-------

        % Analyze Response
        eval([data.functions.AnalyzeResponse '(appHandle);']);
        %---End 03/12/08---

        COMBOARDNUM = 0;

        %----Tunde added on 02/05/07-----------------------------
        % % %         outString = 'BACKGROUND_ON 0';%%%%%%
        % % %         if connected
        % % %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        % % %         end
        % % %         outString = 'SPHERE_FIELD_PARAMS 0 5 1 1 0.05';
        % % %         if connected
        % % %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        % % %         end
        % % %
        % % %         outString = 'ENABLE_FLOOR 0';
        % % %         if connected
        % % %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        % % %         end
        % % %         outString = 'ENABLE_CYLINDERS 0';
        % % %         if connected
        % % %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        % % %         end
        % % %
        % % %         outString = 'ENABLE_TUNNEL 0';  %----Jing for Tunnel prot------
        % % %         if connected
        % % %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        % % %         end
        % % %
        %         outString = 'FP_ON 0';  %----Jing for Tunnel prot------
        %         if connected
        %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %         end
        %-----Tunde end----------------------

        %         if debug
        %             disp(outString)
        %         end

        % % this section is needed for the reaction time task
        if exist('cldata.responeInMiddle')
            if cldata.responeInMiddle == 0
                outString = 'GO_TO_ORIGIN 1';%%%%%%%
                if connected
                    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
                end
            end
        elseif strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')   %Jian 09/20/2012
        else %i.e. not reaction time task
            outString = 'GO_TO_ORIGIN 1';%%%%%%% 
            disp(outString)
            if connected
                cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
            end
        end

        %
        %     if cldata.responeInMiddle == 0
        %         outString = 'GO_TO_ORIGIN 1';%%%%%%%
        %         if connected
        %             cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %         end
        %     end



        %         if debug
        %             disp(outString)
        %         end

        tic % start timer for posttrial time

        cldata.initStage = 0;
        cldata.stage = 'PostTrialStage';
        cldata.trialCount = cldata.trialCount +1; % Jing for trialhistory 05/15/09
        setappdata(appHandle, 'ControlLoopData', cldata);

        % Plot psychometric function
        eval([data.functions.OnlineAnalysis '(appHandle);']);
        % Create Saved Info Structure
        eval([data.functions.MakeData '(appHandle);']);
    end

    if toc >= cldata.postTrialTime
        %---Jing for light control 12/03/07---
        if connected && cldata.lightcontrol ~= 0
            boardNum = 1;
            portNum = 1;
            direction = 1;
            errorCode = cbDConfigPort(boardNum, portNum, direction);
            if errorCode ~= 0
                str = cbGetErrMsg(errorCode);
                disp(['WRONG cbDConfigPort ' str])
            end
            cbDOut(boardNum, portNum,8);
        end
        %---end 12/03/07---

        % Analyze Response to determine next trial (Staircase)
        activeStair = data.activeStair; %---Jing for combine multi-staircase 12/01/08----
        activeRule = data.activeRule;
        if cldata.staircase && trial(activeStair,activeRule).cntr < trial(activeStair,activeRule).num
            eval([data.functions.Staircase '(appHandle);']);
            trial = getappdata(appHandle,'trialInfo');
        end
        trial(activeStair,activeRule).cntr = trial(activeStair,activeRule).cntr + 1;
        setappdata(appHandle,'trialInfo',trial);

        %==================================================================
        % Jimmy Added 1/24/2008. chooseNext handles which trial within a
        % particular staircase is going to be done next, and does not
        % handle which across Staircase is going to be choosen Next. So I
        % will do that here.  ---Jing copy 12/01/08---

        %         if trial(activeStair).cntr > trial(activeStair).num
        %             % if current number of trials done is greater than the total
        %             % number of staircase trials that was specified, then this
        %             % within Staircase is finished.
        %             trial(activeStair).stop = 1;
        %             trial(activeStair).start = 0;
        %             % have to get rid of this staircase from the active list.
        %             stillActive = data.stillActive;
        %             stillActive = stillActive(find(stillActive ~= activeStair));
        %             if ~isempty(stillActive)
        %                 data.stillActive = stillActive;
        %                 setappdata(appHandle,'protinfo',data);
        %                 activeStair = stillActive(1);
        %                 setappdata(appHandle,'trialInfo',trial);
        %             else
        %                 stop(CLoop);
        %             end
        %         else
        %              tmp = data.stillActive;
        %              ind = randperm(length(tmp));
        %              activeStair = tmp(ind(1));  % the number/index for the next staircase to be run.
        %         end


        if trial(activeStair,activeRule).cntr > trial(activeStair,activeRule).num
            trial(activeStair,activeRule).stop = 1;
            trial(activeStair,activeRule).start = 0;
            data.stillActive(activeStair,activeRule) = 0;
            setappdata(appHandle,'protinfo',data);
            setappdata(appHandle,'trialInfo',trial);
        end

        if sum(sum(data.stillActive)) ~=0
            [lenS,lenR] = size(data.stillActive);
            tmpS = randperm(lenS);
            tmpR = randperm(lenR);
            while data.stillActive(tmpS(1),tmpR(1)) == 0
                tmpS = randperm(lenS);
                tmpR = randperm(lenR);
            end
            activeStair =  tmpS(1);
            activeRule = tmpR(1);
        else
            stop(CLoop);
        end

        if debug && cldata.staircase
            fprintf('The next Staircase used is block number %d ,rule number %d \n', activeStair, activeRule);
        end

        data.activeStair = activeStair;
        data.activeRule = activeRule;
        setappdata(appHandle,'protinfo',data);
        %==========================End Jimmy Added=========Jing 12/01/08

        disp('ending posttrialstage')
        if debug
            disp('End ControlLoop')
        end
        cldata.stage = 'InitializationStage';
        cldata.initStage = 1;
        cldata.resp = 0; % ---Jing added 01/29/07----
        setappdata(appHandle, 'ControlLoopData', cldata);

        % To stop the CLoop when all trials are done. When all trials are done,
        % their 'stop' field should all be equal to 1, so set 'isTrialStop' to be 0,
        % indicating that all trials are done.
        flagdata = getappdata(appHandle,'flagdata');
        count = 0;

        [ilen,jlen] = size(trial);
        for i=1:ilen
            for j=1:jlen
                if (trial(i,j).stop) && flagdata.isTrialStop == 0
                    count = count + 1;
                end
            end
        end
        if count == ilen*jlen
            flagdata.isTrialStop = 1;
            setappdata(appHandle,'flagdata',flagdata);
        end

        flagdata = getappdata(appHandle,'flagdata');
        if flagdata.isTrialStop == 1  % all the trial are done, end CLoop.
            stop(CLoop);
        end
    end

    %---end 03/27/08---
    setappdata(appHandle, 'ControlLoopData', cldata);
end
