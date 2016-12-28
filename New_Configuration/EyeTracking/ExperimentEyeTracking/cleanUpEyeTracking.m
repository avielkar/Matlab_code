function cleanUpEyeTracking
global basicfig

eyeDataSampleObj = getappdata(basicfig, 'eyeDataSample');
appHandle = getappdata(basicfig ,'posViewHandle');
eyeWinData = getappdata(basicfig,'eyeWinData');

eyecode = eyeWinData.eyecode;

cbStopBackground(eyeDataSampleObj.boardNum, eyeDataSampleObj.AIFUNCTION);
cbWinBufFree(eyeDataSampleObj.memHandle);

cla(appHandle.axex1);

if eyecode == 0
    plot(appHandle.axex1,eyeWinData.lineXL,eyeWinData.lineY,'-b');
elseif eyecode ==1
    plot(appHandle.axex1,eyeWinData.lineXR,eyeWinData.lineY,'-r');
elseif eyecode ==2
    plot(appHandle.axex1,eyeWinData.lineXL,eyeWinData.lineY,'-b',eyeWinData.lineXR,eyeWinData.lineY,'-r');
end

drawnow;