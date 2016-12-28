function t=GenVariableDelayTime
global basicfig

data = getappdata(basicfig,'protinfo');

tmin = 0;
tmax = 0;
t=0;
i = strmatch('DELAYTIME_LOW',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    tmin = data.configinfo(i).parameters;
end
i = strmatch('DELAYTIME_HIGH',{char(data.configinfo.name)},'exact');
if ~isempty(i)
    tmax = data.configinfo(i).parameters;
end

if tmax~=0
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
end









