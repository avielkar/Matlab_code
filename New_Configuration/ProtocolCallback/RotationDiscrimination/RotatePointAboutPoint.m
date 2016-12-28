function [X,Y,Z,pitch,roll,yaw]=RotatePointAboutPoint(point, rotPoint,rotElevation,rotAzimuth,trajectory,rotationVector,length)

cosE = cos(rotElevation);
cosA = cos(rotAzimuth);
sinE = sin(rotElevation);
sinA = sin(rotAzimuth);

X=zeros(1,length);
Y=zeros(1,length);
Z=zeros(1,length);
pitch=zeros(1,length);
roll=zeros(1,length);
yaw=zeros(1,length);

RAD2DEG=180.0/pi;

for i=1:length
    
    sinB = sin(trajectory(i));
    cosB = cos(trajectory(i));

    xval = ((cosE*cosE*cosA+(-sinA*sinB+sinE*cosA*cosB)*sinE)*cosA+(sinA*cosB+sinE*cosA*sinB)*sinA)*point.x + ...
    (-(cosE*cosE*cosA+(-sinA*sinB+sinE*cosA*cosB)*sinE)*sinA+(sinA*cosB+sinE*cosA*sinB)*cosA)*point.y + ...
    (-cosE*cosA*sinE+(-sinA*sinB+sinE*cosA*cosB)*cosE)*point.z + ...
    -((cosE*cosE*cosA+(-sinA*sinB+sinE*cosA*cosB)*sinE)*cosA+(sinA*cosB+sinE*cosA*sinB)*sinA)*rotPoint.x-(-(cosE*cosE*cosA+(-sinA*sinB+sinE*cosA*cosB)*sinE)*sinA+(sinA*cosB+sinE*cosA*sinB)*cosA)*rotPoint.y-(-cosE*cosA*sinE+(-sinA*sinB+sinE*cosA*cosB)*cosE)*rotPoint.z+rotPoint.x;
    X(i)=xval;

    yval = ((-cosE*cosE*sinA+(-cosA*sinB-sinE*sinA*cosB)*sinE)*cosA+(cosA*cosB-sinE*sinA*sinB)*sinA)*point.x + ...
    (-(-cosE*cosE*sinA+(-cosA*sinB-sinE*sinA*cosB)*sinE)*sinA+(cosA*cosB-sinE*sinA*sinB)*cosA)*point.y + ...
    (cosE*sinA*sinE+(-cosA*sinB-sinE*sinA*cosB)*cosE)*point.z + ...
    -((-cosE*cosE*sinA+(-cosA*sinB-sinE*sinA*cosB)*sinE)*cosA+(cosA*cosB-sinE*sinA*sinB)*sinA)*rotPoint.x-(-(-cosE*cosE*sinA+(-cosA*sinB-sinE*sinA*cosB)*sinE)*sinA+(cosA*cosB-sinE*sinA*sinB)*cosA)*rotPoint.y-(cosE*sinA*sinE+(-cosA*sinB-sinE*sinA*cosB)*cosE)*rotPoint.z+rotPoint.y;
    Y(i)=yval;

    zval = ((-sinE*cosE+cosE*cosB*sinE)*cosA+cosE*sinB*sinA)*point.x + ...
    (-(-sinE*cosE+cosE*cosB*sinE)*sinA+cosE*sinB*cosA)*point.y + ...
    (sinE*sinE+cosE*cosE*cosB)*point.z + ...
    -((-sinE*cosE+cosE*cosB*sinE)*cosA+cosE*sinB*sinA)*rotPoint.x-(-(-sinE*cosE+cosE*cosB*sinE)*sinA+cosE*sinB*cosA)*rotPoint.y-(sinE*sinE+cosE*cosE*cosB)*rotPoint.z+rotPoint.z;
    Z(i)=zval;


    vpitch  = -asin(rotationVector.y*rotationVector.z*(1-cosB) - sinB*rotationVector.x);
    vroll =  asin((rotationVector.x*rotationVector.z*(1-cosB) + sinB*rotationVector.y)/cos(vpitch));
    vyaw  =  asin((rotationVector.y*rotationVector.x*(1-cosB) + sinB*rotationVector.z)/cos(vpitch));
    yaw(i)= vyaw*RAD2DEG;
    pitch(i) = vpitch*RAD2DEG;
    roll(i) = vroll*RAD2DEG;

end

