function userLogin(userRole)
%user login

globalDef

global USERLOGOUT APPLICATION gui
USERLOGOUT = false;

Color = get(0,'DefaultUicontrolBackgroundcolor');
Height = 20;

set(0,'Units','characters')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 50 Height];

gui.main = [];
if strcmp(userRole,'Admin')
    gui.main = figure(...%dialog(...
        'HandleVisibility','on',...
        'IntegerHandle','off',...
        'Menubar','none',...
        'NumberTitle','off',...
        'Name','Admin Tools',...
        'Tag','userLogin',...
        'Color',Color,...
        'Units','characters',...
        'Userdata','logindlg',...
        'Position',Position);
else
    gui.main = dialog(...
        'HandleVisibility','on',...
        'IntegerHandle','off',...
        'Menubar','none',...
        'NumberTitle','off',...
        'Name','User Tools',...
        'Tag','userLogin',...
        'Color',Color,...
        'Units','characters',...
        'Userdata','logindlg',...
        'Position',Position);
end

set(gui.main,'Closerequestfcn',{@Cancel,gui.main},'Keypressfcn',{@Escape,gui.main})

gui.application = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Start Appliction','Position',[10 7 30 1.7],'Callback',{@runApp_Callback, gui.main});
set(gui.application, 'Enable', 'off');
gui.newUser = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Add New User','Position',[10 5 30 1.7],'Callback','newUser');
if ~strcmp(userRole,'Admin')
    set(gui.newUser, 'Enable', 'off');
end

gui.changePW = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Change Password','Position',[10 3 30 1.7],'Callback','changePW');
gui.logout = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Logout','Position',[10 1 30 1.7],'Callback',{@userLogout_Callback, gui.main});

uicontrol(gui.main,'Style','text','FontSize',10,'Units','characters','String','Please input subject name','HorizontalAlign','left','Position',[5 17 40 1.7]);
uicontrol(gui.main,'Style','text','FontSize',10,'Units','characters','HorizontalAlign','left','String','First Name:','Position',[5 15 20 1.7]);
gui.FNedit = uicontrol(gui.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','Position',[20 15 25 1.7]);
uicontrol(gui.main,'Style','text','FontSize',10,'Units','characters','HorizontalAlign','left','String','Last Name:','Position',[5 13 20 1.7]);
gui.LNedit = uicontrol(gui.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','Position',[20 13 25 1.7]);
gui.addNewSubject = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Add New Subject','Position',[5 11 23 1.7],'Callback',{@AddNewSubject, gui.main});
gui.submitSubject = uicontrol(gui.main,'Style','push','FontSize',10,'Units','characters','String','Submit','Position',[30 11 15 1.7],'Callback',{@SubmitSubject, gui.main});
gui.subjectNumText = uicontrol(gui.main,'Style','text','ForegroundColor', [1 0 0], 'FontSize',10,'Units','characters','String','Subject#:','Position',[10 9 30 1.7]);

% get exist subject numbers
global SUBJECT_FILE SUBJECT_IFO
fid = fopen(SUBJECT_FILE);
SUBJECT_IFO = textscan(fid, '%s %s %f');
fclose(fid);

%% Cancel
function Cancel(h,eventdata,fig)
global USERLOGOUT

if USERLOGOUT
    delete(fig)
    close all
    startup
else
    uiresume(fig)
    quit % it will call finish.m
end

%% Escape
function Escape(h,eventdata,fig)
% Close the login if the escape button is pushed and neither edit box is
% active
key = get(fig,'currentkey');

if isempty(strfind(key,'escape')) == 0 && h == fig
    Cancel([],[],fig)
end

%% User Logout callback
function userLogout_Callback(h,eventdata,fig)
global LOGFILE
load(LOGFILE)
logData(end).logoutTime = now;
save(LOGFILE, 'logData')

try
    conn = database('Human Moog','','');
    e = exec(conn, 'update dbo.LogData set logoutTime = getDate() where logNumber = ( select max(logNumber) from dbo.LogData )');
    close(e);
    close(conn);
catch 
    s = sprintf('System Log has problem!\nPlease contact one of the Administors Jian, Jing.\n\nPhone: 798-9195\nEmail: %s, %s,',ADMINEMAIL, ADMINEMAIL2);
    h = warndlg(s ,'!! Warning !!', 'modal');
    uiwait(h)
end

global USERNUMBER
USERNUMBER = [];

global USERLOGOUT
USERLOGOUT = true;

Cancel([],[],fig)
%close all % it will call Cancel function

%% Get a rand subject number and create
function AddNewSubject (h,eventdata,fig)
global gui SUBJECT_IFO SUBJECT_NUM

SUBJECT_NUM = -1;

FirstName = get(gui.FNedit,'String');
LastName = get(gui.LNedit,'String');

I1 = strfind(FirstName, ' ');
I2 = strfind(LastName, ' ');
if ~isempty(I1) || ~isempty(I2)
    warndlg('Name cannot input space!','!! Warning !!')
    return;
end

for i=1:length(SUBJECT_IFO{1})
    if(strcmp(FirstName, SUBJECT_IFO{1}(i)) && strcmp(LastName, SUBJECT_IFO{2}(i)))
        SUBJECT_NUM = SUBJECT_IFO{3}(i);
    end
end

if SUBJECT_NUM==-1 
    SUBJECT_NUM=subjectNumGen;
    msgbox('New subject added!','Message');
    set(gui.application, 'Enable', 'on');
    tmpStr = sprintf('Subject#: %d', SUBJECT_NUM);
    set(gui.subjectNumText, 'String', tmpStr);
else
    warndlg('This subject name have been already used. Please use new name.','!! Warning !!')
end

%% Get check subject exist or not
function SubmitSubject (h,eventdata,fig)
global gui SUBJECT_IFO SUBJECT_NUM

set(gui.application, 'Enable', 'off');
SUBJECT_NUM=-1;

FirstName = get(gui.FNedit,'String');
LastName = get(gui.LNedit,'String');

if isempty(FirstName) || isempty(LastName)
    warndlg('Please input both first and last name of subject!','!! Warning !!')
    return;
end

I1 = strfind(FirstName, ' ');
I2 = strfind(LastName, ' ');
if ~isempty(I1) || ~isempty(I2)
    warndlg('Name cannot input space!','!! Warning !!')
    return;
end

for i=1:length(SUBJECT_IFO{1})
    if(strcmp(FirstName, SUBJECT_IFO{1}(i)) && strcmp(LastName, SUBJECT_IFO{2}(i)))
        SUBJECT_NUM = SUBJECT_IFO{3}(i);
    end
end

if SUBJECT_NUM==-1
    button = questdlg('Cannot find the subject. Do you want to add new subject?','Question','Cancel');
    switch button
       case 'Yes'
           SUBJECT_NUM=subjectNumGen;
       case 'No'
           return;
       case 'Cancel'
           return;
    end
else
    msgbox('Subject found!','Message');
end

if SUBJECT_NUM~=-1
    set(gui.application, 'Enable', 'on');
    tmpStr = sprintf('Subject#: %d', SUBJECT_NUM);
    set(gui.subjectNumText, 'String', tmpStr);
end

%% generate a random subject number of 6 digits, such that it never been used
function sn = subjectNumGen

global SUBJECT_IFO

existSN = SUBJECT_IFO{3};

allSN = 1:(10^6-1); % all possible subject numbers
availableSN = setdiff(allSN,existSN); % all available subject numbers for using
sn = availableSN(floor(rand*(size(availableSN,2)))); % pick up a random number for available subject numbers


%%
function runApp_Callback(h,eventdata,fig)
global SUBJECT_PARA_DIR SUBJECT_PARA_FILE SUBJECT_FILE SUBJECT_NUM gui

SUBJECT_PARA_FILE = sprintf('%sh%06.0f.txt',SUBJECT_PARA_DIR,SUBJECT_NUM);

% if subject parameter file doesn't exist, creat a empty text file.
if exist(SUBJECT_PARA_FILE, 'file') == 0
    fid = fopen(SUBJECT_PARA_FILE,'w');
    fprintf(fid, '');
    fclose(fid);

    FirstName = get(gui.FNedit,'String');
    LastName = get(gui.LNedit,'String');

    fid = fopen(SUBJECT_FILE,'a');
    fprintf(fid, '\n%s %s %06.0f',FirstName,LastName,SUBJECT_NUM);
    fclose(fid);
end

%start application
BasicInterface
