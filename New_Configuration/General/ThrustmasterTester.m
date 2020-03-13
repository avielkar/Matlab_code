joy = vrjoystick(1);

output = [];
x = read(joy);
while (x(3) ~= -1)
    x = read(joy);
%     if(x(3) ~= 0)
        pause(0.1)
        output = [output x(3)]
%     end
end

close(joy);

plot(output);