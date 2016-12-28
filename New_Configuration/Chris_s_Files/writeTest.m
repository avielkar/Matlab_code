function writeTest(numBytes2write)

%x = sprintf('M_SIGMA 3.0 2.0 5.0 1.0\n');
y = [];
for i = [0:10]
y = [y, num2str(i), ','];
end
x = sprintf('%s\n', y);
numBytes2write = 1;

for i = [1:numBytes2write]
    val = cbDWriteString(0, x, 2);
    disp(['Num bytes written: ', num2str(val)]);
end