function [y] = getfilesstruct(directory)

%This function will take in a directory and return char array of file
%names in the given directory


%Author: Dylan Oakley
%Date: 28 April 05
%Name: getfiles.m
%Version: 0.0



%Creates char list of all files/folders in dir and a boolen list of isdir?
files = dir(directory);
dirs = [files.isdir];
files = char(files.name);
if files(1) == '.'                         %For any directory that is not C:\ the first two entries will be '.' and '..'
    files = files(3:end,:);                %Removes '.' and '..' from top of the dir
    dirs = dirs(3:end);                
else
end

                                   
i = 1;                                      %indexing variable
filelist = files;                           %creates a char array from all names in directory
for n1 = 1:size(files,1)
    if dirs(n1) == 0
        filelist(i,:) = files(n1,:);        % replaces names with file names
        i = i+1;
    else
    end
end

filelist = filelist(1:(i-1),:);         %truncates the array so that only the file names appear
[y] = filelist;