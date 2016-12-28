function getEyeTrackingData
global basicfig

eyeDataSampleObj = getappdata(basicfig, 'eyeDataSample');
eyeWinData = getappdata(basicfig,'eyeWinData');

%------Get eye data----------
[buf, st, eyeDataSampleObj.previousCount,eyeDataSampleObj.previousIndex] = ...
    cbGetAInBackgroundScanData(eyeDataSampleObj.boardNum,eyeDataSampleObj.previousCount,...
    eyeDataSampleObj.previousIndex, eyeDataSampleObj.bufferSize,...
    eyeDataSampleObj.chans, eyeDataSampleObj.BIP10VOLTS,eyeDataSampleObj.memHandle);

%---Generate fake eye data for running on my machine----
% len = eyeDataSampleObj.chans(2)-eyeDataSampleObj.chans(1);
% for i=1:len+1   
%     for j = 1:170
%         buf(i,j) = 10*i*sin(j);
%     end
% end

if size(buf,2) ~= 0  % If we get the new data, we save it.
    eyeDataSampleObj.data = [eyeDataSampleObj.data, buf];  %---data for plot eye signal waveform----
    setappdata(basicfig, 'eyeDataSample', eyeDataSampleObj);

    if eyeWinData.isPositionView
        plotEyePosition(buf);
    end
end
