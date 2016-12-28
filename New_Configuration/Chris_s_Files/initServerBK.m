% Load a bunch of cbw defines.
cbwDefs;

COMBOARDNUM = 0;

% Configure the port that we'll send strings across.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTA, DIGITALOUT);
if  errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTA: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, FIRSTPORTA, 0);
end

% Configure the server send bit port.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTB, DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTB: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, FIRSTPORTB, 0);
end

% Configure the client receive bit port.
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTA, DIGITALIN);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTA: ', cbGetErrMsg(errorCode)]);
end

%Configure the stop bit -- ADDED BY TUNDE
%errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTB, DIGITALOUT);
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTB, DIGITALIN);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTB: ', cbGetErrMsg(errorCode)]);
%else
    %Zero the port.
%    cbDOut(COMBOARDNUM, SECONDPORTB, 0);
end




disp('- server com init complete');