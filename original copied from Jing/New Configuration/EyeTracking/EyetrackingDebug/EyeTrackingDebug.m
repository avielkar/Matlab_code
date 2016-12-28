function EyeTrackingDebug
global eyeTrackfig paths

set(0,'Units','centimeters')
pos = get(0,'ScreenSize');
dispTimestr = 50;
posSmoothingstr = 5;
waveformSmoothingstr = 1;
eyeTrackfig = figure('Units','centimeters',...
    'Position',[pos(3)-8.1 pos(4)/2-5 8 9.5 ],...
    'Color',[0.831 0.816 0.784],...
    'Name','Eye Tracking Configuration',...
    'NumberTitle','off',...
    'MenuBar','none');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','checkbox',...
    'Tag','dispcheckBox',...
    'Position',[1 7 4 0.5],...
    'String','Display Eye Position',...
    'BackgroundColor',[0.831 0.816 0.784],...
    'Value', 1);
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','radiobutton',...
    'Tag', 'radioButtonHor',...
    'Position',[1 6 5 0.5],...
    'String','Display Eye Signal Horizontally',...
    'Value', 1,...
    'BackgroundColor',[0.831 0.816 0.784],...
    'Callback',{@radioButton_callback,1});
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','radiobutton',...
    'Tag', 'radioButtonVer',...
    'Position',[1 5 5 0.5],...
    'String','Display Eye Signal Vertically',...
    'BackgroundColor',[0.831 0.816 0.784],...
    'Callback',{@radioButton_callback,2});
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','text',...
    'Position',[1 4 4 0.5],...
    'String','Display Duration (s):',...
    'BackgroundColor',[0.831 0.816 0.784],...
    'HorizontalAlignment', 'Right');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','edit',...
    'Tag','displaytimeEdit',...
    'Position',[5.1 4 1 0.5],...
    'String',dispTimestr,...
    'BackgroundColor','white');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','text',...
    'Position',[1 3 4 0.5],...
    'String','Position Smoothing (pt):',...
    'BackgroundColor',[0.831 0.816 0.784],...
    'HorizontalAlignment', 'Right');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','edit',...
    'Tag','posSmoothEdit',...
    'Position',[5.1 3 1 0.5],...
    'String',posSmoothingstr,...
    'BackgroundColor','white');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','text',...
    'Position',[1 2 4 0.5],...
    'String','Waveform Smoothing (pt):',...
    'BackgroundColor',[0.831 0.816 0.784],...
    'HorizontalAlignment', 'Right');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','edit',...
    'Tag','waveformSmoothEdit',...
    'Position',[5.1 2 1 0.5],...
    'String',waveformSmoothingstr,...
    'BackgroundColor','white');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','pushbutton',...
    'Tag','StartButton',...
    'Position',[2 0.5 1.5 0.5],...
    'String','Start',...
    'Callback',{@startButton_callback});
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','pushbutton',...
    'Tag','StopButton',...
    'Position',[4.5 0.5 1.5 0.5],...
    'String','Stop',...
    'Callback',{@stopButton_callback});

definePaths
data.configpath = paths.configpath;
data.datapath = paths.datapath;
prots = getfiles(data.configpath);
len = size(prots,2) - 4;
prots = [prots; ['None' blanks(len)]];
setappdata(eyeTrackfig,'protinfo',data);
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','text',...
    'Position',[1 8.5 3 0.5],...
    'String','Protocols:',...
    'HorizontalAlignment', 'Left');
uicontrol(eyeTrackfig,'Units','centimeters',...
    'Style','popupmenu',...
    'Tag','ProtPopupMenu',...
    'Position',[1 8 4 0.5],...
    'String',prots,...
    'Value',size(prots,1),...
    'BackgroundColor','white',...
    'Callback',{@ProtPopupMenu_callback});

 


% If there is a fig, reset the fig obj and close unused figure.
hPos = findobj('Name','Watch Eyes');
hHor = findobj('Name','Eye Channel Horizontal View');
hVer = findobj('Name','Eye Channel Vertical View');

if ~isempty(hPos)
    close(hPos);
end

if ~isempty(hHor)
    close(hHor);
end

if ~isempty(hVer)
    close(hVer);
end

function startButton_callback(hobject, event_data)
global eyeTrackfig

