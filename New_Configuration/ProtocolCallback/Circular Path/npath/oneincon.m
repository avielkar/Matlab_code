function [M] = oneincon(appHandle)

global debug

if debug
    disp('Entering oneincon');
end

% Load necessary variables
Resp = getappdata(appHandle,'ResponseInfo');
%data = getappdata(appHandle, 'protinfo');
% crossvals = getappdata(appHandle, 'CrossVals') % Use data.condvect
% crossvalsGL = getappdata(appHandle, 'CrossValsGL'); % Use data.condvect
% trial = getappdata(appHandle, 'trialInfo'); % Use stairInfo
%i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
%motiontype = data.configinfo(i).parameters;
cldata = getappdata(appHandle,'ControlLoopData');

%Baili
   data = getappdata(appHandle, 'protinfo');
   i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
   motiontype = data.configinfo(i).parameters;
   crossvals = getappdata(appHandle, 'CrossVals');
   crossvalsGL = getappdata(appHandle, 'CrossValsGL');
   trial = getappdata(appHandle, 'trialInfo');
   cntr = trial.list(trial.cntr);
%end Baili



if isempty(Resp) % If first trial, initialize stairInfo, and change trial time for oddity
    
    % change trial time
    i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
    dur1 = data.configinfo(i).parameters.moog(1);
%     i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
%     dur2 = data.configinfo(i).parameters.moog(1);
%     i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
%     del = data.configinfo(i).parameters.moog(1);



    i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).parameters ~= 3
        cldata.mainStageTime = dur1;
    end
    i = strmatch('WAIT_FOR_RESP',{char(data.configinfo.name)},'exact');
    cldata.respTime=data.configinfo(i).parameters;
    setappdata(appHandle,'ControlLoopData',cldata);  
    
    % Get staircase info (each direction is a different staircase)
    stairInfo.stairs = [30]; % Hardcode this becasue of the way direction is handled
    stairInfo.numStairs = size(stairInfo.stairs,2);

    % Get staircase steps (each distance is a different step)
%     %if ~isempty(strmatch('Radius of Curve',{char(data.condvect.name)},'exact'))
%         i1 = strmatch('Radius of Curve',{char(data.condvect.name)},'exact');
%         stairInfo.steps = data.condvect(i1).parameters.moog;
%     else % default (should be set another way)
        stairInfo.steps = 1;
    %end
    stairInfo.numSteps = size(stairInfo.steps,2);
    
    % stairInfo.currStair (random)
    stairInfo.currStair = round(rand*stairInfo.numStairs + 0.5);
    
    % stairInfo.currStep (end of range)
    stairInfo.currStep = ones(1,stairInfo.numStairs)*stairInfo.numSteps;
    
    % stairInfo.trialCount (equal to one)
    stairInfo.trialCount = ones(1,stairInfo.numStairs);
    
    % Load stairInfo
    %stairInfo;
    setappdata(appHandle,'stairInfo',stairInfo);  
else
    stairInfo = getappdata(appHandle, 'stairInfo');
end



% Get info from stairInfo
currStair = stairInfo.currStair;
currStep = stairInfo.currStep(currStair);
directions = stairInfo.stairs;
directionsGL = directions; % no conflict for now
amplitudes = stairInfo.steps;
amplitudesGL = amplitudes; % no conflict for now

% Pull and assign required variables for a Translation protocol
i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Origin',{char(data.condvect.name)},'exact');
%     ori(1,:) = [crossvals(cntr,i1) crossvals(cntr,i1) crossvals(cntr,i1)];
%     ori(2,:) = [crossvalsGL(cntr,i1) crossvalsGL(cntr,i1) crossvalsGL(cntr,i1)];
else
    ori(1,:) = data.configinfo(i).parameters;
    ori(2,:) = data.configinfo(i).parameters;
