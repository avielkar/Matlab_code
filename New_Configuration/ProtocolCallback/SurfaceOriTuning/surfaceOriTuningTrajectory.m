function [M] = surfaceOriTuningTrajectory(appHandle)

global debug

if debug
    disp('Entering surfaceOriTuning Trajectory');
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

%==== Special parameters for Dots Disparity   =========
i = strmatch('I_DOTS_HGRAD_MAG',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Dots HGrad Mag',{char(varying.name)},'exact');
    fplane_yaw(1,1) = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3   
    fplane_yaw(1,1) = across.parameters(activeStair);   
elseif data.configinfo(i).status == 4   
    fplane_yaw(1,1) = within.parameters(cntr);  
else
    fplane_yaw(1,1) = data.configinfo(i).parameters;   
end

i = strmatch('I_DOTS_HGRAD_ANGLE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Dots HGrad Angle',{char(varying.name)},'exact');
    fplane_roll(1,1) = crossvals(cntrVarying,i1);    
elseif data.configinfo(i).status == 3   
    fplane_roll(1,1) = across.parameters(activeStair);    
elseif data.configinfo(i).status == 4   
    fplane_roll(1,1) = within.parameters(cntr);   
else
    fplane_roll(1,1) = data.configinfo(i).parameters;    
end

i = strmatch('I_DOTS_HDISP',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Dots Hor Disparity',{char(varying.name)},'exact');
    fplane_hdisp(1,1) = crossvals(cntrVarying,i1);    
elseif data.configinfo(i).status == 3   
    fplane_hdisp(1,1) = across.parameters(activeStair);    
elseif data.configinfo(i).status == 4   
    fplane_hdisp(1,1) = within.parameters(cntr);   
else
    fplane_hdisp(1,1) = data.configinfo(i).parameters;    
end

i = strmatch('ENABLE_HDISP_2I',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1
    j=ceil(rand*length(crossvals));
    fplane_hdisp(1,2) = crossvals(j,i1);  
else
    fplane_hdisp(1,2) = fplane_hdisp(1,1);
end;



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
    
    i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
    randOrder = data.configinfo(i).parameters;   
    
    %==== Special parameters for FPlane =========
    i = strmatch('I_DOTS_HGRAD_MAG2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Dots HGrad Mag 2nd Int',{char(varying.name)},'exact');
        fplane_yaw(1,2) = crossvals(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        fplane_yaw(1,2) = across.parameters(activeStair);
    elseif data.configinfo(i).status == 4
        fplane_yaw(1,2) = within.parameters(cntr);
    else
        fplane_yaw(1,2) = data.configinfo(i).parameters;
    end
    if HR && data.configinfo(i).status == 4  
        fplane_yaw(1,2) = fplane_yaw(1,2) + fplane_yaw(1,1);
    end

    i = strmatch('I_DOTS_HGRAD_ANGLE2I',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Dots HGrad Angle 2nd Int',{char(varying.name)},'exact');
        fplane_roll(1,2) = crossvals(cntrVarying,i1);
    elseif data.configinfo(i).status == 3
        fplane_roll(1,2) = across.parameters(activeStair);
    elseif data.configinfo(i).status == 4
        fplane_roll(1,2) = within.parameters(cntr);
    else
        fplane_roll(1,2) = data.configinfo(i).parameters;
    end
    
    if HR && data.configinfo(i).status == 4   
        fplane_roll(1,2) = fplane_roll(1,2) + fplane_roll(1,1);
    end 
end

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

%==== Special parameters for FPlane =========
M(1).name = 'FPLANE_DUR';
M(1).data = dur(1,ord(1));
M(2).name = 'FPLANE_DUR_2I';
M(2).data = dur(1,ord(2));
M(3).name = 'FPLANE_DELAY_2I';
M(3).data = delay(1);
M(4).name = 'I_DOTS_HGRAD_MAG';
M(4).data = fplane_yaw(1,ord(1));
M(5).name = 'I_DOTS_HGRAD_ANGLE';
M(5).data = fplane_roll(1,ord(1));
M(6).name = 'I_DOTS_HGRAD_MAG2I';
M(6).data = fplane_yaw(1,ord(2));
M(7).name = 'I_DOTS_HGRAD_ANGLE2I';
M(7).data = fplane_roll(1,ord(2));
M(8).name = 'I_DOTS_HDISP';
M(8).data = fplane_hdisp(1,ord(1));
M(9).name = 'I_DOTS_HDISP2I';
M(9).data = fplane_hdisp(1,ord(2));
M(10).name = 'ENABLE_FPLANE_2I';
if motiontype == 3
    M(10).data = 1;
else
    M(10).data = 0;
end;

    

if motiontype == 1
    sprintf('yaw=%f roll=%f', fplane_yaw(1,1), fplane_roll(1,1))
else
    if HR
        sprintf('yaw1=%f  yaw2=%f  ord=%d %d  dir1=%f  dir2=%f', fplane_yaw(1,1), fplane_yaw(1,2)-fplane_yaw(1,1), ord, ...
                 fplane_yaw(1,ord(1)), fplane_yaw(1,ord(2)))
        sprintf('roll1=%f  roll2=%f  ord=%d %d  dir1=%f  dir2=%f', fplane_roll(1,1), fplane_roll(1,2)-fplane_roll(1,1), ord, ...
                 fplane_roll(1,ord(1)), fplane_roll(1,ord(2)))
    else
        sprintf('yaw1=%f  yaw2=%f  ord=%d %d  dir1=%f  dir2=%f', fplane_yaw(1,1), fplane_yaw(1,2), ord, ...
                 fplane_yaw(1,ord(1)), fplane_yaw(1,ord(2)))
        sprintf('roll1=%f  roll2=%f  ord=%d %d  dir1=%f  dir2=%f', fplane_roll(1,1), fplane_roll(1,2), ord, ...
                 fplane_roll(1,ord(1)), fplane_roll(1,ord(2)))
    end
end
if debug
    disp('Exiting surfaceOriTuning Trajectory');
end


