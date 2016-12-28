function varargout = CallBacks(varargin)
% CALLBACKS M-file for CallBacks.fig
%      CALLBACKS, by itself, creates a new CALLBACKS or raises the existing
%      singleton*.
%
%      H = CALLBACKS returns the handle to a new CALLBACKS or the handle to
%      the existing singleton*.
%
%      CALLBACKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALLBACKS.M with the given input arguments.
%
%      CALLBACKS('Property','Value',...) creates a new CALLBACKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CallBacks_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CallBacks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CallBacks

% Last Modified by GUIDE v2.5 18-Oct-2006 14:39:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CallBacks_OpeningFcn, ...
                   'gui_OutputFcn',  @CallBacks_OutputFcn, ...
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


% --- Executes just before CallBacks is made visible.
function CallBacks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CallBacks (see VARARGIN)

% Choose default command line output for CallBacks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CallBacks wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global CBfig
CBfig = hObject;

updateFigure(hObject, eventdata, handles)

% +++++++++++++++++++++++++++Functions Not needed+++++++++++++++++++++++++
% --- Outputs from this function are returned to the command line.
function varargout = CallBacks_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function CustomFuncsList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function FunctionText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% +++++++++++++++++++++++++++Functions Not needed+++++++++++++++++++++++++


% --- Executes on selection change in CustomFuncsList.
function CustomFuncsList_Callback(hObject, eventdata, handles)
% hObject    handle to CustomFuncsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CBfig config

updateFigure(hObject, eventdata, handles)



function FunctionText_Callback(hObject, eventdata, handles)
% hObject    handle to FunctionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CBfig config

cbval = get(findobj(CBfig,'Tag','CustomFuncsList'),'Value');
cbstr = get(findobj(CBfig,'Tag','CustomFuncsList'),'String');
cb = cbstr(cbval);

funcstr = get(findobj(CBfig,'Tag','FunctionText'),'String');

eval(['config.functions.' char(cb) ' = ''' funcstr ''';']);



% --- Executes on button press in AddFuncButton.
function AddFuncButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddFuncButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CBfig config



% --- Executes on button press in RemoveFuncButton.
function RemoveFuncButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveFuncButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CBfig config



% --- Executes on button press in ReturnButton.
function ReturnButton_Callback(hObject, eventdata, handles)
% hObject    handle to ReturnButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global CBfig config

close(CBfig)


function updateFigure(hObject, eventdata, handles)

global CBfig config

cbval = get(findobj(CBfig,'Tag','CustomFuncsList'),'Value');
cbstr = get(findobj(CBfig,'Tag','CustomFuncsList'),'String');
cb = cbstr(cbval);

funcstr = eval(['config.functions.' char(cb) ';']);
set(findobj(CBfig,'Tag','FunctionText'),'String',funcstr);



