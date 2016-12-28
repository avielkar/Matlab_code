function readTest(buffSize)

dostuff = 1;
while dostuff == 1
    %tic;
    nums = cbDReadString(0, 0, buffSize);
    %toc;
    
    if isempty(nums)
        dostuff = 0;
        disp('nothing in buffer');
        %continue;
    else
        disp(nums);
        pause(.01);
    end

%     vals = [];
% 
%     previousIndex = 1;
%     index = 1;
%     for i = find(nums == ',')
%         vals(index) = str2num(nums(previousIndex:i-1));
%         index = index + 1;
%         previousIndex = i + 1;
%     end
% 
%     if isempty(find(diff(vals) ~= 1))
%         disp('transaction good');
%     else
%         disp('transaction bad');
%     end%
end