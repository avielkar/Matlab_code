function success = checkEyeInWindow(appHandle)

data = getappdata(appHandle, 'protinfo');
chanInfo = data.channels(cell2mat({data.channels.active})==1);
eyeWinData = getappdata(appHandle,'eyeWinData');
eyeDataSampleObj = getappdata(appHandle, 'eyeDataSample');

chanList = eyeWinData.chanList;
eyeData = eyeDataSampleObj.data;
eyecode = eyeWinData.eyecode;
rangeXL = eyeWinData.lineXL;
rangeXR = eyeWinData.lineXR;
rangeY = eyeWinData.lineY;

%Convert eyeData from volt to deg based on the chan Scale and Offset
siz = size(eyeData);
for i = 1:siz(1)
    eyeData(i, :) = eyeData(i, :)*chanInfo(chanList(i)).scale+chanInfo(chanList(i)).offset;
end 

%Average the data
aveEyeData = sum(eyeData, 2)/siz(2);

success = 0;
if eyecode == 0
    if aveEyeData(1) >= rangeXL(1) && aveEyeData(1)<= rangeXL(3) &&...
       aveEyeData(2) >= rangeY(1) && aveEyeData(2) <= rangeY(3)
        success = 1;
    end
elseif eyecode == 1
    if aveEyeData(1) >= rangeXR(1) && aveEyeData(1)<= rangeXR(3) &&...
       aveEyeData(2) >= rangeY(1) && aveEyeData(2) <= rangeY(3)
   
        success = 1;
    end
else
    if aveEyeData(1) >= rangeXL(1) && aveEyeData(1)<= rangeXL(3) &&...
       aveEyeData(2) >= rangeY(1) && aveEyeData(2) <= rangeY(3) &&...
       aveEyeData(4) >= rangeXR(1) && aveEyeData(4)<= rangeXR(3) &&...
       aveEyeData(5) >= rangeY(1) && aveEyeData(5) <= rangeY(3)
   
        success = 1;
    end
end
    
    


