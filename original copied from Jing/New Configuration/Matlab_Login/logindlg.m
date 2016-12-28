function [varargout]=logindlg(Title)
% Login function
% Add Path in Matlab for startup.m call this function: File -> Set Path

if nargin ==  0 
    Title = 'Login';
end

% Get Properties
Color = get(0,'DefaultUicontrolBackgroundcolor');
Height = 9.5;

set(0,'Units','characters')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 38 Height];
%Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 35 Height];
set(0,'Units','pixels')

% Create the GUI
gui.main = dialog('HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Login',...
    'Tag','logindlg',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','logindlg',...
    'Position',Position);

set(gui.main,'Name',Title,'Closerequestfcn',{@Cancel,gui.main},'Keypressfcn',{@Escape,gui.main})

% Texts
gui.login_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','User Name','Position',[1 7.65 20 1]);
gui.password_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','Password','Position',[1 4.15 20 1]);

% Edits
gui.edit1 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 6.02 33 1.7]);
gui.edit2 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 2.52 33 1.7],'KeyPressfcn',{@KeyPress_Function,gui.main},'Userdata','');

% Buttons
gui.Help = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Help','Position',[1 .2 10 1.7],'Callback',{@Help,gui.main});
gui.OK = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Login','Position',[17 .2 10 1.7],'Callback',{@OK,gui.main});
gui.Cancel = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Quit','Position',[27 .2 10 1.7],'Callback',{@Cancel,gui.main});

setappdata(0,'logindlg',gui) % Save handle data

uicontrol(gui.edit1) % Make the first edit box active

% Pause the GUI and wait for a button to be pressed
uiwait(gui.main)

Login = get(gui.edit1,'String');
Password = get(gui.edit2,'Userdata');
varargout = {Login, Password};

delete(gui.main) % Close the GUI
setappdata(0,'logindlg',[]) % Erase handles from memory

%% Hide Password
function KeyPress_Function(h,eventdata,fig)
% Function to replace all characters in the password edit box with
% asterixes
password = get(h,'Userdata');
key = get(fig,'currentkey');

switch key
    case 'backspace'
        password = password(1:end-1); % Delete the last character in the password
    case 'return'  % This cannot be done through callback without making tab to the same thing
        gui = getappdata(0,'logindlg');
        OK([],[],gui.main);
    case 'tab'  % Avoid tab triggering the OK button
        gui = getappdata(0,'logindlg');
        uicontrol(gui.OK);
    otherwise
        password = [password get(fig,'currentcharacter')]; % Add the typed character to the password
end

SizePass = size(password); % Find the number of asterixes
if SizePass(2) > 0
    asterix(1,1:SizePass(2)) = '*'; % Create a string of asterixes the same size as the password
    set(h,'String',asterix) % Set the text in the password edit box to the asterix string
else
    set(h,'String','')
end

set(h,'Userdata',password) % Store the password in its current state

%% Cancel
function Cancel(h,eventdata,fig)
uiresume(fig)
quit % it will call finish.m
%{
button = questdlg('Ready to exit MATLAB?', 'Exit Dialog','Yes','No','No');
switch button
            case 'Yes',
              %disp('Exiting MATLAB');
              %Save variables to matlab.mat
              save
              %uiresume(fig)              
              quit
             case 'No',
              quit cancel;
end
%}

%% OK
function OK(h,eventdata,fig)
gui = getappdata(0,'logindlg');
Login = get(gui.edit1,'String');
Password = get(gui.edit2,'Userdata');

if isempty(Login) 
    warndlg('Please input user name!','!! Warning !!');
elseif isempty(Password)
    warndlg('Please input your password!','!! Warning !!')
else
    uiresume(fig)
end

%% Escape
function Escape(h,eventdata,fig)
% Close the login if the escape button is pushed and neither edit box is
% active
key = get(fig,'currentkey');

if isempty(strfind(key,'escape')) == 0 && h == fig
    Cancel([],[],fig)
end

%% Help Information
function Help(h,eventdata,fig)
helpStr = sprintf('%s\n%s\n\n%s\n%s',...
    'If you have login problem or your are new user,',...
    'please contact system administrator Jian or Jing,',...
    'Phone: 798-9195',...
    'Email: jianchen@cns.bcm.edu'...
    );
    
helpdlg(helpStr,'Help');
    