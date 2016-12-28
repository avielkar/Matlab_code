cbwDefs;

COMBOARDNUM = 0;

% Configure the port that we'll receive strings on.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTA, DIGITALIN);
if  errorCode ~= 0
    disp(['*** Could not configure receiver FIRSTPORTA: ', cbGetErrMsg(errorCode)]);
end

% Configure the receiver complete bit port.
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTA, DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure receiver SECONDPORTA: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, SECONDPORTA, 0);
end

% Configure the server send bit port.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTB, DIGITALIN);
if errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTB: ', cbGetErrMsg(errorCode)]);
end

disp('- receiver com init complete');