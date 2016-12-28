function buttonTest
% tests the cedrusopen function
%
pr = {'released:', 'pushed:  '};
cedrusopen
cedrus.releases = 1;

% disp 'Press/release a button 10 times';
% for i=1:10
%    while 1
%        [b t p] = cedrus.getpress();
%        if b ~= 0
%            break
%        end
%    end
%    fprintf ('Button %d %s Time: %d ms\n', b, pr{p+1}, t)
% end

disp 'Press/release a button - wait 10 seconds to end';
while 1
    [b t p] = cedrus.waitpress(10);
    if b == 0
      break
    end
    fprintf ('Button %d %s Time: %d ms\n', b, pr{p+1}, t)
end
disp 'Button test done.';
cedrus.close();
