function RotMakeData(appHandle)

% take configfile and condvect and create a trial by trial parameter list
% for saving. 

SavedInfo = getappdata(appHandle,'SavedInfo');
data = getappdata(appHandle,'protinfo');
crossvals = getappdata(appHandle,'CrossVals');
trial = getappdata(appHandle,'trialInfo');
Resp = getappdata(appHandle,'ResponseInfo');
rep = data.repNum;

for i1 = 1:size(data.configinfo,2)
    name = data.configinfo(i1).name;
    if data.configinfo(i1).status ~= 2
        val = data.configinfo(i1).parameters;
    else
        niceName = char(data.configinfo(i1).nice_name);
        i2 = strmatch(niceName,{char(data.condvect.varying.name)},'exact');
        val = crossvals(trial.list(trial.cntr),i2);
    end
    SavedInfo.Rep(rep).Trial(trial.cntr).Param(i1).name = name;
    SavedInfo.Rep(rep).Trial(trial.cntr).Param(i1).value = val;
end
% SavedInfo.Rep(rep).Trial(trial.cntr).Resp = resp;
SavedInfo.Resp = Resp;
setappdata(appHandle,'SavedInfo',SavedInfo);


