function chooseNext(appHandle)

% In a staircase procedure, returns index and value of parameters for the
% next trial, based on correct or incorrect response to the current trial.
% When done with staircase procedure return index larger than crossvals,
% and ControlLoop2 will terminate session

% Should not pick trial.cntr, should just append appropriate index to the
% end of trial.list and trial.cntr will be incremented.

global debug

if debug
    disp('Entering AbsDepth chooseNext')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
%crossVals = getappdata(appHandle,'CrossVals');
savedInfo = getappdata(appHandle,'SavedInfo');

within = data.condvect.withinStair;
activeStair = data.activeStair;
activeRule = data.activeRule;

%lastInd = trial.list(trial.cntr);
%lastDir = crossVals(lastInd);
lastInd = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
if isfield(within.parameters, 'moog')
    within_vect = within.parameters.moog;
else
    within_vect = within.parameters;
end
lastDir = within_vect(lastInd);

if debug
    probDif = rand
    probAlt = rand
else
    probDif = rand;
    probAlt = rand;
end
i = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
stairUp = data.configinfo(i).parameters/100;
i = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
stairDown = data.configinfo(i).parameters/100;
i = strmatch('ERR_ALT_PROB',{char(data.configinfo.name)},'exact');
errAlt = data.configinfo(i).parameters/100;
i = strmatch('CORR_ALT_PROB',{char(data.configinfo.name)},'exact');
corrAlt = data.configinfo(i).parameters/100;

if savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr)==1
    if probDif < stairUp
        if debug
            disp('Nearer: Go Farther')
        end
        nextInd = lastInd - 1;
    end
elseif savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr)==2
    if probDif < stairDown
        
        nextInd = lastInd + 1;
    
        if debug
            disp('Farther: Go Nearer')
        end
        
    end
else 
    nextInd = lastInd
    disp('Timed out: same depth')
end

nextInd=find(within_vect == nextDir);
if ~isempty(nextInd)
    
    if length(nextInd) >= 2
        if rand > .5 
            nextInd = nextInd(1)
        else
            nextInd = nextInd(2)
        end
    end
    
    %trial.list = [trial.list nextInd];
    trial(activeStair,activeRule).list = [trial(activeStair,activeRule).list nextInd];
else
    %trial.list = [trial.list lastInd];
    trial(activeStair,activeRule).list = [trial(activeStair,activeRule).list lastInd];
end
if debug
    %trial.list
    trial(activeStair,activeRule).list
end

setappdata(appHandle,'trialInfo',trial);

if debug
    disp('Exiting 2I_experment chooseNext')
end

