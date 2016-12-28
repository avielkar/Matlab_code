function ampChooseNext(appHandle)

% In a staircase procedure, returns index and value of parameters for the
% next trial, based on correct or incorrect response to the current trial.
% When done with staircase procedure return index larger than crossvals,
% and ControlLoop2 will terminate session

% Should not pick trial.cntr, should just append appropriate index to the
% end of trial.list and trial.cntr will be incremented.

global debug

if debug
    disp('Entering amp chooseNext')
end


data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
%crossVals = getappdata(appHandle,'CrossVals');
%Resp = getappdata(appHandle,'ResponseInfo');
% CLoop = getappdata(appHandle,'Timer');
savedInfo = getappdata(appHandle,'SavedInfo');

within = data.condvect.withinStair;
crossVals = within.parameters.moog;
activeStair = data.activeStair;
activeRule = data.activeRule;

%lastInd = trial.list(trial.cntr);
lastInd = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
lastDist = crossVals(lastInd)

if ~isempty(strmatch('Distance',{char(within.name)},'exact'))
    %i1 = strmatch('Distance',{char(within.name)},'exact');
    %refDist = crossVals(trial.list(trial.cntr),i1)
    refDist = lastDist
else
    i = strmatch('DIST',{char(data.configinfo.name)},'exact');
    refDist = data.configinfo(i).parameters.moog
end
deltaDist=lastDist-refDist

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


if savedInfo(activeStair,activeRule).Resp(data.repNum).corr(trial(activeStair,activeRule).cntr)
    if probDif < stairUp
        if debug
            disp('Correct: Go Harder')
        end
        if deltaDist > 0
            nextInd = lastInd - 1;
        else
            nextInd = lastInd + 1;
        end
        if probAlt < corrAlt
            if debug
                disp('And switch direction')
            end
            if nextInd == 0
                nextDist = crossVals(length(crossVals))
            elseif nextInd > length(crossVals)
                nextDist = crossVals(1);
            else
                nextDist = 2*refDist-crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0
                nextDist = crossVals(1)
            elseif nextInd > length(crossVals)
                nextDist = crossVals(length(crossVals));
            else
                nextDist = crossVals(nextInd);
            end
        end
    else
        if debug
            disp('Correct: Same level')
        end
        
        nextInd = lastInd;
        
        if probAlt < corrAlt
            if debug
                disp('And switch direction')
            end
            nextDist = 2*refDist-crossVals(nextInd);
        else
            if debug
               disp('Same Direction')
            end
            nextDist = crossVals(nextInd);
        end
    end
elseif savedInfo(activeStair,activeRule).Resp(data.repNum).incorr(trial(activeStair,activeRule).cntr)
    if probDif < stairDown
        if deltaDist > 0
            nextInd = lastInd + 1;
        else
            nextInd = lastInd - 1;
        end
        if debug
            disp('Wrong: Go Easier')
        end
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            if nextInd == 0
                nextDist = crossVals(length(crossVals))
            elseif nextInd > length(crossVals)
                nextDist = crossVals(1);
            else
                nextDist = 2*refDist-crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0
                nextDist = crossVals(1);
            elseif nextInd > length(crossVals)
                nextDist = crossVals(length(crossVals));
            else
                nextDist = crossVals(nextInd);
            end
        end
    else
        if debug
            disp('Wrong: Same Level')
        end
        
        nextInd = lastInd;
        
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            nextDist = 2*refDist-crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDist = crossVals(nextInd);
        end
    end
elseif savedInfo(activeStair,activeRule).Resp(data.repNum).null(trial(activeStair,activeRule).cntr)
    if probDif < stairDown
        if deltaDist > 0
            nextInd = lastInd + 1;
        else
            nextInd = lastInd - 1;
        end
        if debug
            disp('Wrong: Go Easier')
        end
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            if nextInd == 0
                nextDist = crossVals(length(crossVals));
            elseif nextInd > length(crossVals)
                nextDist = crossVals(1);
            else
                nextDist = 2*refDist-crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0
                nextDist = crossVals(1);
            elseif nextInd > length(crossVals)
                nextDist = crossVals(length(crossVals));
            else
                nextDist = crossVals(nextInd);
            end
        end
    else
        if debug
            disp('Wrong: Same Level')
        end

        nextInd = lastInd;
        
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            nextDist = 2*refDist-crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDist = crossVals(nextInd);
        end
    end
elseif savedInfo(activeStair,activeRule).Resp(data.repNum).dontKnow(trial(activeStair,activeRule).cntr)
    if probDif < stairDown
        if deltaDist > 0
            nextInd = lastInd + 1;
        else
            nextInd = lastInd - 1;
        end
        if debug
            disp('Too Hard?: Go Easier')
        end
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            if nextInd == 0
                nextDist = crossVals(length(crossVals))
            elseif nextInd > length(crossVals)
                nextDist = crossVals(1);
            else
                nextDist = 2*refDist-crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0
                nextDist = crossVals(1);
            elseif nextInd > length(crossVals)
                nextDist = crossVals(length(crossVals));
            else
                nextDist = crossVals(nextInd);
            end
        end
    else
        if debug
            disp('Too Hard?: Same Level')
        end

        nextInd = lastInd;
        
        if probAlt < errAlt
            if debug
                disp('And switch direction')
            end
            nextDist = 2*refDist-crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDist = crossVals(nextInd);
        end
    end
else
    disp('Something screwed up!')
end

nextDist

nextInd=find(crossVals == nextDist);
if ~isempty(nextInd)
    
    if length(nextInd) >= 2
        if rand > .5 
            nextInd = nextInd(1)
        else
            nextInd = nextInd(2)
        end
    end
    
    trial.list = [trial.list nextInd];
else
    trial.list = [trial.list lastInd];
end
if debug
    trial.list
end
%----end jing's change---    

setappdata(appHandle,'trialInfo',trial);

if debug
    disp('Exiting amp chooseNext')
end

