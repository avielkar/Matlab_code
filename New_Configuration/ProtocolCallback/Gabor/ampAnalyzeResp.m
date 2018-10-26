function ampAnalyzeResp(appHandle)
%Jing modified this function for combining multi-staircase 12/17/08

global  debug %connected

if debug
    disp('Entering amp analyzeResp')
end

%Resp = getappdata(appHandle,'ResponseInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
%crossVals = getappdata(appHandle,'CrossVals');
within = data.condvect.withinStair;

%response = Resp(data.repNum).response(trial.cntr);
activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;
response =savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1
else  % For 2 interval
    if ~isempty(strmatch('Distance',{char(within.name)},'exact'))
        %i1 = strmatch('Distance',{char(within.name)},'exact');
        %dist(1) = crossVals(trial.list(trial.cntr),i1);
        dist(1) = within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        i = strmatch('DIST',{char(data.configinfo.name)},'exact');
        dist(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Distance 2nd Int',{char(within.name)},'exact'))
        %i1 = strmatch('Distance 2nd Int',{char(within.name)},'exact');
        %dist(2) = crossVals(trial.list(trial.cntr),i1);
        dist(2) = within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        i = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
        dist(2) = data.configinfo(i).parameters.moog;
    end

    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dist1 = dist(intOrder(1));
    dist2 = dist(intOrder(2));

%     Resp(data.repNum).dist(trial.cntr,:) = dist2 - dist1;
%     Resp(data.repNum).intOrder(trial.cntr,:) = intOrder; %----Jing added 02/16/07--
    savedInfo(activeStair,activeRule).Resp(currRep).dist(currTrial) = dist2 - dist1;
    savedInfo(activeStair,activeRule).Resp(currRep).intOrder(currTrial,:) = intOrder;
    
    if response == 1 % Respond 1 (Left/Down)
        if debug
            disp('You answered First Faster')
        end
        if dist2 < dist1
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dist2 > dist1
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
            disp('You answered Second Faster')
        end
        if dist2 > dist1
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
        elseif dist2 < dist1
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
    if savedInfo(activeStair,activeRule).Resp(currRep).corr(trial.cntr) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting amp analyzeResp')
end


