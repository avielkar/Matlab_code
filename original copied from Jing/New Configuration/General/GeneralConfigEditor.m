function varargout = GeneralConfigEditor(varargin)
% GENERALCONFIGEDITOR M-file for GeneralConfigEditor.fig
%      GENERALCONFIGEDITOR, by itself, creates a new GENERALCONFIGEDITOR or raises the existing
%      singleton*.
%
%      H = GENERALCONFIGEDITOR returns the handle to a new GENERALCONFIGEDITOR or the handle to
%      the existing singleton*.
%
%      GENERALCONFIGEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERALCONFIGEDITOR.M with the given input arguments.
%
%      GENERALCONFIGEDITOR('Property','Value',...) creates a new GENERALCONFIGEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneralConfigEditor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneralConfigEditor_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeneralConfigEditor

% Last Modified by GUIDE v2.5 10-Aug-2006 16:38:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeneralConfigEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @GeneralConfigEditor_OutputFcn, ...
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

% ++++++++++++ Functions that need to exist but not be edited++++++++++++++
function varargout = GeneralConfigEditor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function AllParamsListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ActiveParamsListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DefValText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LowText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function HighText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function IncrText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MultText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VectGenPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StatusPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CatPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ToolTipText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NameText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DispNameText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VarCatPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OpenGLMultText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OpenGLIncrText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OpenGLHighText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OpenGLLowText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OpenGLValText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CatValText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CatIndText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AllParamsListBox_Callback(hObject, eventdata, handles)

function CatIndText_Callback(hObject, eventdata, handles)

function GenerateCBText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% +++++++++++++END Functions that need to exist but not be edited++++++++++



% --- Executes just before GeneralConfigEditor is made visible.
function GeneralConfigEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeneralConfigEditor (see VARARGIN)

% Choose default command line output for GeneralConfigEditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeneralConfigEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global fig config parampath protpath
fig = hObject;

% % parampath = 'Z:\Users\Dylan\TestSetup\HumanMoog\New Configuration\Parameters';
% % protpath = 'Z:\Users\Dylan\TestSetup\HumanMoog\New Configuration\Protocols';
% % 
% parampath = 'C:\human moog\New Configuration\Parameters';
% protpath = 'C:\human moog\New Configuration\Protocols';

parampath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Parameters';
protpath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Protocols';

load([parampath filesep 'CompleteConfig.mat']);


updateLists(hObject, eventdata, handles)



% --- Executes on selection change in ActiveParamsListBox.
function ActiveParamsListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ActiveParamsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ActiveParamsListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ActiveParamsListBox

global fig config

updateLists(hObject,eventdata, handles)



function DefValText_Callback(hObject, eventdata, handles)
% hObject    handle to DefValText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DefValText as text
%        str2double(get(hObject,'String')) returns contents of DefValText as a double

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if isfield(config.variables(i).parameters,'moog')
    config.variables(i).parameters.moog = str2num(get(hObject,'String'));
else
    config.variables(i).parameters = str2num(get(hObject,'String'));
end



function OpenGLValText_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGLValText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).parameters.openGL = str2num(get(hObject,'String'));


function LowText_Callback(hObject, eventdata, handles)
% hObject    handle to LowText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if isfield(config.variables(i).parameters,'moog')
    config.variables(i).low_bound.moog = str2num(get(hObject,'String'));
else
    config.variables(i).low_bound = str2num(get(hObject,'String'));
end



function OpenGLLowText_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGLLowText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).low_bound.openGL = str2num(get(hObject,'String'));


function HighText_Callback(hObject, eventdata, handles)
% hObject    handle to HighText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if isfield(config.variables(i).parameters,'moog')
    config.variables(i).high_bound.moog = str2num(get(hObject,'String'));
else
    config.variables(i).high_bound = str2num(get(hObject,'String'));
end



function OpenGLHighText_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGLHighText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).high_bound.openGL = str2num(get(hObject,'String'));


function IncrText_Callback(hObject, eventdata, handles)
% hObject    handle to IncrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if isfield(config.variables(i).parameters,'moog')
    config.variables(i).increment.moog = str2num(get(hObject,'String'));
