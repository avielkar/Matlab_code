% --- Executes on button press in StartButton.
function StartButtonCallbackFunc(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global basicfig connected debug
global SUBJECT_NUM
global responseBoxHandler
global print_var
data = getappdata(basicfig,'protinfo');
flagdata = getappdata(basicfig,'flagdata');
crossvals = getappdata(basicfig,'CrossVals');

COMBOARDNUM = 0;
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% Set Control Loop data, and initialize Variables used in Control Loop
cldata.stage = 'InitializationStage';
cldata.initStage = 1; % represents first time on this stage
cldata.resp = 0; %---Jing for collect response during the movement 01/29/07---
cldata.trialCount = 0;   %Jing for trial history 05/15/09

if ~isempty(data.condvect.acrossStair) || ~isempty(data.condvect.withinStair)
    cldata.staircase = 1;
else
    cldata.staircase = 0;
end

i = strmatch('HEADING_REFERENCE',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.hReference = 0;
else
    cldata.hReference = data.configinfo(i).parameters;
end

i = strmatch('LIGHT_CONTROL',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.lightcontrol = 0;
else
    cldata.lightcontrol = data.configinfo(i).parameters;
end
cldata.lightflag = 0;

if debug
    sprintf('staircase=%f\n hReference=%f\n LightControl=%f\n',cldata.staircase,cldata.hReference,cldata.lightcontrol)
end

%---Jing for Reaction_time_task Protocol 11/10/08-----
i = strmatch('DELAY_MOVEMENT',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.movdelaycontrol = 0;
else
    cldata.movdelaycontrol = data.configinfo(i).parameters;
end
%----End 08/21/08------

%---Jian for RTT Rot Prot 06/02/2010----
i = strmatch('RESP_TIME_PCT',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.resptimepct = 100000;
else
    cldata.resptimepct = data.configinfo(i).parameters;
end
%---- End 06/02/2010 ------

%---Jing for Monocular Protocol 03/06/09-----
i = strmatch('ENABLE_MONOCULAR',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.enablemonocular = 0;
else
    cldata.enablemonocular = data.configinfo(i).parameters;
end
%----End 03/06/09-----

%---Jing for StepVelocity Protocol 12/01/09-----
i = strmatch('RESPONSE_BEEP',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.enableRespBeep = 0;
else
    cldata.enableRespBeep = data.configinfo(i).parameters;
end
%----End 12/01/09-----


%=====Jimmy for Cylinders [4/22/08]=======%Copy from multistaircase by Jing 12/01/08

%     i = strmatch('ENABLE_CYLINDERS',{char(data.configinfo.name)},'exact');
%     if isempty(i)
%         cldata.enable_cylinders = 1;
%     else
%         cldata.enable_cylinders = data.configinfo(i).parameters;
%     end
%     i = strmatch('CYLINDERS_XPOS',{char(data.configinfo.name)},'exact');
%     if isempty(i)
%         cldata.cylinders_xpos = [0 10 -10]; % default moog dots values
%     else
%         cldata.cylinders_xpos = data.configinfo(i).parameters;
%     end
%     i = strmatch('CYLINDERS_YPOS',{char(data.configinfo.name)},'exact');
%     if isempty(i)
%         cldata.cylinders_ypos = [0 10 -10]; % default moog dots values
%     else
%         cldata.cylinders_ypos = data.configinfo(i).parameters;
%     end
%     i = strmatch('CYLINDERS_ZPOS',{char(data.configinfo.name)},'exact');
%     if isempty(i)
%         cldata.cylinders_zpos = [10 10 10]; % default moog dots values
%     else
%         cldata.cylinders_zpos = data.configinfo(i).parameters;
%     end

%======Jimmy End Cylinders======%End 12/01/08----

i= strmatch('DUR_SWEEPING_TARGET',{char(data.configinfo.name)},'exact');
if isempty(i)
    i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
    dur1 = data.configinfo(i).parameters.moog(1);
else
    dur1 = data.configinfo(i).parameters;
end

%------Jian for Ardom 08/10/12-------------------
i = strmatch('FP_CONTROL',{char(data.configinfo.name)},'exact');
if isempty(i)
    cldata.fpcontrol = 0;
else
    cldata.fpcontrol = data.configinfo(i).parameters;
end
%------End 08/10/12-------------------------------

i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
dur2 = data.configinfo(i).parameters.moog(1);
i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
del = data.configinfo(i).parameters.moog(1);

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 3
    %cldata.mainStageTime = dur1 + dur2 + del;
    %%%%%todo:avi: this is changed to be without the dur2 because the
    %%%%%mainTimerStage wait all this time and it should be only the rime
    %%%%%of the delay and the dur2 : see :if toc >=
    %%%%%cldata.mainStageTime+timeOffset  in control loop.
    cldata.mainStageTime = dur1 + del;
    %---Jing added for collect response while movement. 01/30/07---
    cldata.firstIntTime = dur1;
    cldata.delayTime = del;
    %---Jing end---
else
    cldata.mainStageTime = dur1;
    %---Jing added for collect response while movement. 01/30/07---
    cldata.firstIntTime = 0;
    cldata.delayTime = 0;
    %---Jing end---
end

i = strmatch('PRE_TRIAL_TIME',{char(data.configinfo.name)},'exact');
cldata.preTrialTime = data.configinfo(i).parameters(1);
i = strmatch('WAIT_FOR_RESP',{char(data.configinfo.name)},'exact');
cldata.respTime = data.configinfo(i).parameters(1);
i = strmatch('POST_TRIAL_TIME',{char(data.configinfo.name)},'exact');
cldata.postTrialTime = data.configinfo(i).parameters(1);
i = strmatch('RAND_METHOD',{char(data.configinfo.name)},'exact');
randMethod = data.configinfo(i).parameters(1);

%avi----for Sol DELTA protocol.
i = strmatch('DUPLICATE_STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');
if(~isempty(i))
    cldata.duplicatedStimulusType = data.configinfo(i).parameters;
    i_DUPLICATED_STYYMULUS_TYPE_COHERENCE = strmatch('DUPLICATED_STYYMULUS_TYPE_COHERENCE' ,{char(data.configinfo.name)},'exact');
    cldata.starDuplicatedMotionCoherence = data.configinfo(i_DUPLICATED_STYYMULUS_TYPE_COHERENCE).parameters;
else
    cldata.duplicatedStimulusType = 0;
end
%-----end


cldata.beginWav = sin(500*2*pi*(0:.00001:.125));
i = strmatch('SOUND_FREQ',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    freq = data.configinfo(i).parameters(1);
    cldata.beginWav2 = sin(freq*2*pi*(0:.00001:.125));
end

i = strmatch('SOUND_FREQ_2I',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    freq = data.configinfo(i).parameters(1);
    cldata.beginWav3 = sin(freq*2*pi*(0:.00001:.125));
end


setappdata(basicfig,'ControlLoopData',cldata);

Resp = [];
setappdata(basicfig,'ResponseInfo',Resp);

SavedInfo =[];
setappdata(basicfig,'SavedInfo',SavedInfo);

%%

%% ---Jing added for plotPsychFunc.m 01/24/07----
psychPlot.iDir=0;
psychPlot.dirArray=[];
psychPlot.dirRepNum=[];
psychPlot.rightChoice=[];
psychPlot.trialDir = [];
psychPlot.trialCorr = [];
%% ---Jing end---

%% --Jing 12/10/09 for Adaptation Heading Dism protocol psych plot.-----
psychPlot.iDirVes = 0;              %Vestibula only
psychPlot.dirArrayVes = [];
psychPlot.dirRepNumVes = [];
psychPlot.rightChoiceVes = [];

psychPlot.iDirVisual = 0;              %Visual only
psychPlot.dirArrayVisual = [];
psychPlot.dirRepNumVisual = [];
psychPlot.rightChoiceVisual = [];
%% ---end 12/10/09----

%---------avi: for Adam1_Prior protocol and sol Adam1_Delta protocol.

%% -----Adam1_Delta protocol psych plot
psychPlot.iDirLeftDelta = 0;
psychPlot.dirArrayLeftDelta = [];
psychPlot.dirRepNumLeftDelta = [];
psychPlot.rightChoiceLeftDelta = [];

psychPlot.iDirRightDelta = 0;
psychPlot.dirArrayRightDelta = [];
psychPlot.dirRepNumRightDelta = [];
psychPlot.rightChoiceRightDelta = [];

psychPlot.iDirDuplicated = 0;
psychPlot.dirArrayDuplicated = [];
psychPlot.dirRepNumDuplicated = [];
psychPlot.rightChoiceDuplicated = [];

psychPlot.iDirStim114Delta = 0;
psychPlot.dirArray114Delta = [];
psychPlot.dirRepNum114Delta = [];
psychPlot.rightChoice114Delta = [];

psychPlot.iDirStim115Delta = 0;
psychPlot.dirArray115Delta = [];
psychPlot.dirRepNum115Delta = [];
psychPlot.rightChoice115Delta = [];

psychPlot.iDirStim124Delta = 0;
psychPlot.dirArray124Delta = [];
psychPlot.dirRepNum124Delta = [];
psychPlot.rightChoice124Delta= [];

psychPlot.iDirStim125Delta = 0;
psychPlot.dirArray125Delta = [];
psychPlot.dirRepNum125Delta = [];
psychPlot.rightChoice125Delta = [];
%% -----end

%% -----Adam1_Priors protocol for left priors
psychPlot.iDirLeftPriorCombined = 0;            
psychPlot.dirArrayLeftPriorCombined = [];
psychPlot.dirRepNumLeftPriorCombined = [];
psychPlot.rightChoiceLeftPriorCombined = [];

psychPlot.iDirLeftPriorVes = 0;
psychPlot.dirArrayLeftPriorVes = [];
psychPlot.dirRepNumLeftPriorVes = [];
psychPlot.rightChoiceLeftPriorVes = [];

psychPlot.iDirLeftPriorVisual = 0;
psychPlot.dirArrayLeftPriorVisual = [];
psychPlot.dirRepNumLeftPriorVisual = [];
psychPlot.rightChoiceLeftPriorVisual = [];
%% ------end

%% -----Adam1_Priors protocol for right priors
psychPlot.iDirRightPriorCombined = 0;            
psychPlot.dirArrayRightPriorCombined = [];
psychPlot.dirRepNumRightPriorCombined = [];
psychPlot.rightChoiceRightPriorCombined = [];

psychPlot.iDirRightPriorVes = 0;
psychPlot.dirArrayRightPriorVes = [];
psychPlot.dirRepNumRightPriorVes = [];
psychPlot.rightChoiceRightPriorVes = [];

psychPlot.iDirRightPriorVisual = 0;
psychPlot.dirArrayRightPriorVisual = [];
psychPlot.dirRepNumRightPriorVisual = [];
psychPlot.rightChoiceRightPriorVisual = [];
%% ------end

%% -----Adam1_sound protocol for sound 
psychPlot.iDir100 = 0;            
psychPlot.dirArray100 = [];
psychPlot.dirRepNum100 = [];
psychPlot.rightChoice100 = [];

psychPlot.iDir110 = 0;            
psychPlot.dirArray110 = [];
psychPlot.dirRepNum110 = [];
psychPlot.rightChoice110 = [];

psychPlot.iDir120 = 0;            
psychPlot.dirArray120 = [];
psychPlot.dirRepNum120 = [];
psychPlot.rightChoice120 = [];

psychPlot.iDir130 = 0;            
psychPlot.dirArray130 = [];
psychPlot.dirRepNum130 = [];
psychPlot.rightChoice130 = [];
%% ------end
psychPlot.iDir114 = 0;            
psychPlot.dirArray114 = [];
psychPlot.dirRepNum114 = [];
psychPlot.rightChoice114 = [];

psychPlot.iDir115 = 0;            
psychPlot.dirArray115 = [];
psychPlot.dirRepNum115 = [];
psychPlot.rightChoice115 = [];

psychPlot.iDir124 = 0;            
psychPlot.dirArray124 = [];
psychPlot.dirRepNum124 = [];
psychPlot.rightChoice124 = [];

psychPlot.iDir125 = 0;            
psychPlot.dirArray125 = [];
psychPlot.dirRepNum125 = [];
psychPlot.rightChoice125 = [];
%%Sound protocols for sound+delta

%%

%---------end: for Adam1_Prior protocol and sol Adam1_Delta protocol.

setappdata(basicfig,'psychPlot',psychPlot);
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if connected
    initServer
end

% If Order Repeated every time start protocol set rand state here
if randMethod == 1 % sets state of random number generator
    rng('shuffle') %AZ changed
    %rand('state',data.randomseed)
end

CLoop = getappdata(basicfig,'Timer');

iRep = 1;
flagdata.isStopButton = 0; %Jing 01/05/09---
setappdata(basicfig,'flagdata',flagdata);%Jing 01/05/09---

% Loop that runs as long as the experiment goes on (trials + no stop button)
while iRep<=data.reps && ~flagdata.isTrialStop && ~flagdata.isStopButton %Jing 01/05/09---  
    flagdata = getappdata(basicfig,'flagdata');
    data = getappdata(basicfig,'protinfo');
    if(print_var)
        display(' i am here ?????????????');
    end
    data.repNum = iRep; % 'iRep' is iteration of Rep Whileloop
    iRep = iRep+1; % iRep = trial number
    
    data.activeStair = 1;
    data.stillActive = 1;  
    data.activeRule = 1;
    flagdata.isTrialStart = 1;
    flagdata.isTrialStop = 0;
        
    % Determine number of trials and trial list
    if cldata.staircase   %staircase        
        across = data.condvect.acrossStair;
        within = data.condvect.withinStair;
        
        %%%%%%%% MultiStaircase rule %%%%%%%%%%%%%%%%%%%%%%%%%%%
        i=strmatch('STAIRCASE_START_VAL',{char(data.configinfo.name)},'exact');
        staircaseRuleNum = 1;
        staircaseStartPoint = 1;
        if ~isempty(i)
            staircaseRuleNum = length(data.configinfo(i).parameters); 
            tmpVect = data.configinfo(i).parameters;
            if isfield(within.parameters, 'moog')
                len = length(within.parameters.moog);
            else
                len = length(within.parameters);
            end
            
            for j= 1:staircaseRuleNum
                if tmpVect(j) == 0
                   staircaseStartPoint(j) = 1;
                elseif tmpVect(j) == 1
                   staircaseStartPoint(j)= len;
                elseif tmpVect(j) == 3 %Jing 09/16/2012
                   staircaseStartPoint(j)= 0;
                else
                   staircaseStartPoint(j)= -1;  %ceil(rand()* len);  Jing 02/23/2011
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
        if ~isempty(across) && ~isempty(within) % Multi staircase
            if isfield(across.parameters, 'moog')
                acrossLength = length(across.parameters.moog);
                for i=1:acrossLength
                    for j= 1:staircaseRuleNum
                        trial(i,j).start = 1;
                        trial(i,j).stop = 0;  % Here 0 means it is not stopped.
                        trial(i,j).acrossVal = across.parameters.moog(i);    % store the value of the across staircase in here, more convenient.
                    end
                end
            else
                acrossLength = length(across.parameters);
                for i=1:acrossLength
                    for j= 1:staircaseRuleNum
                        trial(i,j).start = 1;
                        trial(i,j).stop = 0;  % Here 0 means it is not stopped.
                        trial(i,j).acrossVal = across.parameters(i);
                        %----avi:for sol DELTA protocol (for duplicated
                        %flag)
                        if(strmatch(data.configfile , '1Adam_Delta.mat' ,'exact'))    %if sol DELTA protocol.
                            trial(i,j).duplicatedTrial = across.isParametersDuplicated(i);
                        else
                            trial(i,j).duplicatedTrial = false;
                        end
                        %----end
                    end
                end
            end
            %data.stillActive = 1:acrossLength;
            data.activeStair = 1;
            data.activeRule = 1;

            % creating the multiTrial struct
            tmpVar = str2num(get(findobj(basicfig,'Tag','NumTrialsText'),'String'));
            
            for i=1:acrossLength
                for j= 1:staircaseRuleNum
                    trial(i,j).cntr = 1;
                    trial(i,j).list = staircaseStartPoint(j);
                    if staircaseStartPoint(j)<0    %  Jing 02/23/2011 
                        trial(i,j).list = ceil(rand()* len);
                    end
                    
                    if staircaseStartPoint(j)== 0    % Jing 09/16/2012
                        m=rand;
                        if m < 0.5
                            trial(i,j).list = 1;
                        else
                            trial(i,j).list = len;
                        end                            
                    end
                        
                    trial(i,j).num = tmpVar;
                    %-----avi:for Adam1_Prior protocol
                    trial(i,j).priorCntr = 1;
                    %-----
                    data.stillActive(i,j) = 1;
                end
            end

%             for i=1:length(trial)
%                 trial(i).num = str2num(get(findobj(basicfig,'Tag','NumTrialsText'),'String'));
%             end
        elseif ~isempty(within)  %-----Single Staircase-----
            for j= 1:staircaseRuleNum
                trial(j).cntr = 1; % reset values each rep
                trial(j).list = staircaseStartPoint(j); % reset values each rep
                if staircaseStartPoint(j)<0    %  Jing 02/23/2011 
                    trial(j).list = ceil(rand()* len);
                end
                
                if staircaseStartPoint(j)== 0    % Jing 09/16/2012
                    m=rand;
                    if m < 0.5
                        trial(i,j).list = 1;
                    else
                        trial(i,j).list = len;
                    end
                end
                    
                trial(j).start = 1;
                trial(j).stop = 0;
                trial(j).acrossVal = 'N/A';
                data.stillActive(j) = 1;
                trial(j).num = str2num(get(findobj(basicfig,'Tag','NumTrialsText'),'String'));
            end
            
        else%if no across and within make the field 0
            trial(1,1).duplicatedTrial = false;
        end
        
        %%-----avi:for Adam1_Prior protocol
        i = strmatch('NUM_OF_PRIORS',{char(data.configinfo.name)},'exact');
        if(~isempty(i))
            numOfPriors = data.configinfo(i).parameters;
            data.condvect.priors.num = numOfPriors;
            data.condvect.priors.left = numOfPriors;
            data.condvect.priors.roundPriors = numOfPriors;
            data.condvect.priors.enabled = 1;
            
            
            i = strmatch('PRIOR_STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
            priorStimType = data.configinfo(i).parameters;
            data.condvect.priors.stim_type = priorStimType;
        else
            data.condvect.priors.enabled = 0;
        end
        %%-----end
        
    else %constant stimuli
		%%-----avi:for Adam1_Prior protocol
        i = strmatch('NUM_OF_PRIORS',{char(data.configinfo.name)},'exact');
        if(isempty(i))
            data.condvect.priors.enabled = 0;
        end
        %%-----end
    
	
        trial.cntr = 1; % reset values each rep
        trial.list = 1; % reset values each rep
        trial.start = 1;
        trial.stop = 0;
        if isempty(crossvals)
            trial.num = 1;
        else
            trial.num = length(crossvals);
        end

        % If Order Repeated every Repetition Set Rand State here
        if randMethod == 2
            rng(data.randomseed) %AZ changed
            %rand('state',data.randomseed)
        end
        % Determine trial order
        if randMethod == 0 % ordered
            trial.list = 1:trial.num;
        elseif randMethod == 3 % cumstom
            eval(['trial.list = ' data.functions.RandomOrderGeneration '(appHandle);']);
        else % random (every rep, or total)
            trial.list = randperm(trial.num);
        end
        
        %if no across and within make the field 0
        trial(1,1).duplicatedTrial = false;    
    end
    

    setappdata(basicfig,'protinfo',data);
    setappdata(basicfig,'trialInfo',trial);
    setappdata(basicfig,'flagdata',flagdata);


    %  Start Control Loop
    run = get(timerfind('Tag','CLoop'),'Running');
    if strmatch(run,'off','exact')
        %send the command to move to the origin after each start
        iORIGIN = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
        outString = ['M_ORIGIN' ' ' num2str(data.configinfo(iORIGIN).parameters/100)];
        cbDWriteString(COMBOARDNUM, sprintf('\n%s\n', outString), 5);
        outString = 'GO_TO_ORIGIN 2';
        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
        %wait for the moogdots moves the robot to the origin.
        pause(5);
        start(CLoop);
    else
        disp('Control Loop already running');
    end
    display('StartCallbackfcn');
    flagdata = getappdata(basicfig,'flagdata');
    % Runs as long as the trial is not over 
    while ~flagdata.isTrialStop
        if(print_var)
            display('i am here again FFFFFFFFFFFFFFFFFFF');
        end
        flagdata = getappdata(basicfig,'flagdata');
        data = getappdata(basicfig,'protinfo'); %----Jing added 03/27/07----       
        trial = getappdata(basicfig,'trialInfo');
        activeStair = data.activeStair;
        activeRule = data.activeRule;
        
        curTrial = trial(activeStair,activeRule).cntr;
        curActiveStair = activeStair;
        curRule = activeRule;
        
            str2 = [];
            if cldata.staircase
                if isfield(within.parameters, 'moog')
                    tmp_vect = (within.parameters.moog)';
                else
                    tmp_vect = (within.parameters)';
                end
         
                for i2 =1:size({within.name},2) 
                    str2 = [str2 ', ' within(i2).name ': ' num2str(tmp_vect((trial(activeStair,activeRule).list(curTrial)),i2))];
                end
                str1 = ['Current Trial Info: Rep ' num2str(data.repNum) ...
                        ', Across Staircase ' num2str(trial(activeStair,activeRule).acrossVal) ...
                        ', Staircase Rule ' num2str(activeRule)...
                        ', Trial ' num2str(curTrial)];
        else 
            if ~isempty(data.condvect.varying)
                for i2 =1:size({data.condvect.varying.name},2) 
                    str2 = [str2 ', ' data.condvect.varying(i2).name ': ' num2str(crossvals((trial.list(curTrial)),i2))];
                end
            end
            str1 = ['Current Trial Info: Rep ' num2str(data.repNum) ',Trial ' num2str(curTrial)];
        end
        
            str(1)={[str1 str2]};
            str(2) = {['Trial Completed: ' num2str(trial(activeStair,activeRule).cntr-1)]};
            str(3) = {['Trial Remaining: ' num2str(trial(activeStair,activeRule).num-trial(activeStair,activeRule).cntr)]};
            set(findobj(basicfig,'Tag','TrialInfoText'),'String',str);
            %------Jing end----
            while curActiveStair == activeStair && curRule == activeRule ...
                  && curTrial == trial(activeStair,activeRule).cntr && ~flagdata.isTrialStop
                drawnow     
                data = getappdata(basicfig,'protinfo');
                if(print_var)
                    display('i am here again AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
                end
                activeStair = data.activeStair;
                activeRule = data.activeRule;
                trial = getappdata(basicfig,'trialInfo');
                flagdata = getappdata(basicfig,'flagdata');
            end
    end
    flagdata.isTrialStop = 0;
    setappdata(basicfig,'flagdata',flagdata);
end

flagdata.isTrialStart = 0;
flagdata.isTrialStop = 0;
%flagdata.isStopButton = 0; %Jing 01/05/09---
setappdata(basicfig,'flagdata',flagdata);

%-----Jing for save comment 02/05/08--------
dlg_title ='Comment... ';
numlines = 3;
defaultanswer={''};
options.WindowStyle='normal';
options.Resize='on';
prompt = '';
%Comment = inputdlg(prompt, dlg_title,numlines,defaultanswer, options);
pause(0.5);
%----end 02/05/09-----------------------------

SavedInfo = getappdata(basicfig,'SavedInfo');
prot = getappdata(basicfig,'motiontype');
a = clock;
timestr = [num2str(a(4)) ',' num2str(a(5))];

[filename, pathname] = uiputfile('*.mat', 'Save Data',...
    [data.datapath filesep char(prot) '_' char(date) '_' char(timestr)]);
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    % Save out the variable data structure.
    %     save('C:\Program Files\MATLAB\R2006a\work\New Configuration\Data\temp.mat')
    %if ~isempty(Comment)
        %save([pathname, filename], 'SavedInfo','Comment');
    %else
        save([pathname, filename], 'SavedInfo');
    %end
    disp(['saving ' pathname filename])   
    cancel_save = 0;
else
    disp('Save Unsuccesful')
    cancel_save = 1;
end


if cancel_save == 1
    %     do not save data in the new automatic format
elseif cancel_save == 0  
    %global SUBJECT_NUM
    % eval(['cd ' data.datapath_primary])
    temp_dir_var = data.datapath_primary;
    dir_list = dir(data.datapath_primary);
    %-----avi:fixing the error of saving.
    found_subject_dir = 0;
    %-----
    for subject_index = 1:length(dir_list)
        found_subject_dir = strcmp(num2str(SUBJECT_NUM), dir_list(subject_index).name);
        if found_subject_dir == 1
            break
        end
    end
    if found_subject_dir == 1
        cd ([temp_dir_var, '\', dir_list(subject_index).name])
    else
        mkdir(temp_dir_var, num2str(SUBJECT_NUM))
        cd ([temp_dir_var, '\', num2str(SUBJECT_NUM)])
    end

    file_listing = dir('*.mat');
    num_data_files = size(file_listing, 1);
    if num_data_files == 0

        save([num2str(SUBJECT_NUM), '_1'], 'SavedInfo')
    else
        save([num2str(SUBJECT_NUM), '_' num2str(num_data_files + 1)], 'SavedInfo')
    end

    cd ('C:\Program Files (x86)\MATLAB\R2013b\bin')  % returnt to home directory
end
%check if the port is not opened because it is a second start
%buttom after the first has benn pushed.
try
    CedrusResponseBox('Close', responseBoxHandler);
catch
    display('The response box is already closed.')
end