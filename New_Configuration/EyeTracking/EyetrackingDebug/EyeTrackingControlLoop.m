%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timer Object callback function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function EyeTrackingControlLoop(obj, event, appHandle)
% Grab the current stage and execute it.
%disp('entering cl');
eyecldata = getappdata(appHandle, 'eyeControlLoopData');
eval([eyecldata.stage, '(appHandle)']);
%disp('exiting cl');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% InitializationStage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InitializationStage(appHandle)

%disp('entering init');
eyecldata = getappdata(appHandle,'eyeControlLoopData');

%---Main function---
if ~eyecldata.paused
    if eyecldata.initStage
        tic % Start for PretrackingTime
        eyecldata.initStage = 0;
        setappdata(appHandle,'eyeControlLoopData',eyecldata);

        eyeWinData = getappdata(appHandle,'eyeWinData');
        hPos = findobj('Name','Watch Eyes');
        hHor = findobj('Name','Eye Channel Horizontal View');
        hVer = findobj('Name','Eye Channel Vertical View');

        if eyeWinData.isPositionView
            if isempty(hPos)
                eyePosHandles.fig = 0;
                setappdata(appHandle ,'posViewHandle',eyePosHandles);
                initPositionView;
            end
        end

        if eyeWinData.isHorView
            if isempty(hHor)
                eyeHorizontalViewHandles.fig = 0;
                setappdata(appHandle ,'horViewHandle', eyeHorizontalViewHandles);
                initHorView;
            end
        end

        if eyeWinData.isVerView
            if isempty(hVer)
                eyeVerticalViewHandles.fig = 0;
                setappdata(appHandle ,'verViewHandle', eyeVerticalViewHandles);
                initVerView;
            end
        end
    end

    if toc >= eyecldata.PretrackingTime
        % Increment the stage.
        eyecldata.stage = 'MainStage';
        eyecldata.initStage = 1;
        setappdata(appHandle, 'eyeControlLoopData', eyecldata);
    end
end
%disp('exiting init');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MainStage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MainStage(appHandle)    

%disp('entering main');
eyecldata = getappdata(appHandle, 'eyeControlLoopData');
eyeWinData = getappdata(appHandle,'eyeWinData');
 
if ~eyecldata.paused
    if eyecldata.initStage
        eyecldata.initStage = 0;
        setappdata(appHandle, 'eyeControlLoopData', eyecldata);

        % Start the timer.
        tic;
    end

    if toc >= eyecldata.TrackingTime
        data = getappdata(appHandle,'protinfo');
        chanInfo = data.channels(cell2mat({data.channels.active})==1);
        eyeDataSampleObj = getappdata(appHandle, 'eyeDataSample');

        %=======Get eye data======================================================
%         [buf, st, eyeDataSampleObj.previousCount,eyeDataSampleObj.previousIndex] = ...
%             cbGetAInBackgroundScanData(eyeDataSampleObj.boardNum,eyeDataSampleObj.previousCount,...
%             eyeDataSampleObj.previousIndex, eyeDataSampleObj.bufferSize,...
%             eyeDataSampleObj.chans, eyeDataSampleObj.BIP10VOLTS,eyeDataSampleObj.memHandle);
        %=======End==============================================================
        for i=1:6    %---Generate fake eye data for running on my machine----
            for j = 1:170
                buf(i,j) = 5*i*sin(j);
            end
        end

        if size(buf,2) ~= 0  % If we get the new data, we plot.
%             for i=1:length(chanInfo)
%                 chanNum = chanInfo(i).chanNum;
%                 buf(chanNum, :) = buf(chanNum, :)*chanInfo(chanNum).scale+chanInfo(chanNum).offset;
%             end
            eyeDataSampleObj.data = [eyeDataSampleObj.data, buf];  %---data for plot eye signal waveform----
            setappdata(appHandle, 'eyeDataSample', eyeDataSampleObj);
            
            plotEyePosition(buf);
            if eyeWinData.isVerView || eyeWinData.isHorView
                plotEyeWaveform;
            end

            setappdata(appHandle, 'eyeDataSample', eyeDataSampleObj);
        end

        eyecldata.stage = 'PostStage';
        eyecldata.initStage = 1;
        setappdata(appHandle, 'eyeControlLoopData', eyecldata);
    end;    
end
%disp('exiting main');
%----End Main function-----

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PostStage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostStage(appHandle)