else
    config.variables(i).increment = str2num(get(hObject,'String'));
end


function OpenGLIncrText_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGLIncrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).increment.openGL = str2num(get(hObject,'String'));


function MultText_Callback(hObject, eventdata, handles)
% hObject    handle to MultText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if isfield(config.variables(i).parameters,'moog')
    config.variables(i).multiplier.moog = str2num(get(hObject,'String'));
else
    config.variables(i).multiplier = str2num(get(hObject,'String'));
end


function OpenGLMultText_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGLMultText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).multiplier.openGL = str2num(get(hObject,'String'));


% --- Executes on selection change in VectGenPopupMenu.
function VectGenPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to VectGenPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).vectgen = get(hObject,'Value')-1;


function GenerateCBText_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateCBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).callback = get(hObject,'String');


% --- Executes on selection change in StatusPopupMenu.
function StatusPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to StatusPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).status = get(hObject,'Value')-1;


% --- Executes on selection change in CatPopupMenu.
function CatPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CatPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config

varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
varname = varstr(val);

catval = get(hObject,'Value');

i = strmatch(varname, {char(config.variables.name)}, 'exact');
if catval <= 9 
    config.variables(i).category = 2^(catval-1);
end


function CatValText_Callback(hObject, eventdata, handles)
% hObject    handle to CatValText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);

catval = str2num(get(hObject,'String'));

% i = strmatch(varname, {char(config.variables.name)}, 'exact');
if ~isempty(catval) & (catval <= 256)
    config.variables(i).category = catval;
else
    disp('Not elegible category number')
end


% --- Executes on button press in EditableCheckBox.
function EditableCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to EditableCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i 

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).editable = get(hObject,'Value');


function ToolTipText_Callback(hObject, eventdata, handles)
% hObject    handle to ToolTipText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i 

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).tool_tip = get(hObject,'String');


function NameText_Callback(hObject, eventdata, handles)
% hObject    handle to NameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i 

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).name = get(hObject,'String');


function DispNameText_Callback(hObject, eventdata, handles)
% hObject    handle to DispNameText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config i

% varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
% val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
% varname = varstr(val);
% 
% i = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i).nice_name = get(hObject,'String');


% --- Executes on button press in ActiveButton.
function ActiveButton_Callback(hObject, eventdata, handles)
% hObject    handle to ActiveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config

varstr = get(findobj(fig,'Tag','AllParamsListBox'),'String');
val = get(findobj(fig,'Tag','AllParamsListBox'),'Value');
varname = varstr(val);

%---added by jing for mutiple active selection---
for i1=1:size(varname,1)
    i = strmatch(varname(i1), {char(config.variables.name)}, 'exact');
    config.variables(i).active = 1;
end

set(findobj(fig,'Tag','AllParamsListBox'),'Value',val(end)+1);
%----end added----

%---old code by dylan---
%i = strmatch(varname, {char(config.variables.name)}, 'exact');
%config.variables(i).active = 1;

updateLists(hObject, eventdata, handles)


% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config %i 

%---added by jing for mutiple remove selection---
 varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
 val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
 varname = varstr(val);
 
 for i1=1:size(varname,1)
     i = strmatch(varname(i1), {char(config.variables.name)}, 'exact');
     config.variables(i).active = 0;
 end
 
 set(findobj(fig,'Tag','ActiveParamsListBox'),'Value',1);
%----end added----

%---old code by dylan---
% config.variables(i).active = 0;
 
updateLists(hObject, eventdata, handles)


% --- Executes on button press in AddButton.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config

prompt = {'Will this variable need separate Moog and OpenGL Values? [Y/N]'};
dlg_title = 'New Variable';
numlines = 1;
answer = inputdlg(prompt, dlg_title,numlines);
answer = upper(char(answer));

numvars = length(config.variables);
config.variables(numvars+1).name = ['NEW_VARIABLE_' num2str(numvars+1)];
config.variables(numvars+1).nice_name = ['New Variable ' num2str(numvars+1)];
if answer == 'N';
    config.variables(numvars+1).parameters = 0;
    config.variables(numvars+1).low_bound = 0;
    config.variables(numvars+1).high_bound = 1;
    config.variables(numvars+1).increment = 1;
    config.variables(numvars+1).multiplier = .5;
