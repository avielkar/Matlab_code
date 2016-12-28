function eyeadaptPlotPsychFunc(appHandle)

global debug

if debug
    disp('Entering eyeadaptPlotPsychFunc')
end

data = getappdata(appHandle,'protinfo');
crossvals = getappdata(appHandle, 'CrossVals');
trial = getappdata(appHandle,'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); 
savedInfo = getappdata(appHandle,'SavedInfo');
plotData = getappdata(appHandle,'psychPlot');

iDir = plotData.iDir;
dirArray = plotData.dirArray;
dirRepNum = plotData.dirRepNum;
rightChoice = plotData.rightChoice;

iDirVes = plotData.iDirVes;
dirArrayVes = plotData.dirArrayVes;
dirRepNumVes = plotData.dirRepNumVes;
rightChoiceVes = plotData.rightChoiceVes;

iDirVisual = plotData.iDirVisual;
dirArrayVisual = plotData.dirArrayVisual;
dirRepNumVisual = plotData.dirRepNumVisual;
rightChoiceVisual = plotData.rightChoiceVisual;

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;

within = data.condvect.withinStair; 
across = data.condvect.acrossStair;
varying = data.condvect.varying;

if ~isempty(varying)
    if cldata.staircase
        cntrVarying = cldata.varyingCurrInd;
    else
        cntrVarying = trial(activeStair,activeRule).list(currTrial);
    end
end

i = strmatch('STIMULUS_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).status == 2
    i1 = strmatch('Stimulus Type',{char(varying.name)},'exact');
    stim_type = crossvals(cntrVarying,i1);
elseif data.configinfo(i).status == 3 
    stim_type = across.parameters(activeStair);
elseif data.configinfo(i).status == 4   
    stim_type = within.parameters(trial(activeStair,activeRule).list(currTrial));
else
    stim_type = data.configinfo(i).parameters;
end

dir = savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial);
response = savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);

if stim_type == 3  %combine
    iInd = find(dirArray == dir);
    if isempty(iInd)
        iDir = iDir+1;
        dirArray(iDir) = dir;
        dirRepNum(iDir) = 1;
        rightChoice(iDir) = 0;
        iInd = iDir;
    else
        dirRepNum(iInd)=dirRepNum(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoice(iInd)=((dirRepNum(iInd)-1)*rightChoice(iInd)+right)/dirRepNum(iInd);    
    
elseif stim_type == 2  %visual
    iInd = find(dirArrayVisual == dir);
    if isempty(iInd)
        iDirVisual = iDirVisual+1;
        dirArrayVisual(iDirVisual) = dir;
        dirRepNumVisual(iDirVisual) = 1;
        rightChoiceVisual(iDirVisual) = 0;
        iInd = iDirVisual;
    else
        dirRepNumVisual(iInd)=dirRepNumVisual(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceVisual(iInd)=((dirRepNumVisual(iInd)-1)*rightChoiceVisual(iInd)+right)/dirRepNumVisual(iInd);    
elseif stim_type == 1 %vestibula only
    iInd = find(dirArrayVes == dir);
    if isempty(iInd)
        iDirVes = iDirVes+1;
        dirArrayVes(iDirVes) = dir;
        dirRepNumVes(iDirVes) = 1;
        rightChoiceVes(iDirVes) = 0;
        iInd = iDirVes;
    else
        dirRepNumVes(iInd)=dirRepNumVes(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceVes(iInd)=((dirRepNumVes(iInd)-1)*rightChoiceVes(iInd)+right)/dirRepNumVes(iInd);
end
[sortDir, sortInd] = sort(dirArray, 2);
sortRight = rightChoice(sortInd);
[sortDirVisual, sortIndVisual] = sort(dirArrayVisual, 2);
sortRightVisual = rightChoiceVisual(sortIndVisual);
[sortDirVes, sortIndVes] = sort(dirArrayVes, 2);
sortRightVes = rightChoiceVes(sortIndVes);   

%----Plot Online Psychometric Function----
figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

if iDirVes>0
    plot(sortDirVes, sortRightVes, '+');
    hold on;
end

if iDirVisual>0
    plot(sortDirVisual, sortRightVisual, 'xr');
    hold on;
end

if iDir>0
    plot(sortDir, sortRight, 'og');
    hold on;
end
           
title('T Online Psychometric Function');
x = within.parameters.moog;
set(gca, 'XTick', x);
hold on;
y1 = 0.5*ones(size(x));
plot(x,y1,'-r');

xlabel('Heading Angle (deg)');

y=0 : 0.1 : 1;
ylim([0 1]);
set(gca, 'YTick', y);
ylabel('Rightward Dicisions%');

hold on;
x1 = zeros(size(y));
plot(x1,y,'-r');

grid on;
hold off;

plotData.iDir = iDir;
plotData.dirArray = dirArray;
plotData.dirRepNum = dirRepNum;
plotData.rightChoice = rightChoice;

plotData.iDirVisual = iDirVisual;
plotData.dirArrayVisual = dirArrayVisual;
plotData.dirRepNumVisual = dirRepNumVisual;
plotData.rightChoiceVisual = rightChoiceVisual;

plotData.iDirVes = iDirVes;
plotData.dirArrayVes = dirArrayVes;
plotData.dirRepNumVes = dirRepNumVes;
plotData.rightChoiceVes = rightChoiceVes;

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting eyeadaptPlotPsychFunc')
end

