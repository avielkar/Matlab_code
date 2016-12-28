function [M] = rotTrajectory_K(appHandle)

global debug

if debug
    disp('Entering rotTrajectory_K')
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

%---Jing 12/20/08------
if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = cntr;
    end
end
%----End 12/20/08-------

freq = 60;
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

i = strmatch('RAMP_TIME 1', {char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Ramp Time 1 %',{char(varying.name)},'exact');
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


i = strmatch('RAMP_TIME 2',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Ramp Time 2 %',{char(varying.name)},'exact');
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

i = strmatch('VESTIB_DELAY',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Vestibula Delay Time',{char(varying.name)},'exact');
    delt = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    delt = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    delt = within.parameters(cntr);
else
    delt = data.configinfo(i).parameters;
end

i = strmatch('VESTIB_DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Vestibula Duration',{char(varying.name)},'exact');
    vesDur = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    vesDur = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    vesDur = within.parameters(cntr);
else
    vesDur = data.configinfo(i).parameters;
end

i = strmatch('VISTB_VEL',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Vestibula Velocity',{char(varying.name)},'exact');
    vestVel = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    vestVel = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    vestVel = within.parameters(cntr);
else
    vestVel = data.configinfo(i).parameters;
end

i = strmatch('VISUAL_VEL',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Visual Velocity',{char(varying.name)},'exact');
    visVel = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    visVel = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    visVel = within.parameters(cntr);
else
    visVel = data.configinfo(i).parameters;
end

%%%% Creating trajectories
dM = GenTrapezoidVel(vesDur, vestVel, rt1(1,1), rt2(1,1), freq);
dGL = GenTrapezoidVel(dur(2,1), visVel, rt1(2,1), rt2(2,1), freq);

xM(1:length(dGL)) = 0;
yM(1:length(dGL)) = 0;
zM(1:length(dGL)) = 0;
rollM(1:length(dGL)) = 0;
pitchM(1:length(dGL)) = 0;
yawM(1:length(dM)) = dM;   
 
xGL(1:length(dGL)) = 0;
yGL(1:length(dGL)) = 0;
zGL(1:length(dGL)) = 0;
rollGL(1:length(dGL)) = 1;
pitchGL(1:length(dGL)) = 1;
yawGL(1:length(dGL)) = dGL;



M(1).name = 'LATERAL_DATA';
M(1).data = xM + ori(1,1);
M(2).name = 'SURGE_DATA';
M(2).data = yM + ori(1,2);
M(3).name = 'HEAVE_DATA';
M(3).data = zM + ori(1,3);
M(4).name = 'YAW_DATA';
M(4).data = [zeros(1,delt*freq) yawM ones(1,(dur(2,1)-delt-vesDur)*freq)*yawM(end)];
M(5).name = 'PITCH_DATA';
M(5).data = pitchM;
M(6).name = 'ROLL_DATA';
M(6).data = rollM;
M(7).name = 'GL_LATERAL_DATA';
M(7).data = xGL + ori(2,1);
M(8).name = 'GL_SURGE_DATA';
M(8).data = yGL + ori(2,2);
M(9).name = 'GL_HEAVE_DATA';
M(9).data = zGL + ori(2,3);
M(10).name = 'GL_ROT_ELE';    
M(10).data = rollGL*90;
M(11).name = 'GL_ROT_AZ';  
M(11).data = pitchGL*0;
M(12).name = 'GL_ROT_DATA';   
M(12).data = yawGL;

disp('Vestibular velocity'); vestVel
disp('Exiting rotTrajectory');


