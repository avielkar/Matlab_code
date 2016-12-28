function v=gaussfunc(t, q)
%GAUSSFUNC Used by GAUSSFIT.
%  GAUSSFUNC assumes a function of the form
%
%	  y = q(1) + q(2) * exp(-0.5*( (x - q(3))/q(4) ).^2 )
%
%	thus q(1) is base rate, q(2) is amplitude, q(3) is center, and q(4) is size
%clear;
%clf;
%q=[1 2 1 1];
%x=-4:0.1:6;
%z = q(1) + q(2) * exp(-0.5*((x - q(3))/ q(4)).^2);
%plot(x,z,'r');
%hold on;
%q=[1 2 1 2];
%x=-4:0.1:6;
%z = q(1) + q(2) * exp(-0.5*((x - q(3))/ q(4)).^2);
%plot(x,z,'g');
%return;
v=q(1) + q(2) * exp(-0.5*((t - q(3))/ q(4)).^2);
return;


