exitfunction varargout = BasicInterface(varargin)
% BASICINTERFACE M-file for BasicInterface.fig
%      BASICINTERFACE, by itself, creates a new BASICINTERFACE or raises
%      the existing
%      singleton*.
%
%      HReference = BASICINTERFACE returns the handle to a new BASICINTERFACE or the
%      handle to
%      the existing singleton*.
%
%      BASICINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the
%      local
%      function named CALLBACK in BASICINTERFACE.M with the given input
%      arguments.
%
%      BASICINTERFACE('Property','Value',...) creates a new BASICINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BasicInterface_OpeningFunction gets
%      called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BasicInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BasicInterface

% Last Modified by GUIDE v2.5 20-Apr-2009 11:11:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BasicInterface_OpeningFcn, ...
    'gui_OutputFcn',  @BasicInterface_OutputFcn, ...
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


% --- Executes just before BasicInterface is made visible.
function BasicInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BasicInterface (see VARARGIN)

% Choose default command line output for BasicInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BasicInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% initialize spacing on figure for future placement

global basicfig connected paths PLOTS debug %pogen_oddity
global in 
basicfig = hObject;

%flag data structure 
flagdata.isEyeTracking = 0;
flagdata.isTrialStart = 0;
flagdata.isTrialStop = 0;
flagdata.isSubControl = 0;
setappdata(basicfig,'flagdata',flagdata);

% Global flags
in = '';   %---Jing added for debug window getting response.03/11/08
debug = 0; % 1 for debug mode
connected = 1; % 1 for connected to Moog Computer

MOOGDOTS_COMM = 0;
PLOTS = 0;


if debug == 1
    display('****************DEBUG MODE*********************')
end


% Set Initial Visibilities
set(findobj(basicfig,'Tag','LoadSaveSubject'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','SubjectNumber'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','TwoIntButton'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','VisualOptionsButton'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','GeneralOptionsButton'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','NoiseOptionsButton'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','MotionOptionsButton'),'Visible','off','Enable','off');
set(findobj(basicfig,'Tag','TimingOptionsButton'),'Visible','off','Enable','off');
%==== Jimmy Added 2/28/2008 ======%
set(findobj(basicfig,'Tag','ModeOptionsButton'),'Visible','off','Enable','off');
%==== End =====%


xy.c0 = 5;
xy.c1 = 150;
xy.c2 = 240;
xy.c3 = 310;
xy.c4 = 380;
xy.c5 = 450;
xy.c6 = 520;
xy.c7 = 590;
xy.c8 = 660;
xy.c9 = 730;
xy.c10 = 790;
xy.c11 = 850;
xy.c12 = 910;
xy.c13 = 970;
xy.c14 = 1030;
xy.c15 = 1090;

xy.r0 = 60;
xy.r1 = 700;
xy.r2 = 680;
xy.r3 = 640;
xy.r4 = 600;
xy.r5 = 560;
xy.r6 = 520;
xy.r7 = 480;
xy.r8 = 440;
xy.r9 = 400;
xy.r10 = 360;
xy.r11 = 320;
xy.r12 = 280;
xy.r13 = 240;
xy.r14 = 200;
xy.r15 = 160;
xy.r16 = 120;
xy.r17 = 80;
xy.r18 = 40;

xy.texth1 = 20;
xy.textw1 = 50;
xy.labelh1 = 15;
xy.labelw1 = 60;

xy.rowcntr = 1;
% End row, column defs

% Initial Paths and values
definePaths;
data = getappdata(basicfig,'protinfo');
data.configpath = paths.configpath;
data.datapath = paths.datapath;
data.datapath_primary = paths.datapath_primary; % this will be the final place that data lives -- Tunde 04/08/09
data.condvect.varying(false) = struct('name','','parameters',[]);
data.condvect.acrossStair(false) = struct('name','','parameters',[]);
data.condvect.withinStair(false) = struct('name','','parameters',[]);

data.randomseed = 13331;
data.reps = 1;

set(findobj(basicfig,'Tag','NumTrialsText'),'String','15');
set(findobj(basicfig,'Tag','TrialsToAddText'),'String','25');

data.correctWav = wavread('C:\WINDOWS\Media\tada.wav');
data.wrongWav = wavread('C:\WINDOWS\Media\Windows Battery Critical.wav');

setappdata(hObject,'protinfo',data);
setappdata(hObject,'rowscols',xy);

% Updating protocols available in PopupMenu
if isempty(get(findobj(basicfig,'Tag','ProtPopupMenu'),'String'))
    prots = getfiles(data.configpath);
    len = size(prots,2) - 4;
    prots = [prots; ['None' blanks(len)]];
    set(findobj(basicfig,'Tag','ProtPopupMenu'),'String',prots);
    set(findobj(basicfig,'Tag','ProtPopupMenu'),'Value',size(prots,1));
end


% Functions that must exist but will never be edited
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% --- Outputs from this function are returned to the command line.
function varargout = BasicInterface_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

function DisplayLabelText_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function DisplayLabelText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function RandomEditText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in DisplayListBox.
function DisplayListBox_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function DisplayListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function RepsText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ProtPopupMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumTrialsText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function TrialsToAddText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TrialsToAddText_Callback(hObject, eventdata, handles)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% --- Executes on selection change in ProtPopupMenu.
function ProtPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProtPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

cleanup
data = getappdata(basicfig,'protinfo');
protstr = get(hObject,'String');
protnum = get(hObject,'Value');
protocol = strtrim(protstr(protnum,:));

