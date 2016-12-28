function startup
% run startup function when Matlab start
% add path in Matlab

globalDef

global loginData
conn = database('Human Moog','','');

if conn.Handle == 0 || exist(LOGFILE, 'file') == 0 || exist(SUBJECT_FILE, 'file') == 0
    s = sprintf('System error!\nPlease contact one of the Administors Tunde, Johnny.\n\nPhone: 747-5528; 747-3367\nEmail: %s, %s,',ADMINEMAIL, ADMINEMAIL2);
    h = warndlg(s ,'!! Warning !!', 'modal');
    uiwait(h)
    quit force %it will not call finish.m
end

t = clock;
%t(2) = 11; t(3) = 1; %for test only

% if t(3) > 0 && t(3) < 5
%     fileName = sprintf('%sreport%d%02d.txt',REPORTDIR,t(1),t(2)-1);
%     if exist(fileName, 'file') == 0
%         generateMonthlyReport(fileName);
%         quit force %it will not call finish.m
%         return;
%     end
% end

userNumber = -1;
expired=true;

[LoginName Password] = logindlg('Login');

%check password here
try
    userNumber = CheckLogin(LoginName, Password);
catch
    userNumber = -1;
end

if userNumber == -1
    s = sprintf('Your User name or Password is not correct!\n');
    h = warndlg(s ,'!! Warning !!', 'modal');
    uiwait(h)
