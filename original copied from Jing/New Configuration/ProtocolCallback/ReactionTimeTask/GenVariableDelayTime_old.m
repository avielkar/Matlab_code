function t=GenVariableDelayTime
global basicfig

data = getappdata(basicfig,'protinfo');

i = strmatch('DELAYTIME_LOW',{char(data.configinfo.name)},'exact');
tmin = data.configinfo(i).parameters;
i = strmatch('DELAYTIME_HIGH',{char(data.configinfo.name)},'exact');
tmax = data.configinfo(i).parameters;

imax = tmax-tmin;

xmin = log(tmin);
xmax = log(tmax);

i=round(imax*rand());
x= xmin+(xmax-xmin)/imax*(i-1);
t=round(exp(x));

if t<tmin
    t=tmin;
end

if t>tmax
    t=tmax;
end

t = t/1000;









