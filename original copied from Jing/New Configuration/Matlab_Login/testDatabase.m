conn = database('Human Moog','','');
e = exec(conn,...
    ['select u.firstName, u.lastName, p.firstName, p.lastName, u.deptName, u.campusBox, u.contactPhone, u.email, u.userRole, u.userNumber '...
    'from dbo.UserInfo as u inner join dbo.PIinfo as p on u.PInumber = p.PInumber '...
    'where u.userName=''Johnny'' and u.userPassword=''wen''']...
    );
e = fetch(e);
close(e)
close(conn)

%, u.campusBox, u.contactPhone, u.email, u.userRole, u.userNumber

% p.firstName, p.lastName, u.campusBox, u.contactPone, u.email. u.userRole, u.userNumber
% userName: 'Tunde'
%     userPassword: 'olakunle'
%        firstName: 'Tunde'
%         lastName: 'Adeyemo'
%           PIname: 'Dora Angelaki'
%       department: 'Anatomy and Neurobiology'
%        campusBox: 8108
%            empID: 69951
%     contactPhone: '747-5528'
%            email: 'badeyemo@pcg.wustl.edu'
%             role: 'Admin'
%       userNumber: 2
