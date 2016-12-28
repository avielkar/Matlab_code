function [data] = GenGabor(dur, sig, mag, hz)

% sig=4;
% dur=4;
% mag=1;
% hz=60;
cyc=1; % This is # of cycles of sine wave; could be passed in.

t0 = dur/2;
t = [0:1/hz:dur];
gauss = exp(-sqrt(2)* ((t-t0) / (dur/sig)).^2);
sine = sin((t-t0)/dur*cyc*2*pi);
data = diff(gauss .* sine); % convert from position to velocity profile
data=data/max(data)*mag; % normalize to magnitude
% figure(7); plot(data);