else answer == 'Y';
    config.variables(numvars+1).parameters.moog = 0;
    config.variables(numvars+1).parameters.openGL = 0;
    config.variables(numvars+1).low_bound.moog = 0;
    config.variables(numvars+1).low_bound.openGL = 0;
    config.variables(numvars+1).high_bound.moog = 1;
    config.variables(numvars+1).high_bound.openGL = 1;
    config.variables(numvars+1).increment.moog = 1;
    config.variables(numvars+1).increment.openGL = 1;
    config.variables(numvars+1).multiplier.moog = .5;
    config.variables(numvars+1).multiplier.openGL = .5;
end
config.variables(numvars+1).vectgen = 0;
config.variables(numvars+1).status = 1; 
config.variables(numvars+1).category = 2^(get(findobj(fig,'Tag','VarCatPopupMenu'),'Value')-1);
config.variables(numvars+1).callback = '';
config.variables(numvars+1).editable = 0;
config.variables(numvars+1).tool_tip = '';
config.variables(numvars+1).active = 1;

val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
str = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
len = length(str);

if val >= len
    set(findobj(fig,'Tag','ActiveParamsListBox'),'Value',len-1);
end

updateLists(hObject, eventdata, handles)


% --- Executes on button press in RemoveVar.
function RemoveVar_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config

varstr = get(findobj(fig,'Tag','AllParamsListBox'),'String');
val = get(findobj(fig,'Tag','AllParamsListBox'),'Value');
varname = varstr(val);

i2 = strmatch(varname, {char(config.variables.name)}, 'exact');
config.variables(i2) = [];

updateLists(hObject, eventdata, handles)


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config protpath parampath

[filename pathname] = uigetfile('.mat','Choose Protocol',[protpath filesep]);
if ~isequal(filename, 0) & ~isequal(pathname, 0)
    config = importdata([pathname filesep filename]);
else
    disp(['Load Failed'])
end

updateLists(hObject, eventdata, handles)

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config protpath parampath

% Order by category
[a, inds] = sort(cell2mat({config.variables.category}));
config.variables = config.variables(inds);

% Order Alphabetically in category
for q = 1:10
    cat = 2^(q-1);
    temp = find(cell2mat({config.variables.category}) == cat);
    if ~isempty(temp)
        [y inds] = sort({config.variables(temp).name});
        %inds + (temp(1)-1)
        config.variables(temp) = config.variables(inds+(temp(1)-1));
    end
end

[filename, pathname] = uiputfile('*.mat', 'Save New Config File',...
    [protpath filesep 'NewConfigFile_' date]);
if ~isequal(filename, 0) & ~isequal(pathname, 0)
    % Save out the variable data structure.
    save([pathname, filename], 'config');
    disp(['saving ' pathname filename])
end


% --- Executes on selection change in VarCatPopupMenu.
function VarCatPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to VarCatPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fig config

set(findobj(fig,'Tag','AllParamsListBox'),'Value',1);

updateLists(hObject, eventdata, handles)


% --- Executes on button press in DataChanButton.
function DataChanButton_Callback(hObject, eventdata, handles)
% hObject    handle to DataChanButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DataConfigEditor


% --- Executes on button press in CallbackButton.
function CallbackButton_Callback(hObject, eventdata, handles)
% hObject    handle to CallbackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CallBacks


function updateLists(hObject, eventdata, handles)

global fig config i

catval = get(findobj(fig,'Tag','VarCatPopupMenu'),'Value');

cntr1 = 1;
cntr2 = 1;
allDisp = {};
activeDisp = {};
for i = 1:size(config.variables,2)
    % sort and disp certain category
    cat = config.variables(i).category;
    if catval > 9
        if sum(bitget(cat,1:9)) > 1
            allDisp{cntr1}  = config.variables(i).name;
            cntr1 = cntr1 + 1;
        end
    else
        if bitget(cat,catval)
            allDisp{cntr1} = config.variables(i).name;
            cntr1 = cntr1 + 1;
        end
    end
    % display active variabls
    if config.variables(i).active
        activeDisp{cntr2} = config.variables(i).name;
        cntr2 = cntr2 + 1;
    end
