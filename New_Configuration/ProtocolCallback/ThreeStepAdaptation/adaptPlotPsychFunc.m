function adaptPlotPsychFunc(appHandle)

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

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motionType = data.configinfo(i).parameters;

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

order = getappdata(appHandle,'Order'); % setting directions same order as in trajectory

%remember that: dir = tmpDir(intOrder(2))- tmpDir(intOrder(1));
dir = savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial);

if(numel(order) == 2 && order(1) == 2)
    dir = - dir;
end

response = savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
%change the rsponse map if 2I , 4->1, 3->2
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if( data.configinfo(i).parameters == 3)
    if(response == 4)
        response = 1;
    elseif(response == 3)
        response = 2;
    end
end

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

    if(motionType == 3)
        if (response == 2 && order(2) == 2) || (response == 1 && order(1) == 2)
            right=1;
        else
            right=0;
        end
    else
        if response == 2
            right=1;
        else
            right=0;
        end
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

    if(motionType == 3)
        if (response == 2 && order(2) == 2) || (response == 1 && order(1) == 2)
            right=1;
        else
            right=0;
        end
    else
        if response == 2
            right=1;
        else
            right=0;
        end
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
    
    if(motionType == 3)
        if (response == 2 && order(2) == 2) || (response == 1 && order(1) == 2)
            right=1;
        else
            right=0;
        end
    else
        if response == 2
            right=1;
        else
            right=0;
        end
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
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDirVes, sortRightVes, '+' , 'linewidth' , 2 , 'MarkerSize' , 8);
    else
        plot(sortDirVes, sortRightVes, 'o' , 'linewidth' , 2 , 'MarkerSize' , 8);
    end
    hold on;
end

if iDirVisual>0
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDirVisual, sortRightVisual, 'xr' , 'linewidth' , 2 , 'MarkerSize' , 8);
    else
        plot(sortDirVisual, sortRightVisual, 'or' , 'linewidth' , 2 , 'MarkerSize' , 8);
    end
    hold on;
end

if iDir>0
    %for different symbols for each active stair.
    if(activeStair == 1)
        plot(sortDir, sortRight, 'og' , 'linewidth' , 2 , 'MarkerSize' , 8);
    else
        plot(sortDirVes, sortRightVes, 'xg' , 'linewidth' , 2 , 'MarkerSize' , 8);
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
if(size(i) == 0) %if heading direction is not varying.
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(size(i) ~= 0)%if heading direction is not within.
        x = within(i).parameters.moog;
    end
else%Heading Direction is varying type.
    x = varying(i).parameters.moog;
end

%if i==0 it means that the paramter is not heading discrimination.
is_heading = true;
if(isempty(i))
    is_heading= false;
   i = strmatch('Distance',{char(within.name)},'exact');
   i_2ndDistance = strmatch('DIST_2I',{char(data.configinfo.name)},'exact');
   x_graph_values = within(i).parameters.moog - data.configinfo(i_2ndDistance).parameters.moog;
   x = union(-x_graph_values , x_graph_values);
end

if(is_heading == true)
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    hold on;
    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    hold off;
else
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Reference - Test (cm)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Reference > Test');

    hold on;
    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    hold off;
end

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
    disp('Exiting adaptPlotPsychFunc')
end

