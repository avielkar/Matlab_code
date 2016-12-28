function makeData(appHandle)
% take configfile and condvect and create a trial by trial parameter list
% for saving. Jing modified for combining Multi-Staircase 12/01/08 

global debug

if debug
    disp('Entering makeData')
end

SavedInfo = getappdata(appHandle,'SavedInfo');
data = getappdata(appHandle,'protinfo');
cldata = getappdata(appHandle, 'ControlLoopData');
crossvals = getappdata(appHandle,'CrossVals');
trial = getappdata(appHandle,'trialInfo');

within = data.condvect.withinStair;
across = data.condvect.acrossStair;
varying = data.condvect.varying;
rep = data.repNum;
activeStair = data.activeStair;
activeRule = data.activeRule;
cntr = trial(activeStair,activeRule).cntr;
cnInd = trial(activeStair,activeRule).list(cntr);

for i = 1:size(data.configinfo,2)
    name = data.configinfo(i).name;
    if data.configinfo(i).status == 2 %varying   
        niceName = char(data.configinfo(i).nice_name);
        icol = strmatch(niceName,{char(varying.name)},'exact');
        if cldata.staircase
            val = crossvals(cldata.varyingCurrInd,icol);
        else            
            val = crossvals(cnInd,icol);
        end       
    elseif data.configinfo(i).status == 3  %acrossStair
        niceName = char(data.configinfo(i).nice_name);
        icol = strmatch(niceName,{char(across.name)},'exact');
        if isfield(across(icol).parameters, 'moog')
            val = across(icol).parameters.moog(activeStair);
        else
            val = across(icol).parameters(activeStair);
        end
    elseif data.configinfo(i).status == 4  %withinStair
        niceName = char(data.configinfo(i).nice_name);
        icol = strmatch(niceName,{char(within.name)},'exact');
        if isfield(within(icol).parameters, 'moog')
            val = within(icol).parameters.moog(cnInd);
        else
            val = within(icol).parameters(cnInd);
        end
    else
        val = data.configinfo(i).parameters;
    end
    
    SavedInfo(activeStair,activeRule).Rep(rep).Trial(cntr).Param(i).name = name;
    SavedInfo(activeStair,activeRule).Rep(rep).Trial(cntr).Param(i).value = val;
end

%======Save eye Data for each trial. Jing 01/27/09=========
flagdata = getappdata(appHandle,'flagdata');
if flagdata.isEyeTracking
    eyeDataSampleObj = getappdata(appHandle, 'eyeDataSample');
    eyeWinData = getappdata(appHandle, 'eyeWinData');
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).data = eyeDataSampleObj.data;
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).eyecode = eyeWinData.eyecode;
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).channels = data.channels(1:6);
end
%======End 01/27/09=========

%======Save the trial history info. Jing 5/15/09========
SavedInfo(activeStair,activeRule).Resp(rep).trialCount(cntr) = cldata.trialCount;
setappdata(appHandle,'SavedInfo',SavedInfo);

if debug
    disp('Existing makeData')
end





