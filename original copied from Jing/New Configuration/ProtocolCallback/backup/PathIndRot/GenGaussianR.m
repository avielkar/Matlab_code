function [data] = GenGaussianR(dur, sig, mag, hz)
t0 = dur/2;
t = [0:1/hz:dur];

% Generate the Gaussian.
data = exp(-sqrt(2)* ((t-t0) / (dur/sig)).^2);

% Normalize it to mag.
data = data/max(data)*mag;