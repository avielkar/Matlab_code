function [vel] = GenTriangleR(time, dist, frequency)

time_half = time/2;
time_vec_half =  [0:1/frequency:time_half];

vel1=2*dist/time/time_half*time_vec_half;
len=max(size(vel1))-1;

for i=1:len
    vel2(i)=vel1(len+1-i);
end

vel=cat(2,vel1,vel2);
