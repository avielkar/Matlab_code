function varargout = GeneralOptions(varargin)
% GENERALOPTIONS M-file for GeneralOptions.fig
%      GENERALOPTIONS, by itself, creates a new GENERALOPTIONS or raises the existing
%      singleton*.
%
%      H = GENERALOPTIONS returns the handle to a new GENERALOPTIONS or the handle to
%      the existing singleton*.
%
%      GENERALOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the
%      local
%      function named CALLBACK in GENERALOPTIONS.M with the given input arguments.
%
%      GENERALOPTIONS('Property','Value',...) creates a new GENERALOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneralOptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneralOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeneralOptions

% Last Modified by GUIDE v2.5 22-Dec-2006 15:34:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeneralOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @GeneralOptions_OutputFcn, ...
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


% --- Executes just before GeneralOptions is made visible.
function GeneralOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeneralOptions (see VARARGIN)

% Choose default command line output for GeneralOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeneralOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

optionOpening(hObject,128);


% --- Executes when figure1 is resized.
% --- This function is added by jing
function GeneralOptions_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

optionResize(hObject,128);

% --- Outputs from this function are returned to the command line.
function varargout = GeneralOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function GeneralOptions_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);







