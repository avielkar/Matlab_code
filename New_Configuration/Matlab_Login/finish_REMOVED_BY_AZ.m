%FINISHDLG  Display a dialog to cancel quitting
%   Change the name of this file to FINISH.M and 
%   put it anywhere on your MATLAB path. When you 
%   quit MATLAB this file will be executed.

%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2000/06/01 16:19:26 $
global LOGFILE

button = questdlg('Ready to quit MATLAB?', ...
                  'Exit Dialog','Yes','No','No');
switch button
  case 'Yes',
      if isempty(LOGFILE)
          save
          quit force;
      end
      load(LOGFILE)
      if isempty(logData(end).logoutTime)
          logData(end).logoutTime = now;
          save(LOGFILE, 'logData')
          try
            conn = database('Human Moog','','');
            e = exec(conn, 'update dbo.LogData set logoutTime = getDate() where logNumber = ( select max(logNumber) from dbo.LogData )');
            close(e);
            close(conn);
          catch 
            s = sprintf('System Login has encountered problem!\nPlease contact one of the Administrator.\n\nPhone: 747-5528; 747-5528\nEmail: %s, %s,',ADMINEMAIL, ADMINEMAIL2);
            h = warndlg(s ,'!! Warning !!', 'modal');
            uiwait(h)
          end
          
          disp('Exiting MATLAB');
          %Save variables to matlab.mat
          save 
          quit force;
      end
  case 'No',
    quit cancel;
end

