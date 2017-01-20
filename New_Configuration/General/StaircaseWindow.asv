function varargout = StaircaseWindow(varargin)
% MULTISTAIRWINDOW M-file for MultistairWindow.fig
%      StaircaseWINDOW, by itself, creates a new StaircaseWINDOW or raises the existing
%      singleton*.
%
%      H = StaircaseWINDOW returns the handle to a new StaircaseWINDOW or the handle to
%      the existing singleton*.
%
%      StaircaseWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in StaircaseWINDOW.M with the given input arguments.
%
%      StaircaseWINDOW('Property','Value',...) creates a new StaircaseWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StaircaseWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StaircaseWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StaircaseWindow

% Last Modified by GUIDE v2.5 28-Feb-2008 16:50:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @StaircaseWindow_OpeningFcn, ...
    'gui_OutputFcn',  @StaircaseWindow_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before StaircaseWindow is made visible.
function StaircaseWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StaircaseWindow (see VARARGIN)

% Choose default command line output for StaircaseWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StaircaseWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%========= Jimmy Added 3/5/2008 ==================%
global basicfig staircasefig

staircasefig = hObject;
data = getappdata(basicfig,'protinfo');

acrossStair = data.condvect.acrossStair;
withinStair = data.condvect.withinStair;

%for now, just display the simplest case where we have one acrossStaircase var and one withinStaircase var. 
acrossName_str = '';
acrossVals_str = '';
withinName_str = '';
withinVals_str = '';

