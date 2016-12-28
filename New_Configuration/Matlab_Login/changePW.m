function changePW
% User change password

set(0,'Units','characters')
Color = get(0,'DefaultUicontrolBackgroundcolor');
Position = [80 40 60 11];

% Create the GUI
handler.main = dialog('HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Change Password',...
    'Tag','changePW',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','changePW',...
    'Position',Position); 

% Texts
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','User Old Password:','Position',[1 8 30 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','User New Password:','Position',[1 6 30 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Confirm New Password:','Position',[1 4 30 1.5]);

% Edits
handler.edit1 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[30 8 28 1.7],'KeyPressfcn',{@KeyPress_Function,handler.main},'Userdata','');
handler.edit2 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[30 6 28 1.7],'KeyPressfcn',{@KeyPress_Function,handler.main},'Userdata','');
handler.edit3 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[30 4 28 1.7],'KeyPressfcn',{@KeyPress_Function,handler.main},'Userdata','');

% Buttons
handler.OK = uicontrol(handler.main,'Style','push','FontSize',10,'Units','characters','String','OK','Position',[7 0.5 20 1.7],'Callback',{@OK,handler.main});
handler.Cancel = uicontrol(handler.main,'Style','push','FontSize',10,'Units','characters','String','Cancel','Position',[33 0.5 20 1.7],'Callback',{@Cancel,handler.main});

setappdata(0,'changePW',handler) % Save handle data

uicontrol(handler.edit1) % Make the first edit box active

% Pause the GUI and wait for a button to be pressed
uiwait(handler.main)


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
        %gui = getappdata(0,'logindlg');
        %OK([],[],gui.main);
        uiresume(fig)
    case 'tab'  % Avoid tab triggering the OK button
        gui = getappdata(0,'newAccount');
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
close(fig)


%% OK
function OK(h,eventdata,fig)
global loginData USERNUMBER
handler = getappdata(0,'changePW');
userOldPW = get(handler.edit1,'Userdata');
userNewPW = get(handler.edit2,'Userdata');
confirmNewPW = get(handler.edit3,'Userdata');

if ~strcmp(userOldPW, loginData(USERNUMBER).userPassword)
    warndlg('Input wrong old password. Please input again.','!! Warning !!');
    set(handler.edit1,'Userdata','','String','');
elseif ~strcmp(userNewPW, confirmNewPW)
    warndlg('Input wrong new password. Please input again.','!! Warning !!');
    set(handler.edit2,'Userdata','','String','');
    set(handler.edit3,'Userdata','','String','');
else
    conn = database('Human Moog','','');
    e = exec(conn,...
        ['update dbo.UserInfo set userPassword = ''' userNewPW ''' where userNumber = ' num2str(USERNUMBER) '']...
        );
    if e.Message ~= ''
        s = sprintf('Change password fail!\nPlease contact one of the Administors Jian, Jing.\n\nPhone: 798-9195\nEmail: %s, %s,',ADMINEMAIL, ADMINEMAIL2);
        h = warndlg(s ,'!! Warning !!', 'modal');
        uiwait(h)
    else
        loginData(USERNUMBER).userPassword = userNewPW;
    end
    close(e);
    close(conn);
    
    uiresume(fig)
    close(fig)
end
