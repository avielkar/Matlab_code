

function [y] = make_ramped_traj(y, el, az, tamp, ramp_duration, ramp_num_sigs) 


 ramp = transTrajectory2(el, az, tamp, ramp_duration, ramp_num_sigs)

 
 
 
y(1).data = cat(2, ramp(1).data, y(1).data);
y(2).data = cat(2, ramp(2).data, y(2).data);
y(3).data = cat(2, ramp(3).data, y(3).data);
% y(4).data = cat(2, ramp(4).data, y(4).data);
% y(5).data = cat(2, ramp(5).data, y(5).data);
% y(6).data = cat(2, ramp(6).data, y(6).data);
y(7).data = cat(2, ramp(7).data, y(7).data);
y(8).data = cat(2, ramp(8).data, y(8).data);
y(9).data = cat(2, ramp(9).data, y(9).data);
% y(10).data = cat(2, ramp(10).data, y(10).data);
% y(11).data = cat(2, ramp(11).data, y(11).data);
% y(12).data = cat(2, ramp(12).data, y(12).data);

 
 
 
%  
% M(1).name = 'LATERAL_DATA';
% M(1).data = dM*xM;
% M(2).name = 'SURGE_DATA';
% M(2).data = dM*yM;
% M(3).name = 'HEAVE_DATA';
% M(3).data = dM*zM;
% M(4).name = 'YAW_DATA';
% M(4).data = 90*ones(1,dur(1)*f);
% M(5).name = 'PITCH_DATA';
% M(5).data = zeros(1,dur(1)*f);
% M(6).name = 'ROLL_DATA';
% M(6).data = zeros(1,dur(1)*f);
% M(7).name = 'GL_LATERAL_DATA';
% M(7).data = dGL*xGL;
% % M(7).data = dM*xM;
% M(8).name = 'GL_SURGE_DATA';
% M(8).data = dGL*yGL;
% % M(8).data = dM*yM;
% M(9).name = 'GL_HEAVE_DATA';
% M(9).data = dGL*zGL;
% % M(9).data = dM*zM;
% M(10).name = 'GL_ROT_ELE';
% % M(10).data = 90*ones(dur(1)*f,1);
% M(10).data = 90*ones(dur(1)*f,1);
% M(11).name = 'GL_ROT_AZ';
% % M(11).data = zeros(dur(1)*f,1);
% M(11).data = zeros(dur(1)*f,1);
% M(12).name = 'GL_ROT_DATA';
% % M(12).data = zeros(dur(1)*f,1);
% M(12).data = zeros(dur(1)*f,1);