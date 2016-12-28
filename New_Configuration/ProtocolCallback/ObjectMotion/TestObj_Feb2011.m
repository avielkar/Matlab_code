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

cldata = getappdata(appHandle,'ControlLoopData');
HR = cldata.hReference;

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

%%%% Reading in the default  heading directions specified on the basic
%%%% interface page.
i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
amps(1,1) = data.configinfo(i).parameters.moog;
amps(2,1) = data.configinfo(i).parameters.openGL;


% % %%%% Reading in the movement distance.
% % i = strmatch('DIST',{char(data.configinfo.name)},'exact');
% % if data.configinfo(i).status == 2
% %     i1 = strmatch('Distance',{char(data.condvect.varying.name)},'exact');
% %     dist(1,1) = crossvals(cntr,i1);
% %     dist(2,1) = crossvalsGL(cntr,i1);
% % else
% %     dist(1,1) = data.configinfo(i).parameters.moog;
% %     dist(2,1) = data.configinfo(i).parameters.openGL;
% % end

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


%%%% Defining the Object Azimuth, Object Elevation and Object Distance.
%%%%% Reading in Object distance.
i = strmatch('OBJECT_DIST',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 4
    obj_dist = within.parameters(cntr);
else
    obj_dist = data.configinfo(i).parameters;
end

i = strmatch('OBJECT_AZI',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 4
    obj_az = within.parameters(cntr);
else
    obj_az = data.configinfo(i).parameters;
end

i = strmatch('DEFAULT_OBJ_ELE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 4
    def_obj_ele = within.parameters(cntr);
else
    def_obj_ele = data.configinfo(i).parameters;
end

%%%%% Reading in the Object angular deviation as specified by the
%%%%% staircase.
i = strmatch('OBJECT_TRAJ',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 4
      obj_dev = within.parameters(cntr);
    else
  	 obj_dev = data.configinfo(i).parameters;
    end

%%%%%% New Object Elevation OR the angular deviation of the object with
%%%%%% respect to the vertical.
new_obj_ele = def_obj_ele + obj_dev

i = strmatch('OBJECT_ELE',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = new_obj_ele;
setappdata(appHandle, 'protinfo', data);

i = strmatch('DEFAULT_OBJECT_POS',{char(data.configinfo.name)},'exact');
orig_pos = data.configinfo(i).parameters;

i = strmatch('OBJECT_POS',{char(data.configinfo.name)},'exact');
clear temp
temp = rand(1,1);
new_xpos = orig_pos(1) + 0*temp
data.configinfo(i).parameters = [new_xpos orig_pos(2) orig_pos(3)];
setappdata(appHandle,'protinfo',data);
clear orig_pos new_xpos

clear dist(1,1) dist(2,1) dist(1,2) dist(2,2)

% % % %%%%% CONDITIONS RELEVANT TO VARIOUS STAIRCASES.
% %%%%%%%%%%%%     First distance = 6 cm.
% %%% if (activeStair == 5)
%     if (activeStair == 1)
%     dist(1,1) = 0.00001;
%     dist(2,1) = 6;
%     i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
%     data.configinfo(i).parameters = 1;
%     setappdata(appHandle,'protinfo',data);
% end
  
%%%%%%%%%%%%   Second distance = 11 cm.
%%%if (activeStair == 6)
% % if (activeStair == 2)
if (activeStair == 1)
    dist(1,1) = 0.00001;
    dist(2,1) = 23;
    i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
    data.configinfo(i).parameters = 1;
    setappdata(appHandle,'protinfo',data);
end

% %%%%%%%%%%%%%% Third distance = 16 cm.
% %%%%if (activeStair == 7)
% if (activeStair == 3)
%     dist(1,1) = 0.00001;
%     dist(2,1) = 16;
%     i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
%     data.configinfo(i).parameters = 1;
%     setappdata(appHandle,'protinfo',data);
% end
%   
%   
% %%%%%%%%%     First distance = 6 cm.
% %%%if (activeStair == 8)
% if (activeStair == 4)
%     dist(1,1) = 6;
%     dist(2,1) = 6;
%     i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
%     data.configinfo(i).parameters = 1;
%     setappdata(appHandle,'protinfo',data);
% end

% %%%%%%%%%%%     Second distance = 11 cm.
% %%%if (activeStair == 9)
% if (activeStair == 5)
%     dist(1,1) = 11;
%     dist(2,1) = 11;
%     i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
%     data.configinfo(i).parameters = 1;
%     setappdata(appHandle,'protinfo',data);
% end
% 
% %%%%%%%%%%%     Third distance = 16 cm.
% %%%%if (activeStair == 10)
% if (activeStair == 6)
%     dist(1,1) = 16;
%     dist(2,1) = 16;
%     i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
%     data.configinfo(i).parameters = 1;
%     setappdata(appHandle,'protinfo',data);
% end
% 

%%%% Saving the distances.
clear i
i = strmatch('MOOG_LENGTH',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = dist(1,1); %%%%% This is saving the distance traveled by moog.
setappdata(appHandle,'protinfo',data);

clear i
i = strmatch('VISUAL_LENGTH',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = dist(2,1); %%%%% This is saving the distance traveled by visual scene.
setappdata(appHandle,'protinfo',data);


%%%% General Gaussian trajectory creation.
vM1 = GenGaussian(dur(1,ord(1)), sig(1,ord(1)), dist(1,ord(1)), f);
dM1 = cumtrapz(vM1);
dM1 = abs(dist(1,ord(1)))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,ord(1)), sig(2,ord(1)), dist(2,ord(1)), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(dist(2,ord(1)))*dGL1(1:end-1)/max(abs(dGL1));


%%%% Specifying the Gaussian trajectory for the object motion.
v_obj = GenGaussian(dur(1,ord(1)), sig(1, ord(1)), obj_dist, f);
d_obj = cumtrapz(v_obj);
d_obj = abs(obj_dist)*d_obj(1:end-1)/max(abs(d_obj));


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
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    M(13).data = obj_dist.* d_obj(1:end-1)/max(abs(d_obj));
    
% %     figure, subplot(2,1,1); plot(M(13).data);
% %     diff_vel = diff(M(13).data);
% %     subplot(2,1,2); plot(diff_vel);
    %========== Jimmy Modified 1/23/2008 =========%
% %     if isfield(within.parameters, 'moog')   % changing 'within' to a usable form.
% %         values = (within.parameters.moog)';
% %     else
% %         values = (within.parameters)';
% %     end

% %     % New code Last Modified 2/14/2008
% %     % Initial Variables
% %     heading_dir = amps(1,1);
% %     movement_mag = dist(2,1);
% %     i = strmatch('OBJECT_POS',{char(data.configinfo.name)},'exact');
% %     obj_pos = data.configinfo(i).parameters;
% %     i = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
% %     eye_offsets = data.configinfo(i).parameters;
% %     i = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
% %     head_center = data.configinfo(i).parameters;
% %     obj_x = obj_pos(1);
% %     obj_z = obj_pos(3);
% % 
% %     % Calculation
% %     x1 = obj_x;
% %     x2 = x1 - movement_mag*sin(heading_dir*pi/180);
% %    
% % 
% %     eye_to_screen = 100 - head_center(2) - eye_offsets(2);
% %     % next line changed 4/23/09 for collection of pilot data
% %     z1 = eye_to_screen - obj_z;% - ori(1,2); 
% %     % used to be:
% % %     z1 = eye_to_screen
% %      z2 = z1 - movement_mag*cos(heading_dir*pi/180);
% % 
% % 
% %     a = tan(values(cntr,1)*pi/180); % object deviation in rad.
% %     b = (x1*z2-z1*x2)/z1;
% %     obj_dist = a*b
% %     values(cntr,1)
% %  %   End new code
% % 
% %     M(13).data = obj_dist.*M(13).data; 

end

if debug
    obj_dist
    disp('Exiting ObjecttransTrajectory_multiStair');
end