eyeDataSampleObj = getappdata(eyeTrackfig, 'eyeDataSample');
eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
data = getappdata(eyeTrackfig,'protinfo');    
chanInfo = data.channels(cell2mat({data.channels.active})==1); 

%Defines eye signal sampling data structure for each channel
eyeDataSampleObj.BIP10VOLTS = 1;      %--- Defines from cbw.h ---
eyeDataSampleObj.AIFUNCTION = 1;      %--- Defines from cbw.h ---
eyeDataSampleObj.bufferSize = 512*6;
eyeDataSampleObj.sampleRate = 600;
eyeDataSampleObj.boardNum = 1;
eyeDataSampleObj.previousCount = 0;
eyeDataSampleObj.previousIndex = 0;
eyeDataSampleObj.chans = [0, 5];
eyeDataSampleObj.memHandle = cbWinBufAlloc(eyeDataSampleObj.bufferSize);
eyeDataSampleObj.data = [];
eyeDataSampleObj.dispstr = [];

setappdata(eyeTrackfig, 'eyeDataSample',eyeDataSampleObj);

%figures position data and flags setup.
set(0,'Units','centimeters');
scnsize = get(0,'ScreenSize');
pos1  = [scnsize(3)+0.1, scnsize(4)-8.6, 14, 8];    %---figure(1)'s position [left bottom width heigh]
pos2 = [pos1(1), pos1(2)-11, 14, 10];               %---Horizontal View's position [left bottom width height]
pos3 = [pos1(1)+14.2, scnsize(4)-16.5, 12, 16];     %---Vertical View's position [left bottom width height]
eyeWinData.posEyefig = pos1;
eyeWinData.posHorView = pos2;
eyeWinData.posVerView = pos3;
eyeWinData.isPositionView = get(findobj(eyeTrackfig,'Tag', 'dispcheckBox'), 'Value');
eyeWinData.isHorView = get(findobj(eyeTrackfig,'Tag', 'radioButtonHor'), 'Value');
eyeWinData.isVerView = get(findobj(eyeTrackfig,'Tag', 'radioButtonVer'), 'Value');
eyeWinData.duration = str2num(get(findobj(eyeTrackfig,'Tag', 'displaytimeEdit'), 'String'));
eyeWinData.posSmoothPt = str2num(get(findobj(eyeTrackfig,'Tag','posSmoothEdit'), 'String'));
eyeWinData.waveformSmoothPt = str2num(get(findobj(eyeTrackfig,'Tag','waveformSmoothEdit'), 'String'));
eyeWinData.slideroffset = 1/eyeDataSampleObj.sampleRate;
eyeWinData.xscale = eyeWinData.slideroffset;
eyeWinData.xpos = 0;
eyeWinData.sliderMin = 0;
eyeWinData.sliderMax = eyeWinData.duration;
eyeWinData.eyecode = 2;%eyecode;
eyeWinData.zoomFactorPos = 1;
eyeWinData.zoomFactorVergence = 1;
eyeWinData.posSmoothCnt = 0;
eyeWinData.posdata = 0;

setappdata(eyeTrackfig,'eyeWinData',eyeWinData);

% If there is a fig, reset the fig obj and close unused figure.
hPos = findobj('Name','Watch Eyes');
hHor = findobj('Name','Eye Channel Horizontal View');
hVer = findobj('Name','Eye Channel Vertical View');

if ~eyeWinData.isPositionView && ~isempty(hPos)
    close(hPos);
end

if ~eyeWinData.isHorView && ~isempty(hHor)
    close(hHor);
end
if eyeWinData.isHorView && ~isempty(hHor)
    tempH = getappdata(eyeTrackfig,'horViewHandle');
    for i=1:length(chanInfo)
        cla(tempH.axes(i));
    end
    set(tempH.posSlider,'min',eyeWinData.sliderMin, 'max',eyeWinData.sliderMax, 'value', eyeWinData.xpos);
    set(tempH.scaleSlider,'min',eyeWinData.sliderMin+eyeWinData.slideroffset,...
        'max',eyeWinData.sliderMax-eyeWinData.slideroffset, 'value',eyeWinData.xscale);
end

if ~eyeWinData.isVerView && ~isempty(hVer)
    close(hVer);
