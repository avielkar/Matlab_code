function [yT,xT,zT,pitchR,yawR,rollR]=GenPITrajectory(time,sigma,maxTran,maxOmega,maxOmegaI,freq,method,op)

maxTran
maxOmega
maxOmegaI
switch lower(method)
    case {'triangle'}
        vel4linear=GenTriangle(time,maxTran,freq);
        vel4Omega=GenTriangle(time,maxOmega,freq);
        vel4OmegaI=GenTriangle(time,maxOmegaI,freq);
    case {'trape'}
        [dat,vel4linear,ac]=GenTrapezoid(time,maxTran,0.2,0.8, freq);
        [dat,vel4Omega,ac]=GenTrapezoid(time,maxOmega,0.2,0.8, freq);
        [dat,vel4OmegaI,ac]=GenTrapezoid(time,maxOmegaI,0.2,0.8, freq);
    case {'gaussian'}
        vel4linear=GenGaussian(time,sigma,maxTran, freq);
        vel4Omega=GenGaussian(time,sigma,maxOmega, freq);
        vel4OmegaI=GenGaussian(time,sigma,maxOmegaI, freq);
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
    disp4Omega(i)=disp4Omega(i-1)+vel4Omega(i)*tm;
    disp4OmegaI(i)=disp4OmegaI(i-1)+vel4OmegaI(i)*tm;

    switch lower(op)
        case {'pathdependent'}
            xT(i)=xT(i-1)+vel4linear(i)*cos(pi*disp4Omega(i)/180.0)*tm;
            yT(i)=yT(i-1)+vel4linear(i)*sin(pi*disp4Omega(i)/180.0)*tm;
            yawR(i)=disp4Omega(i)+disp4OmegaI(i);
        case {'pathindependent'}
            xT(i)=xT(i-1)+vel4linear(i)*tm;
            yawR(i)=disp4Omega(i);
    end
end

clear disp* vel4*


