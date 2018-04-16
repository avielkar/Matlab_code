function ModeOptions
global basicfig modeoptfig debug

if isempty(findobj('Name','Mode Options'))
    flagdata = getappdata(basicfig,'flagdata');
    set(0,'Units','centimeters')
    pos = get(0,'ScreenSize');

    modeoptfig = figure('Units','centimeters',...
        'Position',[pos(3)-4.1 pos(4)-3.6 4 3],...
        'Color',[0.831 0.816 0.784],...
        'Name','Mode Options',...
        'NumberTitle','off',...
        'MenuBar','none',...
        'CloseRequestFcn', {@ModeOption_CloseRequestFcn});
    
    uicontrol(modeoptfig,'Units','centimeters',...
        'Style','checkbox',...
        'Tag','SubjectControl',...
        'Position',[1 1 4 0.5],...
        'String','Subject Control',...
        'Value', flagdata.isSubControl,...
        'BackgroundColor',[0.831 0.816 0.784],...
        'Callback',{@SubjectControl_Callback});    
    uicontrol(modeoptfig,'Units','centimeters',...
        'Style','checkbox',...
        'Tag','EyeTracking',...
        'Position',[1 1.5 4 0.5],...
        'String','Eye Tracking',...
        'Value', flagdata.isEyeTracking,...
        'BackgroundColor',[0.831 0.816 0.784],...
        'Callback',{@EyeTracking_Callback});
    uicontrol(modeoptfig,'Units','centimeters',...
        'Style','checkbox',...
        'Tag','DebugMode',...
        'Position',[1 2 4 0.5],...
        'String','Debug',...
        'Value', debug,...
        'BackgroundColor',[0.831 0.816 0.784],...
        'Callback',{@DebugMode_Callback});
    uicontrol(modeoptfig,'Units','centimeters',...
        'Style','pushbutton',...
        'Position',[0.5 0.2 1 0.5],...
        'String','OK',...
        'Callback',{@OkButton_Callback , basicfig});
    uicontrol(modeoptfig,'Units','centimeters',...
        'Style','pushbutton',...
        'Position',[2 0.2 1.5 0.5],...
        'String','Cancel',...
        'Callback',{@CancelButton_Callback});
end
    

% --- Executes on button press in EyeTracking.
function EyeTracking_Callback(hObject, eventdata)
global basicfig 

flagdata = getappdata(basicfig,'flagdata');
flagdata.isEyeTracking = get(findobj(hObject,'Tag','EyeTracking'),'Value');
setappdata(basicfig,'flagdata',flagdata);

% --- Executes on button press in DebugMode.
function DebugMode_Callback(hObject, eventdata)
global debug

debug = get(findobj(hObject,'Tag','DebugMode'),'Value');

% --- Executes on button press in SubjectControlMode.
function SubjectControl_Callback(hObject, eventdata)
global basicfig 

flagdata = getappdata(basicfig,'flagdata');
flagdata.isSubControl = get(findobj(hObject,'Tag','SubjectControl'),'Value');
setappdata(basicfig,'flagdata',flagdata);


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
global basicfig debug modeoptfig 

flagdata = getappdata(basicfig,'flagdata');
debug = 0;
flagdata.isMultiStair = 0;
flagdata.isEyeTracking = 0;
setappdata(basicfig,'flagdata',flagdata);
delete(modeoptfig);

H = findobj('Name','Debug Window');
if ~isempty(H)
    delete(H);
end

H = findobj('Name','Eye Tracking Configuration');
if ~isempty(H)
    delete(H)
end

% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)
global basicfig debug

flagdata = getappdata(basicfig,'flagdata');

if debug
    display('****************DEBUG MODE*********************');
    DebugWindow(handles);
else
    hDebug = findobj('Name','Debug Window');
    if ~isempty(hDebug)
        close(hDebug);
    end
end
    
if flagdata.isEyeTracking 
    hPos = findobj('Name','Eye Tracking Configuration');
    if ~isempty(hPos)
        close(hPos)
    end
    ExperimentEyeTrackingConfig;  
else
    hPos = findobj('Name','Watch Eyes');
    if ~isempty(hPos)
        close(hPos)
    end
    
    hPos = findobj('Name','Eye Tracking Configuration');
    if ~isempty(hPos)
        close(hPos)
    end
    
end
    
setappdata(basicfig,'flagdata',flagdata);

function ModeOption_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);

H = findobj('Name','Debug Window');
if ~isempty(H)
    delete(H);
end

H = findobj('Name','Eye Tracking Configuration');
if ~isempty(H)
    delete(H)
end



