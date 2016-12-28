function [M] = sinTrajectory(appHandle,HR)

global debug

if debug
    disp('Entering sinTrajectory');
end


f = 60;
data = getappdata(appHandle, 'protinfo');

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;
i = strmatch('SIN_MODE',{char(data.configinfo.name)},'exact');
mod = data.configinfo(i).parameters;

crossvals = getappdata(appHandle, 'CrossVals');
crossvalsGL = getappdata(appHandle, 'CrossValsGL');
trial = getappdata(appHandle, 'trialInfo');
cntr = trial.list(trial.cntr);


if mod == 1 % translation sinusoid
    % Pull and assign required variables for a Translation protocol
    i = strmatch('ORIGIN',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Origin',{char(data.condvect.name)},'exact');
        ori(1) = crossvals(cntr,i1);
        ori(2) = crossvalsGL(cntr,i1);
    else
        ori(1,:) = data.configinfo(i).parameters;
        ori(2,:) = data.configinfo(i).parameters;
    end
    i = strmatch('ELEVATION',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Elevation',{char(data.condvect.name)},'exact');
        el(1,1) = crossvals(cntr,i1);
        el(2,1) = crossvalsGL(cntr,i1);
    else
        el(1,1) = data.configinfo(i).parameters.moog(1);
        el(2,1) = data.configinfo(i).parameters.openGL(1);
    end
    i = strmatch('AZIMUTH',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Azimuth',{char(data.condvect.name)},'exact');
        az(1,1) = crossvals(cntr,i1);
        az(2,1) = crossvalsGL(cntr,i1);
    else
        az(1,1) = data.configinfo(i).parameters.moog(1);
        az(2,1) = data.configinfo(i).parameters.openGL(1);
    end
    i = strmatch('SIN_FREQUENCY',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Sin frequency',{char(data.condvect.name)},'exact');
        freq(1,1) = crossvals(cntr,i1);
        freq(2,1) = crossvalsGL(cntr,i1);
    else
        freq(1,1) = data.configinfo(i).parameters.moog(1);
        freq(2,1) = data.configinfo(i).parameters.openGL(1);
    end
    i = strmatch('DIST',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Distance',{char(data.condvect.name)},'exact');
        dist(1,1) = crossvals(cntr,i1);
        dist(2,1) = crossvalsGL(cntr,i1);
    else
        dist(1,1) = data.configinfo(i).parameters.moog(1);
        dist(2,1) = data.configinfo(i).parameters.openGL(1);
    end
    i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Duration',{char(data.condvect.name)},'exact');
        dur(1,1) = crossvals(cntr,i1);
        dur(2,1) = crossvalsGL(cntr,i1);
    else
        dur(1,1) = data.configinfo(i).parameters.moog(1);
        dur(2,1) = data.configinfo(i).parameters.openGL(1);
    end
    i = strmatch('SIGMA',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Sigma',{char(data.condvect.name)},'exact');
        sig(1,1) = crossvals(cntr,i1);
        sig(2,1) = crossvals(cntr,i1);
    else
        sig(1,1) = data.configinfo(i).parameters.moog(1);
        sig(2,1) = data.configinfo(i).parameters.openGL(1);
    end

    if motiontype == 3 % 2I vars required as well
        i = strmatch('ELEVATION_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Elevation 2nd Int',{char(data.condvect.name)},'exact');
            el(1,2) = crossvals(cntr,i1);
            el(2,2) = crossvalsGL(cntr,i1);
        else
            el(1,2) = data.configinfo(i).parameters.moog(1);
            el(2,2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('AZIMUTH_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Azimuth 2nd Int',{char(data.condvect.name)},'exact');
            az(1,2) = crossvals(cntr,i1);
            az(2,2) = crossvalsGL(cntr,i1);
        else
            az(1,2) = data.configinfo(i).parameters.moog(1);
            az(2,2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact');
            dist(1,2) = crossvals(cntr,i1);
            dist(2,2) = crossvalsGL(cntr,i1);
        else
            dist(1,2) = data.configinfo(i).parameters.moog(1);
            dist(2,2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('SIGMA_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Sigma 2nd Int',{char(data.condvect.name)},'exact');
            sig(1,2) = crossvals(cntr,i1);
            sig(2,2) = crossvals(cntr,i1);
        else
            sig(1,2) = data.configinfo(i).parameters.moog(1);
            sig(2,2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Delay 2nd Int',{char(data.condvect.name)},'exact');
            delay(1) = crossvals(cntr,i1);
            delay(2) = crossvals(cntr,i1);
        else
            delay(1) = data.configinfo(i).parameters.moog(1);
            delay(2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Duration 2nd Int',{char(data.condvect.name)},'exact');
            dur(1,2) = crossvals(cntr,i1);
            dur(2,2) = crossvalsGL(cntr,i1);
        else
            dur(1,2) = data.configinfo(i).parameters.moog(1);
            dur(2,2) = data.configinfo(i).parameters.openGL(1);
        end
        i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
        randOrder = data.configinfo(i).parameters;
    end


    if motiontype == 3 % 2I motion
        if randOrder   % random order for intervals
            ord = randperm(2);
        else
            ord = [1 2];
        end
    else
        ord = 1;
    end

    % 1st interval
    f = 60;
    xM1 = linspace(0,dur(1,ord(1)), dur(1,ord(1))*f);
    xGL1 = linspace(0,dur(2,ord(1)), dur(2,ord(1))*f);
    dM1 = sin(2*pi*freq(1,ord(1))*xM1);
    dGL1 = sin(2*pi*freq(2,ord(1))*xGL1);

    % 2nd Interval
    if motiontype == 3
        xM2 = linspace(0,dur(1,ord(2)), dur(1,ord(2))*f);
        xGL2 = linspace(0,dur(2,ord(2)), dur(2,ord(2))*f);
        dM2 = sin(2*pi*freq(1,ord(2))*xM2);
        dGL2 = sin(2*pi*freq(2,ord(2))*xGL2);
    end

    % If conflict, create two different trajectories

    % Which direction does the openGL go relative to the Moog??
    conamp =0; % conflict hasn't been perfected yet
    if conamp ~= 0
        azM = az(1) + (conpitch + sin(conamp/2*pi/180) + conamp/2*cos(conroll*pi/180));
        azGL = az(1) - (conpitch + sin(conamp/2*pi/180) + conamp/2*cos(conroll*pi/180));
        elM = el(1) + (conpitch + cos(conamp/2*pi/180) + conamp/2*sin(conroll*pi/180));
        elGL = el(1) - (conpitch + cos(conamp/2*pi/180) + conamp/2*sin(conroll*pi/180));
    else
        azM1 = az(1,ord(1));
        azGL1 = az(1,ord(1));
        elM1 = el(2,ord(1));
        elGL1 = el(2,ord(1));
        if motiontype == 3
            azM2 = az(1,ord(2));
            azGL2 = az(1,ord(2));
            elM2 = el(2,ord(2));
            elGL2 = el(2,ord(2));
        end
    end

    if motiontype == 1
        [xM yM zM] = sph2cart(azM1*pi/180, elM1*pi/180, 1);
        [xGL yGL zGL] = sph2cart(azGL1*pi/180, elGL1*pi/180, 1);
        lateralM = dM1*xM;
        surgeM = dM1*yM;
        heaveM = dM1*zM;
        lateralGL = dGL1*xGL;
        surgeGL = dGL1*yGL;
        heaveGL = dGL1*zGL;
    else
        [xM1 yM1 zM1] = sph2cart(azM1*pi/180, elM1*pi/180, 1);
        [xGL1 yGL1 zGL1] = sph2cart(azGL1*pi/180, elGL1*pi/180, 1);
        [xM2 yM2 zM2] = sph2cart(azM2*pi/180, elM2*pi/180, 1);
        [xGL2 yGL2 zGL2] = sph2cart(azGL2*pi/180, elGL2*pi/180, 1);
        restM = ones(1,f*delay(1));
        restGL = ones(1,f*delay(2));

        lateralM1 = dM1*xM1;
        lateralRestM = restM*lateralM1(end);
        lateralM2 = dM2*xM2 + lateralM1(end);
        lateralM = [lateralM1 lateralRestM lateralM2];
        lateralGL1 = dGL1*xGL1;
        lateralRestGL = restGL*lateralGL1(end);
        lateralGL2 = dGL2*xGL2 + lateralGL1(end);
        lateralGL = [lateralGL1 lateralRestGL lateralGL2];

        surgeM1 = dM1*yM1;
        surgeRestM = restM*surgeM1(end);
        surgeM2 = dM2*yM2 + surgeM1(end);
        surgeM = [surgeM1 surgeRestM surgeM2];
        surgeGL1 = dGL1*yGL1;
        surgeRestGL = restGL*surgeGL1(end);
        surgeGL2 = dGL2*yGL2 + surgeGL1(end);
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


    M(1).name = 'LATERAL_DATA';
    M(1).data = lateralM + ori(1,1);
    M(2).name = 'SURGE_DATA';
    M(2).data = surgeM + ori(1,2);
    M(3).name = 'HEAVE_DATA';
    M(3).data = heaveM + ori(1,3);
    M(4).name = 'YAW_DATA';
    M(4).data = 90*ones(1,dur(1)*f);
    M(5).name = 'PITCH_DATA';
    M(5).data = zeros(1,dur(1)*f);
    M(6).name = 'ROLL_DATA';
    M(6).data = zeros(1,dur(1)*f);
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = lateralGL + ori(2,1);
    M(8).name = 'GL_SURGE_DATA';
    M(8).data = surgeGL + ori(2,2);
    M(9).name = 'GL_HEAVE_DATA';
    M(9).data = heaveGL + ori(2,3);
    M(10).name = 'GL_ROT_ELE';
    M(10).data = 90*ones(dur(1)*f,1);
    M(11).name = 'GL_ROT_AZ';
    M(11).data = zeros(dur(1)*f,1);
    M(12).name = 'GL_ROT_DATA';
    M(12).data = zeros(dur(1)*f,1);

elseif mod == 2 % rotational sinusoid
    i = strmatch('ROT_CENTER_OFFSETS',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Center Offsets',{char(data.condvect.name)},'exact');
        rco(1,1) = crossvals(cntr,i1);
        rco(2,1) = crossvalsGL(cntr,i1);
    else
        rco(1,:) = data.configinfo(i).parameters.moog;
        rco(2,:) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_ELEVATION',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Elevation',{char(data.condvect.name)},'exact');
        el(1,1) = crossvals(cntr,i1);
        el(2,1) = crossvalsGL(cntr,i1);
    else
        el(1,1) = data.configinfo(i).parameters.moog;
        el(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_AZIMUTH',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Azimuth',{char(data.condvect.name)},'exact');
        az(1,1) = crossvals(cntr,i1);
        az(2,1) = crossvalsGL(cntr,i1);
    else
        az(1,1) = data.configinfo(i).parameters.moog;
        az(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_AMPLITUDE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Amplitude',{char(data.condvect.name)},'exact');
        amp(1,1) = crossvals(cntr,i1);
        amp(2,1) = crossvalsGL(cntr,i1);
    else
        amp(1,1) = data.configinfo(i).parameters.moog;
        amp(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('DURATION',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Duration',{char(data.condvect.name)},'exact');
        dur(1,1) = crossvals(cntr,i1);
        dur(2,1) = crossvalsGL(cntr,i1);
    else
        dur(1,1) = data.configinfo(i).parameters.moog;
        dur(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_SIGMA',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Sigma',{char(data.condvect.name)},'exact');
        sig(1,1) = crossvals(cntr,i1);
        sig(2,1) = crossvalsGL(cntr,i1);
    else
        sig(1,1) = data.configinfo(i).parameters.moog;
        sig(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_PHASE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i).status == 2
        i1 = strmatch('Rotation Phase',{char(data.condvect.name)},'exact');
        phas(1,1) = crossvals(cntr,i1);
        phas(2,1) = crossvalsGL(cntr,i1);
    else
        phas(1,1) = data.configinfo(i).parameters.moog;
        phas(2,1) = data.configinfo(i).parameters.openGL;
    end
    i = strmatch('ROT_ORIGIN',{char(data.configinfo.name)},'exact');
    ori(1,:) = data.configinfo(i).parameters.moog(1);
    ori(2,:) = data.configinfo(i).parameters.openGL(1);



    if motiontype == 3
        i = strmatch('ROT_ELEVATION_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Rotation Elevation 2nd Int',{char(data.condvect.name)},'exact');
            el(1,2) = crossvals(cntr,i1);
            el(2,2) = crossvalsGL(cntr,i1);
        else
            el(1,2) = data.configinfo(i).parameters.moog;
            el(2,2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('ROT_AZIMUTH_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Rotation Azimuth 2nd Int',{char(data.condvect.name)},'exact');
            az(1,2) = crossvals(cntr,i1);
            az(2,2) = crossvalsGL(cntr,i1);
        else
            az(1,2) = data.configinfo(i).parameters.moog;
            az(2,2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('ROT_AMPLITUDE_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Rotation Amplitude 2nd Int',{char(data.condvect.name)},'exact');
            amp(1,2) = crossvals(cntr,i1);
            amp(2,2) = crossvalsGL(cntr,i1);
        else
            amp(1,2) = data.configinfo(i).parameters.moog;
            amp(2,2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('DURATION_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Duration 2nd Int',{char(data.condvect.name)},'exact');
            dur(1,2) = crossvals(cntr,i1);
            dur(2,2) = crossvalsGL(cntr,i1);
        else
            dur(1,2) = data.configinfo(i).parameters.moog;
            dur(2,2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('ROT_SIGMA_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Rotation Sigma 2nd Int',{char(data.condvect.name)},'exact');
            sig(1,2) = crossvals(cntr,i1);
            sig(2,2) = crossvalsGL(cntr,i1);
        else
            sig(1,2) = data.configinfo(i).parameters.moog;
            sig(2,2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('DELAY_2I',{char(data.configinfo.name)},'exact');
        if data.configinfo(i).status == 2
            i1 = strmatch('Delay 2nd Int',{char(data.condvect.name)},'exact');
            delay(1) = crossvals(cntr,i1);
            delay(2) = crossvalsGL(cntr,i1);
        else
            delay(1) = data.configinfo(i).parameters.moog;
            delay(2) = data.configinfo(i).parameters.openGL;
        end
        i = strmatch('INT_ORDER_2I',{char(data.configinfo.name)},'exact');
        randOrder = data.configinfo(i).parameters;
    end

    if motiontype == 3 % 2I motion
        if randOrder   % random order for intervals
            ord = randperm(2);
        else
            ord = [1 2];
        end
    else
        ord = 1;
    end



    f = 60;
    % 1st Interval
    vM1 = GenGaussian(dur(1,ord(1)), sig(1,ord(1)), amp(1,ord(1)), f);
    dM1 = cumtrapz(vM1);
    dM1 = abs(amp(1,ord(1)))*dM1(1:end-1)/max(abs(dM1));
    vGL1 = GenGaussian(dur(2,ord(1)), sig(2,ord(1)), amp(2,ord(1)), f);
    dGL1 = cumtrapz(vGL1);
    dGL1 = abs(amp(2,ord(1)))*dGL1(1:end-1)/max(abs(dGL1));

    if motiontype == 3
        % 2nd Interval
        vM2 = GenGaussian(dur(1,ord(2)), sig(1,ord(2)), amp(1,ord(2)), f);
        dM2 = cumtrapz(vM2);
        dM2 = abs(amp(1,ord(2)))*dM2(1:end-1)/max(abs(dM2));
        vGL2 = GenGaussian(dur(2,ord(2)), sig(2,ord(2)), amp(2,ord(2)), f);
        dGL2 = cumtrapz(vGL2);
        dGL2 = abs(amp(2,ord(2)))*dGL2(1:end-1)/max(abs(dGL2));
    end


    %  Code borrowed from MoogDots rotation creation., from "PlatformCenter"
    point.x = 0;
    point.y = 0;
    point.z = 0;
    rotPoint.x = rco(1,1); % offset center of platform to rotation reference
    rotPoint.y = rco(1,2);
    rotPoint.z = rco(1,3);
    % double rotElevation, double rotAzimuth,	// Elevation and azimuth of
    % rotation axis.

    % Convert angles from degrees to radians.
    % 1st Interval
    rotElevationM1 = el(1,ord(1)) * pi/180;
    rotAzimuthM1 = az(1,ord(1)) * pi/180;
    rotElevationGL1 = el(2,ord(1)) * pi/180;
    rotAzimuthGL1 = az(2,ord(1)) * pi/180;

    if motiontype == 3
        % Convert angles from degrees to radians.
        % 2nd Interval
        rotElevationM2 = el(1,ord(2)) * pi/180;
        rotAzimuthM2 = az(1,ord(2)) * pi/180;
        rotElevationGL2 = el(2,ord(2)) * pi/180;
        rotAzimuthGL2 = az(2,ord(2)) * pi/180;
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


    % Precompute sines and cosines.
    cosEM1 = cos(rotElevationM1);
    cosAM1 = cos(rotAzimuthM1);
    sinEM1 = sin(rotElevationM1);
    sinAM1 = sin(rotAzimuthM1);
    cosEGL1 = cos(rotElevationGL1);
    cosAGL1 = cos(rotAzimuthGL1);
    sinEGL1 = sin(rotElevationGL1);
    sinAGL1 = sin(rotAzimuthGL1);

    if motiontype == 3
        cosEM2 = cos(rotElevationM2);
        cosAM2 = cos(rotAzimuthM2);
        sinEM2 = sin(rotElevationM2);
        sinAM2 = sin(rotAzimuthM2);
        cosEGL2 = cos(rotElevationGL2);
        cosAGL2 = cos(rotAzimuthGL2);
        sinEGL2 = sin(rotElevationGL2);
        sinAGL2 = sin(rotAzimuthGL2);
    end


    %  Calculate the rotation vector.
    [rotationVectorM1.x rotationVectorM1.y rotationVectorM1.z] = sph2cart(rotAzimuthM1, rotElevationM1, 1);
    [rotationVectorGL1.x rotationVectorGL1.y rotationVectorGL1.z] = sph2cart(rotAzimuthGL1, rotElevationGL1, 1);

    if motiotype == 3
        [rotationVectorM2.x rotationVectorM2.y rotationVectorM2.z] = sph2cart(rotAzimuthM2, rotElevationM2, 1);
        [rotationVectorGL2.x rotationVectorGL2.y rotationVectorGL2.z] = sph2cart(rotAzimuthGL2, rotElevationGL2, 1);
    end

    % I don't know why this is here. it'd reminent from the Tempo code
    dM1 = dM1 * pi/180;
    dGL1 = dGL1 * pi/180;

    if motiontype == 2
        dM2 = dM2 * pi/180;
        dGL2 = dGL2 * pi/180;
    end

    for i1 = 1:dur(1,ord(1))*f;	% Determine what the angle of rotation will be and precompute the sin and cosine of it.
        sinB1 = sin(dM1(i1));
        cosB1 = cos(dM1(i1));

        xvalM1(i1) = ((cosEM1*cosEM1*cosAM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*sinEM1)*cosAM1+(sinAM1*cosB1+sinEM1*cosAM1*sinB1)*sinAM1)*point.x + ...
            (-(cosEM1*cosEM1*cosAM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*sinEM1)*sinAM1+(sinAM1*cosB1+sinEM1*cosAM1*sinB1)*cosAM1)*point.y + ...
            (-cosEM1*cosAM1*sinEM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*cosEM1)*point.z + ...
            -((cosEM1*cosEM1*cosAM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*sinEM1)*cosAM1+(sinAM1*cosB1+sinEM1*cosAM1*sinB1)*sinAM1)*rotPoint.x-(-(cosEM1*cosEM1*cosAM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*sinEM1)*sinAM1+(sinAM1*cosB1+sinEM1*cosAM1*sinB1)*cosAM1)*rotPoint.y-(-cosEM1*cosAM1*sinEM1+(-sinAM1*sinB1+sinEM1*cosAM1*cosB1)*cosEM1)*rotPoint.z+rotPoint.x;


        yvalM1(i1) = ((-cosEM1*cosEM1*sinAM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*sinEM1)*cosAM1+(cosAM1*cosB1-sinEM1*sinAM1*sinB1)*sinAM1)*point.x + ...
            (-(-cosEM1*cosEM1*sinAM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*sinEM1)*sinAM1+(cosAM1*cosB1-sinEM1*sinAM1*sinB1)*cosAM1)*point.y + ...
            (cosEM1*sinAM1*sinEM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*cosEM1)*point.z + ...
            -((-cosEM1*cosEM1*sinAM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*sinEM1)*cosAM1+(cosAM1*cosB1-sinEM1*sinAM1*sinB1)*sinAM1)*rotPoint.x-(-(-cosEM1*cosEM1*sinAM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*sinEM1)*sinAM1+(cosAM1*cosB1-sinEM1*sinAM1*sinB1)*cosAM1)*rotPoint.y-(cosEM1*sinAM1*sinEM1+(-cosAM1*sinB1-sinEM1*sinAM1*cosB1)*cosEM1)*rotPoint.z+rotPoint.y;

        zvalM1(i1) = ((-sinEM1*cosEM1+cosEM1*cosB1*sinEM1)*cosAM1+cosEM1*sinB1*sinAM1)*point.x + ...
            (-(-sinEM1*cosEM1+cosEM1*cosB1*sinEM1)*sinAM1+cosEM1*sinB1*cosAM1)*point.y + ...
            (sinEM1*sinEM1+cosEM1*cosEM1*cosB1)*point.z + ...
            -((-sinEM1*cosEM1+cosEM1*cosB1*sinEM1)*cosAM1+cosEM1*sinB1*sinAM1)*rotPoint.x-(-(-sinEM1*cosEM1+cosEM1*cosB1*sinEM1)*sinAM1+cosEM1*sinB1*cosAM1)*rotPoint.y-(sinEM1*sinEM1+cosEM1*cosEM1*cosB1)*rotPoint.z+rotPoint.z;


        %  This calculates how much the point yaws, pitches, and rolls about the rotation axis given some theta b.
        pitchM1(i1)  = -asin(rotationVectorM1.y*rotationVectorM1.z*(1-cos(dM1(i1))) - sin(dM1(i1))*rotationVectorM1.x);
        rollM1(i1) =  asin((rotationVectorM1.x*rotationVectorM1.z*(1-cos(dM1(i1))) + sin(dM1(i1))*rotationVectorM1.y)/cos(pitchM1(i1)));
        yawM1(i1)  =  asin((rotationVectorM1.y*rotationVectorM1.x*(1-cos(dM1(i1))) + sin(dM1(i1))*rotationVectorM1.z)/cos(pitchM1(i1)));

    end


    for i1 = 1:dur(2,ord(1))*f;	% Determine what the angle of rotation will be and precompute the sin and cosine of it.
        sinB1 = sin(dGL1(i1));
        cosB1 = cos(dGL1(i1));

        xvalGL1(i1) = ((cosEGL1*cosEGL1*cosAGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*sinEGL1)*cosAGL1+(sinAGL1*cosB1+sinEGL1*cosAGL1*sinB1)*sinAGL1)*point.x + ...
            (-(cosEGL1*cosEGL1*cosAGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*sinEGL1)*sinAGL1+(sinAGL1*cosB1+sinEGL1*cosAGL1*sinB1)*cosAGL1)*point.y + ...
            (-cosEGL1*cosAGL1*sinEGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*cosEGL1)*point.z + ...
            -((cosEGL1*cosEGL1*cosAGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*sinEGL1)*cosAGL1+(sinAGL1*cosB1+sinEGL1*cosAGL1*sinB1)*sinAGL1)*rotPoint.x-(-(cosEGL1*cosEGL1*cosAGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*sinEGL1)*sinAGL1+(sinAGL1*cosB1+sinEGL1*cosAGL1*sinB1)*cosAGL1)*rotPoint.y-(-cosEGL1*cosAGL1*sinEGL1+(-sinAGL1*sinB1+sinEGL1*cosAGL1*cosB1)*cosEGL1)*rotPoint.z+rotPoint.x;


        yvalGL1(i1) = ((-cosEGL1*cosEGL1*sinAGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*sinEGL1)*cosAGL1+(cosAGL1*cosB1-sinEGL1*sinAGL1*sinB1)*sinAGL1)*point.x + ...
            (-(-cosEGL1*cosEGL1*sinAGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*sinEGL1)*sinAGL1+(cosAGL1*cosB1-sinEGL1*sinAGL1*sinB1)*cosAGL1)*point.y + ...
            (cosEGL1*sinAGL1*sinEGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*cosEGL1)*point.z + ...
            -((-cosEGL1*cosEGL1*sinAGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*sinEGL1)*cosAGL1+(cosAGL1*cosB1-sinEGL1*sinAGL1*sinB1)*sinAGL1)*rotPoint.x-(-(-cosEGL1*cosEGL1*sinAGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*sinEGL1)*sinAGL1+(cosAGL1*cosB1-sinEGL1*sinAGL1*sinB1)*cosAGL1)*rotPoint.y-(cosEGL1*sinAGL1*sinEGL1+(-cosAGL1*sinB1-sinEGL1*sinAGL1*cosB1)*cosEGL1)*rotPoint.z+rotPoint.y;

        zvalGL1(i1) = ((-sinEGL1*cosEGL1+cosEGL1*cosB1*sinEGL1)*cosAGL1+cosEGL1*sinB1*sinAGL1)*point.x + ...
            (-(-sinEGL1*cosEGL1+cosEGL1*cosB1*sinEGL1)*sinAGL1+cosEGL1*sinB1*cosAGL1)*point.y + ...
            (sinEGL1*sinEGL1+cosEGL1*cosEGL1*cosB1)*point.z + ...
            -((-sinEGL1*cosEGL1+cosEGL1*cosB1*sinEGL1)*cosAGL1+cosEGL1*sinB1*sinAGL1)*rotPoint.x-(-(-sinEGL1*cosEGL1+cosEGL1*cosB1*sinEGL1)*sinAGL1+cosEGL1*sinB1*cosAGL1)*rotPoint.y-(sinEGL1*sinEGL1+cosEGL1*cosEGL1*cosB1)*rotPoint.z+rotPoint.z;


        %  This calculates how much the point yaws, pitches, and rolls about the rotation axis given some theta b.
        pitchGL1(i1)  = -asin(rotationVectorGL1.y*rotationVectorGL1.z*(1-cos(dGL1(i1))) - sin(dGL1(i1))*rotationVectorGL1.x);
        rollGL1(i1) =  asin((rotationVectorGL1.x*rotationVectorGL1.z*(1-cos(dGL1(i1))) + sin(dGL1(i1))*rotationVectorGL1.y)/cos(pitchGL1(i1)));
        yawGL1(i1)  =  asin((rotationVectorGL1.y*rotationVectorGL1.x*(1-cos(dGL1(i1))) + sin(dGL1(i1))*rotationVectorGL1.z)/cos(pitchGL1(i1)));

    end


    if motiontype == 3
        % For 2nd Intercval
        for i1 = 1:dur(1,ord(2))*f;	% Determine what the angle of rotation will be and precompute the sin and cosine of it.
            sinB2 = sin(dM2(i1));
            cosB2 = cos(dM2(i1));

            xvalM2(i1) = ((cosEM2*cosEM2*cosAM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*sinEM2)*cosAM2+(sinAM2*cosB2+sinEM2*cosAM2*sinB2)*sinAM2)*point.x + ...
                (-(cosEM2*cosEM2*cosAM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*sinEM2)*sinAM2+(sinAM2*cosB2+sinEM2*cosAM2*sinB2)*cosAM2)*point.y + ...
                (-cosEM2*cosAM2*sinEM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*cosEM2)*point.z + ...
                -((cosEM2*cosEM2*cosAM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*sinEM2)*cosAM2+(sinAM2*cosB2+sinEM2*cosAM2*sinB2)*sinAM2)*rotPoint.x-(-(cosEM2*cosEM2*cosAM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*sinEM2)*sinAM2+(sinAM2*cosB2+sinEM2*cosAM2*sinB2)*cosAM2)*rotPoint.y-(-cosEM2*cosAM2*sinEM2+(-sinAM2*sinB2+sinEM2*cosAM2*cosB2)*cosEM2)*rotPoint.z+rotPoint.x;


            yvalM2(i1) = ((-cosEM2*cosEM2*sinAM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*sinEM2)*cosAM2+(cosAM2*cosB2-sinEM2*sinAM2*sinB2)*sinAM2)*point.x + ...
                (-(-cosEM2*cosEM2*sinAM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*sinEM2)*sinAM2+(cosAM2*cosB2-sinEM2*sinAM2*sinB2)*cosAM2)*point.y + ...
                (cosEM2*sinAM2*sinEM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*cosEM2)*point.z + ...
                -((-cosEM2*cosEM2*sinAM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*sinEM2)*cosAM2+(cosAM2*cosB2-sinEM2*sinAM2*sinB2)*sinAM2)*rotPoint.x-(-(-cosEM2*cosEM2*sinAM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*sinEM2)*sinAM2+(cosAM2*cosB2-sinEM2*sinAM2*sinB2)*cosAM2)*rotPoint.y-(cosEM2*sinAM2*sinEM2+(-cosAM2*sinB2-sinEM2*sinAM2*cosB2)*cosEM2)*rotPoint.z+rotPoint.y;

            zvalM2(i1) = ((-sinEM2*cosEM2+cosEM2*cosB2*sinEM2)*cosAM2+cosEM2*sinB2*sinAM2)*point.x + ...
                (-(-sinEM2*cosEM2+cosEM2*cosB2*sinEM2)*sinAM2+cosEM2*sinB2*cosAM2)*point.y + ...
                (sinEM2*sinEM2+cosEM2*cosEM2*cosB2)*point.z + ...
                -((-sinEM2*cosEM2+cosEM2*cosB2*sinEM2)*cosAM2+cosEM2*sinB2*sinAM2)*rotPoint.x-(-(-sinEM2*cosEM2+cosEM2*cosB2*sinEM2)*sinAM2+cosEM2*sinB2*cosAM2)*rotPoint.y-(sinEM2*sinEM2+cosEM2*cosEM2*cosB2)*rotPoint.z+rotPoint.z;


            %  This calculates how much the point yaws, pitches, and rolls about the rotation axis given some theta b.
            pitchM2(i1)  = -asin(rotationVectorM2.y*rotationVectorM2.z*(1-cos(dM2(i1))) - sin(dM2(i1))*rotationVectorM2.x);
            rollM2(i1) =  asin((rotationVectorM2.x*rotationVectorM2.z*(1-cos(dM2(i1))) + sin(dM2(i1))*rotationVectorM2.y)/cos(pitchM2(i1)));
            yawM2(i1)  =  asin((rotationVectorM2.y*rotationVectorM2.x*(1-cos(dM2(i1))) + sin(dM2(i1))*rotationVectorM2.z)/cos(pitchM2(i1)));

        end

        for i1 = 1:dur(2,ord(1))*f;	% Determine what the angle of rotation will be and precompute the sin and cosine of it.
            sinB2 = sin(dGL2(i1));
            cosB2 = cos(dGL2(i1));

            xvalGL2(i1) = ((cosEGL2*cosEGL2*cosAGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*sinEGL2)*cosAGL2+(sinAGL2*cosB2+sinEGL2*cosAGL2*sinB2)*sinAGL2)*point.x + ...
                (-(cosEGL2*cosEGL2*cosAGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*sinEGL2)*sinAGL2+(sinAGL2*cosB2+sinEGL2*cosAGL2*sinB2)*cosAGL2)*point.y + ...
                (-cosEGL2*cosAGL2*sinEGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*cosEGL2)*point.z + ...
                -((cosEGL2*cosEGL2*cosAGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*sinEGL2)*cosAGL2+(sinAGL2*cosB2+sinEGL2*cosAGL2*sinB2)*sinAGL2)*rotPoint.x-(-(cosEGL2*cosEGL2*cosAGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*sinEGL2)*sinAGL2+(sinAGL2*cosB2+sinEGL2*cosAGL2*sinB2)*cosAGL2)*rotPoint.y-(-cosEGL2*cosAGL2*sinEGL2+(-sinAGL2*sinB2+sinEGL2*cosAGL2*cosB2)*cosEGL2)*rotPoint.z+rotPoint.x;


            yvalGL2(i1) = ((-cosEGL2*cosEGL2*sinAGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*sinEGL2)*cosAGL2+(cosAGL2*cosB2-sinEGL2*sinAGL2*sinB2)*sinAGL2)*point.x + ...
                (-(-cosEGL2*cosEGL2*sinAGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*sinEGL2)*sinAGL2+(cosAGL2*cosB2-sinEGL2*sinAGL2*sinB2)*cosAGL2)*point.y + ...
                (cosEGL2*sinAGL2*sinEGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*cosEGL2)*point.z + ...
                -((-cosEGL2*cosEGL2*sinAGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*sinEGL2)*cosAGL2+(cosAGL2*cosB2-sinEGL2*sinAGL2*sinB2)*sinAGL2)*rotPoint.x-(-(-cosEGL2*cosEGL2*sinAGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*sinEGL2)*sinAGL2+(cosAGL2*cosB2-sinEGL2*sinAGL2*sinB2)*cosAGL2)*rotPoint.y-(cosEGL2*sinAGL2*sinEGL2+(-cosAGL2*sinB2-sinEGL2*sinAGL2*cosB2)*cosEGL2)*rotPoint.z+rotPoint.y;

            zvalGL2(i1) = ((-sinEGL2*cosEGL2+cosEGL2*cosB2*sinEGL2)*cosAGL2+cosEGL2*sinB2*sinAGL2)*point.x + ...
                (-(-sinEGL2*cosEGL2+cosEGL2*cosB2*sinEGL2)*sinAGL2+cosEGL2*sinB2*cosAGL2)*point.y + ...
                (sinEGL2*sinEGL2+cosEGL2*cosEGL2*cosB2)*point.z + ...
                -((-sinEGL2*cosEGL2+cosEGL2*cosB2*sinEGL2)*cosAGL2+cosEGL2*sinB2*sinAGL2)*rotPoint.x-(-(-sinEGL2*cosEGL2+cosEGL2*cosB2*sinEGL2)*sinAGL2+cosEGL2*sinB2*cosAGL2)*rotPoint.y-(sinEGL2*sinEGL2+cosEGL2*cosEGL2*cosB2)*rotPoint.z+rotPoint.z;


            %  This calculates how much the point yaws, pitches, and rolls about the rotation axis given some theta b.
            pitchGL2(i1)  = -asin(rotationVectorGL2.y*rotationVectorGL2.z*(1-cos(dGL2(i1))) - sin(dGL2(i1))*rotationVectorGL2.x);
            rollGL2(i1) =  asin((rotationVectorGL2.x*rotationVectorGL2.z*(1-cos(dGL2(i1))) + sin(dGL2(i1))*rotationVectorGL2.y)/cos(pitchGL2(i1)));
            yawGL2(i1)  =  asin((rotationVectorGL2.y*rotationVectorGL2.x*(1-cos(dGL2(i1))) + sin(dGL2(i1))*rotationVectorGL2.z)/cos(pitchGL2(i1)));

        end
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

        pitchM = [pitchM1 restPM (xvalM2 + pitchM1(end))];
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
    M(4).data = yawM*180/pi;
    M(5).name = 'PITCH_DATA';
    M(5).data = pitchM*180/pi;
    M(6).name = 'ROLL_DATA';
    M(6).data = rollM*180/pi;
    M(7).name = 'GL_LATERAL_DATA';
    M(7).data = xvalGL*180/pi;
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


else
    disp('Mode is not set for translational or rotational sinusoidal movement')
    M = NaN;
end


if debug
    disp('Exiting sinTrajectory');
end