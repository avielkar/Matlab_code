function [M] = PriorTrajectoyCreation(appHandle)

global debug

if debug
    disp('Entering PriorTrajectoryCreation');
end

%% Take the needed parameters from appHandle
data = getappdata(appHandle, 'protinfo');
crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
activeStair = data.activeStair;
activeRule = data.activeRule;
trial = getappdata(appHandle, 'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); 


within = data.condvect.withinStair; 
across = data.condvect.acrossStair;
varying = data.condvect.varying;
priors = data.condvect.priors;

if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = cntr;
    end
end
%%

% Pull and assign required variables for a Translation protocol

%% ORIGIN
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
%%

%% DISC_PLANE_ELEVATION
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
%%

%% DISC_PLANE_AZIMUTH
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
%%

%% DISC_PLANE_TILT
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
%%

%% DIST
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
%%

%% DURATION
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
%%

%% SIGMA
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
%%

%% ADAPTATION_ANGLE
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
%%

%% ------avi:for Adma1_prior protocol.
i = strmatch('PRIOR_MEAN' ,{char(data.configinfo.name)},'exact');
prior_mean = data.configinfo(i).parameters;

i = strmatch('PRIOR_SIGMA' ,{char(data.configinfo.name)},'exact');
prior_sigma = data.configinfo(i).parameters;

i = strmatch('PRIOR_STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');
prior_stim_type = data.configinfo(i).parameters;

i = strmatch('STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');

%%avi - make that for all status types
real_stim_type = data.configinfo(i).parameters;
if(data.configinfo(i).status == 3)
    i1 = strmatch(data.configinfo(i).nice_name,{char(across.name)},'exact');
    real_stim_type = across(i1).parameters(activeStair);
end

prior_amps = normrnd(prior_mean , prior_sigma);

%if the stimulus type (of the all round should move left or right to the
%prior acrss to the types of the stimulus).
if(real_stim_type == 6 || real_stim_type == 7 || real_stim_type == 8)
    prior_amps = -prior_amps;
end

%transfer the button option also if flahing priors experiment.
if cldata.is_flashing_priors == true
    iBUTTON_RESPONSE_OPTION = strmatch('BUTTON_RESPONSE_OPTION',{char(data.configinfo.name)},'exact');
    button_option = data.configinfo(iBUTTON_RESPONSE_OPTION).parameters;
    data.condvect.priors.currentPrior.ButtonOption = button_option;
end
data.condvect.priors.currentPrior.Dir = prior_amps;
data.condvect.priors.currentPrior.StimulusType = prior_stim_type;
data.condvect.priors.currentPrior.Sigma = prior_sigma;
data.condvect.priors.currentPrior.Mean = prior_mean;

%setappdata(appHandle, 'protinfo',data)

%% ------end

%% Generate the trajectories as the assign required variables for a Translation protocol
f = 60;

vM1 = GenGaussian(dur(1,1), sig(1,1), dist(1,1), f);
dM1 = cumtrapz(vM1);
dM1 = abs(dist(1,1))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,1), sig(2,1), dist(2,1), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(dist(2,1))*dGL1(1:end-1)/max(abs(dGL1));

amp=prior_amps*pi/180;
az=azP*pi/180;
el=elP*pi/180;
tilt=tiltP*pi/180;

%% -----avi:no heading adaptation at priors
% if prior_stim_type == 3    %Combine 
%     amp(1,1)=amp(1,1) + adaptation_amp*pi/180/2;    
%     amp(2,1)=amp(2,1) - adaptation_amp*pi/180/2;
% end
%% -----end

xM = -sin(amp)*sin(az(1))*cos(tilt(1)) + cos(amp)*...
    (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
yM = sin(amp)*cos(az(1))*cos(tilt(1)) + cos(amp)*...
    (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
zM = -sin(amp)*sin(tilt(1)) - cos(amp)*sin(el(1))*cos(tilt(1));

xGL = xM;
yGL = yM;
zGL = zM;


lateralM = dM1*yM;
surgeM = dM1*xM;
heaveM = dM1*zM;
lateralGL = dGL1*yGL;
surgeGL = dGL1*xGL;
heaveGL = dGL1*zGL;
    
if prior_stim_type == 2   %Visual only
   lateralM = zeros(1,length(lateralM));
   surgeM = zeros(1,length(surgeM));
   heaveM = zeros(1,length(heaveM));
end;

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
%%

sprintf('ampVes(prior)=%f  ampGL(prior)=%f', amp*180/pi, amp*180/pi)

iBackground = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
if prior_stim_type == 1  %vestibula only
    data.configinfo(iBackground).parameters = 0;
else   %Combine & Visual only
    data.configinfo(iBackground).parameters = 1;
end
setappdata(appHandle, 'protinfo', data)

setappdata(appHandle, 'trialInfo',trial)

if debug
    disp('Exiting Three Step Adaptation Heading Trajectory');
end


