function CalAnalyzeResp(appHandle)
global  debug connected

if debug
    disp('Entering CalAnalyzeResp')
end

data = getappdata(appHandle, 'protinfo');
flagdata = getappdata(appHandle,'flagdata');
trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;

COMBOARDNUM = 0;
outString = 'FP_ON 0';
if debug
    disp(outString)
end
if connected
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end

isEyeInWindow = eyeInWindow(appHandle);
if isEyeInWindow 
    if debug || flagdata.isSubControl
        %soundsc(data.correctWav,42000);
    end  
    savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 1;
    savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 0;
    savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
    savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
else  % redo the current trial
    if debug || flagdata.isSubControl
        soundsc(data.wrongWav,42000);
    end
    trial.num = trial.num +1;
    trial.list = [trial.list trial.list(trial.cntr)];  
    setappdata(appHandle,'trialInfo',trial);
    savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) = 0;
    savedInfo(activeStair,activeRule).Resp(currRep).incorr(currTrial) = 1;
    savedInfo(activeStair,activeRule).Resp(currRep).null(currTrial) = 0;
    savedInfo(activeStair,activeRule).Resp(currRep).dontKnow(currTrial) = 0;
end
setappdata(appHandle,'SavedInfo',savedInfo);

if debug
    disp('Exiting CalAnalyzeResp')
end