% Removing 'None' from string
wid = size(protstr,2) - 4;
if strmatch(protstr(end,:),['None' blanks(wid)],'exact')
    protstr = protstr(1:(size(protstr,1)-1),:);
    set(findobj(basicfig,'Tag','ProtPopupMenu'),'String',protstr)
end

% a = 1;
if isempty(strmatch(protocol,'None'))
    % Removing 'None' from string
    data.configfile = protocol;
    temp = importdata([data.configpath filesep data.configfile]);
    data.configinfo = temp.variables;
    data.channels = temp.channels;
    data.functions = temp.functions;
    data.customStaircase = data.functions.Staircase;   %for saving custom staircase function.Jing 12/01/08
    clear temp
    % taking out non-active params
    data.configinfo = data.configinfo(cell2mat({data.configinfo.active})==1);
    data.condvect = [];
    data.condvect.varying(false) = struct('name','','parameters',[]);
    data.condvect.acrossStair(false) = struct('name','','parameters',[]);
    data.condvect.withinStair(false) = struct('name','','parameters',[]);
    setappdata(basicfig,'protinfo',data);
    % Initializing Control Loop Parameters
    cldata.stage = 'InitializationStage';
    cldata.initStage = 1;
    cldata.mainStageTime = 2;
    setappdata(basicfig,'ControlLoopData',cldata);
    
    prot = get(hObject,'Value');
    if strcmp(protocol,'Translation.mat')
        prot = 'trans';
    elseif strcmp(protocol,'Direction Discrimination.mat')
        prot = 'trans';
    elseif strcmp(protocol,'Rotation.mat')
        prot = 'rot';
    elseif strcmp(protocol,'Sinusoidal.mat')
        prot = 'sin';
    elseif strcmp(protocol,'cirn.mat')
        prot = 'baili';
    elseif strcmp(protocol, '2I_Experiment.mat')
        prot = '2I';
    elseif strcmp(protocol, 'oddGaborTrans.mat')
        prot = 'GaborTrans';        
    elseif (strcmp(protocol, 'No_Protocol_specified') == 0 )
        prot = 'Undefined_Protocol';
    end
    setappdata(basicfig,'motiontype',prot);
    setappdata(basicfig,'protinfo', data);%---Jing added 03/27/08---

    %----Jing added for changing parameters while testing 01/29/07---
    trial.start = 0;
    setappdata(basicfig,'trialInfo',trial);
    %--- Jing end---

    % Updating window
    set(findobj(basicfig,'Tag','DisplayLabelText'),'String','')
    set(findobj(basicfig,'Tag','DisplayListBox'),'String','')
    set(findobj(basicfig,'Tag','LoadSaveSubject'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','SubjectNumber'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','TwoIntButton'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','VisualOptionsButton'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','GeneralOptionsButton'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','NoiseOptionsButton'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','MotionOptionsButton'),'Visible','on','Enable','on');
    set(findobj(basicfig,'Tag','TimingOptionsButton'),'Visible','on','Enable','on');
    %===== Jimmy Added 2/28/2008 ====%
    set(findobj(basicfig,'Tag','ModeOptionsButton'),'Visible','on','Enable','on');
    %===== End =====%
    set(findobj(basicfig,'Tag','RandomEditText'),'String',num2str(data.randomseed));
    set(findobj(basicfig,'Tag','RepsText'),'String',num2str(data.reps));

    placeObjectsBasic
else
    cleanup
end

% automatic_load_subject_context
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
global SUBJECT_NUM
subject_context_path = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Subject_Context\';
subject_num_length = length(num2str(SUBJECT_NUM));
if subject_num_length ~= 6
   FileName = '000000';
   FileName( ((6 - subject_num_length) + 1):end ) = num2str(SUBJECT_NUM);
   FileName = strcat('h', FileName, '.txt');
else
    FileName = strcat('h', num2str(SUBJECT_NUM), '.txt');
end

% [FileName, PathName] = uigetfile('*.txt','Select Subject file');
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

%global basicfig
% the following part is essentially kludged and can be done more elegantly
data = getappdata(basicfig, 'protinfo');
k = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(1).values;
k = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
data.configinfo(k).parameters = subject_params(2).values;

setappdata(basicfig,'protinfo',data);

% % % This displays the currently loaded subject in the loadsubject window
% global LoadSaveSubjectfig SUBJECT_NUM
% set(findobj(LoadSaveSubjectfig,'Tag','SubjectNumber'), 'string',['Subject:h' num2str(SUBJECT_NUM)]);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% LoadSaveSubject_Callback('automatic')

    
% --- Executes on button press in TwoIntButton.
function TwoIntButton_Callback(hObject, eventdata, handles)
% hObject    handle to TwoIntButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% NEEDS TO BE RE_PROGRAMED WITH UPDATED CONFIGFILE FORMAT

global basicfig
cleanup;

data = getappdata(basicfig,'protinfo');

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;

if motiontype == 1
    data.configinfo(i).parameters = 3;
    set(findobj(basicfig,'Tag','TwoIntButton'),'String','Two Interval');%---Jing added 01/16/07
    for i1 = 1:size(data.configinfo,2)
        if ~isempty(strfind(char(data.configinfo(i1).name),'_2I'))
            data.configinfo(i1).editable = 1;
        end
    end
