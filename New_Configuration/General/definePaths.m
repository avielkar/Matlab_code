function definePaths

global paths

% Paths used in BasicInterface and other FrontPanel interfaces
%%%% Commented on Feb 23, 2012 for testing purposes.
% % % % Commented Out by Jimmy on Dec 12 2007 for testing purposes only
% % %   paths.configpath = 'Z:\Users\Dylan\TestSetup\HumanMoog\New Configuration\Protocols';
% % %   paths.datapath = 'Z:\Users\Dylan\TestSetup\HumanMoog\New Configuration\Data';
% % %   paths.datapath_primary = 'Z:\Data\CID_Moog'; % this will be the final place that data lives -- Tunde 04/08/09

% Added by Jing on Mar 06 2008 for testing at Jing's local computer only
  paths.configpath = 'C:\Matlab_code\New_Configuration\Protocols';
  paths.datapath = 'C:\Matlab_code\New_Configuration\Data';
 
% Path used in hunam lab local c:\
%     paths.configpath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Protocols';
%     paths.datapath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Data';
%     paths.datapath_primary = 'C:\Data\CID_Moog';
% 
%%%% Path temporarily set on Feb 23, 2012.
%     paths.configpath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Protocols';
%     paths.datapath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Data';
     paths.datapath_primary = 'C:\Data\CID_Moog';

 
% Paths used in GeneralConfigEditor

% Commented Out by Jimmy on Dec 12 2007 for testing purposes only
%      paths.parampath = 'Z:\Users\Dylan\TestSetup\HumanMoog\New Configuration\Parameters';

% Added by Jing on Mar 06 2008 for testing at Jing's local computer only
 paths.parampath = 'C:\Matlab_code\New_Configuration\Parameters';
%   paths.parampath = 'C:\Program Files\MATLAB\R2006a\work\New Configuration\Parameters';
paths.protpath = paths.configpath;