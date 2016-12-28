function [M] = ObjecttransTrajectory_pogenjimmy(appHandle)

% [Jimmy] I only modified this for my own protocol. So only the One
% interval motion type is modified. (1/23/2008).
% and Jing modified again for combining Multi-staircase 12/01/08

global debug

if debug
    disp('Entering ObjecttransTrajectory_multiStair');
end

data = getappdata(appHandle, 'protinfo');
trial = getappdata(appHandle, 'trialInfo');

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;

within = data.condvect.withinStair;
activeStair = data.activeStair;
activeRule = data.activeRule;
cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);

% Pull and assign required variables for a Translation protocol
i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Origin',{char(data.condvect.varying.name)},'exact');
    ori(1,:) = [crossvals(cntr,i1) crossvals(cntr,i1) crossvals(cntr,i1)];
    ori(2,:) = [crossvalsGL(cntr,i1) crossvalsGL(cntr,i1) crossvalsGL(cntr,i1)];
else
    ori(1,:) = data.configinfo(i).parameters;
    ori(2,:) = data.configinfo(i).parameters;
end
i = strmatch('DISC_PLANE_ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Elevation',{char(data.condvect.varying.name)},'exact');
    elP(1,1) = crossvals(cntr,i1);
    elP(2,1) = crossvalsGL(cntr,i1);
else
    elP(1,1) = data.configinfo(i).parameters.moog;
    elP(2,1) = data.configinfo(i).parameters.openGL;
end
i = strmatch('DISC_PLANE_AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Azimuth',{char(data.condvect.varying.name)},'exact');
    azP(1,1) = crossvals(cntr,i1);
    azP(2,1) = crossvalsGL(cntr,i1);
else
    azP(1,1) = data.configinfo(i).parameters.moog;
    azP(2,1) = data.configinfo(i).parameters.openGL;
end
i = strmatch('DISC_PLANE_TILT',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Reference Plane, Tilt',{char(data.condvect.varying.name)},'exact');
    tiltP(1,1) = crossvals(cntr,i1);
    tiltP(2,1) = crossvalsGL(cntr,i1);
else
    tiltP(1,1) = data.configinfo(i).parameters.moog;
    tiltP(2,1) = data.configinfo(i).parameters.openGL;
end
i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Heading Direction',{char(data.condvect.varying.name)},'exact');
    amps(1,1) = crossvals(cntr,i1);
    amps(2,1) = crossvalsGL(cntr,i1);
else
    amps(1,1) = data.configinfo(i).parameters.moog;
    amps(2,1) = data.configinfo(i).parameters.openGL;
end


i = strmatch('DIST',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Distance',{char(data.condvect.varying.name)},'exact');
    dist(1,1) = crossvals(cntr,i1);
    dist(2,1) = crossvalsGL(cntr,i1);
else
    dist(1,1) = data.configinfo(i).parameters.moog;
    dist(2,1) = data.configinfo(i).parameters.openGL;
end

%========= Jimmy Added 1/29/2008 ======================%
% Assuming that the across staircase var is 'VESTIBULAR_STIM_OFF'.
vestibular_stim_off = trial(activeStair).acrossVal;
if vestibular_stim_off % We dont want moog to move
    dist(1,1) = 0.0000001;  % Set the moog distance to zero.
end
%========= End Jimmy Added ============================%
i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Duration',{char(data.condvect.varying.name)},'exact');
    dur(1,1) = crossvals(cntr,i1);
    dur(2,1) = crossvalsGL(cntr,i1);
else
    dur(1,1) = data.configinfo(i).parameters.moog;
    dur(2,1) = data.configinfo(i).parameters.openGL;
end
i = strmatch('SIGMA',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Sigma',{char(data.condvect.varying.name)},'exact');
    sig(1,1) = crossvals(cntr,i1);
    sig(2,1) = crossvals(cntr,i1);
else
    sig(1,1) = data.configinfo(i).parameters.moog;
    sig(2,1) = data.configinfo(i).parameters.openGL;
end

f = 60;
ord = 1;

setappdata(appHandle,'Order',ord);

% 1st interval
vM1 = GenGaussian(dur(1,ord(1)), sig(1,ord(1)), dist(1,ord(1)), f);
dM1 = cumtrapz(vM1);
dM1 = abs(dist(1,ord(1)))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,ord(1)), sig(2,ord(1)), dist(2,ord(1)), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(dist(2,ord(1)))*dGL1(1:end-1)/max(abs(dGL1));

%----Jing 03/16/07-------------
amp=amps*pi/180;
az=azP*pi/180;
el=elP*pi/180;
tilt=tiltP*pi/180;

xM = -sin(amp(1,ord(1)))*sin(az(1))*cos(tilt(1)) + cos(amp(1,ord(1)))*...
    (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
yM = sin(amp(1,ord(1)))*cos(az(1))*cos(tilt(1)) + cos(amp(1,ord(1)))*...
    (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
zM = -sin(amp(1,ord(1)))*sin(tilt(1)) - cos(amp(1,ord(1)))*sin(el(1))*cos(tilt(1));

xGL = -sin(amp(2,ord(1)))*sin(az(2))*cos(tilt(2)) + cos(amp(2,ord(1)))*...
    (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
yGL = sin(amp(2,ord(1)))*cos(az(2))*cos(tilt(2)) + cos(amp(2,ord(1)))*...
    (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
zGL = -sin(amp(2,ord(1)))*sin(tilt(2)) - cos(amp(2,ord(1)))*sin(el(2))*cos(tilt(2));

lateralM = dM1*yM;
surgeM = dM1*xM;
heaveM = dM1*zM;
lateralGL = dGL1*yGL;
surgeGL = dGL1*xGL;
heaveGL = dGL1*zGL;

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
    M(13).name = 'OBJECT_TRAJ';
    M(13).data = dM1(1:end-1)/max(abs(dM1));
    %========== Jimmy Modified 1/23/2008 =========%
    if isfield(within.parameters, 'moog')   % changing 'within' to a usable form.
        values = (within.parameters.moog)';
    else
        values = (within.parameters)';
    end

    % New code Last Modified 2/14/2008
    % Initial Variables
    heading_dir = amps(1,1);
    movement_mag = dist(2,1);
    i = strmatch('OBJECT_POS',{char(data.configinfo.name)},'exact');
    obj_pos = data.configinfo(i).parameters;
    i = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
    eye_offsets = data.configinfo(i).parameters;
    i = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
    head_center = data.configinfo(i).parameters;
    obj_x = obj_pos(1);
    obj_z = obj_pos(3);

    % Calculation
    x1 = obj_x;
    x2 = x1 - movement_mag*sin(heading_dir*pi/180);
   

    eye_to_screen = 100 - head_center(2) - eye_offsets(2);
    % next line changed 4/23/09 for collection of pilot data
    z1 = eye_to_screen - obj_z;% - ori(1,2); 
    % used to be:
%     z1 = eye_to_screen
     z2 = z1 - movement_mag*cos(heading_dir*pi/180);


    a = tan(values(cntr,1)*pi/180); % object deviation in rad.
    b = (x1*z2-z1*x2)/z1;
    obj_dist = a*b
    values(cntr,1)
 %   End new code

    M(13).data = obj_dist.*M(13).data; 

end

if debug
    amps(1,1)
    disp('Exiting ObjecttransTrajectory_multiStair');
end