%disp('entering post');
eyecldata = getappdata(appHandle, 'eyeControlLoopData');
if ~eyecldata.paused
    if eyecldata.initStage
        eyecldata.initStage = 0;
        setappdata(appHandle, 'eyeControlLoopData', eyecldata);

        tic;
    end

    if toc >= eyecldata.PostTrackingTime
        eyecldata.stage = 'InitializationStage';
        eyecldata.initStage = 1;
        setappdata(appHandle, 'eyeControlLoopData', eyecldata);
    end
end
%disp('exiting post');


function plotEyePosition(posData)
global eyeTrackfig

data = getappdata(eyeTrackfig, 'protinfo');
chanInfo = data.channels(cell2mat({data.channels.active})==1);
appHandle = getappdata(eyeTrackfig ,'posViewHandle');
eyeWinData = getappdata(eyeTrackfig,'eyeWinData');

eyecode = eyeWinData.eyecode;
zoom1 = eyeWinData.zoomFactorPos;
zoom2 = eyeWinData.zoomFactorVergence;
spt = eyeWinData.posSmoothPt;

siz = size(posData);
len = floor(siz(2)/spt);

if eyecode == 0
    chanList = 1:3;
elseif eyecode == 1
    chanList = 4:6;
elseif eyecode == 2
    chanList = 1:6;
end

%Based on channel info, convert channel data fron Volt to deg 
for i = 1:siz(1)
    posData(i, :) = posData(i, :)*chanInfo(chanList(i)).scale+chanInfo(chanList(i)).offset;
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
        plot(appHandle.axex1, plotData(1), plotData(2),'+b');
    elseif eyecode ==1
        plot(appHandle.axex1, plotData(1), plotData(2),'xr');
    elseif eyecode ==2
        plot(appHandle.axex1, plotData(1), plotData(2),'+b',plotData(4), plotData(5),'xr');
    end
end


title(appHandle.axex1,'Eye Position Display');
xlabel(appHandle.axex1,'degree');
ylabel(appHandle.axex1,'degree');
xlim(appHandle.axex1,[-30*zoom1 30*zoom1]);
ylim(appHandle.axex1,[-30*zoom1 30*zoom1]);

title(appHandle.axex2,'Vergence Display');
xlabel(appHandle.axex2,'degree');
ylabel(appHandle.axex2,'degree');
xlim(appHandle.axex2,[-30*zoom2 30*zoom2]);
ylim(appHandle.axex2,[-30*zoom2 30*zoom2]);


%disp('exiting plotpos');

function plotEyeWaveform
global eyeTrackfig
%disp('entering plotwave');

eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
setappdata(eyeTrackfig,'eyeWinData',eyeWinData);

data = getappdata(eyeTrackfig,'protinfo');    
chanInfo = data.channels(cell2mat({data.channels.active})==1); 

if eyeWinData.isHorView
    appHandle = getappdata(eyeTrackfig ,'horViewHandle');
else
    appHandle = getappdata(eyeTrackfig ,'verViewHandle');
end

eyecode = eyeWinData.eyecode;
xpos = eyeWinData.xpos;
xscale = eyeWinData.xscale;
sliderMin = eyeWinData.sliderMin;
sliderMax = eyeWinData.sliderMax;
slideroffset = eyeWinData.slideroffset;

eyeDataSampleObj = getappdata(eyeTrackfig, 'eyeDataSample');

plotdataY= eyeDataSampleObj.data;

xIndexEnd = size(plotdataY,2);
xIndexStep = eyeWinData.waveformSmoothPt;
xIndexStart = xIndexEnd - round(eyeWinData.duration*eyeDataSampleObj.sampleRate);
if xIndexStart < 0
    xIndexStart = 1;
end
    
xIndexArray = (xIndexStart : xIndexStep : xIndexEnd);
plotdataX = xIndexArray/eyeDataSampleObj.sampleRate;

if plotdataX(end) > eyeWinData.duration
    temp = sliderMin;
    sliderMin = plotdataX(1);
    sliderMax = plotdataX(end);
    xpos = get(appHandle.posSlider,'value')+(sliderMin-temp);
    xscale = get(appHandle.scaleSlider,'value')+(sliderMin-temp);
    
    eyeWinData.xpos = xpos;
    eyeWinData.xscale = xscale;
    eyeWinData.sliderMin = sliderMin;
    eyeWinData.sliderMax = sliderMax;
    setappdata(eyeTrackfig,'eyeWinData',eyeWinData);
    
    %fprintf('xpos=%f, xscale = %f, slidermin = %f, sliderMax = %f %f %f\n',xpos, xscale, sliderMin, sliderMax, plotdataX(1), temp);
    set(appHandle.posSlider,'min',sliderMin, 'max', sliderMax,'value', xpos);
    set(appHandle.scaleSlider,'min',sliderMin+0.5*slideroffset, 'max', sliderMax-0.5*slideroffset,'value',xscale);
