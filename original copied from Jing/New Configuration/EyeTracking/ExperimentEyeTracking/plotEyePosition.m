function plotEyePosition(posData)
global basicfig

data = getappdata(basicfig, 'protinfo');
chanInfo = data.channels(cell2mat({data.channels.active})==1);
appHandle = getappdata(basicfig ,'posViewHandle');
eyeWinData = getappdata(basicfig,'eyeWinData');

eyecode = eyeWinData.eyecode;
spt = eyeWinData.posSmoothPt;
chanList = eyeWinData.chanList;
tagXL = eyeWinData.tagXL;
tagXR = eyeWinData.tagXR;
tagY = eyeWinData.tagY;
lineXL = eyeWinData.lineXL;
lineXR = eyeWinData.lineXR;
lineY = eyeWinData.lineY;

siz = size(posData);
len = floor(siz(2)/spt);
%Based on channel info, convert channel data fron Volt to deg 
for i = 1:siz(1)
    posData(i, :) = posData(i,:)*chanInfo(chanList(i)).scale+chanInfo(chanList(i)).offset; %original way
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
        plot(appHandle.axex1,tagXL,tagY(1),'.b',lineXL,lineY,'-b',plotData(1),plotData(2),'+b');
    elseif eyecode ==1
        plot(appHandle.axex1,tagXR,tagY(1),'.r',lineXR,lineY,'-r',plotData(1),plotData(2),'xr');        
    elseif eyecode ==2
        plot(appHandle.axex1,tagXL,tagY(1),'.b',lineXL,lineY,'-b',plotData(1),plotData(2),'+b',...
                             tagXR,tagY(1),'.r',lineXR,lineY,'-r',plotData(4),plotData(5),'xr');
    end  
    drawnow;
end


