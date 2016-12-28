function sn = subjectNumGen
% generate a random subject number of 6 digits, 
% such that it never been used

globalDef

% if exist(SUBJECT_FILE, 'file') == 0
%     s = sprintf('System error!\nPlease contact Administor Johnny.\n\nPhone: 747-3367\nEmail: %s',ADMINEMAIL);
%     h = warndlg(s ,'!! Warning !!', 'modal');
%     uiwait(h)
%     sn = -1;
%     return;
% end

% get exist subject numbers
fid = fopen(SUBJECT_FILE);
existSN = textscan(fid, '%s %f');
existSN = existSN{2};
fclose(fid);

allSN = 1:(10^6-1); % all possible subject numbers
availableSN = setdiff(allSN,existSN); % all available subject numbers for using
sn = availableSN(floor(rand*(size(availableSN,2)))); % pick up a random number for available subject numbers

SUBJECT_PARA_DIR='C:\Human Moog\New Configuration\Matlab_Login02\';
SUBJECT_PARA_FILE = sprintf('%sh%06.0f.txt',SUBJECT_PARA_DIR,SUBJECT_NUM);
if exist(SUBJECT_PARA_FILE, 'file') == 0
end

end