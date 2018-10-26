function analyzeResp_RTT(appHandle)
global  debug 

if debug
    disp('Entering analyzeResp_RTT')
end

%Resp = getappdata(appHandle,'ResponseInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
crossVals = getappdata(appHandle,'CrossVals');
cldata = getappdata(appHandle, 'ControlLoopData');

response = savedInfo.Resp(data.repNum).response(trial.cntr);
HR = cldata.hReference;

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1   % For single interval
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact');
        dir = crossVals(trial.list(trial.cntr),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir = data.configinfo(i).parameters.moog;
    end

    savedInfo.Resp(data.repNum).dir(trial.cntr,1) = dir;

    if response == 1 % Respond 1 %Left/Down
        if debug
            disp('You answered Left/Down')
        end
        if dir < 0
            if debug
                disp('correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        elseif dir > 0
            if debug
                disp('Not correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end
    elseif response == 2 % Respond 2 Right/Up
        if debug
            disp('you answered right/up')
        end
        if dir > 0
            if debug
                disp('correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        elseif dir < 0
            if debug
                disp('Not correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end

    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
        savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
        savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
        savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
    end
else  % For 2 interval
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact');
        dir(1) = crossVals(trial.list(trial.cntr),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Heading Direction 2nd Int',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.varying.name)},'exact');
        dir(2) = crossVals(trial.list(trial.cntr),i1);
    else

        i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
        dir(2) = data.configinfo(i).parameters.moog;
    end

    if HR
        if debug
            disp('inside analyzeresp hr=1');
        end
        dir(2) = dir(2) + dir(1);
    end

    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dir1 = dir(intOrder(1));
    dir2 = dir(intOrder(2));

    savedInfo.Resp(data.repNum).dir(trial.cntr,:) = dir2 - dir1;
    savedInfo.Resp(data.repNum).intOrder(trial.cntr,:) = intOrder;

    if response == 1 % Respond 1 (Left/Down)
        if debug
            disp('You answered Left/Down')
        end
        if dir2 < dir1
            if debug
                disp('correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        elseif dir2 > dir1
            if debug
                disp('Not correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end
    elseif response == 2 % Respond 2 (Right/Up)
        if debug
            disp('you answered right')
        end
        if dir2 > dir1
            if debug
                disp('correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        elseif dir2 < dir1
            if debug
                disp('Not correct')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
            savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
            savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end

    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo.Resp(data.repNum).corr(trial.cntr) = 0;
        savedInfo.Resp(data.repNum).incorr(trial.cntr) = 0;
        savedInfo.Resp(data.repNum).null(trial.cntr) = 1;
        savedInfo.Resp(data.repNum).dontKnow(trial.cntr) = 0;
    end
end

savedInfo.Resp(data.repNum).totalCorr = sum(savedInfo.Resp(data.repNum).corr);
savedInfo.Resp(data.repNum).totalIncorr = sum(savedInfo.Resp(data.repNum).incorr);
savedInfo.Resp(data.repNum).totalNull = sum(savedInfo.Resp(data.repNum).null);
savedInfo.Resp(data.repNum).totalDontKnow = sum(savedInfo.Resp(data.repNum).dontKnow);

%----save delay movement time-----
savedInfo.Resp(data.repNum).delayTime(trial.cntr) = cldata.preTrialTime*1000;
savedInfo.Resp(data.repNum).responseTime(trial.cntr) = cldata.responeTime*1000;
savedInfo.Resp(data.repNum).responseInMiddle(trial.cntr) = cldata.responeInMiddle;

%setappdata(appHandle,'ResponseInfo',Resp);
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    if savedInfo.Resp(data.repNum).corr(trial.cntr) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting analyzeResp_RTT')
end


