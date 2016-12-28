function chooseNextMupNdown(appHandle)

global debug

if debug
    disp('Entering chooseNextM-up-N-down')
end

data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');

within = data.condvect.withinStair;
activeStair = data.activeStair;
activeRule =data.activeRule;
cntr = trial(activeStair,activeRule).cntr;

lastInd = trial(activeStair,activeRule).list(cntr);
if isfield(within.parameters, 'moog')
    within_vect = within.parameters.moog;
else
    within_vect = within.parameters;
end

i = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
tmpVect = data.configinfo(i).parameters;  %use as number M
stairUp = tmpVect(activeRule);
i = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
tmpVect = data.configinfo(i).parameters;  %use as number N
stairDown = tmpVect(activeRule);

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;

response = savedInfo(activeStair,activeRule).Resp(data.repNum).response(cntr);
if motiontype == 3   % 2I
    currOrd = savedInfo(activeStair,activeRule).Resp(data.repNum).intOrder(cntr,:);
    if currOrd(1) > currOrd(2)
        if response == 1
            response = 2;
        elseif response ==2
            response = 1;
        end
    end
    
    if response == 1 % Respond 1 %Left/Down
        upNum = 0;
        iStart = cntr-stairUp+1;
        if iStart < 1
            iStart = 1;
        end
        tmpDir1 = within_vect(lastInd); 
        for i= iStart : cntr
            tmpResp = savedInfo(activeStair,activeRule).Resp(data.repNum).response(i);
            tmpDir2 = within_vect(trial(activeStair,activeRule).list(i));
            tmpOrd = savedInfo(activeStair,activeRule).Resp(data.repNum).intOrder(i,:);
            if tmpOrd(1) < tmpOrd(2)  %ordered
                if tmpResp==1 && tmpDir2 == tmpDir1
                    upNum = upNum +1;
                end
            else  %disordered
                if tmpResp==2 && tmpDir2 == tmpDir1
                    upNum = upNum +1;
                end
            end
        end
        
        if upNum == stairUp
            if debug
                disp('Respond Left/Down M times in row: Go UP')
            end
            nextInd = lastInd + 1;
            if nextInd > length(within_vect)
                nextInd = lastInd;
            end            
        else
            if debug
                disp('Respond Left/Down: Same level')
            end
            nextInd = lastInd;
        end
    elseif response == 2 % Respond 2 Right/Up
        downNum = 0;
        iStart = cntr-stairDown+1;
        if iStart < 1
            iStart = 1;
        end
        tmpDir1 = within_vect(lastInd);
        for i= iStart : cntr
            tmpResp = savedInfo(activeStair,activeRule).Resp(data.repNum).response(i);
            tmpDir2 = within_vect(trial(activeStair,activeRule).list(i));
            tmpOrd = savedInfo(activeStair,activeRule).Resp(data.repNum).intOrder(i,:);
            if tmpOrd(1) < tmpOrd(2)  %ordered
                if tmpResp==2 && tmpDir2 == tmpDir1
                    downNum = downNum +1;
                end
            else  %disordered
                if tmpResp==1 && tmpDir2 == tmpDir1
                    downNum = downNum +1;
                end
            end
        end

        if downNum == stairDown
            if debug
                disp('Respond Right/Up N times in row: Go DOWN')
            end
            nextInd = lastInd - 1;
            if nextInd == 0
                nextInd = lastInd;
            end
        else
            if debug
                disp('Respond Right/Up: Same level')
            end
            nextInd = lastInd;
        end
    else
        nextInd = lastInd;
    end
else   %1I
    if response == 1 % Respond 1 %Left/Down
        upNum = 0;
        iStart = cntr-stairUp+1;
        if iStart < 1
            iStart = 1;
        end
        tmpDir1 = savedInfo(activeStair,activeRule).Resp(data.repNum).dir(iStart);
        for i= iStart : cntr
            tmpResp = savedInfo(activeStair,activeRule).Resp(data.repNum).response(i);
            tmpDir2 = savedInfo(activeStair,activeRule).Resp(data.repNum).dir(i);
            if tmpResp==1 && tmpDir2 == tmpDir1
                upNum = upNum +1;
            end
        end
        if upNum == stairUp
            if debug
                disp('Respond Left/Down M times in row: Go UP')
            end
            nextInd = lastInd + 1;
            if nextInd > length(within_vect)
                nextInd = lastInd;
            end            
        else
            if debug
                disp('Respond Left/Down: Same level')
            end
            nextInd = lastInd;
        end
    elseif response == 2 % Respond 2 Right/Up
        downNum = 0;
        iStart = cntr-stairDown+1;
        if iStart < 1
            iStart = 1;
        end
        tmpDir1 = savedInfo(activeStair,activeRule).Resp(data.repNum).dir(iStart);
        for i= iStart : cntr
            tmpResp = savedInfo(activeStair,activeRule).Resp(data.repNum).response(i);
            tmpDir2 = savedInfo(activeStair,activeRule).Resp(data.repNum).dir(i);
            if tmpResp==2 && tmpDir2 == tmpDir1
                downNum = downNum +1;
            end
        end

        if downNum == stairDown
            if debug
                disp('Respond Right/Up N times in row: Go DOWN')
            end
            nextInd = lastInd - 1;
            if nextInd == 0
                nextInd = lastInd;
            end
        else
            if debug
                disp('Respond Right/Up: Same level')
            end
            nextInd = lastInd;
        end
    else
        nextInd = lastInd;
    end
end

trial(activeStair,activeRule).list = [trial(activeStair,activeRule).list nextInd];

if debug
    trial(activeStair,activeRule).list
end

setappdata(appHandle,'trialInfo',trial);

if debug
    disp('Exiting chooseNextM-up-N-down')
end

