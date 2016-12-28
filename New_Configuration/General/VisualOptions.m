function varargout = VisualOptions(varargin)
% VISUALOPTIONS M-file for VisualOptions.fig
%      VISUALOPTIONS, by itself, creates a new VISUALOPTIONS or raises the existing
%      singleton*.
%
%      H = VISUALOPTIONS returns the handle to a new VISUALOPTIONS or the handle to
%      the existing singleton*.
%
%      VISUALOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALOPTIONS.M with the given input arguments.
%
%      VISUALOPTIONS('Property','Value',...) creates a new VISUALOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VisualOptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VisualOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VisualOptions

% Last Modified by GUIDE v2.5 22-Dec-2006 15:19:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VisualOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @VisualOptions_OutputFcn, ...
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


% --- Executes just before VisualOptions is made visible.
function VisualOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VisualOptions (see VARARGIN)

% Choose default command line output for VisualOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VisualOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

optionOpening(hObject, 32);

% --- Executes when figure1 is resized.
function VisualOptions_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

optionResize(hObject, 32);



% --- Outputs from this function are returned to the command line.
function varargout = VisualOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function VisualOptions_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);


