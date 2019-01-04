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


%new cedrus response box AZ
%global cedrus
%cedrusopen
%cedrus.releases = 0;

%% AZ I noticed the FIRSTPORTB is defined in moogdots as OUT ?? How is there no clash here? 

% Configure the server send bit port.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTB, DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTB: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, FIRSTPORTB, 0);
end

% Configure the server send bit port.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTCL, DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTCL: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, FIRSTPORTCL, 0);
end

%tell the moog that the matlab waits for the Oculus head tracking.
errorCode = cbDConfigPort(COMBOARDNUM, FIRSTPORTCH, DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server FIRSTPORTCH: ', cbGetErrMsg(errorCode)]);
else
    % Zero the port.
    cbDOut(COMBOARDNUM, FIRSTPORTCL, 0);
end


% Configure the client receive bit port.
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTA, DIGITALIN);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTA: ', cbGetErrMsg(errorCode)]);
end

%Configure the stop bit -- ADDED BY TUNDE
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTB, DIGITALIN);%DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTB: ', cbGetErrMsg(errorCode)]);
%else
    %Zero the port.
    %cbDOut(COMBOARDNUM, SECONDPORTB, 0);
end

%Configure the stop bit -- ADDED BY TUNDE
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTCL, DIGITALIN);%DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTCL: ', cbGetErrMsg(errorCode)]);
%else
    %Zero the port.
    %cbDOut(COMBOARDNUM, SECONDPORTCL, 0);
end

%wait untill it ack matlab for start sending the data.
errorCode = cbDConfigPort(COMBOARDNUM, SECONDPORTCH, DIGITALIN);%DIGITALOUT);
if errorCode ~= 0
    disp(['*** Could not configure server SECONDPORTCH: ', cbGetErrMsg(errorCode)]);
%else
    %Zero the port.
    %cbDOut(COMBOARDNUM, SECONDPORTCL, 0);
end

disp('- server com init complete');