function chooseNextProb(appHandle)

% In a staircase procedure, returns index and value of parameters for the
% next trial, based on correct or incorrect response to the current trial.
% When done with staircase procedure return index larger than crossvals,
% and ControlLoop2 will terminate session

% Should not pick trial.cntr, should just append appropriate index to the
% end of trial.list and trial.cntr will be incremented.

global debug

if debug
    disp('Entering chooseNextProb')
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

if debug
    probDif = rand
else
    probDif = rand;
end

i = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
tmpVect = data.configinfo(i).parameters;
stairUp = tmpVect(activeRule)/100;
i = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
tmpVect = data.configinfo(i).parameters;
stairDown = tmpVect(activeRule)/100;

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;

response = savedInfo(activeStair,activeRule).Resp(data.repNum).response(cntr);
if motiontype == 3  % For 2I we need to handle response in different way.
    currOrd = savedInfo(activeStair,activeRule).Resp(data.repNum).intOrder(cntr,:);
    if currOrd(1) > currOrd(2)
        if response == 1
            response = 2;
        elseif response ==2
            response = 1;
        end
    end
end

if response == 1 % Respond 1 %Left/Down
    if probDif < stairUp
        if debug
            disp('Respond Left/Down Stair_up%>Rand%: Go UP')
        end
        nextInd = lastInd + 1;
        if nextInd > length(within_vect)
            nextInd = lastInd;
        end
    else
        if debug
            disp('Respond Left/Down Stair_up%<Rand%: Same level')
        end

        nextInd = lastInd;
    end
elseif response == 2 % Respond 2 Right/Up
    if probDif < stairDown
        if debug
            disp('Respond Right/Up Stair_down%>Rand%: Go DOWN')
        end
        nextInd = lastInd - 1;
        if nextInd == 0
            nextInd = lastInd;
        end
    else
        if debug
            disp('Respond Right/Up Stair_down%<Rand%: Same Level')
        end
        nextInd = lastInd;
    end
else
    nextInd = lastInd;
end


trial(activeStair,activeRule).list = [trial(activeStair,activeRule).list nextInd];

if debug
    trial(activeStair,activeRule).list
end

setappdata(appHandle,'trialInfo',trial);

if debug
    disp('Exiting chooseNextProb')
end

