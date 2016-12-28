function ModeOptions
global basicfig modeoptfig debug

flagdata = getappdata(basicfig,'flagdata');
if isempty(findobj('Name','Mode Options'))
    flagdata = getappdata(basicfig,'flagdata');
    set(0,'Units','centimeters')
    pos = get(0,'ScreenSize');

    modeoptfig = figure('Units','centimeters',...
        'Position',[pos(3)-4.1 pos(4)-3.6 4 3],...
        'Color',[0.831 0.816 0.784],...
        'Name','Mode Options',...
        'NumberTitle','off',...
        'MenuBar','none');
    
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
        'Callback',{@OkButton_Callback});
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
close(modeoptfig);

H = findobj('Name','Debug Window');
if ~isempty(H)
    close(H);
end


% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)
global basicfig debug

flagdata = getappdata(basicfig,'flagdata');

if debug
    display('****************DEBUG MODE*********************');
    DebugWindow;
else
    hDebug = findobj('Name','Debug Window');
    if ~isempty(hDebug)
        close(hDebug);
    end
    hCfg = findobj('Name','Eye Tracking Configuration');
    if ~isempty(hCfg)
        close(hCfg);
    end
end

hCfg = findobj('Name','Eye Tracking Configuration');
if ~isempty(hCfg)
        close(hCfg);
end
    
if flagdata.isEyeTracking    
    EyeTrackingConfiguration;
else
    hPos = findobj('Name','Watch Eyes');
    hHor = findobj('Name','Eye Channel Horizontal View');
    hVer = findobj('Name','Eye Channel Vertical View');
    if ~isempty(hPos)
        close(hPos)
    end
    if ~isempty(hHor)
        close(hHor)
    end
    if ~isempty(hVer)
        close(hVer)
    end
end
    
setappdata(basicfig,'flagdata',flagdata);



