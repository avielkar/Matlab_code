function newUser
% Admin tool

global NEWUSER
NEWUSER = true;

prompt = {'Please enter your employee ID#:'};
dlg_title = 'Input';
num_lines = 1;
def = {''};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer) || strcmp(answer,'')
    return;
else
    empID = str2double(answer);
    empID = cast(empID,'uint32');
    if isnan(empID)
        h = warndlg('Please input a number!','!! Warning !!', 'modal');
        uiwait(h)
        return
    end
    conn = database('Human Moog','','');
    e = exec(conn, ['select firstName from dbo.UserInfo where empID = ' num2str(empID)]);
    e = fetch(e);
    close(e);
    close(conn);
    
    if ~strcmp('No Data', e.Data(1))
        h = warndlg(['The employee ID ' num2str(empID) ' has already existed!'],'!! Warning !!', 'modal');
        uiwait(h)
        return
    end
end

conn = database('Human Moog','','');
e = exec(conn, 'select firstName from dbo.PIinfo');
e = fetch(e);
close(e);
close(conn);

PIname = e.Data;

set(0,'Units','characters')
Color = get(0,'DefaultUicontrolBackgroundcolor');
Position = [80 20 100 40.5];

% Create the GUI
handler.main = dialog(...
    'HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Apply New Account',...
    'Tag','newAccount',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','newAccount',...
    'Position',Position); 

% Texts
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','User Name:','Position',[1 38 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','User Password:','Position',[1 36 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Confirm Password:','Position',[1 34 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','First Name:','Position',[1 32 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Last Name:','Position',[1 30 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','PI name:','Position',[1 28 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Department:','Position',[1 26 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Camput Box:','Position',[1 24 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Employee ID:','Position',[1 22 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Contact Phone:','Position',[1 20 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Email Address:','Position',[1 18 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Role:','Position',[1 16 25 1.5]);
uicontrol(handler.main,'Style','text','FontSize',10,'HorizontalAlign','left','Units','characters','String','Others:','Position',[1 14 25 1.5]);


% Edits
handler.edit1 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 38 70 1.7]);
handler.edit2 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 36 70 1.7],'KeyPressfcn',{@KeyPress_Function,handler.main},'Userdata','');
handler.edit3 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 34 70 1.7],'KeyPressfcn',{@KeyPress_Function,handler.main},'Userdata','');
handler.edit4 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 32 70 1.7]);
handler.edit5 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 30 70 1.7]);
handler.edit6 = uicontrol(handler.main,'Style','popupmenu','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String',PIname,'Position',[25 28 70 1.7]);
handler.edit7 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 26 70 1.7]);
handler.edit8 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 24 70 1.7]);
handler.edit9 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String',num2str(empID),'Position',[25 22 70 1.7]);
handler.edit10 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 20 70 1.7]);
handler.edit11 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[25 18 70 1.7]);
handler.edit12 = uicontrol(handler.main,'Style','popupmenu','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String',{'User','Admin'},'Position',[25 16 70 1.7]);
handler.edit13 = uicontrol(handler.main,'Style','edit','FontSize',10,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[15 4 80 11],'Max',2);

% Buttons
handler.OK = uicontrol(handler.main,'Style','push','FontSize',10,'Units','characters','String','OK','Position',[27 0.5 20 1.7],'Callback',{@OK,handler.main});
handler.Cancel = uicontrol(handler.main,'Style','push','FontSize',10,'Units','characters','String','Cancel','Position',[52 0.5 20 1.7],'Callback',{@Cancel,handler.main});

setappdata(0,'newAccount',handler) % Save handle data

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
global RECORDEMAIL ADMINEMAIL ADMINEMAIL2 SMTP_SERVER NEWUSER
handler = getappdata(0,'newAccount');
newUser.userName = get(handler.edit1,'String');
newUser.userPassword = get(handler.edit2,'Userdata');
confirmPassword = get(handler.edit3,'Userdata');
newUser.firstName = get(handler.edit4,'String');
newUser.lastName = get(handler.edit5,'String');
newUser.PInumber = get(handler.edit6,'Value');
newUser.PIname = get(handler.edit6,'String');
newUser.PIname = cast(newUser.PIname(newUser.PInumber),'char');
newUser.department = get(handler.edit7,'String');
newUser.campusBox = str2num(get(handler.edit8,'String')); % retrun empty is not input number
newUser.empID = str2num(get(handler.edit9,'String')); % retrun empty is not input number
newUser.contactPhone = get(handler.edit10,'String');
newUser.email = get(handler.edit11,'String');
role = get(handler.edit12,'String');
newUser.role = role(get(handler.edit12,'Value'));
newUser.role = cast(newUser.role, 'char');
others = get(handler.edit13,'String');


