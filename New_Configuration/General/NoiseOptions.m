function varargout = NoiseOptions(varargin)
% NOISEOPTIONS M-file for NoiseOptions.fig
%      NOISEOPTIONS, by itself, creates a new NOISEOPTIONS or raises the existing
%      singleton*.
%
%      H = NOISEOPTIONS returns the handle to a new NOISEOPTIONS or the handle to
%      the existing singleton*.
%
%      NOISEOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOISEOPTIONS.M with the given input arguments.
%
%      NOISEOPTIONS('Property','Value',...) creates a new NOISEOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NoiseOptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NoiseOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NoiseOptions

% Last Modified by GUIDE v2.5 22-Dec-2006 09:43:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NoiseOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @NoiseOptions_OutputFcn, ...
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


% --- Executes just before NoiseOptions is made visible.
function NoiseOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NoiseOptions (see VARARGIN)

% Choose default command line output for NoiseOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NoiseOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

optionOpening(hObject, 64);

% --- Executes when figure1 is resized.
function NoiseOptions_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
optionResize(hObject, 64);

% --- Outputs from this function are returned to the command line.
function varargout = NoiseOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function NoiseOptions_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);








