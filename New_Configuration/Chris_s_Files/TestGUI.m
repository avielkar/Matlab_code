function varargout = TestGUI(varargin)
% TESTGUI M-file for TestGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestGUI

% Last Modified by GUIDE v2.5 11-Nov-2005 14:09:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TestGUI_OutputFcn, ...
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


% --- Executes just before TestGUI is made visible.
function TestGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestGUI (see VARARGIN)

% Choose default command line output for TestGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TestGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global DataObj;
global DataObj DataTimer;

% Defines from cbw.h
DataObj.BIP10VOLTS = 1;
DataObj.AIFUNCTION = 1;

DataObj.bufferSize = 512*12;
DataObj.sampleRate = str2num(get(handles.edit1, 'String'))
DataObj.boardNum = 1;
DataObj.chans = [str2num(get(handles.LowChanEdit, 'String')), str2num(get(handles.HighChanEdit, 'String'))];
DataObj.previousCount = 0;
DataObj.previousIndex = 0;
DataObj.data = [];
DataObj.plotHandle(1) = handles.axes1;
DataObj.plotHandle(2) = handles.axes2;
DataObj.plotHandle(3) = handles.axes3;
DataObj.plotHandle(4) = handles.axes4;
DataObj.plotHandle(5) = handles.axes5;
DataObj.plotHandle(6) = handles.axes6;
DataObj.memHandle = cbWinBufAlloc(DataObj.bufferSize);

DataObj.currun = 0;

% Start the backbround sweep.
cbAInBackgroundScan(DataObj.boardNum, DataObj.chans, DataObj.bufferSize,...
                    DataObj.sampleRate, DataObj.BIP10VOLTS, DataObj.memHandle);
                
% Start the timer to collect data in the background.
%pause(0.75);
start(DataTimer)


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataObj DataTimer;

cbStopBackground(DataObj.boardNum, DataObj.AIFUNCTION);
cbWinBufFree(DataObj.memHandle);

% Stop the timer.
stop(DataTimer)

% if ~isempty(DataObj.data)
%     plot(handles.axes1, DataObj.data);
% end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global DataTimer;

% Get rid of old timers laying around.
delete(timerfind('Tag', 'datatimer'));

% Create the new one to execute at a fixed rate.
DataTimer = timer('TimerFcn', @CollectData, 'Period', 0.1, 'Tag', 'datatimer',...
                  'ExecutionMode', 'fixedRate');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CollectData(obj, event)
global DataObj;

[buf, st, DataObj.previousCount, DataObj.previousIndex] = ...
    cbGetAInBackgroundScanData(DataObj.boardNum, DataObj.previousCount,...
    DataObj.previousIndex, DataObj.bufferSize,...
    DataObj.chans, DataObj.BIP10VOLTS, DataObj.memHandle);

 
% for i=1:6
%         for j = 1:200
%             buf(i,j) = 5*i*sin(3*DataObj.currun+j);
%         end
% end
% c= clock;
% fprintf('n = %d, t = %f, pc = %f, pi = %f, buf = [%f %f]\n', DataObj.currun, c(6), DataObj.previousCount, DataObj.previousIndex, size(buf));

    
if DataObj.previousIndex == -1
    DataObj.previousIndex = 0;
end

DataObj.data = [DataObj.data, buf];

if ~isempty(DataObj.data)
    for i=1:1
        plot(DataObj.plotHandle(i), DataObj.data(i,:));
    end
end
fprintf('n = %d, pc = %f, pi = %f, buf = [%f %f]\n', DataObj.currun, DataObj.previousCount, DataObj.previousIndex, size(buf));

DataObj.currun = DataObj.currun+1;
% if DataObj.currun >= 1000
%     stop(timerfind('Tag', 'datatimer'));
% end
    


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataObj;

% Stop and delete any timers still in existence.
cbStopBackground(DataObj.boardNum, DataObj.AIFUNCTION);
cbWinBufFree(DataObj.memHandle);
stop(timerfind('Tag', 'datatimer'));
delete(timerfind('Tag', 'datatimer'));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen;



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function LowChanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LowChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowChanEdit as text
%        str2double(get(hObject,'String')) returns contents of LowChanEdit as a double


% --- Executes during object creation, after setting all properties.
function LowChanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HighChanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to HighChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HighChanEdit as text
%        str2double(get(hObject,'String')) returns contents of HighChanEdit as a double


% --- Executes during object creation, after setting all properties.
function HighChanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HighChanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