elseif motiontype == 3
    data.configinfo(i).parameters = 1;
    set(findobj(basicfig,'Tag','TwoIntButton'),'String','One Interval');%---Jing added 01/16/07
    for i1 = 1:size(data.configinfo,2)
        if ~isempty(strfind(char(data.configinfo(i1).name),'_2I'))
            data.configinfo(i1).editable = 0;
            data.configinfo(i1).status = 1;%---Jing added for clearn up 2I cross var 03/30/07---------
        end
    end
end

setappdata(basicfig,'protinfo',data);
placeObjectsBasic;

% --- Executes on button press in VisualOptionsButton.
function VisualOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to VisualOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

VisualOptions

% --- Executes on button press in NoiseOptionsButton.
function NoiseOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to NoiseOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NoiseOptions

% --- Executes on button press in GeneralOptionsButton.
function GeneralOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GeneralOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GeneralOptions

% --- Executes on button press in MotionOptionsButton.
function MotionOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to MotionOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MotionOptions

% --- Executes on button press in TimingOptionsButton.
function TimingOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to TimingOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TimingOptions

% % --- Executes on button press in TimingOptionsButton.
% function LoadSaveSubject_Callback(hObject, eventdata, handles)
% % hObject    handle to TimingOptionsButton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% global SUBJECT_NUM
% 
% if nargin == 1
% %     LoadSaveSubject('automatic_load_subject_context')
% else
%     LoadSaveSubject    
% end
% 
% global basicfig
% set(findobj(basicfig,'Tag','SubjectNumber'), 'string',['Subject:h' num2str(SUBJECT_NUM)]);


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

clfunc = {@ControlLoop basicfig};
sbCallback = 'StartButtonCallbackFunc';

period = .001;
delete(timerfind('Tag','CLoop'));
CLoop = timer('TimerFcn',clfunc,'Period',period,'Tag','CLoop','ExecutionMode','fixedRate');
setappdata(basicfig,'Timer',CLoop);
eval([sbCallback '(hObject, eventdata, handles);']);


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig connected

flagdata = getappdata(basicfig,'flagdata');
CLoop = getappdata(basicfig,'Timer');
stop(CLoop)

flagdata.isTrialStop = 1;
flagdata.isTrialStart = 0;
flagdata.isStopButton = 1; %Jing 01/05/09---
setappdata(basicfig,'flagdata',flagdata);


%---Jing for light control. Turn off the light any way when hit stop button . 12/03/07---
if connected
    boardNum = 1;
    portNum = 1;
    direction = 1;
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
        disp(['WRONG cbDConfigPort ' str])
    end
    cbDOut(boardNum, portNum, 0);
end%---Jing end 12/03/07---



% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

data = getappdata(basicfig,'protinfo');

config = importdata([data.configpath filesep data.configfile]);
ind = find(cell2mat({config.variables.active}) == 1);
config.variables(ind) = data.configinfo;

[filename, pathname] = uiputfile('*.mat', 'Save New Config File',...
    [data.configpath filesep 'NewConfigFile_' date]);
if ~isequal(filename, 0) && ~isequal(pathname, 0)
    % Save out the variable data structure.
    save([pathname, filename], 'config');
    disp(['saving ' pathname filename])
end


%----Jing added this function for Edit Varying. 1/29/07-----
%----modified for combining multi-staircase 12/01/08.
function EditButton_Callback(hObject, eventdata, handles)
global basicfig

data = getappdata(basicfig,'protinfo');
tag = get(hObject,'Tag');
varname = strtok(tag,'-');

i = strmatch(varname, {char(data.configinfo.name)}, 'exact');
statusval = data.configinfo(i).status;
varnice_name = data.configinfo(i).nice_name;

if statusval==1
    message = 'The parameter''s status must be varying';
    title = 'Warning Message';
    msgbox(message,title,'warn');
