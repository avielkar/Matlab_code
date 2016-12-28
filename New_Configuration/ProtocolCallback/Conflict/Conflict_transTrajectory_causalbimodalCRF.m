function [M] = Conflict_transTrajectory(appHandle)

global debug

if debug
    disp('Entering Conflict transTrajectory');
end

data = getappdata(appHandle, 'protinfo');
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;
crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
activeStair = data.activeStair;         %---Jing added 12/17/08--- 
activeRule = data.activeRule;
trial = getappdata(appHandle, 'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); %---Jing added 03/12/08--- 

%cntr = trial.list(trial.cntr);
cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
HR = cldata.hReference; %---Jing added 03/12/08--- 

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

% %%%%% Different term used in the present.
% % i = strmatch('HEADING_DIR_CONFLICT',{char(data.configinfo.name)},'exact');
% % if data.configinfo(i).status == 2
% %     i1 = strmatch('Heading Dir Conflict',{char(data.condvect.varying.name)},'exact');
% %     conflict_amp(1,1) = crossvals(cntr,i1);
% % else
% %     conflict_amp(1,1) = data.configinfo(i).parameters;
% % end


clear mean_head ch
%%%%%%%% Mean Heading Angle.
choice_mean_head = -25:5:25;
%%%% choice_mean_head = -10:5:10;

%%%%%%%%%%%%%%%%%%%%%%%%
ch = randperm(length(choice_mean_head));
mean_head = choice_mean_head(ch(5));  %%%%%%%%%%%%% MEAN HEADING ANGLE


amps(1,1) = mean_head; %%%% assigned to moog.
amps(2,1) = mean_head; %%%% assigned to openGL.

i = strmatch('MEAN_HEADING',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = mean_head;
setappdata(appHandle, 'protinfo',data);


i = strmatch('DISPARITY',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Disparity',{char(data.condvect.varying.name)},'exact');
    conflict_amp = crossvals(cntr,i1);
else
    conflict_amp = data.configinfo(i).parameters.moog;
end

polarity_choice = floor(2*rand);
i = strmatch('POLARITY_CHOICE',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = polarity_choice;
setappdata(appHandle,'protinfo',data);

if (polarity_choice == 1)
    conflict_amp = conflict_amp * -1;
end
intact_conflict_amp = conflict_amp;


i = strmatch('INTACT_DISPARITY',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters = intact_conflict_amp;
setappdata(appHandle,'protinfo',data);

i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
data.configinfo(i).parameters.moog = amps(1,1);
data.configinfo(i).parameters.openGL = amps(2,1);
setappdata(appHandle,'protinfo',data);
    

%%%%% 2nd interval part commented out.
% if motiontype == 3 % 2I vars required as well
%     i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.varying.name)},'exact');
%         amps(1,2) = crossvals(cntr,i1);
%         amps(2,2) = crossvalsGL(cntr,i1);
%     else
%         amps(1,2) = data.configinfo(i).parameters.moog;
%         amps(2,2) = data.configinfo(i).parameters.openGL;
%     end
%     if HR %----Jing added for different heading reference(Based on 1I). 03/14/07
%         amps(1,2) = amps(1,2) + amps(1,1);
%         amps(2,2) = amps(2,2) + amps(2,1);
%     end %--end 03/14/07---
%     i = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Distance 2nd Int',{char(data.condvect.varying.name)},'exact');
%         dist(1,2) = crossvals(cntr,i1);
%         dist(2,2) = crossvalsGL(cntr,i1);
%     else
%         dist(1,2) = data.configinfo(i).parameters.moog;
%         dist(2,2) = data.configinfo(i).parameters.openGL;
%     end
%     i = strmatch('SIGMA_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Sigma 2nd Int',{char(data.condvect.varying.name)},'exact');
%         sig(1,2) = crossvals(cntr,i1);
%         sig(2,2) = crossvals(cntr,i1);
%     else
%         sig(1,2) = data.configinfo(i).parameters.moog;
%         sig(2,2) = data.configinfo(i).parameters.openGL;
%     end
%     i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Delay 2nd Int',{char(data.condvect.varying.name)},'exact');
%         delay(1) = crossvals(cntr,i1);
%         delay(2) = crossvals(cntr,i1);
%     else
%         delay(1) = data.configinfo(i).parameters.moog;
%         delay(2) = data.configinfo(i).parameters.openGL;
%     end
%     i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Duration 2nd Int',{char(data.condvect.varying.name)},'exact');
%         dur(1,2) = crossvals(cntr,i1);
%         dur(2,2) = crossvalsGL(cntr,i1);
%     else
%         dur(1,2) = data.configinfo(i).parameters.moog;
%         dur(2,2) = data.configinfo(i).parameters.openGL;
%     end
%     i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
%     randOrder = data.configinfo(i).parameters;    
%     
%     
% % %     i = strmatch('HEADING_DIR_CONFLICT',{char(data.configinfo.name)},'exact');
% % %     if data.configinfo(i).status == 2
% % %         i1 = strmatch('Heading Dir Conflict',{char(data.condvect.varying.name)},'exact');
% % %         conflict_amp(1,1) = crossvals(cntr,i1);
% % %     else
% % %         conflict_amp(1,1) = data.configinfo(i).parameters;
% % %     end
% 
%    
% end


f = 60;
if motiontype == 3 % 2I motion
    if randOrder == 1  % random order for intervals
        ord = randperm(2);
    elseif randOrder == 2
        ord = [2 1];
    else
        ord = [1 2];
    end
else
    ord = 1;
end

setappdata(appHandle,'Order',ord);

% 1st interval
vM1 = GenGaussian(dur(1,ord(1)), sig(1,ord(1)), dist(1,ord(1)), f);
dM1 = cumtrapz(vM1);
dM1 = abs(dist(1,ord(1)))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,ord(1)), sig(2,ord(1)), dist(2,ord(1)), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(dist(2,ord(1)))*dGL1(1:end-1)/max(abs(dGL1));

% % % 2nd Interval
% % if motiontype == 3
% %     vM2 = GenGaussian(dur(1,ord(2)), sig(1,ord(2)), dist(1,ord(2)), f);
% %     dM2 = cumtrapz(vM2);
% %     dM2 = abs(dist(1,ord(2)))*dM2(1:end-1)/max(abs(dM2));
% %     vGL2 = GenGaussian(dur(2,ord(2)), sig(2,ord(2)), dist(2,ord(2)), f);
% %     dGL2 = cumtrapz(vGL2);
% %     dGL2 = abs(dist(2,ord(2)))*dGL2(1:end-1)/max(abs(dGL2));
% % end


%%%%%%%% From here, old part of the code used by CRF.
% If conflict, create two different trajectories

% % Which direction does the openGL go relative to the Moog??
% conamp =0; % conflict hasn't been perfected yet
% if conamp ~= 0
%     % Add Conflict difference here, but this conflict code is outdated
%     %azM = az(1) + (conpitch + sin(conamp/2*pi/180) + conamp/2*cos(conroll*pi/180));
%     %azGL = az(1) - (conpitch + sin(conamp/2*pi/180) + conamp/2*cos(conroll*pi/180));
%     %elM = el(1) + (conpitch + cos(conamp/2*pi/180) + conamp/2*sin(conroll*pi/180));
%     %elGL = el(1) - (conpitch + cos(conamp/2*pi/180) + conamp/2*sin(conroll*pi/180));
% else 
%     %---Jing comment out 03/16/07------------
%     %azM1 = 90 + azP(1) - amps(1,ord(1))*cos(-elP(1)*pi/180) ...
%     %    - tiltP(1)*sin(-elP(1)*pi/180);
%     %azGL1 = 90 + azP(2) - amps(2,ord(1))*cos(-elP(2)*pi/180) ...
%     %    - tiltP(2)*sin(-elP(2)*pi/180);
%     %elM1 = amps(1,ord(1))*sin(-elP(1)*pi/180) - tiltP(1)*cos(-elP(1)*pi/180);
%     %elGL1 = amps(2,ord(1))*sin(-elP(2)*pi/180) -
%     %tiltP(2)*cos(-elP(2)*pi/180);
%     %-----End 03/16/07----------
%     
%     %Used before change to Disc Plane variables, can
%     %delete if Disc plane variables work
%     %azM1 = az(1,ord(1));  
%     %azGL1 = az(1,ord(1));
%     %elM1 = el(2,ord(1));
%     %elGL1 = el(2,ord(1));
%     
%     %---Jing comment out 03/16/07-------------
%     %if motiontype == 3 
%     %    azM2 = 90 + azP(1) - amps(1,ord(2))*cos(-elP(1)*pi/180) ...
%     %       - tiltP(1)*sin(-elP(1)*pi/180);
%     %    azGL2 = 90 + azP(2) - amps(2,ord(2))*cos(-elP(2)*pi/180) ...
%     %       - tiltP(2)*sin(-elP(2)*pi/180);
%     %    elM2 = amps(1,ord(2))*sin(-elP(1)*pi/180) - tiltP(1)*cos(-elP(1)*pi/180);
%     %    elGL2 = amps(2,ord(2))*sin(-elP(2)*pi/180) - tiltP(2)*cos(-elP(2)*pi/180);
%     %-----End 03/16/07---------    
%     
%         % Code for 2nd interval around 1st interval not straight ahead,
%         % maybe used/modified in future
%         %azM2 = 90 + azP(1) - (amps(1,ord(2))+amps(1,ord(1)))*cos(-elP(1)*pi/180) ...
%         %    - tiltP(1)*sin(-elP(1)*pi/180);
%         %azGL2 = 90 + azP(2) - (amps(2,ord(2))+amps(1,ord(1)))*cos(-elP(2)*pi/180) ...
%         %    - tiltP(2)*sin(-elP(2)*pi/180);
%         %elM2 = (amps(1,ord(2))+amps(1,ord(1)))*sin(elP(1)*pi/180) - tiltP(1)*cos(elP(1)*pi/180);
%         %elGL2 = (amps(2,ord(2))+amps(1,ord(1)))*sin(elP(2)*pi/180) - tiltP(2)*cos(elP(2)*pi/180);
%         
%         %Used before change to Disc Plane variables, can
%         %delete if Disc plane variables work
%         %azM2 = az(1,ord(2));
%         %azGL2 = az(1,ord(2));
%         %elM2 = el(2,ord(2));
%         %elGL2 = el(2,ord(2));
%     %end
% end

%----Jing 03/16/07-------------
amp=amps*pi/180;
az=azP*pi/180;
el=elP*pi/180;
tilt=tiltP*pi/180;
conflict_amp = conflict_amp*pi/180 * .5; %ChrisF definition of conflict angle consistent with monk setup

xM = -sin(amp(1,ord(1)))*sin(az(1))*cos(tilt(1)) + cos(amp(1,ord(1)))*...
    (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
yM = sin(conflict_amp + amp(1,ord(1)))*cos(az(1))*cos(tilt(1)) + cos(conflict_amp + amp(1,ord(1)))*...
    (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
zM = -sin(amp(1,ord(1)))*sin(tilt(1)) - cos(amp(1,ord(1)))*sin(el(1))*cos(tilt(1));
%%%%%%%%%
i = strmatch('VEST_HEADING',{char(data.configinfo.name)},'exact');
vest_heading = conflict_amp + amp(1,ord(1));
data.configinfo(i).parameters = vest_heading;
setappdata(appHandle,'protinfo',data);


xGL = -sin(amp(2,ord(1)))*sin(az(2))*cos(tilt(2)) + cos(amp(2,ord(1)))*...
    (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
yGL = sin(-conflict_amp + amp(2,ord(1)))*cos(az(2))*cos(tilt(2)) + cos(-conflict_amp + amp(2,ord(1)))*...
    (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
zGL = -sin(amp(2,ord(1)))*sin(tilt(2)) - cos(amp(2,ord(1)))*sin(el(2))*cos(tilt(2));
%%%%%%%
i = strmatch('VISUAL_HEADING',{char(data.configinfo.name)},'exact');
visual_heading = -conflict_amp + amp(2,ord(1));
data.configinfo(i).parameters = visual_heading;
setappdata(appHandle,'protinfo',data);


%------End 03/16/07-------------

if motiontype == 1
    %---Jing comment out and made change(y-lateral, x-surge) 03/16/07-------------
    %[xM yM zM] = sph2cart(azM1*pi/180, elM1*pi/180, 1);
    %[xGL yGL zGL] = sph2cart(azGL1*pi/180, elGL1*pi/180, 1);
    
    lateralM = dM1*yM;
    surgeM = dM1*xM;
    heaveM = dM1*zM;
    lateralGL = dGL1*yGL;
    surgeGL = dGL1*xGL;
    heaveGL = dGL1*zGL;
    %-----End 03/16/07---------   
else
    %---Jing comment out and made change(y-lateral, x-surge) 03/16/07-------------
    %[xM1 yM1 zM1] = sph2cart(azM1*pi/180, elM1*pi/180, 1);
    %[xGL1 yGL1 zGL1] = sph2cart(azGL1*pi/180, elGL1*pi/180, 1);
    %[xM2 yM2 zM2] = sph2cart(azM2*pi/180, elM2*pi/180, 1);
    %[xGL2 yGL2 zGL2] = sph2cart(azGL2*pi/180, elGL2*pi/180, 1);
    
%     conflict_amp = 5;
% %     
% %     xM1 = xM;
% %     yM1 = yM;
% %     zM1 = zM;
% %     xGL1 = xGL;
% %     yGL1 = yGL;
% %     zGL1 = zGL;
   
% %     xM2 = -sin(amp(1,ord(2)))*sin(az(1))*cos(tilt(1)) + cos(amp(1,ord(2)))*...
% %          (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
% % %     yM2 = sin(conflict_amp + amp(1,ord(2)))*cos(az(1))*cos(tilt(1)) + cos(amp(1,ord(2)))*...
% % %          (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
% % %           %conflict in the second interval for lateral dimension.
% %     yM2 = sin(amp(1,ord(2)))*cos(az(1))*cos(tilt(1)) + cos(amp(1,ord(2)))*...
% %          (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));     
% %     zM2 = -sin(amp(1,ord(2)))*sin(tilt(1)) - cos(amp(1,ord(2)))*sin(el(1))*cos(tilt(1));


% %     xGL2 = -sin(amp(2,ord(2)))*sin(az(2))*cos(tilt(2)) + cos(amp(2,ord(2)))*...
% %           (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
% % %     yGL2 = sin(-conflict_amp + amp(2,ord(2)))*cos(az(2))*cos(tilt(2)) + cos(-conflict_amp + amp(2,ord(2)))*...
% % %           (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
% % %           %conflict in the second interval for lateral dimension.
% % 
% %     yGL2 = sin(amp(2,ord(2)))*cos(az(2))*cos(tilt(2)) + cos(-conflict_amp + amp(2,ord(2)))*...
% %            (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));
% %     zGL2 = -sin(amp(2,ord(2)))*sin(tilt(2)) - cos(amp(2,ord(2)))*sin(el(2))*cos(tilt(2)); 
    
% %     restM = ones(1,f*delay(1));
% %     restGL = ones(1,f*delay(2));
% %     
% %     lateralM1 = dM1*yM1;
% %     lateralRestM = restM*lateralM1(end);
% %     lateralM2 = dM2*yM2 + lateralM1(end);
% %     lateralM = [lateralM1 lateralRestM lateralM2];
% %     lateralGL1 = dGL1*yGL1;
% %     lateralRestGL = restGL*lateralGL1(end);
% %     lateralGL2 = dGL2*yGL2 + lateralGL1(end);
% %     lateralGL = [lateralGL1 lateralRestGL lateralGL2];
% %     
% %     surgeM1 = dM1*xM1;
% %     surgeRestM = restM*surgeM1(end);
% %     surgeM2 = dM2*xM2 + surgeM1(end);
% %     surgeM = [surgeM1 surgeRestM surgeM2];
% %     surgeGL1 = dGL1*xGL1;
% %     surgeRestGL = restGL*surgeGL1(end);
% %     surgeGL2 = dGL2*xGL2 + surgeGL1(end);
% %     surgeGL = [surgeGL1 surgeRestGL surgeGL2];
% %     %-----End 03/16/07---------   
% %     
% %     heaveM1 = dM1*zM1;
% %     heaveRestM = restM*heaveM1(end);
% %     heaveM2 = dM2*zM2 + heaveM1(end);
% %     heaveM = [heaveM1 heaveRestM heaveM2];
% %     heaveGL1 = dGL1*zGL1;
% %     heaveRestGL = restGL*heaveGL1(end);
% %     heaveGL2 = dGL2*zGL2 + heaveGL1(end);
% %     heaveGL = [heaveGL1 heaveRestGL heaveGL2];
    
    
%     if stim_cond == 1  % visual only
%         lateralM = zeros(length(lateralM)); 
%     end
%     if stim_cond == 2 % vestibular only
%         lateralGL = zeros(length(lateralGL));
%         i = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
% %         setappdata(appHandle,'protinfo',data)
%     end
%     if stim_cond == 3  % combined visual and vestibular
% %         Do noting and go on as planned
%     end
        
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
%     M(1).name = 'LATERAL_DATA';
%     M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
%     M(2).name = 'SURGE_DATA';
%     M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
%     M(3).name = 'HEAVE_DATA';
%     M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
%     M(4).name = 'YAW_DATA';
%     M(4).data = 90*ones(1,(dur(1,1)+delay(1)+dur(1,2))*f);
%     M(5).name = 'PITCH_DATA';
%     M(5).data = zeros(1,(dur(1,1)+delay(1)+dur(1,2))*f);
%     M(6).name = 'ROLL_DATA';
%     M(6).data = zeros(1,(dur(1,1)+delay(1)+dur(1,2))*f);
%     M(7).name = 'GL_LATERAL_DATA';
%     M(7).data = lateralGL + ori(2,1);
%     M(8).name = 'GL_SURGE_DATA';
%     M(8).data = surgeGL + ori(2,2);
%     M(9).name = 'GL_HEAVE_DATA';
%     M(9).data = heaveGL + ori(2,3);
%     M(10).name = 'GL_ROT_ELE';
%     M(10).data = 90*ones((dur(2,1)+delay(1)+dur(2,2))*f,1);
%     M(11).name = 'GL_ROT_AZ';
%     M(11).data = zeros((dur(2,1)+delay(1)+dur(2,2))*f,1);
%     M(12).name = 'GL_ROT_DATA';
%     M(12).data = zeros((dur(2,1)+delay(1)+dur(2,2))*f,1);
end
    

if motiontype == 1
%     dir_1I = amps(1,1)
      mean_head, amps(1,1), amps(2,1), intact_conflict_amp,
% else
%     if HR
%         sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amps(1,1), amps(1,2)-amps(1,1), ord, amps(1,ord(1)), amps(1,ord(2)))
%     else
%         sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amps(1,1), amps(1,2), ord, amps(1,ord(1)), amps(1,ord(2)))
%     end
end
if debug
%     if motiontype == 1
%         amps(1,1)
% %     else
% %         amps(1,2) - amps(1,1)
%     end
    mean_head, amps(1,1), amps(2,1), intact_conflict_amp,
    disp('Exiting Conflict transTrajectory');
end



