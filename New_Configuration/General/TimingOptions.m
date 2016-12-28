function varargout = TimingOptions(varargin)
% TIMINGOPTIONS M-file for TimingOptions.fig
%      TIMINGOPTIONS, by itself, creates a new TIMINGOPTIONS or raises the existing
%      singleton*.
%
%      H = TIMINGOPTIONS returns the handle to a new TIMINGOPTIONS or the handle to
%      the existing singleton*.
%
%      TIMINGOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMINGOPTIONS.M with the given input arguments.
%
%      TIMINGOPTIONS('Property','Value',...) creates a new TIMINGOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TimingOptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TimingOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TimingOptions

% Last Modified by GUIDE v2.5 22-Dec-2006 15:50:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TimingOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @TimingOptions_OutputFcn, ...
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


% --- Executes just before TimingOptions is made visible.
function TimingOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TimingOptions (see VARARGIN)

% Choose default command line output for TimingOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TimingOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

optionOpening(hObject,256);

% --- Executes when figure1 is resized.
%----added by jing for resizing WIN--
function TimingOptions_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

optionResize(hObject,256);

% --- Outputs from this function are returned to the command line.
function varargout = TimingOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function TimingOptions_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%global basicfig basicdispfig

% BasicInterface('updatewindow',basicdispfig,[],guidata(basicdispfig));
%data = getappdata(basicfig,'protinfo');
%data.visible = [];
%setappdata(basicfig,'protinfo',data);
delete(hObject);



















