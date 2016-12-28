function [M] = PursuitWAZTrajectory(appHandle)

global debug

if debug
    disp('Entering PursuitWAZ Trajectory');
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

% Pull and assign required variables for a Translation protocol
i = strmatch('MOOG_MOTION_TYPE',{char(data.configinfo.name)},'exact');
mmt = data.configinfo(i).parameters;

i = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
stimtype = data.configinfo(i).parameters;

i = strmatch('AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Azimuth',{char(varying.name)},'exact');  %Using display name for name match 
    azP(1,1) = crossvals(cntrVarying,i1);
    azP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    azP(1,1) = across.parameters.moog(activeStair);
    azP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    azP(1,1) = within.parameters.moog(cntr);
    azP(2,1) = within.parameters.openGL(cntr);
else
    azP(1,1) = data.configinfo(i).parameters.moog;       % for static status
    azP(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Elevation',{char(varying.name)},'exact');
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
dist(1,1)=dist(1,1)/100;
dist(2,1)=dist(2,1)/100;
   
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

i = strmatch('TRAP_T1',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Trapezoid t1',{char(varying.name)},'exact');
    t1(1,1) = crossvals(cntrVarying,i1);
    t1(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    t1(1,1) = across.parameters.moog(activeStair);
    t1(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    t1(1,1) = within.parameters.moog(cntr);
    t1(2,1) = within.parameters.openGL(cntr);
else
    t1(1,1) = data.configinfo(i).parameters.moog;
    t1(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('TRAP_T2',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Trapezoid t2',{char(varying.name)},'exact');
    t2(1,1) = crossvals(cntrVarying,i1);
    t2(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    t2(1,1) = across.parameters.moog(activeStair);
    t2(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    t2(1,1) = within.parameters.moog(cntr);
    t2(2,1) = within.parameters.openGL(cntr);
else
    t2(1,1) = data.configinfo(i).parameters.moog;
    t2(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('ROT_AZIMUTH',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Azimuth',{char(varying.name)},'exact');
    razP(1,1) = crossvals(cntrVarying,i1);
    razP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    razP(1,1) = across.parameters.moog(activeStair);
    razP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    razP(1,1) = within.parameters.moog(cntr);
    razP(2,1) = within.parameters.openGL(cntr);
else
    razP(1,1) = data.configinfo(i).parameters.moog;
    razP(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('ROT_ELEVATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Elevation',{char(varying.name)},'exact');
    relP(1,1) = crossvals(cntrVarying,i1);
    relP(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    relP(1,1) = across.parameters.moog(activeStair);
    relP(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    relP(1,1) = within.parameters.moog(cntr);
    relP(2,1) = within.parameters.openGL(cntr);
else
    relP(1,1) = data.configinfo(i).parameters.moog;
    relP(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('ROT_AMPLITUDE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rotation Amplitude',{char(varying.name)},'exact');
    rdist(1,1) = crossvals(cntrVarying,i1);
    rdist(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    rdist(1,1) = across.parameters.moog(activeStair);
    rdist(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    rdist(1,1) = within.parameters.moog(cntr);
    rdist(2,1) = within.parameters.openGL(cntr);
else
    rdist(1,1) = data.configinfo(i).parameters.moog;
    rdist(2,1) = data.configinfo(i).parameters.openGL;
end
rdist(1,1) = 0;

i = strmatch('TRAP_ROT_T1',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rot Trapezoid t1',{char(varying.name)},'exact');
    rt1(1,1) = crossvals(cntrVarying,i1);
    rt1(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    rt1(1,1) = across.parameters.moog(activeStair);
    rt1(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    rt1(1,1) = within.parameters.moog(cntr);
    rt1(2,1) = within.parameters.openGL(cntr);
else
    rt1(1,1) = data.configinfo(i).parameters.moog;
    rt1(2,1) = data.configinfo(i).parameters.openGL;
end

i = strmatch('TRAP_ROT_T2',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Rot Trapezoid t2',{char(varying.name)},'exact');
    rt2(1,1) = crossvals(cntrVarying,i1);
    rt2(2,1) = crossvalsGL(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    rt2(1,1) = across.parameters.moog(activeStair);
    rt2(2,1) = across.parameters.openGL(activeStair);
elseif data.configinfo(i).status == 4   
    rt2(1,1) = within.parameters.moog(cntr);
    rt2(2,1) = within.parameters.openGL(cntr);
else
    rt2(1,1) = data.configinfo(i).parameters.moog;
    rt2(2,1) = data.configinfo(i).parameters.openGL;
end

%set ROT_START_OFFSET and M_ORIGIN based on the rotation/translation amplitude for the upcoming trial
rso(1,1) = -0.5*rdist(1,1);   %ROT_START_OFFSET
rso(2,1) = -0.5*rdist(2,1);

i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
ori(1)= -0.5*dist(1,1)*cos(azP(1,1)*pi/180);
ori(2)= -0.5*dist(1,1)*sin(azP(1,1)*pi/180);
ori(3)= data.configinfo(i).parameters(3);

%and reset the translation amplitude based on the stimulus type.
if stimtype == 2
    dist(1,1) = 0;
end;


M(1).name = 'M_ORIGIN';
M(1).data = [ori(1) ori(2) ori(3)];
M(2).name = 'MOTION_TYPE';
M(2).data = mmt;
M(3).name = 'M_AZIMUTH';
M(3).data = [azP(1,1) azP(2,1)];
M(4).name = 'M_ELEVATION';
M(4).data = [elP(1,1) elP(2,1)];
M(5).name = 'M_DIST';
M(5).data = [dist(1,1) dist(2,1)];
M(6).name = 'M_TIME';
M(6).data = [dur(1,1) dur(2,1)];
M(7).name = 'TRAPEZOID_TIME1';
M(7).data = [t1(1,1) t1(2,1)];
M(8).name = 'TRAPEZOID_TIME2';
M(8).data = [t2(1,1) t2(2,1)];
M(9).name = 'ROT_AZIMUTH';
M(9).data = [razP(1,1) razP(2,1)];
M(10).name = 'ROT_ELEVATION';
M(10).data = [relP(1,1) relP(2,1)];
M(11).name = 'ROT_AMPLITUDE';
M(11).data = [rdist(1,1) rdist(2,1)];
M(12).name = 'ROT_DURATION';
M(12).data = [dur(1,1) dur(2,1)];
M(13).name = 'TRAPEZOID_ROT_T1';
M(13).data = [rt1(1,1) rt1(2,1)];
M(14).name = 'TRAPEZOID_ROT_T2';
M(14).data = [rt2(1,1) rt2(2,1)];
M(15).name = 'ROT_START_OFFSET';
M(15).data = [rso(1,1) rso(2,1)];
M(16).name = 'FP_ON';
M(16).data = 1;

if debug
    disp('Exiting PursuitWAZ Trajectory');
end