else
    j = strmatch(varnice_name, {char(data.condvect.varying.name)}, 'exact');
    if isfield(data.configinfo(i).parameters, 'moog')
        prompt = {[varnice_name '--Moog Data'],[varnice_name '--OpenGL Data']};
    else
        prompt = {varnice_name};
    end
    dlg_title ='Input... ';
    numlines = 1;
    defaultanswer={'',''};
    options.WindowStyle='normal';
    options.Resize='on';
    answer = inputdlg(prompt, dlg_title,numlines,defaultanswer, options);
    answer=str2num(char(answer));
    if ~isempty(answer)
        if ~isempty(strmatch(varname, 'DISC_AMPLITUDES', 'exact')) ||...
           ~isempty(strmatch(varname, 'DISC_AMPLITUDES_2I', 'exact'))
            if answer(1)==0
                data.condvect.varying(j).parameters.moog = sort([data.condvect.varying(j).parameters.moog answer(1)]);
                data.condvect.varying(j).parameters.openGL = sort([data.condvect.varying(j).parameters.openGL answer(2)]);
            else
                data.condvect.varying(j).parameters.moog = sort([data.condvect.varying(j).parameters.moog answer(1) -answer(1)]);
                data.condvect.varying(j).parameters.openGL = sort([data.condvect.varying(j).parameters.openGL answer(2) answer(2)]);
            end
        else
            if isfield(data.condvect.varying(j).parameters, 'moog')
                data.condvect.varying(j).parameters.moog = sort([data.condvect.varying(j).parameters.moog answer(1)]);
                data.condvect.varying(j).parameters.openGL = sort([data.condvect.varying(j).parameters.openGL answer(2)]);
            else
                data.condvect.varying(j).parameters = sort([data.condvect.varying(j).parameters (answer)'],2);
            end
        end
    end

    setappdata(basicfig,'protinfo',data);
    GenCrossVals(basicfig,[],guidata(basicfig),'Insert',basicfig);
end


% --- Executes on button press in AddButton.
% ---Jing added this function for adding trial data combinations 1/23/07 and modified it 02/01/07--
% ---modified again  for combining multi-staircase 12/01/08.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

data = getappdata(basicfig,'protinfo');
yM = getappdata(basicfig,'CrossVals');
yGL = getappdata(basicfig,'CrossValsGL');

val = get(findobj(basicfig,'Tag','DisplayListBox'),'Value');

if isempty(data.condvect.varying)
    message = 'You can''t add a combination without an original combination.';
    title = 'Warning Message';
    msgbox(message,title,'warn');
elseif size(data.condvect.varying,2)==1 
    message = 'Use Edit Varying button.';
    title = 'Warning Message';
    msgbox(message,title,'warn');
else
    for i=1:size(data.condvect.varying,2)
        if isfield(data.condvect.varying(i).parameters, 'moog')
            prompt = {[data.condvect.varying(i).name '--Moog Data'],[data.condvect.varying(i).name '--OpenGL Data']};
        else
            prompt = {data.condvect.varying(i).name};
        end
        dlg_title ='Input... ';
        numlines = 1;
        defaultanswer={'',''};
        options.WindowStyle='normal';
        options.Resize='on';
        answer = inputdlg(prompt, dlg_title,numlines,defaultanswer, options);
        answer=str2num(char(answer));
        if ~isempty(answer)
            if isfield(data.condvect.varying(i).parameters, 'moog')
                yMtmp(:,i) = [yM((1:val),i)' answer(1) yM(((val+1):end),i)']';
                yGLtmp(:,i) = [yGL((1:val),i)' answer(2) yGL(((val+1):end),i)']';
            else
                yMtmp(:,i) = [yM((1:val),i)' answer(1) yM(((val+1):end),i)']';
                yGLtmp(:,i) = [yGL((1:val),i)' answer(1) yGL(((val+1):end),i)']';
            end
        else
            yMtmp(:,i) = [yM((1:val),i)' 0 yM(((val+1):end),i)']';
            yGLtmp(:,i) = [yGL((1:val),i)' 0 yGL(((val+1):end),i)']';
        end
    end

    spac = {};
    for i1 = 1:size(yMtmp,1)
        spac{i1} = blanks(10); % 10 spaces
    end

    str3 = '';
    for cntr = 1:size(yMtmp,2)
        str3 = [str3 num2str(yMtmp(:,cntr)) char(spac)];
    end

    set(findobj(basicfig,'Tag','DisplayListBox'),'String',str3)
    set(findobj(basicfig,'Tag','DisplayListBox'),'Value',val+1)

    setappdata(basicfig,'protinfo',data);
    setappdata(basicfig,'CrossVals',yMtmp);
    setappdata(basicfig,'CrossValsGL',yGLtmp);
end



% --- Executes on button press in RemoveButton.
function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

data = getappdata(basicfig,'protinfo');
yM = getappdata(basicfig,'CrossVals');
yGL = getappdata(basicfig,'CrossValsGL');


val = get(findobj(basicfig,'Tag','DisplayListBox'),'Value');
temp = val >= size(yM,1);
if size(yM,1) == 0
    set(findobj(basicfig,'Tag','DisplayListBox'),'Value',1);
elseif temp(end)
    set(findobj(basicfig,'Tag','DisplayListBox'),'Value',min(val)-1);
end


if val <= size(yM,1)
    yM(val,:) = [];
    yGL(val,:) = [];

    spac = {};
    for i1 = 1:size(yM,1)
        spac{i1} = blanks(10); % 10 spaces
    end

    str3 = '';
    for cntr = 1:size(yM,2)
        str3 = [str3 num2str(yM(:,cntr)) char(spac)];
    end

    set(findobj(basicfig,'Tag','DisplayListBox'),'String',str3)
else
    disp('Selected value is out of range.');
end

setappdata(basicfig,'CrossVals',yM);
setappdata(basicfig,'CrossValsGL',yGL);

%----If there is only one varying para, we also need to remove the value
%----from the condvect list.
if size(data.condvect.varying, 2) == 1
    if isfield(data.condvect.varying.parameters, 'moog')
        data.condvect.varying.parameters.moog(val) = [];
        data.condvect.varying.parameters.openGL(val) = [];
    else
        data.condvect.varying.parameters(val) = [];
    end
    setappdata(basicfig, 'protinfo', data);
end
        
%----Jing added 02/01/07----
if min(val)==1
    set(findobj(basicfig,'Tag','DisplayListBox'),'Value',1);
else
    set(findobj(basicfig,'Tag','DisplayListBox'),'Value',min(val)-1);
end



function RandomEditText_Callback(hObject, eventdata, handles)
% hObject    handle to RandomEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RandomEditText as text
%        str2double(get(hObject,'String')) returns contents of RandomEditText as a double

global basicfig

data = getappdata(basicfig,'protinfo');

data.randomseed = str2num(get(hObject,'String'));

setappdata(basicfig,'protinfo',data);


function RepsText_Callback(hObject, eventdata, handles)
% hObject    handle to RepsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RepsText as text
%        str2double(get(hObject,'String')) returns contents of RepsText as a double

global basicfig

data = getappdata(basicfig,'protinfo');
data.reps = str2num(get(hObject,'String'));
setappdata(basicfig,'protinfo',data);

% --- Executes on button press in AddTrialsButton.
function AddTrialsButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddTrialsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

trial = getappdata(basicfig,'trialInfo');
addTrials = str2num(get(findobj(basicfig,'Tag','TrialsToAddText'),'String'));
if isfield(trial,'num')
    trial.num = trial.num + addTrials;
    setappdata(basicfig,'trialInfo',trial);
    set(findobj(basicfig,'Tag','NumTrialsText'),'String',num2str(trial.num));
else
    curTrials = str2num(get(findobj(basicfig,'Tag','NumTrialsText'),'String'));
    set(findobj(basicfig,'Tag','NumTrialsText'),'String',num2str(curTrials + addTrials));
end



% --- Executes on button press in RemoveTrialsButton.
function RemoveTrialsButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveTrialsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

trial = getappdata(basicfig,'trialInfo');
addTrials = str2num(get(findobj(basicfig,'Tag','TrialsToAddText'),'String'));
if isfield(trial,'num')
    trial.num = trial.num - addTrials;
    setappdata(basicfig,'trialInfo',trial);
    set(findobj(basicfig,'Tag','NumTrialsText'),'String',num2str(trial.num));
else
    curTrials = str2num(get(findobj(basicfig,'Tag','NumTrialsText'),'String'));
    set(findobj(basicfig,'Tag','NumTrialsText'),'String',num2str(curTrials - addTrials));
end

function NumTrialsText_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrialsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global basicfig

data = getappdata(basicfig,'protinfo');

% makesure variable controls on front panel reflect the status of the
% configuration file.
function updatewindow(hObject, eventdata, handles, tag)
global basicfig 

data = getappdata(basicfig,'protinfo');
set(findobj(basicfig,'Tag','DisplayListBox'),'Value',1);

data.visible = [];

for i = (find(cell2mat({data.configinfo.editable})==1))
    i1 = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i1).parameters == 1 % should be 1 interval
        if isfield(data.configinfo(i).parameters,'moog')
            if length(data.configinfo(i).parameters.moog) >= 3
                inds = 1:3;
            else
                inds = 1;
            end
        else
            if length(data.configinfo(i).parameters) >= 2
                inds = 1:length(data.configinfo(i).parameters);
            else
                inds = 1;
            end
        end
    elseif data.configinfo(i1).parameters == 3 % should be 2 interval
        if isfield(data.configinfo(i).parameters,'moog')
            inds = 1:length(data.configinfo(i).parameters.moog);
        else
            inds = 1:length(data.configinfo(i).parameters);
        end
    end

    tagstr = data.configinfo(i).name;
    genval = data.configinfo(i).vectgen;
    statusval = data.configinfo(i).status;
    if isfield(data.configinfo(i).parameters,'moog')
        lowstr = [num2str(data.configinfo(i).low_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).low_bound.openGL(inds))];
        highstr = [num2str(data.configinfo(i).high_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).high_bound.openGL(inds))];
        incrstr = [num2str(data.configinfo(i).increment.moog(inds)) ,' ',...
            num2str(data.configinfo(i).increment.openGL(inds))];
        multstr = [num2str(data.configinfo(i).multiplier.moog(inds)) ,' ',...
            num2str(data.configinfo(i).multiplier.openGL(inds))];
        datastr = [num2str(data.configinfo(i).parameters.moog(inds)) ,' ',...
            num2str(data.configinfo(i).parameters.openGL(inds))];
    else
        lowstr = num2str(data.configinfo(i).low_bound(inds));
        highstr = num2str(data.configinfo(i).high_bound(inds));
        incrstr = num2str(data.configinfo(i).increment(inds));
        multstr = num2str(data.configinfo(i).multiplier(inds));
        datastr = num2str(data.configinfo(i).parameters(inds));
    end

    % Set all strings to values is config
    set(findobj(basicfig,'Tag',[tagstr '-DataText']),'String',datastr);
    set(findobj(basicfig,'Tag',[tagstr '-LowText']),'String',lowstr);
    set(findobj(basicfig,'Tag',[tagstr '-HighText']),'String',highstr);
    set(findobj(basicfig,'Tag',[tagstr '-MultText']),'String',multstr);
    set(findobj(basicfig,'Tag',[tagstr '-IncrText']),'String',incrstr);
    set(findobj(basicfig,'Tag',[tagstr '-SpacingPopupMenu']),'Value',genval+1);
    if statusval == 0
        a = findobj(basicfig,'Tag',[tagstr '-StatusPopupMenu']);
        pos = get(a,'Position');
        delete(a)
        tag = [tagstr '-StatusPopupMenu'];
        he = uicontrol(basicfig,'Style','text',...
            'Tag',tag,...
            'Position',pos,...
            'String','FIXED VALUE');
    else
        set(findobj(basicfig,'Tag',[tagstr '-StatusPopupMenu']),'Value',statusval);
    end

    % Disable all non relavent variable parameters
    if statusval <= 1 % Static or Fixed
        set(findobj(basicfig,'Tag',[tagstr '-LowText']),'Enable','off');
        set(findobj(basicfig,'Tag',[tagstr '-HighText']),'Enable','off');
        set(findobj(basicfig,'Tag',[tagstr '-MultText']),'Enable','off');
        set(findobj(basicfig,'Tag',[tagstr '-IncrText']),'Enable','off');
        set(findobj(basicfig,'Tag',[tagstr '-SpacingPopupMenu']),'Enable','off');
        set(findobj(basicfig,'Tag',[tagstr '-DataText']),'String',datastr);
    else % Varying
        set(findobj(basicfig,'Tag',[tagstr '-LowText']),'Enable','on');
        set(findobj(basicfig,'Tag',[tagstr '-HighText']),'Enable','on');
        set(findobj(basicfig,'Tag',[tagstr '-SpacingPopupMenu']),'Enable','on');
        set(findobj(basicfig,'Tag',[tagstr '-DataText']),'String',...
            [lowstr ':' incrstr ':' highstr]);
        if data.configinfo(i).vectgen == 0 % Linear Spacing
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','off');
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','on');
        elseif data.configinfo(i).vectgen == 1 % Log Spacing
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','on');
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','off');
        elseif data.configinfo(i).vectgen == 2 % Custom vectot generation
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','off');
            set(findobj(basicfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','off');
        else
            disp('Vector Generation parameter does not match any known format')
        end
    end
end
setappdata(basicfig,'protinfo',data);


% Places and names objects on front panel based on info in config file
function placeObjectsBasic(hObject, eventdata, handles)

global basicfig

data = getappdata(basicfig, 'protinfo');
xy = getappdata(basicfig,'rowscols');


ha = uicontrol(basicfig,'Style','text',...
    'Tag','LabelData',...
    'Position',[xy.c1 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Parameters');

hb = uicontrol(basicfig,'Style','text',...
    'Tag','LabelLow',...
    'Position',[xy.c2 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Low Bound');

hc = uicontrol(basicfig,'Style','text',...
    'Tag','LabelHigh',...
    'Position',[xy.c3 xy.r1 xy.labelw1 xy.labelh1],...
    'String','High Bound');

hd = uicontrol(basicfig,'Style','text',...
    'Tag','LabelIncr',...
    'Position',[xy.c4 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Increment');

he = uicontrol(basicfig,'Style','text',...
    'Tag','LabelMult',...
    'Position',[xy.c5 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Multiplier');

hf = uicontrol(basicfig,'Style','text',...
    'Tag','LabelSpacing',...
    'Position',[xy.c6 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Status');

hg = uicontrol(basicfig,'Style','text',...
    'Tag','LabelStatus',...
    'Position',[xy.c7 xy.r1 xy.labelw1 xy.labelh1],...
    'String','Spacing');

data.visible = [];
% start at 2 b/c 1st row is labels
for i = 1:size(data.configinfo,2)
    i1 = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i1).parameters == 1 % should be 1 interval
        if isfield(data.configinfo(i).parameters,'moog')
            if length(data.configinfo(i).parameters.moog) >= 3
                inds = 1:3;
            else
                inds = 1;
            end
        else
            if length(data.configinfo(i).parameters) >= 2
                inds = 1:length(data.configinfo(i).parameters);
            else
                inds = 1;
            end
        end
    elseif data.configinfo(i1).parameters == 3 % should be 2 interval
        if isfield(data.configinfo(i).parameters,'moog')
            inds = 1:length(data.configinfo(i).parameters.moog);
        else
            inds = 1:length(data.configinfo(i).parameters);
        end
    end

    rowstr = data.configinfo(i).nice_name;
    tagstr = data.configinfo(i).name;
    genval = data.configinfo(i).vectgen;
    statusval = data.configinfo(i).status;
    editval = data.configinfo(i).editable;
    tooltipstr = data.configinfo(i).tool_tip;
    if isfield(data.configinfo(i).parameters,'moog')
        lowstr = [num2str(data.configinfo(i).low_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).low_bound.openGL(inds))];
        highstr = [num2str(data.configinfo(i).high_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).high_bound.openGL(inds))];
        incrstr = [num2str(data.configinfo(i).increment.moog(inds)) ,' ',...
            num2str(data.configinfo(i).increment.openGL(inds))];
        multstr = [num2str(data.configinfo(i).multiplier.moog(inds)) ,' ',...
            num2str(data.configinfo(i).multiplier.openGL(inds))];
    else
        lowstr = num2str(data.configinfo(i).low_bound(inds));
        highstr = num2str(data.configinfo(i).high_bound(inds));
        incrstr = num2str(data.configinfo(i).increment(inds));
        multstr = num2str(data.configinfo(i).multiplier(inds));
    end

    if editval
        data.visible = [data.visible i];
        eval([ 'row = xy.r' num2str(xy.rowcntr+1) ';']);

        tag = [tagstr '-Label'];
        h0 = uicontrol(basicfig,'Style','text',...
            'Tag',tag,...
            'Position',[xy.c0 row 2.8*xy.textw1 xy.texth1],...
            'String',rowstr,...
            'HorizontalAlignment','left',...
            'ToolTipString',tooltipstr);

        tag = [tagstr '-DataText'];
        if statusval == 1 | statusval == 0
            if isfield(data.configinfo(i).parameters,'moog')
                indstr = num2str(data.configinfo(i).parameters.moog(inds));
            else
                indstr = num2str(data.configinfo(i).parameters(inds));
            end
        else
            indstr = [lowstr ':' incrstr ':' highstr];
        end
        he = uicontrol(basicfig,'Style','edit',...
            'Tag',tag,...
            'Position',[xy.c1 row 1.7*xy.textw1 xy.texth1],...
            'String',indstr,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);

        tag = [tagstr '-LowText'];
        ha = uicontrol(basicfig,'Style','edit',...
            'Tag',tag,...
            'Position',[xy.c2 row 1.3*xy.textw1 xy.texth1],...
            'String',lowstr,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);


        tag = [tagstr '-HighText'];
        hb = uicontrol(basicfig,'Style','edit',...
            'Tag',tag,...
            'Position',[xy.c3 row 1.3*xy.textw1 xy.texth1],...
            'String',highstr,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);


        tag = [tagstr '-IncrText'];
        hc = uicontrol(basicfig,'Style','edit',...
            'Tag',tag,...
            'Position',[xy.c4 row 1.3*xy.textw1 xy.texth1],...
            'String',incrstr,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);


        tag = [tagstr '-MultText'];
        hd = uicontrol(basicfig,'Style','edit',...
            'Tag',tag,...
            'Position',[xy.c5 row 1.3*xy.textw1 xy.texth1],...
            'String',multstr,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);


        if statusval == 0
            disp(['This variable ' rowstr ' has been choosen to be editable,'...
                ' but is a fixed value and should never be changed'])
            tag = [tagstr '-StatusPopupMenu'];
            he = uicontrol(basicfig,'Style','text',...
                'Tag',tag,...
                'Position',[xy.c6 row 1.3*xy.textw1 xy.texth1],...
                'String','FIXED VALUE',...
                'ToolTipString',tooltipstr);
            set(findobj(basicfig,'Tag',[tagstr '-DataText']),'Enable','Inactive');
        else
            tag = [tagstr '-StatusPopupMenu'];
            he = uicontrol(basicfig,'Style','popupmenu',...
                'Tag',tag,...
                'Position',[xy.c6 row 1.3*xy.textw1 xy.texth1],...
                'String',['Static     ';'Varying    ';'AcrossStair';'WithinStair'],...
                'Value',statusval,...
                'BackgroundColor','white',...
                'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
                'ToolTipString',tooltipstr);
        end


        tag = [tagstr '-SpacingPopupMenu'];
        hf = uicontrol(basicfig,'Style','popupmenu',...
            'Tag',tag,...
            'Position',[xy.c7 row 1.3*xy.textw1 xy.texth1],...
            'String',['Linear';'Log   ';'Custom'],...
            'HorizontalAlignment','left',...
            'Value',genval+1,...
            'BackgroundColor','white',...
            'Callback',['BasicInterface(''updateconfigBasic'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);

        %-----Jing added for 'Edit Varying' 01/28/07----
        tag = [tagstr '-EditVarying'];
        hev = uicontrol(basicfig,'Style','pushbutton',...
            'Tag',tag,...
            'Position',[xy.c8 row 1.3*xy.textw1 xy.texth1],...
            'String',['Edit Varying'],...
            'HorizontalAlignment','left',...
            'Callback',['BasicInterface(''EditButton_Callback'',gcbo,[],guidata(gcbo))'],...
            'ToolTipString',tooltipstr);

        xy.rowcntr = xy.rowcntr + 1;
    else
        % do not put any control for particular variable on screen
    end
end
xy.rowcntr = 1;
setappdata(basicfig,'protinfo',data);
GenCrossVals(basicfig,[],guidata(basicfig),'first',basicfig);
updatewindow(basicfig,[],guidata(basicfig));



% Callback for text and checkbox objects
% function updateconfig(tag)
function updateconfigBasic(hObject, eventdata, handles)
global basicfig

flagdata = getappdata(basicfig,'flagdata');
paused = get(findobj(basicfig,'Tag','PauseButton'),'Value');

if  ~paused && flagdata.isTrialStart
    message =[ 'You should pause the experiment first, ' sprintf('\n') 'and then change parameters'];
    title = 'Warning Message';
    msgbox(message,title,'warn');
else 
    data = getappdata(basicfig,'protinfo');
    tag = get(hObject,'Tag');

    varname = strtok(tag,'-');
    datapart = tag(strfind(tag,'-')+1:end);
    i = strmatch(varname, {char(data.configinfo.name)}, 'exact');

    i1 = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i1).parameters == 1 % should be 1 interval
        if isfield(data.configinfo(i).parameters,'moog')
            if length(data.configinfo(i).parameters.moog) >= 3
                inds = 1:3;
            else
                inds = 1;
            end
        else
            if length(data.configinfo(i).parameters) >= 2
                inds = 1:length(data.configinfo(i).parameters);
            else
                inds = 1;
            end
        end
    elseif data.configinfo(i1).parameters == 3 % should be 2 interval
        if isfield(data.configinfo(i).parameters,'moog')
            inds = 1:length(data.configinfo(i).parameters.moog);
        else
            inds = 1:length(data.configinfo(i).parameters);
        end
    end

    rowstr = data.configinfo(i).nice_name;
    tagstr = data.configinfo(i).name;
    genval = data.configinfo(i).vectgen;
    statusval = data.configinfo(i).status;
    editval = data.configinfo(i).editable;
    
    if strmatch(datapart, 'DataText', 'exact');
        val = str2num(get(findobj(basicfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if size(val,2)==2
                data.configinfo(i).parameters.moog(inds) = val(1);
                data.configinfo(i).parameters.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).parameters, 2);
            if size(val,2)==len         
                data.configinfo(i).parameters(inds)=val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'LowText', 'exact');
        val = str2num(get(findobj(basicfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if size(val,2)==2
                data.configinfo(i).low_bound.moog(inds) = val(1);
                data.configinfo(i).low_bound.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).low_bound,2);
            if size(val,2)==len
                data.configinfo(i).low_bound(inds)=val;
            else
                WarningTwo(len);
            end
        end

    elseif strmatch(datapart, 'HighText', 'exact');
        val = str2num(get(findobj(basicfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')        
            if size(val,2)==2
                data.configinfo(i).high_bound.moog(inds) = val(1);
                data.configinfo(i).high_bound.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).high_bound,2);
            if size(val,2)==len
                data.configinfo(i).high_bound(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'IncrText', 'exact');
        val = str2num(get(findobj(basicfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if size(val,2)==2
                data.configinfo(i).increment.moog(inds) = val(1);
                data.configinfo(i).increment.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).increment,2);
            if size(val,2)==len
                data.configinfo(i).increment(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'MultText', 'exact');
        val = str2num(get(findobj(basicfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if size(val,2)==2
                data.configinfo(i).multiplier.moog(inds) = val(1);
                data.configinfo(i).multiplier.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).multiplier,2);
            if size(val,2)==len
                data.configinfo(i).multiplier(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'SpacingPopupMenu', 'exact');
        data.configinfo(i).vectgen = get(findobj(basicfig,'Tag',tag),'Value') - 1;


    elseif strmatch(datapart, 'StatusPopupMenu', 'exact');
        statusval = get(findobj(basicfig,'Tag',tag),'Value');
        data.oriStatus = data.configinfo(i).status;   %Jing 12/01/08
        data.configinfo(i).status = statusval;

    else
        disp('Didn''t know what to do here')
    end

    setappdata(basicfig,'protinfo',data);

    % Runs GenCrossVals to update parameter list when anytime the status is
    % changed, or only it that particular var is status = varying. [Jimmy
    % Modified] Or when that particular var is status = acrossStair or
    % status = withinStair.
    if strmatch('StatusPopupMenu',datapart,'exact')
        GenCrossVals(hObject,gcbo,guidata(gcbo),tag,basicfig);
    else
        if statusval == 2 || statusval == 3 || statusval == 4
            % 1 - Static, 2 - Varying, 3 - AcrossStair, 4 - WithinStair
            GenCrossVals(hObject,gcbo,guidata(gcbo),tag,basicfig);
        end
    end
    updatewindow(basicfig,[],guidata(basicfig))
end

% Clears screen of objects placed by placeObjectsBasic
function cleanup(hObject, eventdata, handles)

global basicfig
data = getappdata(basicfig,'protinfo');

if isfield(data, 'configinfo') && isfield(data.configinfo, 'editable')
    for i = 1:size(data.configinfo,2)
        if data.configinfo(i).editable == 1
            tag = [data.configinfo(i).name '-DataText'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-LowText'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-HighText'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-IncrText'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-MultText'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-SpacingPopupMenu'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-StatusPopupMenu'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-Label'];
            delete(findobj(basicfig,'Tag',tag));
            tag = [data.configinfo(i).name '-EditVarying'];
            delete(findobj(basicfig,'Tag',tag));
        end
    end
else
    %     disp(['Either no Config File loaded or attempt to load old version',...
    %     ' of Config File']);
end

%---Jing added for clearn up 2I cross var 03/30/07---
% for i = 1:size(data.condvect,2)
%     data.condvect(i).name = '';
%     data.condvect(i).parameters = [];
% 
% end

%----End 03/30/07-----

setappdata(basicfig,'protinfo',data);


% Function to create condition list, based on varying variables in config
% file.====Jing changed the whole function for combining multi-staircase on 12/01/08 
function GenCrossVals(hObject, eventdata, handles, tag, fig)
global basicfig

GenCrossValsFunc(hObject, eventdata, handles, tag, fig);

%Updating control parameter in PopupMenu based on the varying 
data = getappdata(basicfig,'protinfo');
varying = data.condvect.varying;
within = data.condvect.withinStair;
across = data.condvect.acrossStair;

if ~isempty(within) || ~isempty(across)
    str ={'None'};
elseif ~isempty(varying)      
    for i=1:length(varying)
        str(i)={varying(i).name};
    end
else 
    ind=find(cell2mat({data.configinfo.editable}) == 1);
    for i = 1:length(ind)
        str(i)={data.configinfo(ind(i)).nice_name};
    end
end
set(findobj(basicfig,'Tag','controlParaPopupmenu'),'String',str);
set(findobj(basicfig,'Tag','controlParaPopupmenu'),'Value',1);

%----Jing added this function.01/28/07---
function WarningOne

message = 'You should input 2 values';
title = 'Warning Message';
msgbox(message,title,'warn');

%----Jing added this function.01/28/07---
function WarningTwo(str)

message = ['You should input ' num2str(str) ' values'];
title = 'Warning Message';
msgbox(message,title,'warn');


% --- Executes on button press in WindowOptionsButton.
% ---This is the new button for select different mode widow. Jing 03/06/08
function ModeOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ModeOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ModeOptions


% --- Executes on selection change in controlParaPopupmenu.
function controlParaPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to controlParaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns controlParaPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from controlParaPopupmenu


% --- Executes during object creation, after setting all properties.
function controlParaPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controlParaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function BasicInterface_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
close all;


% --- Executes on button press in eyeCalpushbutton.
function eyeCalpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to eyeCalpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global basicfig

EyeCalibration;
set(basicfig,'Visible','off');