elseif userNumber == -2
    s = sprintf('Please contact Mandy to active your account.\n\nPhone: 747-5528\nEmail: %s',RECORDEMAIL');
    h = warndlg(s ,'!! Warning !!', 'modal');
    uiwait(h);
else
    % check expiration date from HMprotocol.txt
    try
        [expired expDate PIname protocol] = CheckExpire(userNumber);
    catch
        expired=true;
    end
    if expired
        s = sprintf('Your protocol has problem!\nPlease contact Mandy.\n\nPhone: 747-5528\nEmail: %s',RECORDEMAIL');
        h = warndlg(s ,'!! Warning !!', 'modal');
        uiwait(h)
    end
end
    
while userNumber == -1 || expired == true
    %check password here
    [LoginName Password] = logindlg('Login fail!');
    try
        userNumber = CheckLogin(LoginName, Password);
    catch
        userNumber = -1;
    end

    if userNumber == -1
        s = sprintf('Your User name or Password is not correct!\n');
        h = warndlg(s ,'!! Warning !!', 'modal');
        uiwait(h)
    elseif userNumber == -2
        s = sprintf('Please contact Mandy to active your account.\n\nPhone: 747-5528\nEmail: %s',RECORDEMAIL');
        h = warndlg(s ,'!! Warning !!', 'modal');
        uiwait(h);
    else
        % check expiration date from HMprotocol.txt
        try
            [expired expDate PIname protocol] = CheckExpire(userNumber);
        catch
            expired=true;
        end
        if expired
            s = sprintf('Your protocol has problem!\nPlease contact Mandy.\n\nPhone: 747-5528\nEmail: %s',RECORDEMAIL');
            h = warndlg(s ,'!! Warning !!', 'modal');
            uiwait(h)
        end
    end
end

global USERNUMBER
USERNUMBER = userNumber;

recordLogin(userNumber, protocol, expDate);

if strcmp(loginData(userNumber).role, 'Admin')
    userLogin('Admin');
elseif strcmp(loginData(userNumber).role, 'User')
    userLogin('User');
else
    userLogin('User');
end

%% check login
function userNumber = CheckLogin(LoginName, Password)
global loginData RECORDEMAIL
loginData=[];
userNumber = -1;

conn = database('Human Moog','','');
e = exec(conn,...
    ['select u.userPassword, u.firstName, u.lastName, u.PInumber, p.firstName, p.lastName, u.deptName, u.campusBox, u.contactPhone, u.email, u.userRole, u.active, u.userNumber '...
    'from dbo.UserInfo as u inner join dbo.PIinfo as p on u.PInumber = p.PInumber '...
    'where u.userName=''' LoginName ''' and u.userPassword=''' Password '''']...
    );
e = fetch(e);
close(e);

k=1;
if strcmp(Password, cell2mat(e.Data(k)))
    userNumber = cell2mat(e.Data(end));
    loginData(userNumber).userPassword = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).firstName =cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).lastName = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).PInumber = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).PIname = [cell2mat(e.Data(k)) ' ' cell2mat(e.Data(k+1))]; k=k+2;
    loginData(userNumber).department = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).campusBox = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).contactPhone = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).email = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).role = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).active = cell2mat(e.Data(k)); k=k+1;
    loginData(userNumber).userNumber = cell2mat(e.Data(k));
    if loginData(userNumber).active == false
        userNumber = -2;
    end
end

%% check expiration date for HMprotocol.txt
function [expired expDate PIname protocol] = CheckExpire(userNumber)
global loginData
expired = true;
expDate = [];
PIname = loginData(userNumber).PIname;
protocol = [];

conn = database('Human Moog','','');
e = exec(conn,...
    ['select pl.PInumber, pl.startDate, pl.expDate, pl.protocol '...
    'from dbo.PIinfo as po inner join dbo.Protocol as pl on po.PInumber = pl.PInumber '...
    'where po.PInumber = ' num2str(loginData(userNumber).PInumber) ' and pl.expDate >= getDate() and pl.startDate <= getDate()']...
    );
e = fetch(e);
close(e);
close(conn);

if loginData(userNumber).PInumber == cell2mat(e.Data(1))
    expired = false;
    expDate = datenum(strtok(cell2mat(e.Data(3))), 'yyyy-mm-dd');
    protocol = cell2mat(e.Data(4));
end
    

%% add login record in logData.mat
function recordLogin(userNumber, protocol, expDate)
global LOGFILE ADMINEMAIL ADMINEMAIL2
load(LOGFILE);
s = length(logData);
logData(s+1).userNumber = userNumber;
logData(s+1).loginTime = now;
logData(s+1).protocol = protocol;
logData(s+1).expDate = expDate;
save(LOGFILE, 'logData')

try
% save all information
    conn = database('Human Moog','','');
    e = exec(conn,...
        ['insert into dbo.LogData (userNumber, loginTime, protocol, expDate) '...
        'values ('...
        num2str(userNumber) ', '...
        'getDate(), '...
        num2str(protocol) ', '...
        '''' datestr(expDate) ''''...
        ')'...
        ]...
        );
    close(e);
    close(conn);
catch 
    s = sprintf('System Log has problem!\nPlease contact one of the Administors Tunde, Johnny.\n\nPhone: 747-5528; 747-3367\nEmail: %s, %s,',ADMINEMAIL, ADMINEMAIL2);
    h = warndlg(s ,'!! Warning !!', 'modal');
    uiwait(h)
end

%% generate monthly report
function generateMonthlyReport(fileName)
global LOGINFILE LOGFILE RECORDEMAIL ADMINEMAIL ADMINEMAIL2 SMTP_SERVER
fid = fopen(fileName, 'w');
if fid == -1
    warndlg('Generate monthly report error', '!! Warning !!', 'modal');
else
    load(LOGINFILE);
    load(LOGFILE);
    t = clock;
    %t(2) = 11; t(3) = 1; %for test only
    endDate = datenum(t(1),t(2),t(3));
    if t(2) == 1 % January
        t(1) = t(1)-1;
        t(2) = 12;
    else
        t(2) = t(2)-1;
    end
    startDate = datenum(t(1),t(2),t(3));
    for i=1:length(logData)
        if logData(i).loginTime > startDate
            break;
        end
    end
    
    fprintf(fid, 'Human Moog Facility -- Monthly Login Report (%s)\n',datestr(now,'mmm.dd,yyyy HH:MM:SS'));
    for j=i:length(logData)
        if logData(j).loginTime <= endDate
            k = logData(j).userNumber;
            fprintf(fid, '\nTime-in:\t\t\t%s\nTime-out:\t\t\t%s\nFirst Name:\t\t\t%s\nLast Name:\t\t\t%s\nPI Name:\t\t\t%s\nDepartment:\t\t\t%s\nCampus Box:\t\t\t%d\nProtocol#:\t\t\t%d\nexpDate:\t\t\t%s\nPhone:\t\t\t%s\nEmail:\t\t\t%s\n',...
                datestr(logData(j).loginTime,'mmm.dd,yyyy HH:MM:SS'),...
                datestr(logData(j).logoutTime,'mmm.dd,yyyy HH:MM:SS'),...
                loginData(k).firstName,...
                loginData(k).lastName,...
                loginData(k).PIname,...
                loginData(k).department,...
                loginData(k).campusBox,...
                logData(j).protocol,...
                datestr(logData(j).expDate, 'mmm.dd,yyyy'),...
                loginData(k).contactPhone,...
                loginData(k).email...
                );
        end
    end
    
    fclose(fid)
     
    setpref('Internet','SMTP_Server',SMTP_SERVER);
    setpref('Internet','E_mail',ADMINEMAIL);
    sendmail({RECORDEMAIL,ADMINEMAIL,ADMINEMAIL2},'Human Moog Facility -- Monthly Login Report',...
        'Human Moog Facility -- Monthly Login Report', fileName);
    
end
    
