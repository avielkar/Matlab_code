function priorAnalyzeResp(appHandle)
global  debug 

if debug
    disp('Entering  PriorAnalyzeResp')
end

trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
data = getappdata(appHandle,'protinfo');
cldata = getappdata(appHandle, 'ControlLoopData');
crossVals = getappdata(appHandle,'CrossVals');
flagdata = getappdata(appHandle,'flagdata');

within = data.condvect.withinStair;
across = data.condvect.acrossStair;
varying = data.condvect.varying;
priors = data.condvect.priors;

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).priorCntr;

%response =savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
response =savedInfo(activeStair,activeRule).PriorResp.response(trial(activeStair,activeRule).priorCntr);
HR = cldata.hReference;
dir = priors.currentPrior.Dir;
savedInfo(activeStair,activeRule).PriorResp(currRep).dir(currTrial) = dir;

%if regular analyze for the priors
if cldata.is_flashing_priors == false
    if response == 1 % Respond 1 %Left/Down
        if debug
            disp('You answered Left/Down')
        end
        if dir < 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir > 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == 2 % Respond 2 Right/Up
        if debug
            disp('you answered right/up')
        end
        if dir > 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir < 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
    end
%if flashing analyze for the priors
else
    %take the curretnt button response option in order to know how to
    %analyze.
    button_option = priors.currentPrior.ButtonOption;
    num_of_flashes = cldata.num_of_flashes;
    if response == 1 % Respond 1 %Left/Down
        if debug
            disp('You answered Left/Down')
        end
        if dir < 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir > 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == 2 % Respond 2 Right/Up
        if debug
            disp('you answered right/up')
        end
        if dir > 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir < 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
    end
end


savedInfo(activeStair,activeRule).PriorResp(currRep).totalCorr = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).corr);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalIncorr = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).incorr);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalNull = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).null);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalDontKnow = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow);

if~isempty(across)
    if isfield(across.parameters, 'moog')   % Adds in the across staircase value into the 'SavedInfo' matrix
        savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = across.parameters.moog(activeStair);
    else
        savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = across.parameters(activeStair);
    end
else
    savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = '';
end

setappdata(appHandle,'SavedInfo',savedInfo);

if debug || flagdata.isSubControl
    if savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting general analyzeResp')
end


