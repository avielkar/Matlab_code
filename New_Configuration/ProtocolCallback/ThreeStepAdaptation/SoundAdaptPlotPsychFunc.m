function SoundAdaptPlotPsychFunc(appHandle)

global debug

if debug
    disp('Entering adaptPlotPsychFunc')
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

iDirSound = plotData.iDirSound;
dirArraySound = plotData.dirArraySound;
dirRepNumSound = plotData.dirRepNumSound;
rightChoiceSound = plotData.rightChoiceSound;

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
%avi :status_type for deciding which status type is :
%                                           static = 1
%                                           varying = 2
%                                          withinstair = 3
%status_type = data.configinfo(i).status;
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

if stim_type == 102  %combined sound + visual
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
elseif stim_type == 100 %sound only
    iInd = find(dirArraySound == dir);
    if isempty(iInd)
        iDirSound = iDirSound+1;
        dirArraySound(iDirSound) = dir;
        dirRepNumSound(iDirSound) = 1;
        rightChoiceSound(iDirSound) = 0;
        iInd = iDirSound;
    else
        dirRepNumSound(iInd)=dirRepNumSound(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceSound(iInd)=((dirRepNumSound(iInd)-1)*rightChoiceSound(iInd)+right)/dirRepNumSound(iInd);
end
[sortDir, sortInd] = sort(dirArray, 2);
sortRight = rightChoice(sortInd);
[sortDirVisual, sortIndVisual] = sort(dirArrayVisual, 2);
sortRightVisual = rightChoiceVisual(sortIndVisual);
[sortDirSound, sortIndSound] = sort(dirArraySound, 2);
sortRightSound = rightChoiceSound(sortIndSound);   

%----Plot Online Psychometric Function----
figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

if iDirSound>0
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDirSound, sortRightSound, '+' , 'linewidth' , 2);
    else
        plot(sortDirSound, sortRightSound, 'o' , 'linewidth' , 2);
    end
    hold on;
end

if iDirVisual>0
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDirVisual, sortRightVisual, 'xr' , 'linewidth' , 2);
    else
        plot(sortDirVisual, sortRightVisual, 'or' , 'linewidth' , 2);
    end
    hold on;
end

if iDir>0
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDir, sortRight, 'og' , 'linewidth' , 2);
    else
        plot(sortDir, sortRight, 'xg' , 'linewidth' , 2);
    end
    hold on;
end

%decide which of the parameters to call by the status variable 
title('Online Psychometric Function');

%avi
%if(status_type == 2)    % if varying status
%     i = strmatch('Heading Direction',{char(varying.name)},'exact');
%     x = varying(i).parameters.moog;
% elseif(status_type == 3 || status_type == 1)    %if within status or static status.
%     i = strmatch('Heading Direction',{char(within.name)},'exact');
%     x = within(i).parameters.moog;
% end

%original code is only the two line
%i = strmatch('Heading Direction',{char(varying.name)},'exact');
%x = varying(i).parameters.moog;

%avi - check the type of the Heading Direction parameter.
i = strmatch('Heading Direction',{char(varying.name)},'exact');
if(size(i) == 0) %if the size is 0 , it means that no match found ,else a match has been found.
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(size(i) == 0)%Heading Direction is across type.
        x = across(i).parameters.moog;        
    else%Heading Direction is within type.
        x = within(i).parameters.moog;
    end
else%Heading Direction is varying type.
    x = varying(i).parameters.moog;
end

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

plotData.iDirSound = iDirSound;
plotData.dirArraySound = dirArraySound;
plotData.dirRepNumSound = dirRepNumSound;
plotData.rightChoiceSound = rightChoiceSound;

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting adaptPlotPsychFunc')
end