str_Rule = 'Single-Rule';
i=strmatch('STAIRCASE_START_VAL',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    if length(data.configinfo(i).parameters) > 1
        str_Rule = 'Multi-Rule';
    end
end

if ~isempty(acrossStair)
    set(findobj(staircasefig,'Tag','StaircaseTypeText'),'String',['Multi-Staircase,' str_Rule]);
    acrossName_str = acrossStair.name;
    if isfield(acrossStair.parameters, 'moog')
        acrossVals_str = num2str((acrossStair.parameters.moog)');
    else
        acrossVals_str = num2str((acrossStair.parameters)');
    end
end

if ~isempty(withinStair)
    withinName_str = withinStair.name;
    if isfield(withinStair.parameters, 'moog')
        withinVals_str = num2str((withinStair.parameters.moog)');
    else
        withinVals_str = num2str((withinStair.parameters)');
    end
    if isempty(acrossStair)
        set(findobj(staircasefig,'Tag','StaircaseTypeText'),'String',['Single-Staircase,' str_Rule]);
    end
end

set(findobj(staircasefig,'Tag','AcrossStairDisplayLabel'),'String',acrossName_str);
set(findobj(staircasefig,'Tag','AcrossStairDisplayList'),'String',acrossVals_str);
set(findobj(staircasefig,'Tag','WithinStairDisplayLabel'),'String',withinName_str);
set(findobj(staircasefig,'Tag','WithinStairDisplayList'),'String',withinVals_str);

staircaseMethod_str(1) = {'Custom Staircase'};
staircaseMethod_str(2) = {'Probability Staircase'};
staircaseMethod_str(3) = {'M-up N-down Staircase'};
staircaseMethod_str(4) = {'Probability Staircase with Flip'};
staircaseMethod_str(5) = {'M-up N-down Staircase with Flip'};



iStaircase = strmatch('STAIRCASE',{char(data.configinfo.name)},'exact');
iUp = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
iDown = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');
tmpVal = data.configinfo(iStaircase).parameters;

set(findobj(staircasefig,'Tag','StaircaseMethodPopupmenu'),'String',staircaseMethod_str);
set(findobj(staircasefig,'Tag','StaircaseMethodPopupmenu'),'Value',tmpVal+1);

if tmpVal == 0
    data.functions.Staircase = data.customStaircase;
    data.configinfo(iStaircase).nice_name = 'Staircase:Custom';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal == 1    
    data.functions.Staircase = 'chooseNextProb';
    data.configinfo(iStaircase).nice_name = 'Staircase:Probability';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal == 2
    data.functions.Staircase = 'chooseNextMupNdown';
    data.configinfo(iStaircase).nice_name = 'Staircase:M-up N-down';
    data.configinfo(iUp).nice_name = 'Staircase # UP';
    data.configinfo(iDown).nice_name = 'Staircase # DOWN'; 
elseif tmpVal == 3    
    data.functions.Staircase = 'chooseNextProb_flip';
    data.configinfo(iStaircase).nice_name = 'Staircase:Probability/flip';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal == 4
    data.functions.Staircase = 'chooseNextMupNdown_flip';
    data.configinfo(iStaircase).nice_name = 'Staircase:M-up N-down/flip';
    data.configinfo(iUp).nice_name = 'Staircase # UP';
    data.configinfo(iDown).nice_name = 'Staircase # DOWN'; 
end

setappdata(basicfig,'protinfo',data);

if ~isempty(acrossStair) && isempty(withinStair)
    message = 'You can not have Across Parameter without Within Parameter.';
    title = 'Warning Message';
    msgbox(message,title,'warn');
end


% --- Outputs from this function are returned to the command line.
function varargout = StaircaseWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close StaircaseWindow.
function StaircaseWindow_CloseRequestFcn(hObject, eventdata, handles)
global basicfig 

if ~isempty(findobj('Name', 'BasicInterface'))
    data = getappdata(basicfig,'protinfo');

    acrossStair = data.condvect.acrossStair;
    withinStair = data.condvect.withinStair;

    if ~isempty(acrossStair) || ~isempty(withinStair)
        message = 'You are in the staircase mode and can not close the Staircase Window. Change the parameter status to Static and Window will close automatically';
        title = 'Warning Message';
        msgbox(message,title,'warn');
    else
        delete(hObject);
    end
else
    delete(hObject);
end


% --- Executes on selection change in WithinStairDisplayList.
function WithinStairDisplayList_Callback(hObject, eventdata, handles)
% hObject    handle to WithinStairDisplayList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns WithinStairDisplayList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WithinStairDisplayList

global currObject

currObject = get(hObject,'Tag');


% --- Executes during object creation, after setting all properties.
function WithinStairDisplayList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WithinStairDisplayList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WithinStairDisplayLabel_Callback(hObject, eventdata, handles)
% hObject    handle to WithinStairDisplayLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WithinStairDisplayLabel as text
%        str2double(get(hObject,'String')) returns contents of WithinStairDisplayLabel as a double


% --- Executes during object creation, after setting all properties.
function WithinStairDisplayLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WithinStairDisplayLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AcrossStairDisplayList.
function AcrossStairDisplayList_Callback(hObject, eventdata, handles)
% hObject    handle to AcrossStairDisplayList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AcrossStairDisplayList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AcrossStairDisplayList

global currObject
currObject = get(hObject,'Tag');

% --- Executes during object creation, after setting all properties.
function AcrossStairDisplayList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcrossStairDisplayList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AcrossStairDisplayLabel_Callback(hObject, eventdata, handles)
% hObject    handle to AcrossStairDisplayLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AcrossStairDisplayLabel as text
%        str2double(get(hObject,'String')) returns contents of AcrossStairDisplayLabel as a double


% --- Executes during object creation, after setting all properties.
function AcrossStairDisplayLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AcrossStairDisplayLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddToStair.
function AddToStair_Callback(hObject, eventdata, handles)
% hObject    handle to AddToStair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig staircasefig currObject

data = getappdata(basicfig,'protinfo');
if strcmp(currObject, 'WithinStairDisplayList')
    tmpCondVect = data.condvect.withinStair;
else
    tmpCondVect = data.condvect.acrossStair;
end

if isempty(tmpCondVect)
    message = 'You can''t add a combination without an original combination.';
    title = 'Warning Message';
    msgbox(message,title,'warn');
elseif size(tmpCondVect,2)==1
    if isfield(tmpCondVect.parameters, 'moog')
        prompt = {[tmpCondVect.name '--Moog Data'],[tmpCondVect.name '--OpenGL Data']};
    else
        prompt = {tmpCondVect.name};
    end
    dlg_title ='Input... ';
    numlines = 1;
    defaultanswer={'',''};
    options.WindowStyle='normal';
    options.Resize='on';
    answer = inputdlg(prompt, dlg_title,numlines,defaultanswer, options);
    answer=str2num(char(answer));
    if ~isempty(answer)
        if ~isempty(strmatch(tmpCondVect.name, 'Heading Direction', 'exact')) ||...
           ~isempty(strmatch(tmpCondVect.name, 'Heading Direction 2nd Int', 'exact'))
            if answer(1)==0
                tmpCondVect.parameters.moog = sort([tmpCondVect.parameters.moog answer(1)]);
                tmpCondVect.parameters.openGL = sort([tmpCondVect.parameters.openGL answer(2)]);
            else
                tmpCondVect.parameters.moog = sort([tmpCondVect.parameters.moog answer(1) -answer(1)]);
                tmpCondVect.parameters.openGL = sort([tmpCondVect.parameters.openGL answer(2) answer(2)]);
            end
        else
            if isfield(tmpCondVect.parameters, 'moog')
                tmpCondVect.parameters.moog = sort([tmpCondVect.parameters.moog answer(1)]);
                tmpCondVect.parameters.openGL = sort([tmpCondVect.parameters.openGL answer(2)]);
            else
                tmpCondVect.parameters = sort([tmpCondVect.parameters (answer)'],2);
            end
        end
    end
    
    if strcmp(currObject, 'WithinStairDisplayList')
        data.condvect.withinStair = tmpCondVect;
    else
        data.condvect.acrossStair = tmpCondVect;
    end
    
    setappdata(basicfig,'protinfo',data);
    
    if isfield(tmpCondVect.parameters, 'moog')
        vector = (tmpCondVect.parameters.moog)';
    else
        vector = (tmpCondVect.parameters)';
    end
    
    spac = {};
    for i1 = 1:size(vector,1)
        spac{i1} = blanks(10); % 10 spaces
    end

    str = '';
    for cntr = 1:size(vector,2)
        str = [str num2str(vector(:,cntr)) char(spac)];
    end
        
    set(findobj(staircasefig,'Tag',currObject),'String',str);    
else
    %for now, do nothing here because we only have one across/withinStair para.
end




% --- Executes on button press in RemoveFromStair.
function RemoveFromStair_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveFromStair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig staircasefig currObject

data = getappdata(basicfig,'protinfo');

if strcmp(currObject, 'WithinStairDisplayList')
    tmpCondVect = data.condvect.withinStair;
else
    tmpCondVect = data.condvect.acrossStair;
end

if size(tmpCondVect,2)==1
    if isfield(tmpCondVect.parameters, 'moog')
        vector = (tmpCondVect.parameters.moog)';
        vectorGL = (tmpCondVect.parameters.openGL)';
    else
        vector = (tmpCondVect.parameters)';
        %-----avi:for Adam1_Delta sol protocol
        if(strcmp(data.configfile , '1Adam_Delta.mat'))
            duplicatedFlagVector = tmpCondVect.isParametersDuplicated;
        end
        %-----end
    end

    val = get(findobj(staircasefig,'Tag',currObject),'Value'); % Currently highlighted value in the display.
    temp = val >= size(vector,1);
    if size(vector,1) == 0
        set(findobj(staircasefig,'Tag',currObject),'Value',1);
    elseif temp(end)
        set(findobj(staircasefig,'Tag',currObject),'Value',min(val)-1);
    end

    if val <= size(vector,1)
        if isfield(tmpCondVect.parameters, 'moog')
            vector(val,:) = [];
            vectorGL(val,:) = [];
        else
            vector(val,:) = [];
            %-----avi:for Adam1_Delta sol protocol
            if(strcmp(data.configfile , '1Adam_Delta.mat'))
                duplicatedFlagVector(val) = [];
            end
            %-----end
        end

        spac = {};
        for i1 = 1:size(vector,1)
            spac{i1} = blanks(10); % 10 spaces
        end

        str = '';
        for cntr = 1:size(vector,2)
            str = [str num2str(vector(:,cntr)) char(spac)];
        end

        set(findobj(staircasefig,'Tag',currObject),'String',str)
    else
        disp('Selected value is out of range.');
    end
    
    if isfield(tmpCondVect.parameters, 'moog')
        tmpCondVect.parameters.moog = vector';
        tmpCondVect.parameters.openGL = vectorGL';
    else
        tmpCondVect.parameters = vector';
        %-----avi:for Adam1_Delta sol protocol
        tmpCondVect.isParametersDuplicated = duplicatedFlagVector;
        %-----end
    end

    if strcmp(currObject, 'WithinStairDisplayList')
        data.condvect.withinStair = tmpCondVect;
    else
        data.condvect.acrossStair = tmpCondVect;
    end
    
    setappdata(basicfig,'protinfo',data);

    if min(val)==1
        set(findobj(staircasefig,'Tag',currObject),'Value',1);
    else
        set(findobj(staircasefig,'Tag',currObject),'Value',min(val)-1);
    end

else
    %for now, do nothing here because we only have one across/withinStair para.
end


function StaircaseMethodPopupmenu_Callback(hObject, eventdata, handles)
global basicfig staircasefig

data = getappdata(basicfig,'protinfo');

tmpVal = get(findobj(staircasefig,'Tag','StaircaseMethodPopupmenu'),'Value');
iStaircase = strmatch('STAIRCASE',{char(data.configinfo.name)},'exact');
iUp = strmatch('STAIR_UP_PCT',{char(data.configinfo.name)},'exact');
iDown = strmatch('STAIR_DOWN_PCT',{char(data.configinfo.name)},'exact');

if tmpVal == 1
    data.functions.Staircase = data.customStaircase;
    data.configinfo(iStaircase).parameters = 0;
    data.configinfo(iStaircase).nice_name = 'Staircase:Custom';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal ==2    
    data.functions.Staircase = 'chooseNextProb';
    data.configinfo(iStaircase).parameters = 1;
    data.configinfo(iStaircase).nice_name = 'Staircase:Probability';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal ==3
    data.functions.Staircase = 'chooseNextMupNdown';
    data.configinfo(iStaircase).parameters = 2;
    data.configinfo(iStaircase).nice_name = 'Staircase:M-up N-down';
    data.configinfo(iUp).nice_name = 'Staircase # UP';
    data.configinfo(iDown).nice_name = 'Staircase # DOWN';     
elseif tmpVal == 4    
    data.functions.Staircase = 'chooseNextProb_flip';
    data.configinfo(iStaircase).parameters = 3;
    data.configinfo(iStaircase).nice_name = 'Staircase:Probability/flip';
    data.configinfo(iUp).nice_name = 'Staircase % Harder';
    data.configinfo(iDown).nice_name = 'Staircase % Easier';
elseif tmpVal == 5
    data.functions.Staircase = 'chooseNextMupNdown_flip';
    data.configinfo(iStaircase).parameters = 4;
    data.configinfo(iStaircase).nice_name = 'Staircase:M-up N-down/flip';
    data.configinfo(iUp).nice_name = 'Staircase # UP';
    data.configinfo(iDown).nice_name = 'Staircase # DOWN'; 
end
setappdata(basicfig,'protinfo',data);
    


