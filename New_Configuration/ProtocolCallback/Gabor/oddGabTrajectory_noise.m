function [M] = gabTrajectory(appHandle)

global debug

if debug
    disp('Entering gabTrajectory');
end

% Load necessary variables
Resp = getappdata(appHandle,'ResponseInfo');
data = getappdata(appHandle, 'protinfo');
% crossvals = getappdata(appHandle, 'CrossVals') % Use data.condvect
% crossvalsGL = getappdata(appHandle, 'CrossValsGL'); % Use data.condvect
% trial = getappdata(appHandle, 'trialInfo'); % Use stairInfo
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;
cldata = getappdata(appHandle,'ControlLoopData');

if isempty(Resp) % If first trial, initialize stairInfo, and change trial time for oddity
    
    % change trial time
    i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
    dur1 = data.configinfo(i).parameters.moog(1);
    i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
    dur2 = data.configinfo(i).parameters.moog(1);
    i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
    del = data.configinfo(i).parameters.moog(1);

    i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).parameters == 3
        cldata.mainStageTime = dur1 + dur1 + dur2 + del + del;
    end
    cldata.respTime=5;
    setappdata(appHandle,'ControlLoopData',cldata);  
    
    % Get staircase info (each direction is a different staircase)
    stairInfo.stairs = [-45 0 45 90]; % Hardcode this becasue of the way direction is handled
    stairInfo.numStairs = size(stairInfo.stairs,2);

    % Get staircase steps (each distance is a different step)
    if ~isempty(strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact');
        stairInfo.steps = data.condvect(i1).parameters.moog;
    else % default (should be set another way)
        stairInfo.steps = 1;
    end
    stairInfo.numSteps = size(stairInfo.steps,2);
    
    % stairInfo.currStair (random)
    stairInfo.currStair = round(rand*stairInfo.numStairs + 0.5);
    
    % stairInfo.currStep (end of range)
    stairInfo.currStep = ones(1,stairInfo.numStairs)*stairInfo.numSteps;
    
    % stairInfo.trialCount (equal to one)
    stairInfo.trialCount = ones(1,stairInfo.numStairs);
    
    % Load stairInfo
    stairInfo;
    setappdata(appHandle,'stairInfo',stairInfo);  
else
    stairInfo = getappdata(appHandle, 'stairInfo');
end

% Get info from stairInfo
currStair = stairInfo.currStair;
currStep = stairInfo.currStep(currStair);
directions = stairInfo.stairs;
directionsGL = directions; % no conflict for now
amplitudes = stairInfo.steps;
amplitudesGL = amplitudes; % no conflict for now

% Pull and assign required variables for a Translation protocol
i = strmatch('NOISE_PARAMS',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters(7)=round(rand*2000)

i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Origin',{char(data.condvect.name)},'exact');
%     ori(1,:) = [crossvals(cntr,i1) crossvals(cntr,i1) crossvals(cntr,i1)];
%     ori(2,:) = [crossvalsGL(cntr,i1) crossvalsGL(cntr,i1) crossvalsGL(cntr,i1)];
else
    ori(1,:) = data.configinfo(i).parameters;
    ori(2,:) = data.configinfo(i).parameters;
end
i = strmatch('DISC_PLANE_ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Reference Plane, Elevation',{char(data.condvect.name)},'exact');
%     elP(1,1) = crossvals(cntr,i1);
%     elP(2,1) = crossvalsGL(cntr,i1);
else
    elP(1,1) = data.configinfo(i).parameters.moog;%(1);----jing comment out,1/11/07---
    elP(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('DISC_PLANE_AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Reference Plane, Azimuth',{char(data.condvect.name)},'exact');
%     azP(1,1) = crossvals(cntr,i1);
%     azP(2,1) = crossvalsGL(cntr,i1);
else
    azP(1,1) = data.configinfo(i).parameters.moog;%(1);
    azP(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('DISC_PLANE_TILT',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Reference Plane, Tilt',{char(data.condvect.name)},'exact');
%     tiltP(1,1) = crossvals(cntr,i1);
%     tiltP(2,1) = crossvalsGL(cntr,i1);
else
    tiltP(1,1) = data.configinfo(i).parameters.moog;%(1);
    tiltP(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
%     dir(1,1) = crossvals(cntr,i1);
%     dir(2,1) = crossvalsGL(cntr,i1);
else
    dir(1,1) = data.configinfo(i).parameters.moog;%(1);
    dir(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('DIST',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Distance',{char(data.condvect.name)},'exact');
%     dist(1,1) = crossvals(cntr,i1);
%     dist(2,1) = crossvalsGL(cntr,i1);
else
    dist(1,1) = data.configinfo(i).parameters.moog;%(1);
    dist(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Duration',{char(data.condvect.name)},'exact');
%     dur(1,1) = crossvals(cntr,i1);
%     dur(2,1) = crossvalsGL(cntr,i1);
else
    dur(1,1) = data.configinfo(i).parameters.moog;%(1);
    dur(2,1) = data.configinfo(i).parameters.openGL;%(1);
end
i = strmatch('SIGMA',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Sigma',{char(data.condvect.name)},'exact');
%     sig(1,1) = crossvals(cntr,i1);
%     sig(2,1) = crossvals(cntr,i1);
else
    sig(1,1) = data.configinfo(i).parameters.moog;%(1);
    sig(2,1) = data.configinfo(i).parameters.openGL;%(1);
end


if motiontype == 3 % 2I vars required as well
    i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
%         i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact');
        dir(1,2) = directions(currStair);
        dir(2,2) = directions(currStair);
    else
        dir(1,2) = directions(currStair);
        dir(2,2) = directions(currStair);
%         dir(1,2) = data.configinfo(i).parameters.moog;%(1);
%         dir(2,2) = data.configinfo(i).parameters.openGL;%(1);
    end
    i = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
%         i1 = strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact');
        dist(1,2) = amplitudes(currStep);
        dist(2,2) = amplitudes(currStep);
    else
        dist(1,2) = data.configinfo(i).parameters.moog;%(1);
        dist(2,2) = data.configinfo(i).parameters.openGL;%(1);
    end
    i = strmatch('SIGMA_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
%         i1 = strmatch('Sigma 2nd Int',{char(data.condvect.name)},'exact');
%         sig(1,2) = crossvals(cntr,i1);
%         sig(2,2) = crossvals(cntr,i1);
    else
        sig(1,2) = data.configinfo(i).parameters.moog;%(1);
        sig(2,2) = data.configinfo(i).parameters.openGL;%(1);
    end
    i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
%         i1 = strmatch('Delay 2nd Int',{char(data.condvect.name)},'exact');
%         delay(1) = crossvals(cntr,i1);
%         delay(2) = crossvals(cntr,i1);
    else
        delay(1) = data.configinfo(i).parameters.moog;%(1);
        delay(2) = data.configinfo(i).parameters.openGL;%(1);
    end
    i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
%         i1 = strmatch('Duration 2nd Int',{char(data.condvect.name)},'exact');
%         dur(1,2) = crossvals(cntr,i1);
%         dur(2,2) = crossvalsGL(cntr,i1);
    else
        dur(1,2) = data.configinfo(i).parameters.moog;%(1);
        dur(2,2) = data.configinfo(i).parameters.openGL;%(1);
    end
    i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
    randOrder = data.configinfo(i).parameters;    
end

% Generate gabor trajectories (no direction specified)
f = 60; % This is frequency / update rate (Hz)
% even trajectory
vMev = GenGabor(dur(1,1), sig(1,1), dist(1,1), f);
dMev = cumtrapz(vMev);
dMev = abs(dist(1,1))*dMev(1:end-1)/max(abs(dMev));
% vGL1 = GenGabor(dur(2,1), sig(2,1), dist(2,1), f);
% dGL1 = cumtrapz(vGL1);
% dGL1 = abs(dist(2,1))*dGL1(1:end-1)/max(abs(dGL1));

% odd trajectory
if motiontype == 3
    vMod = GenGabor(dur(1,2), sig(1,2), dist(1,2), f);
    dMod = cumtrapz(vMod);
    dMod = abs(dist(1,2))*dMod(1:end-1)/max(abs(dMod));
%     vGL2 = GenGabor(dur(2,2), sig(2,2), dist(2,2), f);
%     dGL2 = cumtrapz(vGL2);
%     dGL2 = abs(dist(2,2))*dGL2(1:end-1)/max(abs(dGL2));
end

% first movement normal to reference plane (dir=0)
dir(1,1)=0; 
dir(2,1)=0; 

dirs=dir*pi/180;
az=azP*pi/180;
el=(elP+90)*pi/180; % make it normal to reference plane
tilt=tiltP*pi/180;

% xM = -sin(dirs(1,1))*sin(az(1))*cos(tilt(1)) + cos(dirs(1,1))*...
%     (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
% yM = sin(dirs(1,1))*cos(az(1))*cos(tilt(1)) + cos(dirs(1,1))*...
%     (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
% zM = -sin(dirs(1,1))*sin(tilt(1)) - cos(dirs(1,1))*sin(el(1))*cos(tilt(1));
% 
% xGL = -sin(dirs(2,1))*sin(az(2))*cos(tilt(2)) + cos(dirs(2,1))*...
%     (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
% yGL = sin(dirs(2,1))*cos(az(2))*cos(tilt(2)) + cos(dirs(2,1))*...
%     (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
% zGL = -sin(dirs(2,1))*sin(tilt(2)) - cos(dirs(2,1))*sin(el(2))*cos(tilt(2));

%------End 03/16/07-------------

if motiontype == 1 % We should never enter this one
    
    lateralM = dM1*yM;
    surgeM = dM1*xM;
    heaveM = dM1*zM;
    lateralGL = dGL1*yGL;
    surgeGL = dGL1*xGL;
    heaveGL = dGL1*zGL;
    
else
    
    samediff = ceil(rand*3); % Use this to store oddity order
    setappdata(appHandle,'samediff',samediff); 
    
    ord = 1; % Default: we won't use this variable
    setappdata(appHandle,'Order',ord);
    
    % "even" stimulus
    xMev = -sin(dirs(1,1))*sin(az(1))*cos(tilt(1)) + cos(dirs(1,1))*...
        (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
    yMev = sin(dirs(1,1))*cos(az(1))*cos(tilt(1)) + cos(dirs(1,1))*...
        (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
    zMev = -sin(dirs(1,1))*sin(tilt(1)) - cos(dirs(1,1))*sin(el(1))*cos(tilt(1));
        
    el=elP*pi/180; % move back into reference plane to calc "odd" stimulus

    % "odd" stimulus
    xMod = -sin(dirs(1,2))*sin(az(1))*cos(tilt(1)) + cos(dirs(1,2))*...
        (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
    yMod = sin(dirs(1,2))*cos(az(1))*cos(tilt(1)) + cos(dirs(1,2))*...
        (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
    zMod = -sin(dirs(1,2))*sin(tilt(1)) - cos(dirs(1,2))*sin(el(1))*cos(tilt(1));
    
    restM = ones(1,f*delay(1));
    
    % Arrange movements in right order
    if samediff==1 % odd first 
        lateralM1 = dMod*yMod;
        lateralRestM1 = restM*lateralM1(end);
        lateralM2 = dMev*yMev + lateralM1(end);
        lateralRestM2 = restM*lateralM2(end);
        lateralM3 = dMev*yMev + lateralM2(end);        
        lateralM = [lateralM1 lateralRestM1 lateralM2 lateralRestM2 lateralM3];        
        lateralGL = lateralM;

        surgeM1 = dMod*xMod;
        surgeRestM1 = restM*surgeM1(end);
        surgeM2 = dMev*xMev + surgeM1(end);
        surgeRestM2 = restM*surgeM2(end);
        surgeM3 = dMev*xMev + surgeM2(end);        
        surgeM = [surgeM1 surgeRestM1 surgeM2 surgeRestM2 surgeM3];        
        surgeGL = surgeM;

        heaveM1 = dMod*zMod;
        heaveRestM1 = restM*heaveM1(end);
        heaveM2 = dMev*zMev + heaveM1(end);
        heaveRestM2 = restM*heaveM2(end);
        heaveM3 = dMev*zMev + heaveM2(end);        
        heaveM = [heaveM1 heaveRestM1 heaveM2 heaveRestM2 heaveM3];        
        heaveGL = heaveM;
        
    elseif samediff==2 % odd second
        lateralM1 = dMev*yMev;
        lateralRestM1 = restM*lateralM1(end);
        lateralM2 = dMod*yMod + lateralM1(end);
        lateralRestM2 = restM*lateralM2(end);
        lateralM3 = dMev*yMev + lateralM2(end);        
        lateralM = [lateralM1 lateralRestM1 lateralM2 lateralRestM2 lateralM3];        
        lateralGL = lateralM;

        surgeM1 = dMev*xMev;
        surgeRestM1 = restM*surgeM1(end);
        surgeM2 = dMod*xMod + surgeM1(end);
        surgeRestM2 = restM*surgeM2(end);
        surgeM3 = dMev*xMev + surgeM2(end);        
        surgeM = [surgeM1 surgeRestM1 surgeM2 surgeRestM2 surgeM3];        
        surgeGL = surgeM;

        heaveM1 = dMev*zMev;
        heaveRestM1 = restM*heaveM1(end);
        heaveM2 = dMod*zMod + heaveM1(end);
        heaveRestM2 = restM*heaveM2(end);
        heaveM3 = dMev*zMev + heaveM2(end);        
        heaveM = [heaveM1 heaveRestM1 heaveM2 heaveRestM2 heaveM3];
        heaveGL = heaveM;
        
    else % odd third
        lateralM1 = dMev*yMev;
        lateralRestM1 = restM*lateralM1(end);
        lateralM2 = dMev*yMev + lateralM1(end);
        lateralRestM2 = restM*lateralM2(end);
        lateralM3 = dMod*yMod + lateralM2(end);        
        lateralM = [lateralM1 lateralRestM1 lateralM2 lateralRestM2 lateralM3];        
        lateralGL = lateralM;

        surgeM1 = dMev*xMev;
        surgeRestM1 = restM*surgeM1(end);
        surgeM2 = dMev*xMev + surgeM1(end);
        surgeRestM2 = restM*surgeM2(end);
        surgeM3 = dMod*xMod + surgeM2(end);        
        surgeM = [surgeM1 surgeRestM1 surgeM2 surgeRestM2 surgeM3];        
        surgeGL = surgeM;

        heaveM1 = dMev*zMev;
        heaveRestM1 = restM*heaveM1(end);
        heaveM2 = dMev*zMev + heaveM1(end);
        heaveRestM2 = restM*heaveM2(end);
        heaveM3 = dMod*zMod + heaveM2(end);        
        heaveM = [heaveM1 heaveRestM1 heaveM2 heaveRestM2 heaveM3];
        heaveGL = heaveM;
        
    end
        
end 

if motiontype == 1
    M(1).name = 'LATERAL_DATA';
    M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(2).name = 'SURGE_DATA';
    M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(3).name = 'HEAVE_DATA';
    M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(4).name = 'YAW_DATA';
%     M(4).data = 90*ones(1,dur(1,1)*f);
    M(4).data = zeros(1,dur(1,1)*f);
    M(5).name = 'PITCH_DATA';
    M(5).data = zeros(1,dur(1,1)*f);
    M(6).name = 'ROLL_DATA';
    M(6).data = zeros(1,dur(1,1)*f);
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = lateralGL + ori(2,1);
    M(8).name = 'GL_SURGE_DATA';
    M(8).data = surgeGL + ori(2,2);
    M(9).name = 'GL_HEAVE_DATA';
    M(9).data = heaveGL + ori(2,3);
    M(10).name = 'GL_ROT_ELE';
    M(10).data = 90*ones(dur(2,1)*f,1);
    M(11).name = 'GL_ROT_AZ';
    M(11).data = zeros(dur(2,1)*f,1);
    M(12).name = 'GL_ROT_DATA';
    M(12).data = zeros(dur(2,1)*f,1);
else
    traj_length = size(lateralM,2);
    M(1).name = 'LATERAL_DATA';
    M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(2).name = 'SURGE_DATA';
    M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(3).name = 'HEAVE_DATA';
    M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(4).name = 'YAW_DATA';
    M(4).data = 90*ones(1,traj_length);
    M(5).name = 'PITCH_DATA';
    M(5).data = zeros(1,traj_length);
    M(6).name = 'ROLL_DATA';
    M(6).data = zeros(1,traj_length);
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = lateralGL + ori(2,1);
    M(8).name = 'GL_SURGE_DATA';
    M(8).data = surgeGL + ori(2,2);
    M(9).name = 'GL_HEAVE_DATA';
    M(9).data = heaveGL + ori(2,3);
    M(10).name = 'GL_ROT_ELE';
    M(10).data = 90*ones(traj_length,1);
    M(11).name = 'GL_ROT_AZ';
    M(11).data = zeros(traj_length,1);
    M(12).name = 'GL_ROT_DATA';
    M(12).data = zeros(traj_length,1);
end

% HACK
trial = getappdata(appHandle, 'trialInfo'); 
trial.list = ones(1,trial.num);
setappdata(appHandle, 'trialInfo', trial); 
setappdata(appHandle,'protinfo',data);

if motiontype == 1
    dir_1I = dir(1,1)
else
%     if HR
%         sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', dir(1,1), dir(1,2)-dir(1,1), ord, dir(1,ord(1)), dir(1,ord(2)))
%     else
%         sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', dir(1,1), dir(1,2), ord, dir(1,ord(1)), dir(1,ord(2)))
%     end
end
if debug
%     if motiontype == 1
%         dir(1,1)
%     else
%         dir(1,2) - dir(1,1)
%     end
    disp('Exiting gabTrajectory_edit');
end


