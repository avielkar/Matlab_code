%Three Step Adapte heading discrimination protocol. Jing for Mandy 2/02/2010
function [M] = ThreeStepAdaptationTrajectorySoundDelta(appHandle)

global debug

COMBOARDNUM = 0;

if debug
    disp('Entering Three Step Adaptation Heading Trajectory');
end

data = getappdata(appHandle, 'protinfo');
crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
activeStair = data.activeStair;
activeRule = data.activeRule;
trial = getappdata(appHandle, 'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); 

cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);

within = data.condvect.withinStair; 
across = data.condvect.acrossStair;
varying = data.condvect.varying;

if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = cntr;
    end
end

% Pull and assign required variables for a Translation protocol
i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Origin',{char(varying.name)},'exact');
    ori(1,:) = [crossvals(cntrVarying,i1) crossvals(cntrVarying,i1) crossvals(cntrVarying,i1)];
    ori(2,:) = [crossvalsGL(cntrVarying,i1) crossvalsGL(cntrVarying,i1) crossvalsGL(cntrVarying,i1)];
elseif data.configinfo(i).status == 3  
    tempVect = across.parameters';
    ori(1,:) = tempVect(activeStair,:);
    ori(2,:) = tempVect(activeStair,:);
elseif data.configinfo(i).status == 4  
    tempVect = within.parameters';
    ori(1,:) = tempVect(cntr,:);
    ori(2,:) = tempVect(cntr,:);
else
    ori(1,:) = data.configinfo(i).parameters;
    ori(2,:) = data.configinfo(i).parameters;