end
    

for i=1:length(chanInfo) 
    chanNum = chanInfo(i).chanNum;
    chanTitle = chanInfo(i).title;
    chanUnits = chanInfo(i).units;
    dispstr(i)= {[chanTitle ' = ' num2str(plotdataY(i,end),'%06.2f') ' ' chanUnits]};
    
    if eyecode == 0
        if chanNum <= 3            
            plot(appHandle.axes(i), plotdataX, plotdataY(chanNum, xIndexArray),'b');
        end
    elseif eyecode == 1
        if chanNum > 3                   
            plot(appHandle.axes(i), plotdataX, plotdataY(chanNum, xIndexArray),'r');    
        end
    elseif eyecode == 2      
        if chanNum <= 3
            plot(appHandle.axes(i), plotdataX, plotdataY(chanNum, xIndexArray),'b');
        else
            plot(appHandle.axes(i), plotdataX, plotdataY(chanNum, xIndexArray),'r');
        end        
    end 
    
    ylabel(appHandle.axes(i), 's');
    ylabel(appHandle.axes(i),chanTitle);
    ylim(appHandle.axes(i),[-5 5]);
  
    tempvar = xpos+sliderMax-xscale;
    if tempvar <= xpos
        tempvar = xpos + slideroffset;
    end
    set(appHandle.axes(i),'xlim', [xpos tempvar]);   
end


set(appHandle.disptext,'String',dispstr);

eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
setappdata(eyeTrackfig,'eyeWinData',eyeWinData);
%disp('exiting plotwave');

% Creat a figure for Watch Eye window. There are two axes and one
% pushbutton in this figure.
function initPositionView
global eyeTrackfig

%disp('entering initpos');
eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
appHandle = getappdata(eyeTrackfig, 'posViewHandle');

pos = eyeWinData.posEyefig;
appHandle.fig = figure('Units','centimeters',...
                       'Position',pos,...
                       'Name','Watch Eyes',...
                       'NumberTitle','off',...
                       'MenuBar','none',...
                       'Color',[0.831 0.816 0.784]);
                      
appHandle.axex1 = axes('Units','centimeters','position',[1.5 2 5 5]);                                                            
appHandle.axex2 = axes('Units','centimeters','position',[8 2 5 5]);  

appHandle.button = uicontrol('Units','centimeters',...
                             'style','pushbutton',...
                             'string','Eye Options',...
                             'position',[6 0.5 2 0.5]);
set(appHandle.button, 'callback',{@eyeoptsButton_callback,appHandle});

setappdata(eyeTrackfig ,'posViewHandle',appHandle);
%disp('exiting initpos');
%end Watch Eye window


%Creat a figure for display eye data waveform horizontally. There are six axes, two
%slider, one pushbutton and static text box
function initHorView
global eyeTrackfig

%disp('entering inithor');
data = getappdata(eyeTrackfig,'protinfo');    
chanInfo = data.channels(cell2mat({data.channels.active})==1); 

eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
appHandle = getappdata(eyeTrackfig, 'horViewHandle');

xscale = eyeWinData.xscale;
xpos = eyeWinData.xpos;
sliderMin = eyeWinData.sliderMin;
sliderMax = eyeWinData.sliderMax;
slideroffset = eyeWinData.slideroffset;
pos = eyeWinData.posHorView;

appHandle.fig =  figure('Units','centimeters',...
                        'Position',pos,...
                        'Name','Eye Channel Horizontal View',...
                        'NumberTitle','off',...
                        'MenuBar','none',...
                        'Color',[0.831 0.816 0.784]); 
                    
for i=1:length(chanInfo)
    chanNum = chanInfo(i).chanNum;
    if chanNum <= 3
        appHandle.axes(i) = axes('Units','centimeters','position',[1.5 pos(4)-chanNum*2.3 5 1.5]);
    else
        appHandle.axes(i) = axes('Units','centimeters','position',[8 pos(4)-(chanNum-3)*2.3 5 1.5]);
    end
end

