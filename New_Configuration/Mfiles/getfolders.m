function [y] = getfolders(directory)

%This function will take in a directory and return char array of folder
%names in the given directory


%Author: Dylan Oakley
%Date: 28 April 05
%Name: getfolders.m
%Version: 0.0


%Creates char list of all files/folders in dir and a boolen list of isdir?
folders = dir(directory);
dirs = [folders.isdir];
folders = char(folders.name);
if folders(1) == '.'                            %For any directory that is not C:\ the first two entries will be '.' and '..'
    folders = folders(3:end,:);                 %Removes '.' and '..' from top of the dir
    dirs = dirs(3:end);                
else
end

                                   
i = 1;                                          %indexing variable
folderlist = folders;                           %creates a char array from all names in directory
for n1 = 1:size(folders,1)
    if dirs(n1) == 1
        folderlist(i,:) = folders(n1,:);        % replaces names with folder names
        i = i+1;
    else
    end
end
  
folderlist = folderlist(1:(i-1),:);             %truncates the array so that only the folder names appear
[y] = folderlist;