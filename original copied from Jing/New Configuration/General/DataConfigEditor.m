function varargout = DataConfigEditor(varargin)
% DATACONFIGEDITOR M-file for DataConfigEditor.fig
%      DATACONFIGEDITOR, by itself, creates a new DATACONFIGEDITOR or
%      raises the existing
%      singleton*.
%
%      H = DATACONFIGEDITOR returns the handle to a new DATACONFIGEDITOR or the handle to
%      the existing singleton*.
%
%      DATACONFIGEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATACONFIGEDITOR.M with the given input arguments.
%
%      DATACONFIGEDITOR('Property','Value',...) creates a new DATACONFIGEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataConfigEditor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataConfigEditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataConfigEditor

% Last Modified by GUIDE v2.5 09-Apr-2008 14:59:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataConfigEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @DataConfigEditor_OutputFcn, ...
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

% +++++++++++++++Begin Functions that need no editing++++++++++++++++++++++
function varargout = DataConfigEditor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function ChannelListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ActiveListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ChanTitleText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ScaleText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UnitsText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OffsetText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DescriptionText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ChanNumText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function CouplingText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to couplingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% +++++++++++++++++End Functions that need no editing++++++++++++++++++++++

% --- Executes just before DataConfigEditor is made visible.
function DataConfigEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataConfigEditor (see VARARGIN)

% Choose default command line output for DataConfigEditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataConfigEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global config datafig

datafig = hObject;

all = {config.channels.name};
set(findobj(datafig,'Tag','ChannelListBox'),'String',all);

updateChannels(hObject, eventdata, handles)



% --- Executes on selection change in ChannelListBox.
function ChannelListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ChannelListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChannelListBox





% --- Executes on selection change in ActiveListBox.
function ActiveListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ActiveListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----Jing modified 03/28/08-----
% global config datafig
% 
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% set(findobj(datafig,'Tag','ChanTitleText'),'String',config.channels(i).name);
% set(findobj(datafig,'Tag','ScaleText'),'String',num2str(config.channels(i).scale));
% set(findobj(datafig,'Tag','UnitsText'),'String',config.channels(i).units);
% set(findobj(datafig,'Tag','OffsetText'),'String',num2str(config.channels(i).offset));
% set(findobj(datafig,'Tag','TimeText'),'String',num2str(config.channels(i).timeWindow));
% set(findobj(datafig,'Tag','DescriptionText'),'String',config.channels(i).description);

updateChannels(hObject, eventdata, handles)
%----end 03/28/08

function ChanNumText_Callback(hObject, eventdata, handles)
% hObject    handle to ChanNumText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChanNumText as text
%        str2double(get(hObject,'String')) returns contents of ChanNumText as a double


function ChanTitleText_Callback(hObject, eventdata, handles)
% hObject    handle to ChanTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config editIndex %datafig

%----Jing modified 03/28/08-----
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% config.channels(i).name = get(hObject,'String');
config.channels(editIndex).title = get(hObject,'String');
%----end 03/28/08-----


function ScaleText_Callback(hObject, eventdata, handles)
% hObject    handle to ScaleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config editIndex %datafig

%----Jing modified 03/28/08-----
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% config.channels(i).scale = str2num(get(hObject,'String'));

config.channels(editIndex).scale = str2num(get(hObject,'String'));
%----end 03/28/08-----


function UnitsText_Callback(hObject, eventdata, handles)
% hObject    handle to UnitsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config editIndex %datafig

%----Jing modified 03/28/08-----
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% config.channels(i).units = get(hObject,'String');

config.channels(editIndex).units = get(hObject,'String');
%----end 03/28/08-----




function OffsetText_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config editIndex %datafig

%----Jing modified 03/28/08-----
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% config.channels(i).offset = str2num(get(hObject,'String'));
config.channels(editIndex).offset = str2num(get(hObject,'String'));
%----end 03/28/08-----


