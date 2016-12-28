function [data] = GenTriangle(time, dist, frequency)

if (dist > 0)
    time_half = time/2; %time to middle of trajectory
    time_vec_whole = [0:1/frequency:time];
    time_vec_half =  [0:1/frequency:time_half];

    % Generate the triangle profile
    % 1st half
    a = 4.0*dist/time_half^2;
    vel_vec_final = a * time_vec_half;
    dist_vec_1st = 0.5 * vel_vec_final .* time_vec_half;

    % 2nd half
    % turning point of triangle velocity
    u = a * time/2;

    t = time_vec_whole(ceil(length(time_vec_whole)/2) : end) - time_half;
    v = u - a*t;


    data = cat(2, vel_vec_final, v);
    data = data/max(data) * dist;

elseif (dist < 0)
    dist = dist * -1;
    time_half = time/2; %time to middle of trajectory
    time_vec_whole = [0:1/frequency:time];
    time_vec_half =  [0:1/frequency:time_half];

    % Generate the triangle profile
    % 1st half
    a = 4.0*dist/time_half^2;
    vel_vec_final = a * time_vec_half;
    dist_vec_1st = 0.5 * vel_vec_final .* time_vec_half;

    % 2nd half
    % turning point of triangle velocity
    u = a * time/2;

    t = time_vec_whole(ceil(length(time_vec_whole)/2) : end) - time_half;
    v = u - a*t;


    data = cat(2, vel_vec_final, v);
    data = data/max(data) * dist;
    data = data * -1;

end