appHandle.pushbutton = uicontrol('Units','centimeters',...
                                  'style','pushbutton',...
                                 'string','Horizontal View','position',[5.5 pos(4)-0.6 3 0.5],...
                                 'BusyAction', 'queue');
set(appHandle.pushbutton, 'Callback', {@eyeHorViewButton_callback,appHandle});

appHandle.disptext = uicontrol('Units','centimeters','style','text','string','',...
                               'position', [10.5 0.1 2.5 2.2],'BackgroundColor',[0.831 0.816 0.784]);   

appHandle.posSlider = uicontrol('Units','centimeters',...
                                'style','slider',...
                                'position', [1.5 1.5 7 0.5],...
                                'min', sliderMin,'max', sliderMax,...
                                'sliderstep', [0.01 0.1],...
                                'value',xpos,...
                                'Backgroundcolor', [0 0 0]);
appHandle.scaleSlider = uicontrol('Units','centimeters',...
                                  'style','slider',...
                                  'position', [1.5 0.5 7 0.5],...
                                  'min',sliderMin+slideroffset, 'max', sliderMax-slideroffset,...
                                  'sliderstep', [0.01 0.1],...
                                  'value', xscale,...
                                  'Backgroundcolor', [0 0 0]);
set(appHandle.posSlider, 'Callback', {@Slider_callback,appHandle});
set(appHandle.scaleSlider, 'Callback', {@Slider_callback,appHandle});
                                                            
uicontrol('Units','centimeters','style','text','string','X-axis Position',...
          'position', [1.5 2 2 0.3],'BackgroundColor',[0.831 0.816 0.784]);    
uicontrol('Units','centimeters','style','text','string','X-axis Scale',...
          'position', [1.5 1 1.8 0.3],'BackgroundColor',[0.831 0.816 0.784]);   

setappdata(eyeTrackfig, 'horViewHandle',appHandle);
%disp('exiting inithor');
%----end function initHorView----    


function initVerView
global eyeTrackfig 

%disp('entering initver');
data = getappdata(eyeTrackfig,'protinfo');    
chanInfo = data.channels(cell2mat({data.channels.active})==1); 

eyeWinData = getappdata(eyeTrackfig,'eyeWinData');
appHandle = getappdata(eyeTrackfig, 'verViewHandle');

xscale = eyeWinData.xscale;
xpos = eyeWinData.xpos;
sliderMin = eyeWinData.sliderMin;
sliderMax = eyeWinData.sliderMax;
slideroffset = eyeWinData.slideroffset;
pos = eyeWinData.posVerView;

appHandle.fig  = figure('Units','centimeters',...
                        'Position',pos,...
                        'Name','Eye Channel Vertical View',...
                        'NumberTitle','off',...
                        'MenuBar','none',...
                        'Color',[0.831 0.816 0.784]);
                    
for i=1:length(chanInfo)
    chanNum = chanInfo(i).chanNum;
    appHandle.axes(i) = axes('Units','centimeters','position',[1.5 pos(4)-chanNum*2.2 10 1.5]);
end

appHandle.pushbutton = uicontrol('Units','centimeters',...
                                 'style','pushbutton',...
                                 'string','Vertical View','position',[4.5 pos(4)-0.6 3 0.5],...
                                 'BusyAction', 'queue');
set(appHandle.pushbutton, 'Callback', {@eyeVerViewButton_callback,appHandle});

appHandle.disptext = uicontrol('Units','centimeters','style','text','string','',... 
                               'position', [9 0.1 2.5 2.2],'BackgroundColor',[0.831 0.816 0.784]);      

appHandle.posSlider = uicontrol('Units','centimeters',...
                                'style','slider',...
                                'position', [1.5 1 7 0.5],...
                                'min', sliderMin, 'max', sliderMax,...
                                'sliderstep', [0.01 0.1],...
                                'value',xpos,...
                                'Backgroundcolor', [0 0 0]);
appHandle.scaleSlider = uicontrol('Units','centimeters',...
                                  'style','slider',...
                                  'position', [1.5 0.1 7 0.5],...
                                  'min', sliderMin+slideroffset, 'max', sliderMax-slideroffset,...
                                  'sliderstep', [0.01 0.1],...
                                  'value', xscale,...
                                  'Backgroundcolor', [0 0 0]);
set(appHandle.posSlider, 'Callback', {@Slider_callback,appHandle});
set(appHandle.scaleSlider, 'Callback', {@Slider_callback,appHandle});
                                                            