end
if eyeWinData.isVerView && ~isempty(hVer)
    tempH = getappdata(eyeTrackfig ,'verViewHandle');
    for i=1:length(chanInfo)
        cla(tempH.axes(i));
    end
    set(tempH.posSlider,'min',eyeWinData.sliderMin, 'max',eyeWinData.sliderMax, 'value', eyeWinData.xpos);
    set(tempH.scaleSlider,'min',eyeWinData.sliderMin+eyeWinData.slideroffset,...
        'max',eyeWinData.sliderMax-eyeWinData.slideroffset, 'value',eyeWinData.xscale);
end

 %control loop data initiate
eyecldata.stage = 'InitializationStage';
eyecldata.initStage = 1;
eyecldata.PretrackingTime = 0.001;
eyecldata.TrackingTime = 0.001;
eyecldata.PostTrackingTime = 0.001;
eyecldata.count  = 0;
eyecldata.num = 1000;
eyecldata.paused = 0;   % when try to change from horizontal view to vertical view, pause plot/timer.
setappdata(eyeTrackfig,'eyeControlLoopData',eyecldata);

% Define a timer.
period = .001;
delete(timerfind('Tag','eyeCLoop'));
CLoop = timer('TimerFcn',{@EyeTrackingControlLoop eyeTrackfig},'Period',period,'Tag','eyeCLoop','ExecutionMode','fixedRate');

%=====Start the backbround eye signal sampling sweep.=====
cbAInBackgroundScan(eyeDataSampleObj.boardNum, eyeDataSampleObj.chans, eyeDataSampleObj.bufferSize,...
                   eyeDataSampleObj.sampleRate, eyeDataSampleObj.BIP10VOLTS, eyeDataSampleObj.memHandle);
%=====End==================================================================

%  Start Control Loop(timer)
run = get(timerfind('Tag','eyeCLoop'),'Running');
if strmatch(run,'off','exact')               
    start(CLoop);
else
    disp('Control Loop already running');
end
    
    
function radioButton_callback(hobject, event_data, radioIndex)

switch radioIndex
    case 1
        set(hobject, 'Value', 1); % ensure radio1 stays selected
        set(findobj(gcf,'Tag', 'radioButtonVer'),'Value', 0);
    case 2
        set(hobject, 'Value', 1); % ensure radio2 stays selected
        set(findobj(gcf,'Tag', 'radioButtonHor'),'Value', 0);
end


function stopButton_callback(hobject, event_data)
global eyeTrackfig

eyeDataSampleObj = getappdata(eyeTrackfig, 'eyeDataSample');
cbStopBackground(eyeDataSampleObj.boardNum, eyeDataSampleObj.AIFUNCTION);
cbWinBufFree(eyeDataSampleObj.memHandle);
stop(timerfind('Tag','eyeCLoop'));

data = getappdata(eyeTrackfig,'protinfo');
a = clock;
timestr = [num2str(a(4)) ',' num2str(a(5))];
[filename, pathname] = uiputfile('*.mat', 'Save Data',...
    [data.datapath filesep 'eyeData_' char(date) '_' char(timestr)]);
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    save([pathname, filename], 'eyeDataSampleObj');
    disp(['saving ' pathname filename])
else
    disp('Save Unsuccesful')
end


function ProtPopupMenu_callback(hobject, event_data)    
global eyeTrackfig

data = getappdata(eyeTrackfig,'protinfo');
protstr = get(hobject,'String');
protnum = get(hobject,'Value');
protocol = strtrim(protstr(protnum,:));

% Removing 'None' from string
wid = size(protstr,2) - 4;
if strmatch(protstr(end,:),['None' blanks(wid)],'exact')
    protstr = protstr(1:(size(protstr,1)-1),:);
    set(findobj(eyeTrackfig,'Tag','ProtPopupMenu'),'String',protstr)
end

if isempty(strmatch(protocol,'None'))
    % Removing 'None' from string
    data.configfile = protocol;
    a = importdata([data.configpath filesep data.configfile]);
    data.configinfo = a.variables;
    data.channels = a.channels;
    data.functions = a.functions;
    clear a
    % taking out non-active params
    data.configinfo = data.configinfo(cell2mat({data.configinfo.active})==1);
    setappdata(eyeTrackfig,'protinfo',data);
end


function EyeTrackingDebug_CloseRequestFcn(hobject, event_data)
close all;


                                                            


