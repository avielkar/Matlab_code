function varargout = LoadSaveSubject(varargin)
% LOADSAVESUBJECT M-file for LoadSaveSubject.fig
%      LOADSAVESUBJECT, by itself, creates a new LOADSAVESUBJECT or raises the existing
%      singleton*.
%
%      H = LOADSAVESUBJECT returns the handle to a new LOADSAVESUBJECT or the handle to
%      the existing singleton*.
%
%      LOADSAVESUBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADSAVESUBJECT.M with the given input arguments.
%
%      LOADSAVESUBJECT('Property','Value',...) creates a new LOADSAVESUBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LoadSaveSubject_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LoadSaveSubject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LoadSaveSubject

% Last Modified by GUIDE v2.5 03-Sep-2007 17:31:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LoadSaveSubject_OpeningFcn, ...
                   'gui_OutputFcn',  @LoadSaveSubject_OutputFcn, ...
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


% --- Executes just before LoadSaveSubject is made visible.
function LoadSaveSubject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LoadSaveSubject (see VARARGIN)

% Choose default command line output for LoadSaveSubject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LoadSaveSubject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global LoadSaveSubjectfig
LoadSaveSubjectfig = hObject;



global SUBJECT_PARA_DIR SUBJECT_PARA_FILE SUBJECT_FILE SUBJECT_NUM basicfig


% global SUBJECT_PARA_FILE 
if length(varargin) == 1
    automatic_load_subject_context
%     disp('automatic') --- debugging
    
% disp(SUBJECT_PARA_DIR)
% disp(SUBJECT_PARA_FILE)
% disp(SUBJECT_FILE)
% disp(SUBJECT_NUM)
else
    LoadSubject_Callback
%     disp('manual') -------debugging
end





% --- Outputs from this function are returned to the command line.
function varargout = LoadSaveSubject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadSubject.
function LoadSubject_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% uiopen

[FileName, PathName] = uigetfile('*.txt','Select Subject file');
% loaded_subject_unformated = importdata(FileName);
fid = fopen(FileName);
loaded_subject_unformated = textscan(fid, '%s %f %f %f');
fclose(fid);
subject_params = [];
for i = 1:length(loaded_subject_unformated{1})
    subject_params(i).name = loaded_subject_unformated{1}{i,1};
        for j = 2:( length(loaded_subject_unformated)  )
            subject_params(i).values(j-1) = loaded_subject_unformated{j}(i, 1);
        end
end

global basicfig
% the following part is essentially kludged and can be done more elegantly
data = getappdata(basicfig, 'protinfo');
k = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(1).values;
k = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(2).values;

setappdata(basicfig,'protinfo',data);

% % This displays the currently loaded subject in the loadsubject window
global LoadSaveSubjectfig SUBJECT_NUM
set(findobj(LoadSaveSubjectfig,'Tag','SubjectNumber'), 'string',['Subject:h' num2str(SUBJECT_NUM)]);

% clear fid i j loaded_subject_unformated


% textread()
% textscan()

% --- Executes on button press in SaveSubject.
function SaveSubject_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% save

function automatic_load_subject_context(hobject, eventdata, handles)

global SUBJECT_PARA_DIR SUBJECT_PARA_FILE SUBJECT_FILE SUBJECT_NUM
global LoadSaveSubjectfig

fid = fopen(SUBJECT_PARA_FILE);
loaded_subject_unformated = textscan(fid, '%s %f %f %f');
fclose(fid);
subject_params = [];
for i = 1:length(loaded_subject_unformated{1})
    subject_params(i).name = loaded_subject_unformated{1}{i,1};
        for j = 2:( length(loaded_subject_unformated)  )
            subject_params(i).values(j-1) = loaded_subject_unformated{j}(i, 1);
        end
end

global basicfig
% the following part is essentially kludged and can be done more elegantly
data = getappdata(basicfig, 'protinfo');
k = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(1).values;
k = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(2).values;

setappdata(basicfig,'protinfo',data);



% disp(SUBJECT_PARA_DIR)
% disp(SUBJECT_PARA_FILE)
% disp(SUBJECT_FILE)
% disp(SUBJECT_NUM)

% attempting to close or hide loadsavesubject window without much success
% set(LoadSaveSubjectfig, 'HandleVisibility','off')
% LoadSaveSubject_CloseRequestFcn

% --- Executes when user attempts to close figure1.
function LoadSaveSubject_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% delete(hObject);
global LoadSaveSubjectfig
delete(LoadSaveSubjectfig);


