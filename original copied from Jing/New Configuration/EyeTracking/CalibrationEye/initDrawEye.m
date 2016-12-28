function initDrawEye
global eyeCalfig

eyeWinData = getappdata(eyeCalfig,'eyeWinData');

eyecode = eyeWinData.eyecode;
winSize = eyeWinData.winSize;
tagX = eyeWinData.tagX;
tagY = eyeWinData.tagY;

if eyecode == 0
    chanNum = 3;
    chans = [0,2];
    eyeWinData.chanList = 1:3;
elseif eyecode == 1    
    chanNum = 3;
    chans = [3,5];
    eyeWinData.chanList = 4:6;
end

tagXL = tagX(1);
tagXR = tagX(1);
eyeWinData.tagXL = tagXL;
eyeWinData.tagXR = tagXR;
eyeWinData.lineXL =[tagXL-winSize/2, tagXL+winSize/2, tagXL+winSize/2, tagXL-winSize/2,tagXL-winSize/2];
eyeWinData.lineXR =[tagXR-winSize/2, tagXR+winSize/2, tagXR+winSize/2, tagXR-winSize/2,tagXR-winSize/2]; 

eyeWinData.tagYLR = tagY(1);
eyeWinData.lineY =[tagY(1)-winSize/2, tagY(1)-winSize/2, tagY(1)+winSize/2, tagY(1)+winSize/2,tagY(1)-winSize/2];
setappdata(eyeCalfig, 'eyeWinData', eyeWinData);

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

setappdata(eyeCalfig, 'eyeDataSample',eyeDataSampleObj);