end
val = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
len = length(activeDisp);
if val > len
    if len == 0
        val = 1;
    else
        set(findobj(fig,'Tag','ActiveParamsListBox'),'Value',len);
    end
end
val = get(findobj(fig,'Tag','AllParamsListBox'),'Value');
len = length(allDisp);
if val > len
    if len == 0
        val = 1;
    else
        set(findobj(fig,'Tag','AllParamsListBox'),'Value',len);
    end
end
set(findobj(fig,'Tag','AllParamsListBox'),'String',allDisp)
set(findobj(fig,'Tag','ActiveParamsListBox'),'String',activeDisp)

varval = get(findobj(fig,'Tag','ActiveParamsListBox'),'Value');
varstr = get(findobj(fig,'Tag','ActiveParamsListBox'),'String');
varname = varstr(varval);

%----added by jing------
if size(varname,1)>1
    set(findobj(fig,'Tag','NameText'),'Enable','off');
    set(findobj(fig,'Tag','DispNameText'),'Enable','off');
    
    set(findobj(fig,'Tag','DefValText'),'Enable','off');
    set(findobj(fig,'Tag','LowText'),'Enable','off');
    set(findobj(fig,'Tag','HighText'),'Enable','off');
    set(findobj(fig,'Tag','IncrText'),'Enable','off');
    set(findobj(fig,'Tag','MultText'),'Enable','off');
    set(findobj(fig,'Tag','OpenGLValText'),'Enable','off');
    set(findobj(fig,'Tag','OpenGLLowText'),'Enable','off');
    set(findobj(fig,'Tag','OpenGLHighText'),'Enable','off');
    set(findobj(fig,'Tag','OpenGLIncrText'),'Enable','off');
    set(findobj(fig,'Tag','OpenGLMultText'),'Enable','off');
    
    set(findobj(fig,'Tag','VectGenPopupMenu'),'Enable','off');
    set(findobj(fig,'Tag','GenerateCBText'),'Enable','off');
    set(findobj(fig,'Tag','StatusPopupMenu'),'Enable','off');
    set(findobj(fig,'Tag','ToolTipText'),'Enable','off');
    set(findobj(fig,'Tag','EditableCheckBox'),'Enable','off');
    
    set(findobj(fig,'Tag','CatPopupMenu'),'Enable','off');
    set(findobj(fig,'Tag','CatValText'),'Visible','off');
    set(findobj(fig,'Tag','CatValLabel'),'Visible','off');
    set(findobj(fig,'Tag','CatIndText'),'Visible','off');