% function TimeText_Callback(hObject, eventdata, handles)
% % hObject    handle to TimeText (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% global config editIndex %datafig
% 
% %----Jing modified 03/28/08-----
% % val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% % str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% % name = str(val);
% % 
% % i = strmatch(name, {char(config.channels.name)}, 'exact');
% % config.channels(i).timeWindow = str2num(get(hObject,'String'));
% config.channels(editIndex).timeWindow = str2num(get(hObject,'String'));
% %----end 03/28/08-----


function DescriptionText_Callback(hObject, eventdata, handles)
% hObject    handle to DescriptionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config editIndex %datafig

%----Jing modified 03/28/08-----
% val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
% str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
% name = str(val);
% 
% i = strmatch(name, {char(config.channels.name)}, 'exact');
% config.channels(i).description = get(hObject,'String');
config.channels(editIndex).description = get(hObject,'String');
%----end 03/28/08-----


function CouplingText_Callback(hObject, eventdata, handles)
% hObject    handle to couplingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of couplingText as text
%        str2double(get(hObject,'String')) returns contents of couplingText as a double
global config editIndex

config.channels(editIndex).coupling = get(hObject,'String');



% --- Executes on button press in ActivateButton.
function ActivateButton_Callback(hObject, eventdata, handles)
% hObject    handle to ActivateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config datafig

val = get(findobj(datafig,'Tag','ChannelListBox'),'Value');
str = get(findobj(datafig,'Tag','ChannelListBox'),'String');
name = str(val);

%---added by jing for mutiple active selection 03/28/08---
for i1=1:size(name,1)
    i = strmatch(name(i1), {char(config.channels.name)}, 'exact');
    config.channels(i).active = 1;
end

if val(end) < length(str)
    set(findobj(datafig,'Tag','ChannelListBox'),'Value',val(end)+1);
else
    set(findobj(datafig,'Tag','ChannelListBox'),'Value',val(end));
end
%----end 03/28/08---


% i = strmatch(name, {char(config.channels.name)}, 'exact');
%config.channels(val).active = 1;

updateChannels(hObject, eventdata, handles);



% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config datafig

val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
name = str(val);

%---added by jing for mutiple remove selection 03/28/08------
for i1=1:size(name,1)
    i = strmatch(name(i1), {char(config.channels.name)}, 'exact');
    config.channels(i).active = 0;
end
 
set(findobj(datafig,'Tag','ActiveListBox'),'Value',1);
%----end 03/28/08---

%i = strmatch(name, {char(config.channels.name)}, 'exact');
%config.channels(i).active = 0;

updateChannels(hObject, eventdata, handles)


% --- Executes on button press in ReturnButton.
function ReturnButton_Callback(hObject, eventdata, handles)
% hObject    handle to ReturnButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global datafig

close(datafig)


% --- Internal Function to update the display of listBoxes.
function updateChannels(hObject, eventdata, handles)

global config datafig editIndex

active = {config.channels(cell2mat({config.channels.active})==1).name};
val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
len = size(active,2);
if len == 0 
    set(findobj(datafig,'Tag','ActiveListBox'),'Value',1);
elseif val > len
    set(findobj(datafig,'Tag','ActiveListBox'),'Value',val-1);
end


if ~isempty(active)
    set(findobj(datafig,'Tag','ActiveListBox'),'String',active);
    val = get(findobj(datafig,'Tag','ActiveListBox'),'Value');
    str = get(findobj(datafig,'Tag','ActiveListBox'),'String');
    name = str(val);

    %---From here Jing modified a lot 03/28/08
    if size(name,1)>1
        set(findobj(datafig,'Tag','ChanNumText'),'Enable','off');
        set(findobj(datafig,'Tag','ChanTitleText'),'Enable','off');
        set(findobj(datafig,'Tag','ScaleText'),'Enable','off');
        set(findobj(datafig,'Tag','UnitsText'),'Enable','off');
        set(findobj(datafig,'Tag','OffsetText'),'Enable','off');
        set(findobj(datafig,'Tag','DescriptionText'),'Enable','off');
        set(findobj(datafig,'Tag','CouplingText'),'Enable','off');
    else
        editIndex = strmatch(name, {char(config.channels.name)}, 'exact'); 
        i = editIndex;
        set(findobj(datafig,'Tag','ChanNumText'),'String',config.channels(i).chanNum,'Enable','off');
        set(findobj(datafig,'Tag','ChanTitleText'),'String',config.channels(i).title,'Enable','off');
        set(findobj(datafig,'Tag','ScaleText'),'String',num2str(config.channels(i).scale),'Enable','off');
        set(findobj(datafig,'Tag','UnitsText'),'String',config.channels(i).units,'Enable','off');
        set(findobj(datafig,'Tag','OffsetText'),'String',num2str(config.channels(i).offset),'Enable','off');
        set(findobj(datafig,'Tag','DescriptionText'),'String',config.channels(i).description,'Enable','off');
        set(findobj(datafig,'Tag','CouplingText'),'String',config.channels(i).coupling,'Enable','off');
    end
else
    set(findobj(datafig,'Tag','ActiveListBox'),'String','');
    set(findobj(datafig,'Tag','ChanNumText'),'String','');
    set(findobj(datafig,'Tag','ChanTitleText'),'String','');
    set(findobj(datafig,'Tag','ScaleText'),'String','');
    set(findobj(datafig,'Tag','UnitsText'),'String','');
    set(findobj(datafig,'Tag','OffsetText'),'String','');
    set(findobj(datafig,'Tag','DescriptionText'),'String','');
    set(findobj(datafig,'Tag','CouplingText'),'String','');
end
set(findobj(datafig,'Tag','ChannelListBox'),'String',{config.channels.name});















