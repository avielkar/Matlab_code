function [data] = GenGaussian(dur, sig, mag, hz)
t0 = dur/2;
t = [0:1/hz:dur];

% Generate the Gaussian.
%avi : change the equation for the rate
%data = exp(-sqrt(2)* ((t-t0) / (dur/sig)).^2);



data = exp(-0.5* ((t-t0) / (dur/(2*sig))).^2);

% Normalize it to mag.
data = data/max(data)*mag;