%------end added-----
else %-----something is changed by jing from here---
  i = strmatch(varname, {char(config.variables.name)}, 'exact');

  set(findobj(fig,'Tag','NameText'),'String',config.variables(i).name,'Enable','on');
  set(findobj(fig,'Tag','DispNameText'),'String',config.variables(i).nice_name,'Enable','on');
  
  if isfield(config.variables(i).parameters,'moog')
     set(findobj(fig,'Tag','DefValText'),'String',num2str(config.variables(i).parameters.moog),'Enable','on');
     set(findobj(fig,'Tag','OpenGLValText'),'String',num2str(config.variables(i).parameters.openGL),'Enable','on');
     set(findobj(fig,'Tag','LowText'),'String',num2str(config.variables(i).low_bound.moog),'Enable','on');
     set(findobj(fig,'Tag','OpenGLLowText'),'String',num2str(config.variables(i).low_bound.openGL),'Enable','on');
     set(findobj(fig,'Tag','HighText'),'String',num2str(config.variables(i).high_bound.moog),'Enable','on');
     set(findobj(fig,'Tag','OpenGLHighText'),'String',num2str(config.variables(i).high_bound.openGL),'Enable','on');
     set(findobj(fig,'Tag','IncrText'),'String',num2str(config.variables(i).increment.moog),'Enable','on');
     set(findobj(fig,'Tag','OpenGLIncrText'),'String',num2str(config.variables(i).increment.openGL),'Enable','on');
     set(findobj(fig,'Tag','MultText'),'String',num2str(config.variables(i).multiplier.moog),'Enable','on');
     set(findobj(fig,'Tag','OpenGLMultText'),'String',num2str(config.variables(i).multiplier.openGL),'Enable','on');
  else
     set(findobj(fig,'Tag','DefValText'),'String',num2str(config.variables(i).parameters),'Enable','on');
     set(findobj(fig,'Tag','OpenGLValText'),'String','N/A','Enable','off');
     set(findobj(fig,'Tag','LowText'),'String',num2str(config.variables(i).low_bound),'Enable','on');
     set(findobj(fig,'Tag','OpenGLLowText'),'String','N/A','Enable','off');
     set(findobj(fig,'Tag','HighText'),'String',num2str(config.variables(i).high_bound),'Enable','on');
     set(findobj(fig,'Tag','OpenGLHighText'),'String','N/A','Enable','off');
     set(findobj(fig,'Tag','IncrText'),'String',num2str(config.variables(i).increment),'Enable','on');
     set(findobj(fig,'Tag','OpenGLIncrText'),'String','N/A','Enable','off');
     set(findobj(fig,'Tag','MultText'),'String',num2str(config.variables(i).multiplier),'Enable','on');
     set(findobj(fig,'Tag','OpenGLMultText'),'String','N/A','Enable','off');
  end
  set(findobj(fig,'Tag','VectGenPopupMenu'),'Value',config.variables(i).vectgen + 1,'Enable','on');   %+1 switches 0-2 to 1-3  
  set(findobj(fig,'Tag','GenerateCBText'),'String',config.variables(i).callback,'Enable','on');
  set(findobj(fig,'Tag','StatusPopupMenu'),'Value',config.variables(i).status + 1,'Enable','on');   %+1 switches 0-2 to 1-3
  set(findobj(fig,'Tag','ToolTipText'),'String',config.variables(i).tool_tip,'Enable','on');
  set(findobj(fig,'Tag','EditableCheckBox'),'Value',config.variables(i).editable,'Enable','on');
  if sum(bitget(config.variables(i).category,1:9)) > 1 || get(findobj(fig,'Tag','VarCatPopupMenu'),'Value') == 10 % custom category value
     set(findobj(fig,'Tag','CatValText'),'Visible','on','String',num2str(config.variables(i).category));
     set(findobj(fig,'Tag','CatValLabel'),'Visible','on');
     catstr = get(findobj(fig,'Tag','VarCatPopupMenu'),'String');
     inds = bitget(config.variables(i).category,1:9).*[1:9];
     inds = inds(inds~=0);
     catstr = catstr(inds,:);
     set(findobj(fig,'Tag','CatIndText'),'Visible','on','String',catstr);
     set(findobj(fig,'Tag','CatPopupMenu'),'Value',10,'Enable','on');
  else
     set(findobj(fig,'Tag','CatValText'),'Visible','off','String',num2str(config.variables(i).category));
     set(findobj(fig,'Tag','CatValLabel'),'Visible','off');
     set(findobj(fig,'Tag','CatIndText'),'Visible','off','String','');
     set(findobj(fig,'Tag','CatPopupMenu'),'Value',log2(config.variables(i).category)+1,'Enable','on');
  end


 % if isfield(config.variables(i).parameters,'moog')
 %    set(findobj(fig,'Tag','OpenGLValText'),'Enable','on')
 %    set(findobj(fig,'Tag','OpenGLLowText'),'Enable','on')
 %    set(findobj(fig,'Tag','OpenGLHighText'),'Enable','on')
 %    set(findobj(fig,'Tag','OpenGLIncrText'),'Enable','on')
 %    set(findobj(fig,'Tag','OpenGLMultText'),'Enable','on')
 % else
 %    set(findobj(fig,'Tag','OpenGLValText'),'Enable','off')
 %    set(findobj(fig,'Tag','OpenGLLowText'),'Enable','off')
 %    set(findobj(fig,'Tag','OpenGLHighText'),'Enable','off')
 %    set(findobj(fig,'Tag','OpenGLIncrText'),'Enable','off')
 %    set(findobj(fig,'Tag','OpenGLMultText'),'Enable','off')
 % end
end
