uicontrol('Units','centimeters','style','text','string','X-axis Position',...
          'position', [1.5 1.5 2 0.3],'BackgroundColor',[0.831 0.816 0.784]);    
uicontrol('Units','centimeters','style','text','string','X-axis Scale',...
          'position', [1.5 0.6 1.8 0.3],'BackgroundColor',[0.831 0.816 0.784]);    

setappdata(eyeTrackfig, 'verViewHandle',appHandle);
%disp('exiting initver');
%----end function initVerView----    


function eyeoptsButton_callback(hobject, event_data, handles)

hOpt = findobj('Name','Eye Options');
if ~isempty(hOpt)
    close(hOpt);
end
EyeOptionsWindow;


function eyeVerViewButton_callback(hobject, event_data, handles)
global eyeTrackfig eyeTrackfig

%disp('entering verButton');
eyeWinData = getappdata(eyeTrackfig, 'eyeWinData');
eyecldata = getappdata(eyeTrackfig,'eyeControlLoopData');

eyecldata.paused = 1;
setappdata(eyeTrackfig,'eyeControlLoopData',eyecldata);

eyeWinData.isHorView = 1;
eyeWinData.isVerView = 0;
setappdata(eyeTrackfig, 'eyeWinData', eyeWinData);

set(findobj(eyeTrackfig,'Tag', 'radioButtonHor'),'Value', 1);
set(findobj(eyeTrackfig,'Tag', 'radioButtonVer'),'Value', 0);

close(handles.fig);
initHorView;

run = get(timerfind('Tag','eyeCLoop'),'Running');
if strmatch(run,'off','exact')  
    plotEyeWaveform;
end

eyecldata.paused = 0;
setappdata(eyeTrackfig,'eyeControlLoopData',eyecldata);
%disp('exiting verButton');


function eyeHorViewButton_callback(hobject, event_data, handles)
global eyeTrackfig 

%disp('entering horButton');
eyeWinData = getappdata(eyeTrackfig, 'eyeWinData');
eyecldata = getappdata(eyeTrackfig,'eyeControlLoopData');


eyecldata.paused = 1;
setappdata(eyeTrackfig,'eyeControlLoopData',eyecldata);

eyeWinData.isHorView = 0;
eyeWinData.isVerView = 1;
setappdata(eyeTrackfig, 'eyeWinData', eyeWinData);

set(findobj(eyeTrackfig,'Tag', 'radioButtonHor'),'Value', 0);
set(findobj(eyeTrackfig,'Tag', 'radioButtonVer'),'Value', 1);

close(handles.fig);
initVerView;

run = get(timerfind('Tag','eyeCLoop'),'Running');
if strmatch(run,'off','exact')  
    plotEyeWaveform;
end

eyecldata.paused = 0;
setappdata(eyeTrackfig,'eyeControlLoopData',eyecldata);
%disp('exiting horButton');


function Slider_callback(hobject, event_data,handles)
global eyeTrackfig

data = getappdata(eyeTrackfig,'protinfo');    
chanInfo = data.channels(cell2mat({data.channels.active})==1); 

eyeWinData = getappdata(eyeTrackfig, 'eyeWinData');
sliderMin = eyeWinData.sliderMin;
sliderMax = eyeWinData.sliderMax;
slideroffset = eyeWinData.slideroffset;

xpos = get(handles.posSlider,'value');
xscale = get(handles.scaleSlider,'value');
if xpos < sliderMin
    xpos = sliderMin;
end
if xpos > sliderMax
    xpos = sliderMax;
end
if xscale <= sliderMin+slideroffset
   xscale = sliderMin+1.5*slideroffset;
end
if xscale >= sliderMax-slideroffset
    xscale = sliderMax-1.5*slideroffset;
end
set(handles.posSlider,'value',xpos);
set(handles.scaleSlider,'value',xscale);

tempvar = xpos+sliderMax-xscale;
if tempvar <= xpos
    tempvar = xpos + slideroffset;
end
for i=1:length(chanInfo)    
    set(handles.axes(i),'xlim', [xpos tempvar]);
end
%fprintf('xpos=%f, xscale = %f, slidermin = %f, sliderMax = %f\n',xpos, xscale, sliderMin, sliderMax);
eyeWinData.xpos = xpos;
eyeWinData.xscale = xscale;
setappdata(eyeTrackfig, 'eyeWinData', eyeWinData);

drawnow


