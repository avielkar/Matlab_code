function Conflict_analyzeResp_2resp(appHandle)
global  debug 

if debug
    disp('Entering Conflict_analyzeResp_2resp')
end

savedInfo = getappdata(appHandle,'SavedInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
crossVals = getappdata(appHandle,'CrossVals');
cldata = getappdata(appHandle, 'ControlLoopData'); %---Jing added 03/12/08---

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;
response1 =savedInfo(activeStair,activeRule).Resp(currRep).response1(currTrial);
response2 =savedInfo(activeStair,activeRule).Resp(currRep).response2(currTrial);

HR = cldata.hReference;

if ~isempty(strmatch('Heading Dir Conflict',{char(data.condvect.varying.name)},'exact'))
    i1 = strmatch('Heading Dir Conflict',{char(data.condvect.varying.name)},'exact');
    dirConf = crossVals(trial(activeStair,activeRule).list(currTrial),i1);
else
    i = strmatch('HEADING_DIR_CONFLICT',{char(data.configinfo.name)},'exact');
    dirConf = data.configinfo(i).parameters.moog;
end
    
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1   % For single interval
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact');
        dir = crossVals(trial(activeStair,activeRule).list(currTrial),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir = data.configinfo(i).parameters.moog;
    end      
else  % For 2 interval
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact');
        dir(1) = crossVals(trial(activeStair,activeRule).list(currTrial),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Heading Direction 2nd Int',{char(data.condvect.varying.name)},'exact'))
        i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.varying.name)},'exact');
        dir(2) = crossVals(trial(activeStair,activeRule).list(currTrial),i1);
    else
        i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
        dir(2) = data.configinfo(i).parameters.moog;
    end

    if HR %------Jing for different heading reference 03/14/07----
        if debug
            disp('inside analyzeresp hr=1');
        end
        dir(2) = dir(2) + dir(1);
    end %----end 03/14/07----

    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dir1 = dir(intOrder(1));
    dir2 = dir(intOrder(2));
    dir = dir2-dir1;
    
    savedInfo(activeStair,activeRule).Resp(currRep).intOrder(currTrial,:) = intOrder; 
end

savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial) = dir;
savedInfo(activeStair,activeRule).Resp(currRep).dirConf(currTrial) = dirConf;

tmpInfo_dir = getRespInfo_dir(dir, response1);
tmpInfo_conf = getRespInfo_conflict(dirConf, response2);

savedInfo(activeStair,activeRule).Resp(currRep).corr1(currTrial) = tmpInfo_dir.corr;
savedInfo(activeStair,activeRule).Resp(currRep).corr2(currTrial) = tmpInfo_conf.corr;

savedInfo(activeStair,activeRule).Resp(currRep).incorr1(currTrial) = tmpInfo_dir.incorr;
savedInfo(activeStair,activeRule).Resp(currRep).incorr2(currTrial) = tmpInfo_conf.incorr;

savedInfo(activeStair,activeRule).Resp(currRep).null1(currTrial) = tmpInfo_dir.null;
savedInfo(activeStair,activeRule).Resp(currRep).null2(currTrial) = tmpInfo_conf.null;

savedInfo(activeStair,activeRule).Resp(currRep).dontKnow1(currTrial) = tmpInfo_dir.dontKnow;
savedInfo(activeStair,activeRule).Resp(currRep).dontKnow2(currTrial) = tmpInfo_conf.dontKnow;

savedInfo(activeStair,activeRule).Resp(currRep).totalCorr1 = sum(savedInfo(activeStair,activeRule).Resp(currRep).corr1);
savedInfo(activeStair,activeRule).Resp(currRep).totalCorr2 = sum(savedInfo(activeStair,activeRule).Resp(currRep).corr2);

