function [M] = CalTrajectory(appHandle)

global debug

if debug
    disp('Entering CalTrajectory');
end

eyeWinData = getappdata(appHandle, 'eyeWinData');
data = getappdata(appHandle, 'protinfo');
crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
activeStair = data.activeStair;
activeRule = data.activeRule;
trial = getappdata(appHandle, 'trialInfo');

cntr = trial(activeStair,activeRule).list(trial(activeStair,activeRule).cntr);

varying = data.condvect.varying;

i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Duration',{char(varying.name)},'exact');
    dur(1,1) = crossvals(cntr,i1);
    dur(2,1) = crossvalsGL(cntr,i1);
else
    dur(1,1) = data.configinfo(i).parameters.moog;
    dur(2,1) = data.configinfo(i).parameters.openGL;
end

%---Get target position-------
i = strmatch('TARG_XCTR',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Target Center (X)',{char(varying.name)},'exact');
    tagX = crossvals(cntr,i1);
else
    tagX = data.configinfo(i).parameters(1);
end

i = strmatch('TARG_YCTR',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Target Center (Y)',{char(varying.name)},'exact');
    tagY = crossvals(cntr,i1);
else
    tagY = data.configinfo(i).parameters(1);
end

i = strmatch('TARG_ZCTR',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Target Center (Z)',{char(varying.name)},'exact');
    tagZ = crossvals(cntr,i1);    
else
    tagZ = data.configinfo(i).parameters(1);
end

%---Convert deg to cm based on the Viewing Dist-----
i = strmatch('HEAD_CENTER',{char(data.configinfo.name)},'exact');
hc = data.configinfo(i).parameters;
i = strmatch('EYE_OFFSETS',{char(data.configinfo.name)},'exact');
eo = data.configinfo(i).parameters;

distV = 100-hc(2)-eo(2);
tagX = distV*tan(tagX*pi/180);
tagY = distV*tan(tagY*pi/180);
tagZ = distV*tan(tagZ*pi/180);

%---Adjust the target position to left/right eye
i = strmatch('IO_DIST',{char(data.configinfo.name)},'exact');
ioDist = data.configinfo(i).parameters;

i = strmatch('EYE_CODE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters  % Right eye
    tagX = tagX + ioDist/2.0;
    eyeWinData.isLineUpRight = 1;
    eyeWinData.isLineUpLeft = 0;
else
    tagX = tagX - ioDist/2.0;
    eyeWinData.isLineUpRight = 0;
    eyeWinData.isLineUpLeft = 1;
end
setappdata(appHandle, 'eyeWinData',eyeWinData);

f = 60;

M(1).name = 'LATERAL_DATA';
M(1).data = zeros(1,dur(1,1)*f);
M(2).name = 'SURGE_DATA';
M(2).data = zeros(1,dur(1,1)*f);
M(3).name = 'HEAVE_DATA';
M(3).data = zeros(1,dur(1,1)*f);
M(4).name = 'YAW_DATA';
M(4).data = zeros(1,dur(1,1)*f);
M(5).name = 'PITCH_DATA';
M(5).data = zeros(1,dur(1,1)*f);
M(6).name = 'ROLL_DATA';
M(6).data = zeros(1,dur(1,1)*f);
M(7).name = 'GL_LATERAL_DATA';
M(7).data = zeros(1,dur(1,1)*f);
M(8).name = 'GL_SURGE_DATA';
M(8).data = zeros(1,dur(1,1)*f);
M(9).name = 'GL_HEAVE_DATA';
M(9).data = zeros(1,dur(1,1)*f);
M(10).name = 'GL_ROT_ELE';
M(10).data = 90*ones(dur(2,1)*f,1);
M(11).name = 'GL_ROT_AZ';
M(11).data = zeros(dur(2,1)*f,1);
M(12).name = 'GL_ROT_DATA';
M(12).data = zeros(dur(2,1)*f,1);

%-----Send the target position to Moogdot-----
M(13).name = 'TARG_XCTR';
M(13).data = tagX;
M(14).name = 'TARG_YCTR';
M(14).data = tagY;
M(15).name = 'TARG_ZCTR';
M(15).data = tagZ;
M(16).name = 'FP_ON';
M(16).data = 1;

    
if debug
    disp('Exiting CalTrajectory');
end


