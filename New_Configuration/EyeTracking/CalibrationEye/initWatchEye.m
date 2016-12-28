% Creat a figure for Watch Eye window. There are two axes and one
% pushbutton in this figure.
function initWatchEye
global eyeCalfig

if isempty(findobj('Name','Watch Eyes'))
    eyeWinData = getappdata(eyeCalfig,'eyeWinData');

    %figures position data and flags setup.
    set(0,'Units','centimeters');
    scnsize = get(0,'ScreenSize');
    pos1  = [scnsize(3)/2-6, scnsize(4)-8.6, 14, 8];    %---figure(1)'s position [left bottom width heigh]

    eyeWinData.posEyefig = pos1;
    eyeWinData.zoomFactorPos = 1;
    eyeWinData.zoomFactorVergence = 1;

    setappdata(eyeCalfig,'eyeWinData',eyeWinData);

    appHandle = getappdata(eyeCalfig, 'posViewHandle');

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

    setappdata(eyeCalfig ,'posViewHandle',appHandle);
end

function eyeoptsButton_callback(hobject, event_data, handles)

hOpt = findobj('Name','Eye Options');
if ~isempty(hOpt)
    close(hOpt);
end
eyeCalibrationOptionsWindow;

function posView_CloseRequestFcn(hobject, event_data, handles)

delete(hobject)
hOpt = findobj('Name','Eye Options');
if ~isempty(hOpt)
    close(hOpt);
end


function posView_ResizeFcn(hobject, event_data, handles)
global eyeCalfig

appHandle = getappdata(eyeCalfig, 'posViewHandle');

pos = get(appHandle.fig, 'position');
set(appHandle.axex1,'position',[1.5 2 pos(3)/2-2 pos(4)-3]);
set(appHandle.axex2,'position',[pos(3)/2+1 2 pos(3)/2-2 pos(4)-3]);