end
% first time send newline before data to separate junk from commands
outString = ['ORIGIN' ' ' num2str(ori(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('\n%s\n', outString), 5);

i = strmatch('DISC_PLANE_ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Elevation',{char(varying.name)},'exact');
    elP(1,1) = crossvals(cntrVarying,i1);
    elP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    elP(1,1) = across.parameters.moog(activeStair);
    elP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    elP(1,1) = within.parameters.moog(cntr);
    elP(2,1) = within.parameters.openGL(cntr);
else
    elP(1,1) = data.configinfo(i).parameters.moog;
    elP(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['DISC_PLANE_ELEVATION' ' ' num2str(elP(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('DISC_PLANE_AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Azimuth',{char(varying.name)},'exact');
    azP(1,1) = crossvals(cntrVarying,i1);
    azP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    azP(1,1) = across.parameters.moog(activeStair);
    azP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    azP(1,1) = within.parameters.moog(cntr);
    azP(2,1) = within.parameters.openGL(cntr);
else
    azP(1,1) = data.configinfo(i).parameters.moog;
    azP(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['DISC_PLANE_AZIMUTH' ' ' num2str(azP(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('DISC_PLANE_TILT',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Tilt',{char(varying.name)},'exact');
    tiltP(1,1) = crossvals(cntrVarying,i1);
    tiltP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    tiltP(1,1) = across.parameters.moog(activeStair);
    tiltP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    tiltP(1,1) = within.parameters.moog(cntr);
    tiltP(2,1) = within.parameters.openGL(cntr);
else
    tiltP(1,1) = data.configinfo(i).parameters.moog;
    tiltP(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['DISC_PLANE_TILT' ' ' num2str(tiltP(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('DIST',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Distance',{char(varying.name)},'exact');
    dist(1,1) = crossvals(cntrVarying,i1);
    dist(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    dist(1,1) = across.parameters.moog(activeStair);
    dist(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    dist(1,1) = within.parameters.moog(cntr);
    dist(2,1) = within.parameters.openGL(cntr);
else
    dist(1,1) = data.configinfo(i).parameters.moog;
    dist(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['DIST' ' ' num2str(dist(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Duration',{char(varying.name)},'exact');
    dur(1,1) = crossvals(cntrVarying,i1);
    dur(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    dur(1,1) = across.parameters.moog(activeStair);
    dur(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    dur(1,1) = within.parameters.moog(cntr);
    dur(2,1) = within.parameters.openGL(cntr);
else
    dur(1,1) = data.configinfo(i).parameters.moog;
    dur(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['DURATION' ' ' num2str(dur(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('SIGMA',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Sigma',{char(varying.name)},'exact');
    sig(1,1) = crossvals(cntrVarying,i1);
    sig(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    sig(1,1) = across.parameters.moog(activeStair);
    sig(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    sig(1,1) = within.parameters.moog(cntr);
    sig(2,1) = within.parameters.openGL(cntr);
else
    sig(1,1) = data.configinfo(i).parameters.moog;
    sig(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['SIGMA' ' ' num2str(sig(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('ADAPTATION_ANGLE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Adaptation Angle',{char(varying.name)},'exact');
    adaptation_amp = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3 
    adaptation_amp = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    adaptation_amp = within.parameters(cntr);
else
    adaptation_amp = data.configinfo(i).parameters;
end
outString = ['ADAPTATION_ANGLE' ' ' num2str(adaptation_amp(1,1))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Stimulus Type',{char(varying.name)},'exact');
    stim_type = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3 
    stim_type = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    stim_type = within.parameters(cntr);
else
    stim_type = data.configinfo(i).parameters;
end


i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Heading Direction',{char(varying.name)},'exact');
    amps(1,1) = crossvals(cntrVarying,i1);
    amps(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    amps(1,1) = across.parameters.moog(activeStair);
    amps(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    amps(1,1) = within.parameters.moog(cntr);
    amps(2,1) = within.parameters.openGL(cntr);
else
    amps(1,1) = data.configinfo(i).parameters.moog;
    amps(2,1) = data.configinfo(i).parameters.openGL;
end

%avi - sol protocol with DELTA
if(stim_type == 1 || stim_type == 2 || stim_type == 3)
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1))];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end

i = strmatch('DELTA',{char(data.configinfo.name)},'exact');
delta = data.configinfo(i).parameters;
if(stim_type == 4)  %Combine plus left delta
    amps(1) = amps(1) + delta/2;    %Moog increase
    amps(2) = amps(2) - delta/2;    %opengl decrease
    %for this stymulus type the delta is saved as positive in makeData.m
end

if(stim_type == 5)  %Combine plus right delta
    amps(1) = amps(1) - delta/2;    %Moog decrease
    amps(2) = amps(2) + delta/2;    %opengl incerease
    %for this symulus type the delta is saved as negative in makeData.m
end

if(stim_type == 100 || stim_type == 110 || stim_type == 120 || stim_type == 130)  %Combine plus right delta
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1))];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end

if(stim_type == 114)  %Combine audio-/vestibular+
    %audio decrease
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1) - delta/2 )];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    %Moog increase
    amps(1) = amps(1) + delta/2;  
    %for this symulus type the delta is saved as negative in makeData.m
end

if(stim_type == 115)  %Combine audio+/vestibular-
    %audio increase
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1) + delta/2 )];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    %Moog decrease
    amps(1) = amps(1) - delta/2; 
    %for this symulus type the delta is saved as negative in makeData.m
end

if(stim_type == 124)  %Combine audio-/visual+
    %audio decrease
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1) - delta/2 )];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    %opengl increaes
    amps(2) = amps(2) + delta/2;
    %for this symulus type the delta is saved as negative in makeData.m
end

if(stim_type == 125)  %Combine audio+/visual-
    %audio increaes
    outString = ['DISC_AMPLITUDES' ' ' num2str(amps(1,1) + delta/2 )];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
    %opengl decrease
    amps(2) = amps(2) - delta/2;
    %for this symulus type the delta is saved as negative in makeData.m
end
%avi - end sol protocol for DELTA

f = 60;

vM1 = GenGaussian(dur(1,1), sig(1,1), dist(1,1), f);
dM1 = cumtrapz(vM1);
dM1 = abs(dist(1,1))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,1), sig(2,1), dist(2,1), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(dist(2,1))*dGL1(1:end-1)/max(abs(dGL1));

amp=amps*pi/180;
az=azP*pi/180;
el=elP*pi/180;
tilt=tiltP*pi/180;

if stim_type == 3    %Combine 
    amp(1,1)=amp(1,1) + adaptation_amp*pi/180/2;    
    amp(2,1)=amp(2,1) - adaptation_amp*pi/180/2;
end

xM = -sin(amp(1,1))*sin(az(1))*cos(tilt(1)) + cos(amp(1,1))*...
    (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
yM = sin(amp(1,1))*cos(az(1))*cos(tilt(1)) + cos(amp(1,1))*...
    (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
zM = -sin(amp(1,1))*sin(tilt(1)) - cos(amp(1,1))*sin(el(1))*cos(tilt(1));

xGL = -sin(amp(2,1))*sin(az(2))*cos(tilt(2)) + cos(amp(2,1))*...
    (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
yGL = sin(amp(2,1))*cos(az(2))*cos(tilt(2)) + cos(amp(2,1))*...
    (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
zGL = -sin(amp(2,1))*sin(tilt(2)) - cos(amp(2,1))*sin(el(2))*cos(tilt(2));


lateralM = dM1*yM;
surgeM = dM1*xM;
heaveM = dM1*zM;
lateralGL = dGL1*yGL;
surgeGL = dGL1*xGL;
heaveGL = dGL1*zGL;
    
if stim_type == 2 || stim_type == -2   %Visual only
   lateralM = zeros(1,length(lateralM));
   surgeM = zeros(1,length(surgeM));
   heaveM = zeros(1,length(heaveM));
end

%do not move the robot - empty || vis || sound || sound + vis || sound + vis
%deltas.
if stim_type == 0 || stim_type == 2 || stim_type == 100 || stim_type == 120 || stim_type == 124 || stim_type == 125
   lateralM = zeros(1,length(lateralM));
   surgeM = zeros(1,length(surgeM));
   heaveM = zeros(1,length(heaveM));
end

if(stim_type == 100 || stim_type == 110 || stim_type == 120 || stim_type==130 || stim_type==114 || stim_type==115 || stim_type==124 || stim_type==125)  %as stim_type 1,2,3 with sound. 
    outString = ['MOOG_CREATE_TRAJ' ' ' num2str(1)];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
else
    outString = ['MOOG_CREATE_TRAJ' ' ' num2str(0)];
    cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);
end


M(1).name = 'LATERAL_DATA';
M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
M(2).name = 'SURGE_DATA';
M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
M(3).name = 'HEAVE_DATA';
M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
M(4).name = 'YAW_DATA';
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

sprintf('ampVes=%f  ampGL=%f', amp(1,1)*180/pi, amp(2,1)*180/pi)

% todo: check if to do it also fr osund and not for trajectory because if
% there is no movement the MoogDots creates the movement.
iBackground = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
if stim_type == 1  %vestibula only
    data.configinfo(iBackground).parameters = 0;
elseif stim_type == 0  %non vestibular and non visual.
    data.configinfo(iBackground).parameters = 0;
elseif stim_type == 100 %sound only
    data.configinfo(iBackground).parameters = 0;
elseif stim_type == 110 %sound with vetibular only.
    data.configinfo(iBackground).parameters = 0;
elseif stim_type == 114 %sound with vetibular delta+.
    data.configinfo(iBackground).parameters = 0;
elseif stim_type == 115 %sound with vetibular delta-.
    data.configinfo(iBackground).parameters = 0;
else   %others.
    data.configinfo(iBackground).parameters = 1;
end
setappdata(appHandle, 'protinfo', data)

setappdata(appHandle, 'trialInfo',trial)

if debug
    disp('Exiting Three Step Adaptation Heading Trajectory');
end

