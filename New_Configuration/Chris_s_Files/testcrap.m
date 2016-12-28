numPts = 8000;
rate = 10000;
boardNum = 1;
lowChan = 0;
highChan = 0;
previousCount = 0;
previousIndex = 0;

% Defines from cbw.h
AIFUNCTION = 1;
BIP10VOLTS = 1;

data = [];

memHandle = cbWinBufAlloc(numPts);

% Start the backbround sweep.
cbAInBackgroundScan(boardNum, [lowChan, highChan], numPts, rate, BIP10VOLTS, memHandle)  
                    
for i = [1:1]
    pause(.1);
    [buf, st, previousCount, previousIndex] = cbGetAInBackgroundScanData(boardNum, previousCount, previousIndex, numPts,...
                                            [lowChan, highChan], BIP10VOLTS, memHandle);
    data = [data, buf];
end
cbStopBackground(boardNum, AIFUNCTION);
cbWinBufFree(memHandle);

if ~isempty(data)
    plot(data);
end