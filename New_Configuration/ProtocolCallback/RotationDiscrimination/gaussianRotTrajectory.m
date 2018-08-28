function [M] = gaussianRotTrajectory(appHandle)

CENTROID_OFFSET_X=0.0;
CENTROID_OFFSET_Y=0.0;
CENTROID_OFFSET_Z=122.0;
platformCenter=zeros(1,3);

global debug

COMBOARDNUM = 0;

if debug
    disp('Entering gaussianRot Trajectory');
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

if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = cntr;
    end
end

i = strmatch('ROT_CENTER_OFFSETS',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Center Offsets',{char(varying.name)},'exact');
    rco(1,1) = crossvals(cntrVarying,i1);
    rco(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3
    rco(1,1) = across.parameters.moog(activeStair);
    rco(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4
    rco(1,1) = within.parameters.moog(cntr);
    rco(2,1) = within.parameters.openGL(cntr);
else
    rco(1,:) = data.configinfo(i).parameters.moog;
    rco(2,:) = data.configinfo(i).parameters.openGL;
end
outString = ['ROT_CENTER_OFFSETS' ' ' num2str(rco(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);


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
outString = ['ORIGIN' ' ' num2str(ori(1 , :))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);


i = strmatch('ROT_ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Elevation',{char(varying.name)},'exact');
    el(1,1) = crossvals(cntrVarying,i1);
    el(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3
    el(1,1) = across.parameters.moog(activeStair);
    el(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4
    el(1,1) = within.parameters.moog(cntr);
    el(2,1) = within.parameters.openGL(cntr);
else
    el(1,1) = data.configinfo(i).parameters.moog;
    el(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['ROT_ELEVATION' ' ' num2str(el(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);


% i = strmatch('ROT_ELEVATION_OFFSET',{char(data.configinfo.name)},'exact');
% if data.configinfo(i).status == 2
%     i1 = strmatch('Rotation Elevation Offset',{char(varying.name)},'exact');
%     elOffset(1,1) = crossvals(cntrVarying,i1);
%     elOffset(2,1) = crossvalsGL(cntrVarying,i1);
% elseif data.configinfo(i).status == 3
%     elOffset(1,1) = across.parameters.moog(activeStair);
%     elOffset(2,1) = across.parameters.openGL(activeStair);
% elseif data.configinfo(i).status == 4
%     elOffset(1,1) = within.parameters.moog(cntr);
%     elOffset(2,1) = within.parameters.openGL(cntr);
% else
%     elOffset(1,1) = data.configinfo(i).parameters.moog;
%     elOffset(2,1) = data.configinfo(i).parameters.openGL;
% end
elOffset(1,1) = 0;
elOffset(2,1) = 0;

i = strmatch('ROT_AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Azimuth',{char(varying.name)},'exact');
    az(1,1) = crossvals(cntrVarying,i1);
    az(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3
    az(1,1) = across.parameters.moog(activeStair);
    az(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4
    az(1,1) = within.parameters.moog(cntr);
    az(2,1) = within.parameters.openGL(cntr);
else
    az(1,1) = data.configinfo(i).parameters.moog;
    az(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['ROT_AZIMUTH' ' ' num2str(az(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

% i = strmatch('ROT_AZIMUTH_OFFSET',{char(data.configinfo.name)},'exact');
% if data.configinfo(i).status == 2
%     i1 = strmatch('Rotation Azimuth Offset',{char(varying.name)},'exact');
%     azOffset(1,1) = crossvals(cntrVarying,i1);
%     azOffset(2,1) = crossvalsGL(cntrVarying,i1);
% elseif data.configinfo(i).status == 3
%     azOffset(1,1) = across.parameters.moog(activeStair);
%     azOffset(2,1) = across.parameters.openGL(activeStair);
% elseif data.configinfo(i).status == 4
%     azOffset(1,1) = within.parameters.moog(cntr);
%     azOffset(2,1) = within.parameters.openGL(cntr);
% else
%     azOffset(1,1) = data.configinfo(i).parameters.moog;
%     azOffset(2,1) = data.configinfo(i).parameters.openGL;
% end
azOffset(1,1) = 0;
azOffset(2,1) = 0;

i = strmatch('ROT_AMPLITUDE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Amplitude',{char(varying.name)},'exact');
    amp(1,1) = crossvals(cntrVarying,i1);
    amp(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3
    amp(1,1) = across.parameters.moog(activeStair);
    amp(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4
    amp(1,1) = within.parameters.moog(cntr);
    amp(2,1) = within.parameters.openGL(cntr);
else
    amp(1,1) = data.configinfo(i).parameters.moog;
    amp(2,1) = data.configinfo(i).parameters.openGL;
end
outString = ['ROT_AMPLITUDE' ' ' num2str(amp(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('ROT_SIGMA',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Sigma',{char(varying.name)},'exact');
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
outString = ['ROT_SIGMA' ' ' num2str(sig(1))];
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
outString = ['ROT_DURATION' ' ' num2str(dur(1,:))];
cbDWriteString(COMBOARDNUM, sprintf('%s\n', outString), 5);

i = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
hc = data.configinfo(i).parameters;

if motiontype == 3 % 2I vars required as well    
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
        
    i = strmatch('ROT_ELEVATION_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Elevation 2nd Int',{char(varying.name)},'exact');
        el(1,2) = crossvals(cntrVarying,i1);
        el(2,2) = crossvalsGL(cntrVarying,i1);
    else
        el(1,2) = data.configinfo(i).parameters.moog;
        el(2,2) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_AZIMUTH_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Azimuth 2nd Int',{char(varying.name)},'exact');
        az(1,2) = crossvals(cntrVarying,i1);
        az(2,2) = crossvalsGL(cntrVarying,i1);
    else
        az(1,2) = data.configinfo(i).parameters.moog;
        az(2,2) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_AMPLITUDE_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Amplitude 2nd Int',{char(data.condvect.name)},'exact');
        amp(1,2) = crossvals(cntrVarying,i1);
        amp(2,2) = crossvalsGL(cntrVarying,i1);
    else
        amp(1,2) = data.configinfo(i).parameters.moog;
        amp(2,2) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Duration 2nd Int',{char(varying.name)},'exact');
        dur(1,2) = crossvals(cntrVarying,i1);
        dur(2,2) = crossvalsGL(cntrVarying,i1);
    else
        dur(1,2) = data.configinfo(i).parameters.moog;
        dur(2,2) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_SIGMA_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Sigma 2nd Int',{char(varying.name)},'exact');
        sig(1,2) = crossvals(cntrVarying,i1);
        sig(2,2) = crossvalsGL(cntrVarying,i1);
    else
        sig(1,2) = data.configinfo(i).parameters.moog;
        sig(2,2) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Delay 2nd Int',{char(varying.name)},'exact');
        delay(1) = crossvals(cntrVarying,i1);
        delay(2) = crossvalsGL(cntrVarying,i1);
    else
        delay(1) = data.configinfo(i).parameters.moog;
        delay(2) = data.configinfo(i).parameters.openGL;
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
vM1 = GenGaussian(dur(1,ord(1)), sig(1,ord(1)), amp(1,ord(1)), f);
dM1 = cumtrapz(vM1);
dM1 = abs(amp(1,ord(1)))*dM1(1:end-1)/max(abs(dM1));
vGL1 = GenGaussian(dur(2,ord(1)), sig(2,ord(1)), amp(2,ord(1)), f);
dGL1 = cumtrapz(vGL1);
dGL1 = abs(amp(2,ord(1)))*dGL1(1:end-1)/max(abs(dGL1));

% 2nd Interval
if motiontype == 3
    vM2 = GenGaussian(dur(1,ord(2)), sig(1,ord(2)), amp(1,ord(2)), f);
    dM2 = cumtrapz(vM2);
    dM2 = abs(amp(1,ord(2)))*dM2(1:end-1)/max(abs(dM2));
    vGL2 = GenGaussian(dur(2,ord(2)), sig(2,ord(2)), amp(2,ord(2)), f);
    dGL2 = cumtrapz(vGL2);
    dGL2 = abs(amp(2,ord(2)))*dGL2(1:end-1)/max(abs(dGL2));
end

point.x = platformCenter(1) + ori(1,1); 
point.y = platformCenter(2) + ori(1,2);
point.z = platformCenter(3) + ori(1,3);
    
rotPoint.x = hc(1) + CENTROID_OFFSET_X + rco(1,1) + ori(1,1); % offset center of platform to rotation reference
rotPoint.y = hc(2) + CENTROID_OFFSET_Y + rco(1,2) + ori(1,2);
rotPoint.z = hc(3) + CENTROID_OFFSET_Z + rco(1,3) + ori(1,3);

% Convert angles from degrees to radians.
% 1st Interval
rotElevationM1 = (el(1,ord(1))-elOffset(1,ord(1))) * pi/180;
rotAzimuthM1 = (az(1,ord(1))-azOffset(1,ord(1))) * pi/180;
rotElevationGL1 = (el(2,ord(1))+elOffset(2,ord(1))) * pi/180;
rotAzimuthGL1 = (az(2,ord(1))+azOffset(2,ord(1))) * pi/180;

if motiontype == 3
    % Convert angles from degrees to radians.
    % 2nd Interval
    rotElevationM2 = (el(1,ord(2))-elOffset(1,ord(2))) * pi/180;
    rotAzimuthM2 = (az(1,ord(2))-azOffset(1,ord(2))) * pi/180;
    rotElevationGL2 = (el(2,ord(2))+elOffset(2,ord(2))) * pi/180;
    rotAzimuthGL2 = (az(2,ord(2))+azOffset(2,ord(2))) * pi/180;
end

% We have to negate these 2 angles to make 90 degrees elevation point straight up and 90 degrees
% azimuth point forward.
rotAzimuthM1 = -rotAzimuthM1;
rotElevationM1 = -rotElevationM1;
rotAzimuthGL1 = -rotAzimuthGL1;
rotElevationGL1 = -rotElevationGL1;

if motiontype == 3
    rotAzimuthM2 = -rotAzimuthM2;
    rotElevationM2 = -rotElevationM2;
    rotAzimuthGL2 = -rotAzimuthGL2;
    rotElevationGL2 = -rotElevationGL2;
end


%  Calculate the rotation vector.
[rotationVectorM1.x rotationVectorM1.y rotationVectorM1.z] = sph2cart(rotAzimuthM1, rotElevationM1, 1);
[rotationVectorGL1.x rotationVectorGL1.y rotationVectorGL1.z] = sph2cart(rotAzimuthGL1, rotElevationGL1, 1);

if motiontype == 3
    [rotationVectorM2.x rotationVectorM2.y rotationVectorM2.z] = sph2cart(rotAzimuthM2, rotElevationM2, 1);
    [rotationVectorGL2.x rotationVectorGL2.y rotationVectorGL2.z] = sph2cart(rotAzimuthGL2, rotElevationGL2, 1);
end

dM1 = dM1 * pi/180;
dGL1 = dGL1 * pi/180;

if motiontype == 3
    dM2 = dM2 * pi/180;
    dGL2 = dGL2 * pi/180;
end

[xvalM1,yvalM1,zvalM1,pitchM1,rollM1,yawM1]=RotatePointAboutPoint(point, rotPoint,rotElevationM1,rotAzimuthM1,dM1,rotationVectorM1,dur(1,ord(1))*f);

xvalGL1=zeros(1,length(dGL1));
yvalGL1=zeros(1,length(dGL1));
zvalGL1=zeros(1,length(dGL1));
%zvalGL1=-zvalGL*22.86;

if motiontype == 3
    [xvalM2,yvalM2,zvalM2,pitchM2,rollM2,yawM2]=RotatePointAboutPoint(point, rotPoint,rotElevationM2,rotAzimuthM2,dM2,rotationVectorM2,dur(1,ord(2))*f);
    xvalGL2=zeros(1,length(dGL2));
    yvalGL2=zeros(1,length(dGL2));
    zvalGL2=zeros(1,length(dGL2));
end


if motiontype == 3
    restM = ones(1,delay(1)*f);
    restGL = ones(1,delay(2)*f);
    restxM = restM * xvalM1(end);
    restyM = restM * yvalM1(end);
    restzM = restM * zvalM1(end);
    restxGL = restGL * xvalGL1(end);
    restyGL = restGL * yvalGL1(end);
    restzGL = restGL * zvalGL1(end);
    
    xvalM = [xvalM1 restxM (xvalM2 + xvalM1(end))];
    yvalM = [yvalM1 restyM (yvalM2 + yvalM1(end))];
    zvalM = [xvalM1 restzM (zvalM2 + zvalM1(end))];
    xvalGL = [xvalGL1 restxGL (xvalGL2 + xvalGL1(end))];
    yvalGL = [yvalGL1 restyGL (yvalGL2 + yvalGL1(end))];
    zvalGL = [xvalGL1 restzGL (zvalGL2 + zvalGL1(end))];
    
    restPM = restM * pitchM1(end);
    restRM = restM * rollM1(end);
    restYM = restM * yawM1(end);
    restEGL = restGL * rotElevationGL1(end);
    restAGL = restGL * rotAzimuthGL1(end);
    restDGL = restGL * dGL1(end);
    
    pitchM = [pitchM1 restPM (pitchM2 + pitchM1(end))];
    rollM = [rollM1 restRM (rollM2 + rollM1(end))];
    yawM = [yawM1 restYM (yawM2 + yawM1(end))];
    EleGL = [ones(1,dur(1,ord(1))*f)*rotElevationGL1 restEGL (ones(1,dur(1,ord(2))*f)*rotElevationGL2 + rotElevationGL1(end))]*180/pi;
    AziGL = [ones(1,dur(1,ord(1))*f)*rotAzimuthGL1 restAGL (ones(1,dur(1,ord(2))*f)*rotAzimuthGL2 + rotAzimuthGL1(end))]*180/pi;
    DataGL = [dGL1 restDGL (dGL2 + dGL1(end))]*180/pi;
else
    xvalM = xvalM1;
    yvalM = yvalM1;
    zvalM = zvalM1;
    xvalGL = xvalGL1;
    yvalGL = yvalGL1;
    zvalGL = zvalGL1;
    pitchM = pitchM1;
    rollM = rollM1;
    yawM = yawM1;
    EleGL = ones(1,dur(1,ord(1))*f)*rotElevationGL1*180/pi;
    AziGL = ones(1,dur(1,ord(1))*f)*rotAzimuthGL1*180/pi;
    DataGL = dGL1*180/pi;
end
    
M(1).name = 'LATERAL_DATA';
M(1).data = xvalM;
M(2).name = 'SURGE_DATA';
M(2).data = yvalM;
M(3).name = 'HEAVE_DATA';
M(3).data = zvalM;
M(4).name = 'YAW_DATA';
M(4).data = yawM;
M(5).name = 'PITCH_DATA';
M(5).data = pitchM;
M(6).name = 'ROLL_DATA';
M(6).data = rollM;
M(7).name = 'GL_LATERAL_DATA';
M(7).data = xvalGL;
M(8).name = 'GL_SURGE_DATA';
M(8).data = yvalGL;
M(9).name = 'GL_HEAVE_DATA';
M(9).data = zvalGL;
M(10).name = 'GL_ROT_ELE';
M(10).data = EleGL;
M(11).name = 'GL_ROT_AZ';
M(11).data = AziGL;
M(12).name = 'GL_ROT_DATA';
M(12).data = DataGL;



if motiontype == 1
    dir_1I = amp(1,1)
else
    if HR
        sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amp(1,1), amp(1,2)-amp(1,1), ord, amp(1,ord(1)), amp(1,ord(2)))
    else
        sprintf('amp1=%f  amp2=%f  ord=%d %d  dir1=%f  dir2=%f', amp(1,1), amp(1,2), ord, amp(1,ord(1)), amp(1,ord(2)))
    end
end
if debug
    if motiontype == 1
        amp(1,1)
    else
        amp(1,2) - amp(1,1)
    end
    disp('Exiting gaussianRot')
end
