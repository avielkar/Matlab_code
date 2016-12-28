function initEyeTracking
global basicfig

data = getappdata(basicfig, 'protinfo');
eyeWinData = getappdata(basicfig,'eyeWinData');

%Initiate the parameter for drawing target and related eye window
crossvals = getappdata(basicfig, 'CrossVals');
activeStair = data.activeStair;
activeRule = data.activeRule;
trial = getappdata(basicfig, 'trialInfo');
cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
varying = data.condvect.varying;

i = strmatch('EYE_CODE',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    eyecode = data.configinfo(i).parameters;
else
    eyecode = eyeWinData.eyecode;
end
eyeWinData.eyecode = eyecode;

i = strmatch('EYE_WIN_SIZE',{char(data.configinfo.name)},'exact');
winSize = data.configinfo(i).parameters;

%---Get target position-------
i = strmatch('TARG_XCTR',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Target Center (X)',{char(varying.name)},'exact');
    tagX = crossvals(cntr,i1);
else
    tagX = data.configinfo(i).parameters(1);
end

i = strmatch('TARG_YCTR',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Target Center (Y)',{char(varying.name)},'exact');
    tagY = crossvals(cntr,i1);
else
    tagY = data.configinfo(i).parameters(1);
end
eyeWinData.tagY = tagY;

%Convert IO dist to deg based on viewing distance.
i = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
hc = data.configinfo(i).parameters;
i = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
eo = data.configinfo(i).parameters;
i = strmatch('IO_DIST',{char(data.configinfo.name)},'exact');
ioDist = data.configinfo(i).parameters;
iodeg=atan(ioDist/2/(100-hc(2)-eo(2)))*180/pi;

if eyecode == 0
    chanNum = 3;
    chans = [0,2];
    tagXL = tagX(1);
    if ~eyeWinData.isLineUpLeft
        tagXL = tagXL+iodeg;
    end
    eyeWinData.tagXL =  tagXL;
    eyeWinData.tagXR =  0;
    eyeWinData.lineXL =[tagXL-winSize/2, tagXL+winSize/2, tagXL+winSize/2, tagXL-winSize/2,tagXL-winSize/2];
    eyeWinData.lineXR = 0;
    eyeWinData.chanList = 1:3;
elseif eyecode == 1
    chanNum = 3;
    chans = [3,5];
    tagXR= tagX(1);
    if ~eyeWinData.isLineUpRight
        tagXR= tagXR-iodeg;
    end
    eyeWinData.tagXL = 0;
    eyeWinData.tagXR = tagXR;
    eyeWinData.lineXL = 0;
    eyeWinData.lineXR =[tagXR-winSize/2, tagXR+winSize/2, tagXR+winSize/2, tagXR-winSize/2,tagXR-winSize/2];   
    eyeWinData.chanList = 4:6;
elseif eyecode == 2
    chanNum = 6;
    chans = [0,5];
    tagXL = tagX(1)+iodeg;
    tagXR = tagX(1)-iodeg;
    eyeWinData.tagXL = tagXL;
    eyeWinData.tagXR = tagXR;
    eyeWinData.lineXL =[tagXL-winSize/2, tagXL+winSize/2, tagXL+winSize/2, tagXL-winSize/2,tagXL-winSize/2];
    eyeWinData.lineXR =[tagXR-winSize/2, tagXR+winSize/2, tagXR+winSize/2, tagXR-winSize/2,tagXR-winSize/2];
    eyeWinData.chanList = 1:6;
end
eyeWinData.lineY =[tagY(1)-winSize/2, tagY(1)-winSize/2, tagY(1)+winSize/2, tagY(1)+winSize/2,tagY(1)-winSize/2];
setappdata(basicfig, 'eyeWinData', eyeWinData);

%Defines eye signal sampling data structure for each channel
eyeDataSampleObj.BIP10VOLTS = 1;      %--- Defines from cbw.h ---
eyeDataSampleObj.AIFUNCTION = 1;      %--- Defines from cbw.h ---
eyeDataSampleObj.bufferSize = 512*chanNum;
eyeDataSampleObj.sampleRate = 600;
eyeDataSampleObj.boardNum = 1;
eyeDataSampleObj.previousCount = 0;
eyeDataSampleObj.previousIndex = 0;
eyeDataSampleObj.chans = chans;
eyeDataSampleObj.memHandle = cbWinBufAlloc(eyeDataSampleObj.bufferSize);
eyeDataSampleObj.data = [];

setappdata(basicfig, 'eyeDataSample',eyeDataSampleObj);

%Start the backbround eye signal sampling sweep.
cbAInBackgroundScan(eyeDataSampleObj.boardNum, eyeDataSampleObj.chans, eyeDataSampleObj.bufferSize,...
                    eyeDataSampleObj.sampleRate, eyeDataSampleObj.BIP10VOLTS, eyeDataSampleObj.memHandle);