conn = database('Human Moog','','');
e = exec(conn, ['select firstName from dbo.UserInfo where UserName = ''' newUser.userName '''']);
e = fetch(e);
close(e);
close(conn);

sameUserName = false;
if ~strcmp('No Data', e.Data(1))
    sameUserName = true;
end

if (sameUserName)
    s = sprintf('The user name (%s) has already been used.\nPlease create new user name!', newUser.userName);
    warndlg(s,'!! Warning !!');
    set(handler.edit1,'String','');
elseif isempty(newUser.campusBox)
    warndlg('Please input a number for Campus Box.','!! Warning !!');
    set(handler.edit8,'String','');
elseif isempty(newUser.empID)
    warndlg('Please input a number for Protocol.','!! Warning !!');
    set(handler.edit9,'String','');
elseif isempty(newUser.userName) || isempty(newUser.userPassword) || isempty(confirmPassword)...
        || isempty(newUser.firstName) || isempty(newUser.lastName) || isempty(newUser.department)...
        || isempty(newUser.contactPhone) || isempty(newUser.email) || isempty(newUser.PIname)
    warndlg('Please input all information!','!! Warning !!');
elseif (~strcmp(newUser.userPassword, confirmPassword))
    warndlg('Input wrong password. Please input again.','!! Warning !!');
    set(handler.edit2,'Userdata','','String','');
    set(handler.edit3,'Userdata','','String','');
else 
    %s = sprintf('First Name: %s\nLast Name: %s\nDepartment: %s\nCampus Box: %d\nProtocol: %d\nPhone: %s\nEmail: %s\nOther Message:', ...
    %    newUser.firstName, newUser.lastName, newUser.department, newUser.campusBox, newUser.protocol, contactPhone, email);
    s = sprintf('First Name:\t\t%s\nLast Name:\t\t%s\nPI Name:\t\t%s\nDepartment:\t\t%s\nCampus Box:\t\t%d\nEmp ID#:\t\t%d\nPhone#:\t\t\t%s\nEmail:\t\t\t%s\nOther Message:\n',...
                newUser.firstName,...
                newUser.lastName,...
                newUser.PIname,...
                newUser.department,...
                newUser.campusBox,...
                newUser.empID,...
                newUser.contactPhone,...
                newUser.email...
                );
    [r c] = size(others);
    for i=1:r
        s = sprintf('%s\n%s',s,others(i,:));
    end
    
    try
        if NEWUSER
            s = sprintf('Date: %s\n%s',datestr(now),s);
            h = msgbox('Sending your application. Please wait!','Send Email');
            setpref('Internet','SMTP_Server',SMTP_SERVER);
            setpref('Internet','E_mail',newUser.email);
            sendmail({RECORDEMAIL,ADMINEMAIL,ADMINEMAIL2,newUser.email},'New User Application of Human Moog Facility',s);

            close(h);
            s = sprintf('Successful for sending your application!\nPlease check the confirm email in your email account.');
            msgbox(s,'Send Email');
        end
        % save all information
        conn = database('Human Moog','','');
        e = exec(conn,...
            ['insert into dbo.UserInfo (userName, userPassword, firstName, lastName, PInumber, deptName, campusBox, empID, contactPhone, email, userRole) '...
            'values ('...
            '''' newUser.userName ''', '...
            '''' newUser.userPassword ''', '...
            '''' newUser.firstName ''', '...
            '''' newUser.lastName ''', '...
            num2str(newUser.PInumber) ', '...
            '''' newUser.department ''', '...
            num2str(newUser.campusBox) ', '...
            num2str(newUser.empID) ', '...
            '''' newUser.contactPhone ''', '...
            '''' newUser.email ''', '...
            '''' newUser.role ''''...
            ')'...
            ]...
            );
        close(e);
        close(conn);

        uiresume(fig);
        close(fig)
    catch % catch email error. If so, we will not save the information.
        close(h);
        error = lasterror;
        s = sprintf('%s\n%s',error.identifier, error.message);
        warndlg(s,'!! Warning !!');
    end
    
    if ~NEWUSER
        msgbox('The account is active!','Message', 'modal');
    end

end

