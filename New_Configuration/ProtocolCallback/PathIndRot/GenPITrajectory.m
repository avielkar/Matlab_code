function [yT,xT,zT,pitchR,yawR,rollR]=GenPITrajectory(time,sigma,maxTran,maxOmega,maxOmegaI,freq,method,op)

calTran=1;
calOmega=1;
calOmageI=1;

switch lower(method)
    case {'triangle'}
        vel4linear=GenTriangleR(time,maxTran,freq);
        vel4Omega=GenTriangleR(time,maxOmega,freq);
        vel4OmegaI=GenTriangleR(time,maxOmegaI,freq);
    case {'trape'}
        [dat,vel4linear,ac]=GenTrapezoidR(time,maxTran,0.2,0.8, freq);
        [dat,vel4Omega,ac]=GenTrapezoidR(time,maxOmega,0.2,0.8, freq);
        [dat,vel4OmegaI,ac]=GenTrapezoidR(time,maxOmegaI,0.2,0.8, freq);
    case {'gaussian'}
        vel4linear=GenGaussian(time,sigma,maxTran, freq);
        vel4Omega=GenGaussian(time,sigma,maxOmega, freq);
        vel4OmegaI=GenGaussian(time,sigma,maxOmegaI, freq);

        if maxTran~=0
            vel4linear=vel4linear*max(vel4linear/maxTran)/(sqrt(pi/sqrt(2))*time/sigma);
        else
            calTran=0;
        end

        if maxOmega~=0
            vel4Omega=vel4Omega*max(vel4Omega/maxOmega)/(sqrt(pi/sqrt(2))*time/sigma);
        else
            calOmega=0;
        end

        if maxOmegaI~=0
            vel4OmegaI=vel4OmegaI*max(vel4OmegaI/maxOmegaI)/(sqrt(pi/sqrt(2))*time/sigma);
        else
            calOmageI=0;
        end
end

len=max(size(vel4linear));
tm=1.0/freq;

disp4Omega=zeros(1,len);
disp4OmegaI=zeros(1,len);

xT=zeros(1,len);
yT=zeros(1,len);
zT=zeros(1,len);
pitchR=zeros(1,len);
yawR=zeros(1,len);
rollR=zeros(1,len);

for i=2:len

    if calOmega==1
        disp4Omega(i)=disp4Omega(i-1)+vel4Omega(i)*tm;
    end

    if calOmageI==1
        disp4OmegaI(i)=disp4OmegaI(i-1)+vel4OmegaI(i)*tm;
    end

    switch lower(op)
        case {'pathdependent'}

            if calTran==1
                xT(i)=xT(i-1)+vel4linear(i)*cos(pi*disp4Omega(i)/180.0)*tm;
                yT(i)=yT(i-1)+vel4linear(i)*sin(pi*disp4Omega(i)/180.0)*tm;
            end

            yawR(i)=disp4Omega(i)+disp4OmegaI(i);

        case {'pathindependent'}

            if calTran==1
                xT(i)=xT(i-1)+vel4linear(i)*tm;
            end

            yawR(i)=disp4Omega(i);

    end
end

clear disp* vel4*

