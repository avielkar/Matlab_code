function analyzeResp(appHandle)

global  debug %connected

if debug
    disp('Entering 2I_experment analyzeResp')
end

%Resp = getappdata(appHandle,'ResponseInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
%crossVals = getappdata(appHandle,'CrossVals');
within = data.condvect.withinStair;

cldata = getappdata(appHandle, 'ControlLoopData');
HR = cldata.hReference;

%response = Resp(data.repNum).response(trial.cntr);

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;
response = savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1   % For single interval
    if ~isempty(strmatch('Heading Direction',{char(within.name)},'exact'))
        %i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
        %dir = crossVals(trial.list(trial.cntr),i1);
        dir =within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir = data.configinfo(i).parameters.moog;
    end

    savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial) = dir;

    if response == 1 % Respond 1 %Left/Down
        if debug
            disp('You answered Left/Down')
        end
        if dir < 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dir > 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == 2 % Respond 2 Right/Up
        if debug
            disp('you answered right/up')
        end
        if dir > 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dir < 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        end

    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
    end

else  % For 2 interval
    
    if ~isempty(strmatch('Heading Direction',{char(within.name)},'exact'))
        %i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
        %dir(1) = crossVals(trial.list(trial.cntr),i1);
        dir(1) = within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Heading Direction 2nd Int',{char(within.name)},'exact'))
        %i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact');
        %dir(2) = crossVals(trial.list(trial.cntr),i1);
        dir(2) = within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
        dir(2) = data.configinfo(i).parameters.moog;
    end
    

    if HR %------Jing for different heading reference 03/14/07----
        dir(2) = dir(2) + dir(1);
    end %----end 03/14/07----

    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dir1 = dir(intOrder(1));
    dir2 = dir(intOrder(2));

    savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial,:) = dir2 - dir1;
    savedInfo(activeStair,activeRule).Resp(currRep).intOrder(currTrial,:) = intOrder; %----Jing added 02/16/07--

    if response == 1 % Respond 1 (Left/Down)
        if debug
            disp('You answered Left/Down')
        end
        if dir2 < dir1
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dir2 > dir1
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == 2 % Respond 2 (Right/Up)
        if debug
            disp('you answered right')
        end
        if dir2 > dir1
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dir2 < dir1
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        end

    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr

        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
    end
end

savedInfo(activeStair,activeRule).Resp(currRep).totalCorr = sum(savedInfo(activeStair,activeRule).Resp(currRep).corr);
savedInfo(activeStair,activeRule).Resp(currRep).totalIncorr = sum(savedInfo(activeStair,activeRule).Resp(currRep).incorr);
savedInfo(activeStair,activeRule).Resp(currRep).totalNull = sum(savedInfo(activeStair,activeRule).Resp(currRep).null);
savedInfo(activeStair,activeRule).Resp(currRep).totalDontKnow = sum(savedInfo(activeStair,activeRule).Resp(currRep).dontKnow);

%setappdata(appHandle,'ResponseInfo',Resp);
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    if savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting 2I_experment analyzeResp')
end


