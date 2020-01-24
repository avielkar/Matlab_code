function generalAnalyzeRespVaryingDelta(appHandle)
global  debug 
global portAudio
global responseCorrectnessFeedback

% Received legit answer sound
 a = [ones(22,200);zeros(22,200)];
 a_legit = a(:)';
% Time Out Sound
a = [ones(220,25);zeros(220,25)];
a_timeout = a(:)';

if debug
    disp('Entering general analyzeResp')
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

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;

response =savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
HR = cldata.hReference;

if cldata.staircase % If it is staircase, use withinStair parameter to analyze Resp.
    if isfield(within.parameters, 'moog')
        dir = within.parameters.moog((trial(activeStair,activeRule).list(currTrial)));
    else
        dir = within.parameters((trial(activeStair,activeRule).list(currTrial)));
    end
    controlName = within.name;
else     %Else, use control parameter to analyze Resp.
    %avi - for the varying heading dirction instead of the 1st default one.
    if ~isempty(strmatch('Heading Direction',{char(varying.name)},'exact'))
        headingDirextionIndex = strmatch('Heading Direction',{char(varying.name)},'exact');
        %i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
        %dir = crossVals(trial.list(trial.cntr),i1);
        currentCrossValIndex = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
        dir = crossVals(currentCrossValIndex,headingDirextionIndex);
    end
end

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
is1IControl = 0;
if data.configinfo(i).parameters == 3   % For two interval
    if isempty(findstr(controlName,'2nd Int'))   % 1I parameter is a control parameter.
        refName = [controlName ' 2nd Int'];
        is1IControl = 1;
    else   % 2I parameter is a control parameter.
        refName = strtrim(strtok(controlName,'2'));
    end

    if ~isempty(strmatch(refName,{char(across.name)},'exact'))
        if isfield(across.parameters,'moog')
            dir2 = across.parameters.moog(activeStair);
        else
            dir2 = across.parameters(activeStair);
        end
    elseif ~isempty(strmatch(refName,{char(varying.name)},'exact'))
        ind = strmatch(refName,{char(varying.name)},'exact');
        if cldata.staircase
            dir2 = crossVals(cldata.varyingCurrInd,ind);
        else
            dir2 = crossVals(trial.list(trial.cntr),ind);
        end
    else
        ind = strmatch(refName,{char(data.configinfo.nice_name)},'exact');
        if isfield(data.configinfo(ind).parameters,'moog')
            dir2 = data.configinfo(ind).parameters.moog;
        else
            dir2 = data.configinfo(ind).parameters;
        end
    end
    
    if is1IControl
        tmpDir(1) = dir;
        tmpDir(2) = dir2;
    else
        tmpDir(1) = dir2;
        tmpDir(2) = dir;
    end
    
    if HR 
        tmpDir(2) = tmpDir(2) + tmpDir(1);
    end 
    
    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dir = tmpDir(intOrder(2))- tmpDir(intOrder(1));
    
    savedInfo(activeStair,activeRule).Resp(currRep).intOrder(currTrial,:) = intOrder;
end

savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial) = dir;

if response == 1 % Respond 1 %Left/Down
    if debug
        disp('You answered Left/Down')
    end
    if dir < 0
        if debug
            disp('correct')
        end
        savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
        savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
    elseif dir > 0
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
elseif response == 2 % Respond 2 Right/Up
    if debug
        disp('you answered right/up')
    end
    if dir > 0
        if debug
            disp('correct')
        end
        savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
        savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
        savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
    elseif dir < 0
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


savedInfo(activeStair,activeRule).Resp(currRep).totalCorr = sum(savedInfo(activeStair,activeRule).Resp(currRep).corr);
savedInfo(activeStair,activeRule).Resp(currRep).totalIncorr = sum(savedInfo(activeStair,activeRule).Resp(currRep).incorr);
savedInfo(activeStair,activeRule).Resp(currRep).totalNull = sum(savedInfo(activeStair,activeRule).Resp(currRep).null);
savedInfo(activeStair,activeRule).Resp(currRep).totalDontKnow = sum(savedInfo(activeStair,activeRule).Resp(currRep).dontKnow);

if~isempty(across)
    if isfield(across.parameters, 'moog')   % Adds in the across staircase value into the 'SavedInfo' matrix
        savedInfo(activeStair,activeRule).Resp(currRep).acrossVal = across.parameters.moog(activeStair);
    else
        savedInfo(activeStair,activeRule).Resp(currRep).acrossVal = across.parameters(activeStair);
    end
else
    savedInfo(activeStair,activeRule).Resp(currRep).acrossVal = '';
end

setappdata(appHandle,'SavedInfo',savedInfo);

%giving feedback sound correctness in the analyze stage.
if responseCorrectnessFeedback
    if savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) == 1
        PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
        PsychPortAudio('Start', portAudio, 1,0);
    else 
        PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
        PsychPortAudio('Start', portAudio, 1,0);
    end 
end

if debug || flagdata.isSubControl
% %     if savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) == 1
% %         soundsc(data.correctWav,42000);
% %     else
% %         soundsc(data.wrongWav,42000);
% %     end
    disp('Exiting general analyzeResp')
end


