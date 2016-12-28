%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timer Object callback function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function eyeCalibrationControlLoop(obj, event, appHandle)
% Grab the current stage and execute it.

eyecldata = getappdata(appHandle, 'eyeControlLoopData');
eval([eyecldata.stage, '(appHandle)']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% InitializationStage
%   Initialization stage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InitializationStage(appHandle)
global  connected debug in

eyecldata = getappdata(appHandle,'eyeControlLoopData');

if eyecldata.initStage
    tic % Start for PreTrialTime
    eyecldata.initStage = 0;
    eyecldata.go = 0;

    setappdata(appHandle,'eyeControlLoopData',eyecldata);
    
    initDrawEye;
    sendVarToMoogdot;

    % Ready to start sound
    soundsc(eyecldata.beginWav,100000)
end


% Wait for red button to be pressed to start movement
if connected && ~debug
    % Configure Port
    boardNum = 1;
    portNum = 1;
    direction = 1;
    errorCode = cbDConfigPort(boardNum, portNum, direction);
    if errorCode ~= 0
        str = cbGetErrMsg(errorCode);
        disp(['WRONG cbDConfigPort ' str])
    end
    response = cbDIn(boardNum, portNum);
    if response == 4 || response == 12
        eyecldata.go = 1;
        setappdata(appHandle,'eyeControlLoopData',eyecldata);
    end
elseif (connected && debug) || (~connected && debug)
    DebugWindow;

    if strcmp(in,'s')
        eyecldata.go = 1;
        in = '';
    end
    setappdata(appHandle,'eyeControlLoopData',eyecldata);
end

eyecldata = getappdata(appHandle, 'eyeControlLoopData');

% Pause before movement
if toc >= eyecldata.PretrackingTime && eyecldata.go == 1
    %Start the backbround eye signal sampling sweep.
    eyeDataSampleObj = getappdata(appHandle, 'eyeDataSample');    
    cbAInBackgroundScan(eyeDataSampleObj.boardNum, eyeDataSampleObj.chans, eyeDataSampleObj.bufferSize,...
                        eyeDataSampleObj.sampleRate, eyeDataSampleObj.BIP10VOLTS, eyeDataSampleObj.memHandle);

    % Increment the stage.
    eyecldata.stage = 'MainStage';
    eyecldata.initStage = 1;
    setappdata(appHandle, 'eyeControlLoopData', eyecldata);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MainStage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MainStage(appHandle)
%disp('entering main');
eyecldata = getappdata(appHandle, 'eyeControlLoopData');

if eyecldata.initStage
    eyecldata.initStage = 0;
    setappdata(appHandle, 'eyeControlLoopData', eyecldata);

    % Start the timer.
    tic;
end

drawEye;

% if the timer is done, go to the next stage.
if toc >= eyecldata.TrackingTime
    eyecldata.stage = 'PostStage';
    eyecldata.initStage = 1;
    setappdata(appHandle, 'eyeControlLoopData', eyecldata);
end

%disp('exiting main');
%----End Main function-----

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PostStage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostStage(appHandle)
global connected debug

%disp('entering post');
eyecldata = getappdata(appHandle, 'eyeControlLoopData');
if eyecldata.initStage
    eyecldata.initStage = 0;
    setappdata(appHandle, 'eyeControlLoopData', eyecldata);

    cleanUp;
    
    COMBOARDNUM = 0;
    outString = 'FP_ON 0';
    if debug
        disp(outString)
    end
    if connected
        cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    end
    
    if checkEyeInWindow(appHandle)
        soundsc(eyecldata.correctWav,42000);
    else
        soundsc(eyecldata.wrongWav,42000);
    end
    
    tic;
end

if toc >= eyecldata.PostTrackingTime
    eyecldata.stage = 'InitializationStage';
    eyecldata.initStage = 1;
    setappdata(appHandle, 'eyeControlLoopData', eyecldata);
end
%disp('exiting post');


function sendVarToMoogdot
global eyeCalfig connected debug

eyeWinData = getappdata(eyeCalfig,'eyeWinData');

%---Convert deg to cm based on the Viewing Dist-----
hc = eyeWinData.headCenter;
eo = eyeWinData.eyeOffset;

distV = 100-hc(2)-eo(2);
tagX = distV*tan(eyeWinData.tagX*pi/180);%cm
tagY = distV*tan(eyeWinData.tagY*pi/180);%cm
 
if eyeWinData.eyecode  % Right eye
    tagX = tagX + eyeWinData.ioDist/2.0;
else
    tagX = tagX - eyeWinData.ioDist/2.0;
end

outString(1).name = 'HEAD_CENTER';
outString(1).data = eyeWinData.headCenter;
outString(2).name = 'EYE_OFFSETS';
outString(2).data = eyeWinData.eyeOffset;
outString(3).name = 'IO_DIST';
outString(3).data = eyeWinData.ioDist;
outString(4).name = 'TARG_XCTR';
outString(4).data = [tagX 0 0];
outString(5).name = 'TARG_YCTR';
outString(5).data = [tagY 0 0];
outString(6).name = 'TARG_ZCTR';
outString(6).data = [0 0 0];
outString(7).name = 'FP_ON';
outString(7).data = 1;
outString(8).name = 'BACKGROUND_ON';
outString(8).data = 0;
outString(9).name = 'SPHERE_FIELD_PARAMS';
outString(9).data = [0 5 1 1 0.05];
outString(10).name = 'ENABLE_FLOOR';
outString(10).data = 0;
outString(11).name = 'ENABLE_TUNNEL';
outString(11).data = 0;
outString(12).name = 'ENABLE_CYLINDERS';
outString(12).data = 0;

COMBOARDNUM = 0;
for i= 1: size(outString,2)
    tempStr= [outString(i).name ' ' sprintf('%2.3f ',outString(i).data) sprintf('\n')];
    if connected        
        cbDWriteString(COMBOARDNUM, sprintf('%s', tempStr), 5);
    end
    if debug
        disp(sprintf('%s', tempStr));
    end
end




