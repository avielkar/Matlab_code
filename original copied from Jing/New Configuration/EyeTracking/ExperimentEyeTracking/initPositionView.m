% Creat a figure for Watch Eye window. There are two axes and one
% pushbutton in this figure.
function initPositionView
global basicfig eyeTrackfig

data = getappdata(basicfig,'protinfo');
chanInfo = data.channels(cell2mat({data.channels.active})==1);  

i = strmatch('EYE_CODE',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    eyecode = data.configinfo(i).parameters;
else
    %Find out which eye being tested from protocol (init checking)
    isLeftEye = 0;
    isRightEye = 0;
    for i=1:length(chanInfo)
        chanNum = chanInfo(i).chanNum;
        if chanNum == 1 || chanNum == 2
            isLeftEye = 1;
        end;
        if  chanNum == 4 || chanNum == 5
            isRightEye = 1;
        end
    end

    if isLeftEye && isRightEye
        eyecode = 2;
    elseif isLeftEye
        eyecode = 0;
    elseif isRightEye
        eyecode = 1;
    else
        message = 'Can not track eye signal because there is not any active eye channel.';
        warntitle = 'Warning Message';
        msgbox(message,warntitle,'warn');
    end
end
%End

%figures position data and flags setup.
set(0,'Units','centimeters');
scnsize = get(0,'ScreenSize');
pos1  = [scnsize(3)+0.1, scnsize(4)-8.6, 14, 8];    %---figure(1)'s position [left bottom width heigh]
%pos1  = [0.1, scnsize(4)-8.6, 14, 8];

eyeWinData.posEyefig = pos1;
eyeWinData.isPositionView = get(findobj(eyeTrackfig,'Tag', 'dispcheckBox'), 'Value');
eyeWinData.posSmoothPt = str2num(get(findobj(eyeTrackfig,'Tag','posSmoothEdit'), 'String'));
eyeWinData.zoomFactorPos = 1;
eyeWinData.zoomFactorVergence = 1;
eyeWinData.posSmoothCnt = 0;
eyeWinData.eyecode = eyecode;
eyeWinData.isLineUpRight = 0;
eyeWinData.isLineUpLeft = 0;
setappdata(basicfig,'eyeWinData',eyeWinData);

appHandle = getappdata(basicfig, 'posViewHandle');

pos = eyeWinData.posEyefig;
zoom1 = eyeWinData.zoomFactorPos;
zoom2 = eyeWinData.zoomFactorVergence;
appHandle.fig = figure('Units','centimeters',...
                       'Position',pos,...
                       'Name','Watch Eyes',...
                       'NumberTitle','off',...
                       'MenuBar','none',...
                       'Color',[0.831 0.816 0.784],...
                       'CloseRequestFcn', {@posView_CloseRequestFcn,appHandle},...
                       'ResizeFcn',{@posView_ResizeFcn,appHandle});
                       
appHandle.axex1 = axes('Units','centimeters',...
                       'nextplot','replacechildren',...
                       'XLim',[-30*zoom1 30*zoom1],'YLim',[-30*zoom1 30*zoom1]);   
title(appHandle.axex1,'Eye Position Display');
xlabel(appHandle.axex1,'degree');
ylabel(appHandle.axex1,'degree');

appHandle.axex2 = axes('Units','centimeters',...
                       'nextplot','replacechildren',...
                       'XLim',[-30*zoom2 30*zoom2],'YLim',[-30*zoom2 30*zoom2]); 
title(appHandle.axex2,'Vergence Display');
xlabel(appHandle.axex2,'degree');
ylabel(appHandle.axex2,'degree');

appHandle.button = uicontrol('Units','centimeters',...
                             'style','pushbutton',...
                             'string','Eye Options',...
                             'position',[6 0.5 2 0.5]);
set(appHandle.button, 'callback',{@eyeoptsButton_callback,appHandle});

setappdata(basicfig ,'posViewHandle',appHandle);


function eyeoptsButton_callback(hobject, event_data, handles)

hOpt = findobj('Name','Eye Options');
if ~isempty(hOpt)
    close(hOpt);
end
EyeOptionsWindow;

function posView_CloseRequestFcn(hobject, event_data, handles)

delete(hobject)
hOpt = findobj('Name','Eye Options');
if ~isempty(hOpt)
    close(hOpt);
end


function posView_ResizeFcn(hobject, event_data, handles)
global basicfig

appHandle = getappdata(basicfig, 'posViewHandle');

pos = get(appHandle.fig, 'position');
set(appHandle.axex1,'position',[1.5 2 pos(3)/2-2 pos(4)-3]);
set(appHandle.axex2,'position',[pos(3)/2+1 2 pos(3)/2-2 pos(4)-3]);

