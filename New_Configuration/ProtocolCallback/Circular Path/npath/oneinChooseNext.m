function oneinChooseNext(appHandle)

% In a staircase procedure, returns index and value of parameters for the
% next trial, based on correct or incorrect response to the current trial.
% When done with staircase procedure return index larger than crossvals,
% and ControlLoop2 will terminate session

% Should not pick trial.cntr, should just append appropriate index to the
% end of trial.list and trial.cntr will be incremented.

global debug

if debug
    disp('Entering oneinchooseNext')
end


data = getappdata(appHandle,'protinfo');
% trial = getappdata(appHandle,'trialInfo');
% crossVals = getappdata(appHandle,'CrossVals');
Resp = getappdata(appHandle,'ResponseInfo');
% CLoop = getappdata(appHandle,'Timer');

stairInfo = getappdata(appHandle,'stairInfo') 

lastInd = stairInfo.currStep(stairInfo.currStair);

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

if Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair))
    if probDif < stairUp
        if debug
            disp('Correct: Go Harder')
        end
        nextInd = lastInd - 1;
%         if probAlt < corrAlt
%             if debug
%                 disp('And switch direction')
%             end
%             if nextInd == 0 || nextInd > length(crossVals)
%                 nextDir = -crossVals(lastInd);
%             else
%                 nextDir = -crossVals(nextInd);
%             end
%         else
%             if debug
%                 disp('Same Direction')
%             end
%             if nextInd == 0 || nextInd > length(crossVals)
%                 nextDir = crossVals(lastInd);
%             else
%                 nextDir = crossVals(nextInd);
%             end
%         end
    else
        if debug
            disp('Correct: Same level')
        end        
        nextInd = lastInd;       
%         if probAlt < corrAlt
%             if debug
%                 disp('And switch direction')
%             end
%             nextDir = -crossVals(nextInd);
%         else
%             if debug
%                disp('Same Direction')
%             end
%             nextDir = crossVals(nextInd);
%         end
    end
elseif Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair))
    if probDif < stairDown
        if debug
            disp('Wrong: Go Easier')
        end
        nextInd = lastInd + 1;
%         if probAlt < errAlt
%             if debug
%                 disp('And switch direction')
%             end
%             if nextInd == 0 || nextInd > length(crossVals)
%                 nextDir = -crossVals(lastInd);
%             else
%                 nextDir = -crossVals(nextInd);
%             end
%         else
%             if debug
%                 disp('Same Direction')
%             end
%             if nextInd == 0 || nextInd > length(crossVals)
%                 nextDir = crossVals(lastInd);
%             else
%                 nextDir = crossVals(nextInd);
%             end
%         end
    else
        if debug
            disp('Wrong: Same Level')
        end
        nextInd = lastInd;        
%         if probAlt < errAlt
%             if debug
%                 disp('And switch direction')
%             end
%             nextDir = -crossVals(nextInd);
%         else
%             if debug
%                 disp('Same Direction')
%             end
%             nextDir = crossVals(nextInd);
%         end
    end
elseif Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair))
        if debug
            disp('Null: Same Level')
        end
        nextInd = lastInd;
        
%         if probAlt < errAlt
%             if debug
%                 disp('And switch direction')
%             end
%             nextDir = -crossVals(nextInd);
%         else
%             if debug
%                 disp('Same Direction')
%             end
%             nextDir = crossVals(nextInd);
%         end

elseif Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair))
        if debug
            disp('Redo: Same Level')
        end
        nextInd = lastInd;       
%         if probAlt < errAlt
%             if debug
%                 disp('And switch direction')
%             end
%             nextDir = -crossVals(nextInd);
%         else
%             if debug
%                 disp('Same Direction')
%             end
%             nextDir = crossVals(nextInd);
%         end

else
    disp('Something screwed up!')
end

if nextInd==0 || nextInd>stairInfo.numSteps % if nextInd outside range
    nextInd=lastInd;
end

% Update currStep for this staircase
stairInfo.currStep(stairInfo.currStair) = nextInd; 

% Increment trial counter for this staircase
stairInfo.trialCount(stairInfo.currStair) = stairInfo.trialCount(stairInfo.currStair) + 1; 

% Change staircase for next trial (random)
stairInfo.currStair = round(rand*stairInfo.numStairs + 0.5)

setappdata(appHandle,'stairInfo',stairInfo);

if debug
    stairInfo;
end

if debug
    disp('Exiting oneinchooseNext')
end

