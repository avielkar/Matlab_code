function [data,vel,accel] = GenTrapezoid(time, dist, time1, time2, frequency)

%frequency = 60;
time_step = 1/frequency;
time1 = time1 * time;
time2 = time2 * time;
t = 0:time_step:time; 

% %  Error handling
if time2 < time1
    disp('const. vel end time is less than const. vel start time.')
    disp('Function will not compute until this is corrected')
    return
end

if time2 > time 
    disp('const. vel end time is greater than trapezoid duration time.')
    disp('Function will not compute until this is corrected')
    return
end

% Calulating constant velocity
const_trap_vel = 2*dist/(time+time2-time1); %%constant trapezoid velocity

% Calculating trajectory b/t duration 0 -> time1 i.e. t1
i = 0;
if time1>0    
    accel1 = const_trap_vel/time1; % acceleratiion during 0 -> time1 i.e. t1;
    while(i*time_step <= time1)
        dist_vec(i + 1) = 0.5 * accel1 * i.^2 .* time_step.^2;  %s = ut + (1/2)at^2, where u=0
        i = i + 1;
    end
end


% Calculating trajectory between t1 -> t2
dist1 = 0.5 * (const_trap_vel * time1); %s = 1/2(u + v)t
while(i*time_step <= time2)
    timei = i * time_step - time1;
    %note that if time1 == time2 then the trajectory will now change to a trianglular velocity profile
    dist_vec(i + 1) = (const_trap_vel * timei) + dist1;
    i = i + 1;

end

if time2<time
    % Calculating trajectory from t2 -> t
    dist2 = const_trap_vel * (time2-time1); %%s=vt for constant v.
    accel2 = -const_trap_vel/(time-time2); %constant acceleration between duration t2->t.

    while (i * time_step <= time)
        timei = i * time_step - time2;
        dist_vec(i + 1) = const_trap_vel * timei  +  0.5 * accel2*timei^2 + dist1 + dist2;
        i = i + 1;
    end
end

data = dist_vec;

vel = diff(data)/time_step;
accel = diff(vel)/time_step/980;

figure

subplot(3,1,1), plot(t,data);grid on;
subplot(3,1,2), plot(t(1: end-1),vel);grid on;
subplot(3,1,3), plot(t(1: end-2),accel);grid on;

 



