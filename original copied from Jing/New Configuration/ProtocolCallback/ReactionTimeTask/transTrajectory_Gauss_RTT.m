function [M] = transTrajectory_RTT(appHandle)

global debug

if debug
    disp('Entering transTrajectory_Gauss_RTT');
end

data = getappdata(appHandle, 'protinfo');
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;
crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
activeStair = data.activeStair;
activeRule = data.activeRule;
trial = getappdata(appHandle, 'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); 

cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);
HR = cldata.hReference; 

within = data.condvect.withinStair; 
across = data.condvect.acrossStair;
varying = data.condvect.varying;

%---Jing 12/20/08------
if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = cntr;
    end
end
%----End 12/20/08-------

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
% i = strmatch('DIST',{char(data.configinfo.name)},'exact');
% if data.configinfo(i).status == 2
%     i1 = strmatch('Distance',{char(varying.name)},'exact');
%     dist(1,1) = crossvals(cntr,i1);
%     dist(2,1) = crossvalsGL(cntr,i1);
% else
%     dist(1,1) = data.configinfo(i).parameters.moog;
%     dist(2,1) = data.configinfo(i).parameters.openGL;
% end
% % % commented out below to accomodate control of distance by acceleration 
% % % parameter "accel" above
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


if motiontype == 3 % 2I vars required as well
    i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Heading Direction 2nd Int',{char(varying.name)},'exact');
        amps(1,2) = crossvals(cntrVarying,i1);
        amps(2,2) = crossvalsGL(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        amps(1,2) = across.parameters.moog(activeStair);
        amps(2,2) = across.parameters.openGL(activeStair);
    elseif data.configinfo(i).status == 4
        amps(1,2) = within.parameters.moog(cntr);
        amps(2,2) = within.parameters.openGL(cntr);
    else
        amps(1,2) = data.configinfo(i).parameters.moog;
        amps(2,2) = data.configinfo(i).parameters.openGL;
    end
    if HR %----Jing added for different heading reference(Based on 1I). 03/14/07        
        amps(1,2) = amps(1,2) + amps(1,1);
        amps(2,2) = amps(2,2) + amps(2,1);
    end %--end 03/14/07---
    
    i = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Distance 2nd Int',{char(varying.name)},'exact');
        dist(1,2) = crossvals(cntrVarying,i1);
        dist(2,2) = crossvalsGL(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        dist(1,2) = across.parameters.moog(activeStair);
        dist(2,2) = across.parameters.openGL(activeStair);
    elseif data.configinfo(i).status == 4
        dist(1,2) = within.parameters.moog(cntr);
        dist(2,2) = within.parameters.openGL(cntr);
    else
        dist(1,2) = data.configinfo(i).parameters.moog;
        dist(2,2) = data.configinfo(i).parameters.openGL;
    end
    
    i = strmatch('SIGMA_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Sigma 2nd Int',{char(varying.name)},'exact');
        sig(1,2) = crossvals(cntrVarying,i1);
        sig(2,2) = crossvalsGL(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        sig(1,2) = across.parameters.moog(activeStair);
        sig(2,2) = across.parameters.openGL(activeStair);
    elseif data.configinfo(i).status == 4
        sig(1,2) = within.parameters.moog(cntr);
        sig(2,2) = within.parameters.openGL(cntr);
    else
        sig(1,2) = data.configinfo(i).parameters.moog;
        sig(2,2) = data.configinfo(i).parameters.openGL;
    end
    
    i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Delay 2nd Int',{char(varying.name)},'exact');
        delay(1) = crossvals(cntrVarying,i1);
        delay(2) = crossvalsGL(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        delay(1) = across.parameters.moog(activeStair);
        delay(2) = across.parameters.openGL(activeStair);
    elseif data.configinfo(i).status == 4
        delay(1) = within.parameters.moog(cntr);
        delay(2) = within.parameters.openGL(cntr);
    else
        delay(1) = data.configinfo(i).parameters.moog;
        delay(2) = data.configinfo(i).parameters.openGL;
    end
    
    i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Duration 2nd Int',{char(varying.name)},'exact');
        dur(1,2) = crossvals(cntrVarying,i1);
        dur(2,2) = crossvalsGL(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        dur(1,2) = across.parameters.moog(activeStair);
        dur(2,2) = across.parameters.openGL(activeStair);
    elseif data.configinfo(i).status == 4
        dur(1,2) = within.parameters.moog(cntr);
        dur(2,2) = within.parameters.openGL(cntr);
    else
        dur(1,2) = data.configinfo(i).parameters.moog;
        dur(2,2) = data.configinfo(i).parameters.openGL;
    end
    
    i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
    randOrder = data.configinfo(i).parameters;    
end


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

% 2nd Interval
if motiontype == 3
    vM2 = GenGaussian(dur(1,ord(2)), sig(1,ord(2)), dist(1,ord(2)), f);
    dM2 = cumtrapz(vM2);
    dM2 = abs(dist(1,ord(2)))*dM2(1:end-1)/max(abs(dM2));
    vGL2 = GenGaussian(dur(2,ord(2)), sig(2,ord(2)), dist(2,ord(2)), f);
    dGL2 = cumtrapz(vGL2);
    dGL2 = abs(dist(2,ord(2)))*dGL2(1:end-1)/max(abs(dGL2));
end

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

if motiontype == 1
    lateralM = dM1*yM;
    surgeM = dM1*xM;
    heaveM = dM1*zM;
    lateralGL = dGL1*yGL;
    surgeGL = dGL1*xGL;
    heaveGL = dGL1*zGL;
else
    xM1 = xM;
    yM1 = yM;
    zM1 = zM;
    xGL1 = xGL;
    yGL1 = yGL;
    zGL1 = zGL;
   
    xM2 = -sin(amp(1,ord(2)))*sin(az(1))*cos(tilt(1)) + cos(amp(1,ord(2)))*...
         (cos(az(1))*cos(el(1))+sin(az(1))*sin(tilt(1))*sin(el(1)));
    yM2 = sin(amp(1,ord(2)))*cos(az(1))*cos(tilt(1)) + cos(amp(1,ord(2)))*...
         (sin(az(1))*cos(el(1))-cos(az(1))*sin(tilt(1))*sin(el(1)));
    zM2 = -sin(amp(1,ord(2)))*sin(tilt(1)) - cos(amp(1,ord(2)))*sin(el(1))*cos(tilt(1));


    xGL2 = -sin(amp(2,ord(2)))*sin(az(2))*cos(tilt(2)) + cos(amp(2,ord(2)))*...
          (cos(az(2))*cos(el(2))+sin(az(2))*sin(tilt(2))*sin(el(2)));
    yGL2 = sin(amp(2,ord(2)))*cos(az(2))*cos(tilt(2)) + cos(amp(2,ord(2)))*...
          (sin(az(2))*cos(el(2))-cos(az(2))*sin(tilt(2))*sin(el(2)));   
    zGL2 = -sin(amp(2,ord(2)))*sin(tilt(2)) - cos(amp(2,ord(2)))*sin(el(2))*cos(tilt(2)); 
    
    restM = ones(1,f*delay(1));
    restGL = ones(1,f*delay(2));
    
    lateralM1 = dM1*yM1;
    lateralRestM = restM*lateralM1(end);
    lateralM2 = dM2*yM2 + lateralM1(end);
    lateralM = [lateralM1 lateralRestM lateralM2];
    lateralGL1 = dGL1*yGL1;
    lateralRestGL = restGL*lateralGL1(end);
    lateralGL2 = dGL2*yGL2 + lateralGL1(end);
    lateralGL = [lateralGL1 lateralRestGL lateralGL2];
    
    surgeM1 = dM1*xM1;
    surgeRestM = restM*surgeM1(end);
    surgeM2 = dM2*xM2 + surgeM1(end);
    surgeM = [surgeM1 surgeRestM surgeM2];
    surgeGL1 = dGL1*xGL1;
    surgeRestGL = restGL*surgeGL1(end);
    surgeGL2 = dGL2*xGL2 + surgeGL1(end);
    surgeGL = [surgeGL1 surgeRestGL surgeGL2]; 
    
    heaveM1 = dM1*zM1;
    heaveRestM = restM*heaveM1(end);
    heaveM2 = dM2*zM2 + heaveM1(end);
    heaveM = [heaveM1 heaveRestM heaveM2];
    heaveGL1 = dGL1*zGL1;
    heaveRestGL = restGL*heaveGL1(end);
    heaveGL2 = dGL2*zGL2 + heaveGL1(end);
    heaveGL = [heaveGL1 heaveRestGL heaveGL2];
        
end 
   
if motiontype == 1
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
else
    M(1).name = 'LATERAL_DATA';
    M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(2).name = 'SURGE_DATA';
    M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(3).name = 'HEAVE_DATA';
    M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(4).name = 'YAW_DATA';
    M(4).data = 90*ones(1,(dur(1,1)+delay(1)+dur(1,2))*f);
    M(5).name = 'PITCH_DATA';
    M(5).data = zeros(1,(dur(1,1)+delay(1)+dur(1,2))*f);
    M(6).name = 'ROLL_DATA';
    M(6).data = zeros(1,(dur(1,1)+delay(1)+dur(1,2))*f);
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = lateralGL + ori(2,1);
    M(8).name = 'GL_SURGE_DATA';
    M(8).data = surgeGL + ori(2,2);
    M(9).name = 'GL_HEAVE_DATA';
    M(9).data = heaveGL + ori(2,3);
    M(10).name = 'GL_ROT_ELE';
    M(10).data = 90*ones((dur(2,1)+delay(1)+dur(2,2))*f,1);
    M(11).name = 'GL_ROT_AZ';
    M(11).data = zeros((dur(2,1)+delay(1)+dur(2,2))*f,1);
    M(12).name = 'GL_ROT_DATA';
    M(12).data = zeros((dur(2,1)+delay(1)+dur(2,2))*f,1);
end

%=====For different stimulus type sending different trajectory=====
iBackground = strmatch('BACKGROUND_ON',{char(data.configinfo.name)},'exact');
data.configinfo(iBackground).parameters = 1.0;
% % old part written by Jing
% i_CST = strmatch({char(data.condvect.varying.name)},'Stimulus Type','exact');
% if ~isempty(i_CST)
%     if crossvals(trial.list(trial.cntr),i_CST)==0    %Visual only
%         for i=1:6
%             M(i).data=0*M(i).data;
%         end
%     elseif crossvals(trial.list(trial.cntr),i_CST)==1     %Vestibular only
%         for i=7:12
%             M(i).data=0*M(i).data;
%         end
%         data.configinfo(iBackground).parameters = 0.0;
%     end
% else
%     i_ST = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i_ST).parameters == 0         %Visual only
%         for i=1:6
%             M(i).data=0*M(i).data;
%         end
%     elseif data.configinfo(i_ST).parameters == 1     %Vestibular only
%         for i=7:12
%             M(i).data=0*M(i).data;
%         end
%         data.configinfo(iBackground).parameters = 0.0;
%     end        
% end






% % % new part written by Tunde
i_CST = strmatch({char(data.condvect.varying.name)},'Stimulus Type','exact');
if ~isempty(i_CST)
    if crossvals(trial.list(trial.cntr),i_CST)==0    %Visual only
        M(1).data= ori(1,1) * ones(1, length(M(1).data));
        M(2).data= ori(1,2) * ones(1, length(M(2).data));
        M(3).data= ori(1,3) * ones(1, length(M(3).data));
        M(4).data= 0 * ones(1, length(M(4).data));
        M(5).data= 0 * ones(1, length(M(5).data));
        M(6).data= 0 * ones(1, length(M(6).data));
    elseif crossvals(trial.list(trial.cntr),i_CST)==1     %Vestibular only
        for i=7:12
            M(i).data=0*M(i).data;
        end
        data.configinfo(iBackground).parameters = 0.0;
    end
else
    i_ST = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');

    if data.configinfo(i_ST).status == 2
        i1 = strmatch('Stimulus Type',{char(varying.name)},'exact');
        stm_type = crossvals(cntrVarying,i1);

        if stm_type == 0         %Visual only
            M(1).data= ori(1,1) * ones(1, length(M(1).data));
            M(2).data= ori(1,2) * ones(1, length(M(2).data));
            M(3).data= ori(1,3) * ones(1, length(M(3).data));
            M(4).data= 0 * ones(1, length(M(4).data));
            M(5).data= 0 * ones(1, length(M(5).data));
            M(6).data= 0 * ones(1, length(M(6).data));
        elseif stm_type == 1     %Vestibular only
            for i=7:12
                M(i).data=0*M(i).data;
            end
            data.configinfo(iBackground).parameters = 0.0;
        end
    elseif data.configinfo(i_ST).status == 1 %same as before
        i_CST = strmatch({char(data.condvect.varying.name)},'Stimulus Type','exact');
        if ~isempty(i_CST)
            if crossvals(trial.list(trial.cntr),i_CST)==0    %Visual only
                M(1).data= ori(1,1) * ones(1, length(M(1).data));
                M(2).data= ori(1,2) * ones(1, length(M(2).data));
                M(3).data= ori(1,3) * ones(1, length(M(3).data));
                M(4).data= 0 * ones(1, length(M(4).data));
                M(5).data= 0 * ones(1, length(M(5).data));
                M(6).data= 0 * ones(1, length(M(6).data));
            elseif crossvals(trial.list(trial.cntr),i_CST)==1     %Vestibular only
                for i=7:12
                    M(i).data=0*M(i).data;
                end
                data.configinfo(iBackground).parameters = 0.0;
            end
        else
            i_ST = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
            if data.configinfo(i_ST).parameters == 0         %Visual only

                M(1).data= ori(1,1) * ones(1, length(M(1).data));
                M(2).data= ori(1,2) * ones(1, length(M(2).data));
                M(3).data= ori(1,3) * ones(1, length(M(3).data));
                M(4).data= 0 * ones(1, length(M(4).data));
                M(5).data= 0 * ones(1, length(M(5).data));
                M(6).data= 0 * ones(1, length(M(6).data));

            elseif data.configinfo(i_ST).parameters == 1     %Vestibular only
                for i=7:12
                    M(i).data=0*M(i).data;
                end
                data.configinfo(iBackground).parameters = 0.0;
            end
        end
    end

end















% % % % new part written by Tunde
% % i_CST = strmatch({char(data.condvect.varying.name)},'Stimulus Type','exact');
% % if ~isempty(i_CST)
% %     if crossvals(trial.list(trial.cntr),i_CST)==0    %Visual only
% % %         for i=1:3
% %             M(1).data= ori(1,1) * ones(1, length(M(1).data));
% %             M(2).data= ori(1,2) * ones(1, length(M(2).data));
% %             M(3).data= ori(1,3) * ones(1, length(M(3).data));
% %             M(4).data= 0 * ones(1, length(M(4).data));
% %             M(5).data= 0 * ones(1, length(M(5).data));
% %             M(6).data= 0 * ones(1, length(M(6).data));
% % %         end
% %     elseif crossvals(trial.list(trial.cntr),i_CST)==1     %Vestibular only
% %         for i=7:12
% %             M(i).data=0*M(i).data;
% %         end
% %         data.configinfo(iBackground).parameters = 0.0;
% %     end
% % else
% %     i_ST = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
% %     if data.configinfo(i_ST).parameters == 0         %Visual only
% % %         for i=1:6
% %             M(1).data= ori(1,1) * ones(1, length(M(1).data));
% %             M(2).data= ori(1,2) * ones(1, length(M(2).data));
% %             M(3).data= ori(1,3) * ones(1, length(M(3).data));
% %             M(4).data= 0 * ones(1, length(M(4).data));
% %             M(5).data= 0 * ones(1, length(M(5).data));
% %             M(6).data= 0 * ones(1, length(M(6).data));            
% % %         end
% %     elseif data.configinfo(i_ST).parameters == 1     %Vestibular only
% %         for i=7:12
% %             M(i).data=0*M(i).data;
% %         end
% %         data.configinfo(iBackground).parameters = 0.0;
% %     end        
% % end

setappdata(appHandle, 'protinfo', data);
%========End============================================================

% %==== Special parameter for tunnel =========
% tmpInd = 13;
% i = strmatch('TUNNEL_ELEVATION',{char(data.configinfo.name)},'exact');
% if ~isempty(i)
%     M(tmpInd).name = 'TUNNEL_ELEVATION';
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Tunnel Elevation',{char(varying.name)},'exact');
%         tmpAng = crossvals(cntrVarying,i1);
%     elseif data.configinfo(i).status == 3
%         tmpAng = across.parameters(activeStair);
%     elseif data.configinfo(i).status == 4
%         tmpAng = within.parameters(cntr);
%     else
%         tmpAng = data.configinfo(i).parameters;
%     end
% else
%     i_ST = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i_ST).parameters == 0         %Visual only
%         for i=1:6
%             M(i).data=0*M(i).data;
%         end
%     elseif data.configinfo(i_ST).parameters == 1     %Vestibular only
%         for i=7:12
%             M(i).data=0*M(i).data;
%         end
%         data.configinfo(iBackground).parameters = 0.0;
%     end        
% end
% setappdata(appHandle, 'protinfo', data);
% %========End============================================================    

if motiontype == 1
    sprintf('amp=%f', amps(1,1))
else
    if HR
        sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amps(1,1), amps(1,2)-amps(1,1), ord, amps(1,ord(1)), amps(1,ord(2)))
    else
        sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amps(1,1), amps(1,2), ord, amps(1,ord(1)), amps(1,ord(2)))
    end
end
if debug
    disp('Exiting transTrajectory_Gauss_RTT');
end


