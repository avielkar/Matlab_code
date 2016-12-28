function chooseNextMupNdown_flip(appHandle)

global debug

if debug
    disp('Entering chooseNextM-up-N-down flip')
end


data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');

within = data.condvect.withinStair;
activeStair = data.activeStair;
cntr = trial(activeStair).cntr;

lastInd = trial(activeStair).list(trial(activeStair).cntr);
if isfield(within.parameters, 'moog')
    within_vect = within.parameters.moog;
else
    within_vect = within.parameters;
end
lastDir = within_vect(lastInd);

if debug
    probAlt = rand
else
    probAlt = rand;
end

i = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
stairUp = data.configinfo(i).parameters;  %use as number M
i = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
stairDown = data.configinfo(i).parameters;  %use as number N
i = strmatch('ERR_ALT_PROB',{char(data.configinfo.name)},'exact');
errAlt = data.configinfo(i).parameters/100;
i = strmatch('CORR_ALT_PROB',{char(data.configinfo.name)},'exact');
corrAlt = data.configinfo(i).parameters/100;

if savedInfo(activeStair).Resp(data.repNum).corr(cntr)
    corrNum = 0;
    iStart = cntr-stairUp+1;
    if iStart < 1
        iStart = 1;
    end
    tmpDir1 = savedInfo(activeStair).Resp(data.repNum).dir(iStart);
    for i= iStart : cntr
        tmpResp = savedInfo(activeStair).Resp(data.repNum).corr(i);
        tmpDir2 = savedInfo(activeStair).Resp(data.repNum).dir(i);
        if tmpResp && tmpDir2 == tmpDir1
            corrNum = corrNum +1;
        end
    end
    if corrNum == stairUp
        if debug
            disp('Correct M times in row: Go Harder')
        end
        if lastDir > 0
            nextInd = lastInd - 1;
        else
            nextInd = lastInd + 1;
        end
        
        if nextInd == 0 || nextInd > length(within_vect)
            nextInd = lastInd;
        end
        
        tmpInd = find(within_vect == -within_vect(nextInd));
        if probAlt < corrAlt && ~isempty(tmpInd)
            if debug
                disp('And switch direction')
            end          
            nextInd = tmpInd;
        end        
    else
        if debug
            disp('Correct: Same level')
        end        
        nextInd = lastInd;
    end
else
    incorrNum = 0;
    iStart = cntr-stairDown+1;
    if iStart < 1
        iStart = 1;
    end
    tmpDir1 = savedInfo(activeStair).Resp(data.repNum).dir(iStart);
    for i= iStart : cntr
        tmpResp = savedInfo(activeStair).Resp(data.repNum).corr(i);
        tmpDir2 = savedInfo(activeStair).Resp(data.repNum).dir(i);
        if ~tmpResp && tmpDir2 == tmpDir1
            incorrNum = incorrNum +1;
        end
    end
    
    if incorrNum == stairDown
        if debug
            disp('Wrong N times in row: Go Easier')
        end
        if lastDir > 0
            nextInd = lastInd + 1;
        else
            nextInd = lastInd - 1;
        end
                
        if nextInd == 0 || nextInd > length(within_vect)
            nextInd = lastInd;
        end
        
        tmpInd = find(within_vect == -within_vect(nextInd));
        if probAlt < errAlt && ~isempty(tmpInd)
            if debug
                disp('And switch direction')
            end
            nextInd = tmpInd;
        end
    else
        if debug
            disp('Wrong: Same Level')
        end       
        nextInd = lastInd;
    end
end

trial(activeStair).list = [trial(activeStair).list nextInd];

if debug
    trial(activeStair).list
end

setappdata(appHandle,'trialInfo',trial);

if debug
    disp('Exiting chooseNextM-up-N-down flip')
end