end
%Baili
i = strmatch('PATH_ROT_SIGMA',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Curve Sigma',{char(data.condvect.name)},'exact');
%     cursig = crossvals(cntr,i1);
%     cursigGL = crossvalsGL(cntr,i1);
else
    cursig = data.configinfo(i).parameters.moog;
    cursigGL = data.configinfo(i).parameters.openGL;
end

i = strmatch('PATH_ROT_AMP',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Curve Amp',{char(data.condvect.name)},'exact');
%     curamp = crossvals(cntr,i1);
%     curampGL = crossvalsGL(cntr,i1);
else
    curamp = data.configinfo(i).parameters.moog;
    curampGL = data.configinfo(i).parameters.openGL;
end



i = strmatch('INITIAL_DIRECTION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Initital Direction',{char(data.condvect.name)},'exact');
%     ini_dir = crossvals(cntr,i1);
%     ini_dirGL = crossvalsGL(cntr,i1);
else
    ini_dir = data.configinfo(i).parameters.moog;
    ini_dirGL = data.configinfo(i).parameters.openGL;
end

i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
%     i1 = strmatch('Duration',{char(data.condvect.name)},'exact');
%     dur(1,1) = crossvals(cntr,i1);
%     dur(2,1) = crossvalsGL(cntr,i1);
else
    dur(1,1) = data.configinfo(i).parameters.moog;
    dur(2,1) = data.configinfo(i).parameters.openGL;
end



i = strmatch('RADIUS',{char(data.configinfo.name)},'exact'); %RADIUS means standard radius
if data.configinfo(i).status == 2
    i1 = strmatch('Radius of Curve',{char(data.condvect.name)},'exact');
    r(1,1) = crossvals(cntr,i1);
    r(2,1) = crossvalsGL(cntr,i1);
else
    r(1,1) = data.configinfo(i).parameters.moog;
    r(2,1) = data.configinfo(i).parameters.openGL;
end

testradius =1000
r(1,1)


%     i = strmatch('RADIUS_2I',{char(data.configinfo.name)},'exact'); %RADIUS_2I means comparison radius
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Radius 2nd Int',{char(data.condvect.name)},'exact');
%         r(1,2) = crossvals(cntr,i1);
%         r(2,2) = crossvalsGL(cntr,i1);
%     else
%         r(1,2) = data.configinfo(i).parameters.moog;
%         r(2,2) = data.configinfo(i).parameters.openGL;
%     end
    
%    i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
%         i1 = strmatch('Duration (sec) 2nd Int',{char(data.condvect.name)},'exact');
%         dur(1,2) = crossvals(cntr,i1);
%         dur(2,2) = crossvalsGL(cntr,i1);
%     else
%         dur(1,2) = data.configinfo(i).parameters.moog;
%         dur(2,2) = data.configinfo(i).parameters.openGL;
%     end
    
%     i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
%     if data.configinfo(i).status == 2
% %         i1 = strmatch('Delay 2nd Int',{char(data.condvect.name)},'exact');
% %         delay = crossvals(cntr,i1);
% %         delayGL = crossvalsGL(cntr,i1);
%     else
%         delay(1) = data.configinfo(i).parameters.moog;
%         delay(2) = data.configinfo(i).parameters.openGL;
%     end    
%end_Baili



 
    i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
    randOrder = data.configinfo(i).parameters;    



f = 60; % This is frequency / update rate (Hz)


if motiontype == 1 % We should never enter this one
    
     
%else
    
    samediff = ceil(rand*2) % Use this to store oddity order
    Resp(data.repNum).samediff(trial.cntr) = samediff;
    setappdata(appHandle,'samediff',samediff); 
    
    ord = 1; % Default: we won't use this variable
    setappdata(appHandle,'Order',ord);
    
    %Baili
  
% vR1 = GenGaussian(dur(1,1), cursig, curamp, f); %qr_1: rotation para,
% dR1 = cumtrapz(vR1);
% dR1 = abs(curamp)*dR1(1:end-1)/max(abs(dR1));

% vC1 = GenGaussian(duration, cursig, curamp*r(1,2), f);
% dC1 = cumtrapz(vC1);
% dC1 = abs(curamp*r(1,2))*dC1(1:end-1)/max(abs(dC1));
qlinear = [0 curamp*r(1,1) dur(1,1)/2 1/cursig];
qangular=[0 curamp dur(1,1)/2 1/cursig];

    for i=1:(dur(1,1)*f)
        t=0:0.0001:(i/f);
        w=gaussfunc(t,qangular);
        dR1(i)=trapz(t,w);
    end

    for i=1:(dur(1,1)*f)
        t=0:0.0001:(i/f);
        v=gaussfunc(t,qlinear);
        d=trapz(t,v);
        xModd(i)=-r(1,1)*(1-cos(d/r(1,1)));   
%         xModd(i) = 0;

        yModd(i)=r(1,1)*sin(d/r(1,1));     
%         yModd(i) = 0;
        zModd(i)=0;                       
        rollMod(i)=0;
        pitchMod(i)=0;
        yawMod(i) = ini_dir - dR1(i)*180/pi;
    end

   
    for i=1:(dur(1,1)*f)
        xMeven(i) = 0;
        yMeven(i) = 0;
        zMeven(i) = 0;
        rollMev(i)=0;
        pitchMev(i)=0;
        yawMev(i)= -dR1(i)*180/pi;
    end
    


    
    % Arrange movements in right order
    %Baili
    if samediff==1 % rotation 
        lateralM = xMeven;
        lateralGL = lateralM;

 
        surgeM = yMeven;
        surgeGL = surgeM;

        heaveM = zMeven;
        heaveGL = heaveM;
        
        pitchM = pitchMev; 
        pitchGL = pitchM;    
        

        rollM = rollMev;        
        rollGL = rollM; 
        
        yawM = yawMev; 
        yawGL = yawM;     
        
    elseif samediff==2 % curve path
        lateralM = xModd;
        lateralGL = lateralM;

        surgeM = yModd;
        surgeGL = surgeM;
   
        heaveM = zModd;
        heaveGL = heaveM;

        pitchM =  pitchMod;
        pitchGL = pitchM;    
  
        rollM =  rollMod;
        rollGL = rollM;    
        
        yawM =  yawMod;
        yawGL = yawM; 
        
    end        
        
    
        
end 

if motiontype == 1
    %do nothing
%else    



    M(1).name = 'LATERAL_DATA';
    M(1).data = lateralM + ori(1,1); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(2).name = 'SURGE_DATA';
    M(2).data = surgeM + ori(1,2); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(3).name = 'HEAVE_DATA';
    M(3).data = heaveM + ori(1,3); %%this has to be done b/c origin is in cm but moogdots needs it in meters -- Tunde
    M(4).name = 'YAW_DATA';
%     M(4).data = 90*ones(1,dur(1,1)*f);
    M(4).data = yawM;
    M(5).name = 'PITCH_DATA';
    M(5).data = pitchM;
    M(6).name = 'ROLL_DATA';
    M(6).data = rollM;
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = lateralGL + ori(2,1);
    M(8).name = 'GL_SURGE_DATA';
    M(8).data = surgeGL + ori(2,2);
    M(9).name = 'GL_HEAVE_DATA';
    M(9).data = heaveGL + ori(2,3);
    M(10).name = 'GL_ROT_ELE';
    M(10).data = ones(1,dur(1,1)*f)*90;                           %yawM;
    M(11).name = 'GL_ROT_AZ';
    M(11).data = ones( 1,dur(1,1)*f  )*0;                %pitchM;
    M(12).name = 'GL_ROT_DATA';
    M(12).data = yawM;
end    


% HACK
% trial = getappdata(appHandle, 'trialInfo'); 
% trial.list = ones(1,trial.num);
% setappdata(appHandle, 'trialInfo', trial); 


if debug

    disp('Exiting oneincon');
end