savedInfo(activeStair,activeRule).Resp(currRep).totalIncorr1 = sum(savedInfo(activeStair,activeRule).Resp(currRep).incorr1);
savedInfo(activeStair,activeRule).Resp(currRep).totalIncorr2 = sum(savedInfo(activeStair,activeRule).Resp(currRep).incorr2);

savedInfo(activeStair,activeRule).Resp(currRep).totalNull1 = sum(savedInfo(activeStair,activeRule).Resp(currRep).null1);
savedInfo(activeStair,activeRule).Resp(currRep).totalNull2 = sum(savedInfo(activeStair,activeRule).Resp(currRep).null2);

savedInfo(activeStair,activeRule).Resp(currRep).totalDontKnow1 = sum(savedInfo(activeStair,activeRule).Resp(currRep).dontKnow1);
savedInfo(activeStair,activeRule).Resp(currRep).totalDontKnow2 = sum(savedInfo(activeStair,activeRule).Resp(currRep).dontKnow2);

setappdata(appHandle,'SavedInfo',savedInfo);
%+++++++++ Commented out for now, put in analyzeResp+++++++++++++++++++++++

if debug
    if savedInfo(activeStair,activeRule).Resp(currRep).corr1(currTrial) == 1 && ...
       savedInfo(activeStair,activeRule).Resp(currRep).corr2(currTrial) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting Conflict_analyzeResp_2resp')
end


function respInfo = getRespInfo_dir(dir,response)
global  debug 
if response == 1 % Respond 1 %Left/Down
    if debug
        disp('You answered Left/Down')
    end
    if dir < 0
        if debug
            disp('correct')
        end
        respInfo.corr = 1;
        respInfo.incorr = 0;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    elseif dir > 0
        if debug
            disp('Not correct')
        end
        respInfo.corr = 0;
        respInfo.incorr = 1;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    else
        if debug
            disp('No Answer')
        end
        respInfo.corr = 0;
        respInfo.incorr = 0;
        respInfo.null = 1;
        respInfo.dontKnow = 0;
    end
elseif response == 2 % Respond 2 Right/Up
    if debug
        disp('you answered right/up')
    end
    if dir > 0
        if debug
            disp('correct')
        end
        respInfo.corr = 1;
        respInfo.incorr = 0;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    elseif dir < 0
        if debug
            disp('Not correct')
        end
        respInfo.corr = 0;
        respInfo.incorr = 1;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    else
        if debug
            disp('No Answer')
        end
        respInfo.corr = 0;
        respInfo.incorr = 0;
        respInfo.null = 1;
        respInfo.dontKnow = 0;
    end
else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
    if debug
        disp('Time Expired: Move Faster!!')
    end
    respInfo.corr = 0;
    respInfo.incorr = 0;
    respInfo.null = 1;
    respInfo.dontKnow = 0;
end

function respInfo =getRespInfo_conflict(dir, response)
global  debug 
if response == 1 % Respond 1 %Left/Down/Same
    if debug
        disp('You answered Left/Down/Same')
    end
    if dir == 0
        if debug
            disp('correct')
        end
        respInfo.corr = 1;
        respInfo.incorr = 0;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    else
        if debug
            disp('Not correct')
        end
        respInfo.corr = 0;
        respInfo.incorr = 1;
        respInfo.null = 0;
        respInfo.dontKnow = 0;    
    end
elseif response == 2 % Respond 2 Right/Up/Different
    if debug
        disp('you answered right/up/Different')
    end
    if dir ~= 0
        if debug
            disp('correct')
        end
        respInfo.corr = 1;
        respInfo.incorr = 0;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    else
        if debug
            disp('Not correct')
        end
        respInfo.corr = 0;
        respInfo.incorr = 1;
        respInfo.null = 0;
        respInfo.dontKnow = 0;
    end
else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
    if debug
        disp('Time Expired: Move Faster!!')
    end
    respInfo.corr = 0;
    respInfo.incorr = 0;
    respInfo.null = 1;
    respInfo.dontKnow = 0;
end

