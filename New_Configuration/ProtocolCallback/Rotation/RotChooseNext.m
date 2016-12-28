function chooseNext(appHandle)

% In a staircase procedure, returns index and value of parameters for the
% next trial, based on correct or incorrect response to the current trial.
% When done with staircase procedure return index larger than crossvals,
% and ControlLoop2 will terminate session

% Should not pick trial.cntr, should just append appropriate index to the
% end of trial.list and trial.cntr will be incremented.

global debug

if debug
    disp('Entering chooseNext')
end


data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
crossVals = getappdata(appHandle,'CrossVals');
Resp = getappdata(appHandle,'ResponseInfo');
% CLoop = getappdata(appHandle,'Timer');

lastInd = trial.list(trial.cntr);
lastDir = crossVals(lastInd);

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


if Resp(data.repNum).corr(trial.cntr)
    if probDif < stairUp
        if debug
            disp('Correct: Go Harder')
        end
        if lastDir > 0
            nextInd = lastInd - 1;
        else
            nextInd = lastInd + 1;
        end
        if probAlt < corrAlt
            if debug
                disp('And switch direction')
            end
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = -crossVals(lastInd);
            else
                nextDir = -crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = crossVals(lastInd);
            else
                nextDir = crossVals(nextInd);
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
            nextDir = -crossVals(nextInd);
        else
            if debug
               disp('Same Direction')
            end
            nextDir = crossVals(nextInd);
        end
    end
elseif Resp(data.repNum).incorr(trial.cntr)
    if probDif < stairDown
        if lastDir > 0
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
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = -crossVals(lastInd);
            else
                nextDir = -crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = crossVals(lastInd);
            else
                nextDir = crossVals(nextInd);
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
            nextDir = -crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDir = crossVals(nextInd);
        end
    end
elseif Resp(data.repNum).null(trial.cntr)
    if probDif < stairDown
        if lastDir > 0
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
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = -crossVals(lastInd);
            else
                nextDir = -crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = crossVals(lastInd);
            else
                nextDir = crossVals(nextInd);
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
            nextDir = -crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDir = crossVals(nextInd);
        end
    end
elseif Resp(data.repNum).dontKnow(trial.cntr)
    if probDif < stairDown
        if lastDir > 0
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
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = -crossVals(lastInd);
            else
                nextDir = -crossVals(nextInd);
            end
        else
            if debug
                disp('Same Direction')
            end
            if nextInd == 0 || nextInd > length(crossVals)
                nextDir = crossVals(lastInd);
            else
                nextDir = crossVals(nextInd);
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
            nextDir = -crossVals(nextInd);
        else
            if debug
                disp('Same Direction')
            end
            nextDir = crossVals(nextInd);
        end
    end
else
    disp('Something screwed up!')
end

%----Jing comment out here and make some change for the case that the
%----combination in the other direction can't find.---01/12/07
%if debug
%    trial.list = [trial.list find(crossVals == nextDir)]
%else
%    trial.list = [trial.list find(crossVals == nextDir)];
%end
nextInd=find(crossVals == nextDir);
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
    disp('Exiting chooseNext')
end

