function drawEye
global eyeCalfig

eyeDataSampleObj = getappdata(eyeCalfig, 'eyeDataSample');

%------Get eye data----------
[buf, st, eyeDataSampleObj.previousCount,eyeDataSampleObj.previousIndex] = ...
    cbGetAInBackgroundScanData(eyeDataSampleObj.boardNum,eyeDataSampleObj.previousCount,...
    eyeDataSampleObj.previousIndex, eyeDataSampleObj.bufferSize,...
    eyeDataSampleObj.chans, eyeDataSampleObj.BIP10VOLTS,eyeDataSampleObj.memHandle);

%---Generate fake eye data for running on my machine----
% len = eyeDataSampleObj.chans(2)-eyeDataSampleObj.chans(1);
% for i=1:len+1
%     for j = 1:170
% %       buf(i,j) = 10*i*sin(j);
%         buf(i,j) = 0.5;
%     end
% end

if size(buf,2) ~= 0  % If we get the new data, we save it.
    eyeDataSampleObj.data = [eyeDataSampleObj.data, buf];  %---data for plot eye signal waveform----
    setappdata(eyeCalfig, 'eyeDataSample', eyeDataSampleObj);
    
    plotEyeTargetWin(buf);
end

function plotEyeTargetWin(posData)
global eyeCalfig

data = getappdata(eyeCalfig, 'protinfo');
chanInfo = data.channels(cell2mat({data.channels.active})==1);
appHandle = getappdata(eyeCalfig ,'posViewHandle');
eyeWinData = getappdata(eyeCalfig,'eyeWinData');

eyecode = eyeWinData.eyecode;
spt = eyeWinData.posSmoothPt;
chanList = eyeWinData.chanList;
tagXL = eyeWinData.tagXL;
tagXR = eyeWinData.tagXR;
tagYLR = eyeWinData.tagYLR;
lineXL = eyeWinData.lineXL;
lineXR = eyeWinData.lineXR;
lineY = eyeWinData.lineY;

siz = size(posData);
len = floor(siz(2)/spt);
%Based on channel info, convert channel data fron Volt to deg 
for i = 1:siz(1)
    posData(i, :) = posData(i,:)*chanInfo(chanList(i)).scale+chanInfo(chanList(i)).offset; 
end

for i = 1 : len         
    for j = 1 : siz(1)
        plotData(j) = 0;
        for k = 1 : spt        
            plotData(j) = plotData(j) + posData(j,(i-1)*spt+k);  % get average eye data and plot eye position
        end        
    end

    plotData = plotData/spt;
    if eyecode == 0        
        plot(appHandle.axex1,tagXL,tagYLR,'.b',lineXL,lineY,'-b',plotData(1),plotData(2),'+b');
    elseif eyecode ==1
        plot(appHandle.axex1,tagXR,tagYLR,'.r',lineXR,lineY,'-r',plotData(1),plotData(2),'xr');        
    elseif eyecode ==2
        plot(appHandle.axex1,tagXL,tagYLR,'.b',lineXL,lineY,'-b',plotData(1),plotData(2),'+b',...
                             tagXR,tagYLR,'.r',lineXR,lineY,'-r',plotData(4),plotData(5),'xr');
    end  
    drawnow;
end
