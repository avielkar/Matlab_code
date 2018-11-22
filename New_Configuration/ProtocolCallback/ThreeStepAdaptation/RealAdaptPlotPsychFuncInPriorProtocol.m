function RealAdaptPlotPsychFuncInPriorProtocol(appHandle)

global debug

if debug
    disp('Entering adaptPlotPsychFunc')
end

%% take all the appHandle variables.
data = getappdata(appHandle,'protinfo');
crossvals = getappdata(appHandle, 'CrossVals');
trial = getappdata(appHandle,'trialInfo');
cldata = getappdata(appHandle, 'ControlLoopData'); 
savedInfo = getappdata(appHandle,'SavedInfo');
plotData = getappdata(appHandle,'psychPlot');
%%

%% left priors initialization.
iDirLeftPriorCombined = plotData.iDirLeftPriorCombined;
dirArrayLeftPriorCombined = plotData.dirArrayLeftPriorCombined;
dirRepNumLeftPriorCombined = plotData.dirRepNumLeftPriorCombined;
rightChoiceLeftPriorCombined = plotData.rightChoiceLeftPriorCombined;

iDirLeftPriorVes = plotData.iDirLeftPriorVes;
dirArrayLeftPriorVes = plotData.dirArrayLeftPriorVes;
dirRepNumLeftPriorVes = plotData.dirRepNumLeftPriorVes;
rightChoiceLeftPriorVes = plotData.rightChoiceLeftPriorVes;

iDirLeftPriorVisual = plotData.iDirLeftPriorVisual;
dirArrayLeftPriorVisual = plotData.dirArrayLeftPriorVisual;
dirRepNumLeftPriorVisual = plotData.dirRepNumLeftPriorVisual;
rightChoiceLeftPriorVisual = plotData.rightChoiceLeftPriorVisual;
%%

%% right priors initialization.
iDirRightPriorCombined = plotData.iDirRightPriorCombined;
dirArrayRightPriorCombined = plotData.dirArrayRightPriorCombined;
dirRepNumRightPriorCombined = plotData.dirRepNumRightPriorCombined;
rightChoiceRightPriorCombined = plotData.rightChoiceRightPriorCombined;

iDirRightPriorVes = plotData.iDirRightPriorVes;
dirArrayRightPriorVes = plotData.dirArrayRightPriorVes;
dirRepNumRightPriorVes = plotData.dirRepNumRightPriorVes;
rightChoiceRightPriorVes = plotData.rightChoiceRightPriorVes;

iDirRightPriorVisual = plotData.iDirRightPriorVisual;
dirArrayRightPriorVisual = plotData.dirArrayRightPriorVisual;
dirRepNumRightPriorVisual = plotData.dirRepNumRightPriorVisual;
rightChoiceRightPriorVisual = plotData.rightChoiceRightPriorVisual;
%%

%% take activeStair , activeRule , currRep ,currTrial information.
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
%%

%% check for stim_type, dir , and response
%-----avi:for Adam1_Priors protocol(only with staircase for now).
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
%-----end
%%
        
%% vestibular only with left prior
if stim_type == 6 
    iInd = find(dirArrayLeftPriorVes == dir);
    if isempty(iInd)
        iDirLeftPriorVes = iDirLeftPriorVes+1;
        dirArrayLeftPriorVes(iDirLeftPriorVes) = dir;
        dirRepNumLeftPriorVes(iDirLeftPriorVes) = 1;
        rightChoiceLeftPriorVes(iDirLeftPriorVes) = 0;
        iInd = iDirLeftPriorVes;
    else
        dirRepNumLeftPriorVes(iInd)=dirRepNumLeftPriorVes(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceLeftPriorVes(iInd)=((dirRepNumLeftPriorVes(iInd)-1)*rightChoiceLeftPriorVes(iInd)+right)/dirRepNumLeftPriorVes(iInd);
%%
        
%% visual only with left prior
elseif stim_type == 7 
    iInd = find(dirArrayLeftPriorVisual == dir);
    if isempty(iInd)
        iDirLeftPriorVisual = iDirLeftPriorVisual+1;
        dirArrayLeftPriorVisual(iDirLeftPriorVisual) = dir;
        dirRepNumLeftPriorVisual(iDirLeftPriorVisual) = 1;
        rightChoiceLeftPriorVisual(iDirLeftPriorVisual) = 0;
        iInd = iDirLeftPriorVisual;
    else
        dirRepNumLeftPriorVisual(iInd)=dirRepNumLeftPriorVisual(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceLeftPriorVisual(iInd)=((dirRepNumLeftPriorVisual(iInd)-1)*rightChoiceLeftPriorVisual(iInd)+right)/dirRepNumLeftPriorVisual(iInd);
%%
        
%% combine with left prior
elseif stim_type == 8 
    iInd = find(dirArrayLeftPriorCombined == dir);
    if isempty(iInd)
        iDirLeftPriorCombined = iDirLeftPriorCombined+1;
        dirArrayLeftPriorCombined(iDirLeftPriorCombined) = dir;
        dirRepNumLeftPriorCombined(iDirLeftPriorCombined) = 1;
        rightChoiceLeftPriorCombined(iDirLeftPriorCombined) = 0;
        iInd = iDirLeftPriorCombined;
    else
        dirRepNumLeftPriorCombined(iInd)=dirRepNumLeftPriorCombined(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceLeftPriorCombined(iInd)=((dirRepNumLeftPriorCombined(iInd)-1)*rightChoiceLeftPriorCombined(iInd)+right)/dirRepNumLeftPriorCombined(iInd);
%%
        
%% vestibular only with right prior
elseif stim_type == 9 
    iInd = find(dirArrayRightPriorVes == dir);
    if isempty(iInd)
        iDirRightPriorVes = iDirRightPriorVes+1;
        dirArrayRightPriorVes(iDirRightPriorVes) = dir;
        dirRepNumRightPriorVes(iDirRightPriorVes) = 1;
        rightChoiceRightPriorVes(iDirRightPriorVes) = 0;
        iInd = iDirRightPriorVes;
    else
        dirRepNumRightPriorVes(iInd)=dirRepNumRightPriorVes(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceRightPriorVes(iInd)=((dirRepNumRightPriorVes(iInd)-1)*rightChoiceRightPriorVes(iInd)+right)/dirRepNumRightPriorVes(iInd);
%%
    
%% visual only with right prior
elseif stim_type == 10 
    iInd = find(dirArrayRightPriorVisual == dir);
    if isempty(iInd)
        iDirRightPriorVisual = iDirRightPriorVisual+1;
        dirArrayRightPriorVisual(iDirRightPriorVisual) = dir;
        dirRepNumRightPriorVisual(iDirRightPriorVisual) = 1;
        rightChoiceRightPriorVisual(iDirRightPriorVisual) = 0;
        iInd = iDirRightPriorVisual;
    else
        dirRepNumRightPriorVisual(iInd)=dirRepNumRightPriorVisual(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceRightPriorVisual(iInd)=((dirRepNumRightPriorVisual(iInd)-1)*rightChoiceRightPriorVisual(iInd)+right)/dirRepNumRightPriorVisual(iInd);
%%
    
%% combine with right prior
elseif stim_type == 11 
    iInd = find(dirArrayRightPriorCombined == dir);
    if isempty(iInd)
        iDirRightPriorCombined = iDirRightPriorCombined+1;
        dirArrayRightPriorCombined(iDirRightPriorCombined) = dir;
        dirRepNumRightPriorCombined(iDirRightPriorCombined) = 1;
        rightChoiceRightPriorCombined(iDirRightPriorCombined) = 0;
        iInd = iDirRightPriorCombined;
    else
        dirRepNumRightPriorCombined(iInd)=dirRepNumRightPriorCombined(iInd)+1;
    end

    if response == 2
        right=1;
    else
        right=0;
    end

    rightChoiceRightPriorCombined(iInd)=((dirRepNumRightPriorCombined(iInd)-1)*rightChoiceRightPriorCombined(iInd)+right)/dirRepNumRightPriorCombined(iInd);
%%
end

%% sorting left prior types for plot.
[sortDirLeftPriorCombined, sortInd] = sort(dirArrayLeftPriorCombined, 2);
sortRightLeftPriorCombined = rightChoiceLeftPriorCombined(sortInd);

[sortDirLeftPriorVisual, sortIndVisual] = sort(dirArrayLeftPriorVisual, 2);
sortRightLeftPriorVisual = rightChoiceLeftPriorVisual(sortIndVisual);

[sortDirLeftPriorVes, sortIndVes] = sort(dirArrayLeftPriorVes, 2);
sortRightLeftPriorVes = rightChoiceLeftPriorVes(sortIndVes);   
%%

%% sort right prior types for plot.
[sortDirRightPriorCombined, sortInd] = sort(dirArrayRightPriorCombined, 2);
sortRightRightPriorCombined = rightChoiceRightPriorCombined(sortInd);

[sortDirRightPriorVisual, sortIndVisual] = sort(dirArrayRightPriorVisual, 2);
sortRightRightPriorVisual = rightChoiceRightPriorVisual(sortIndVisual);

[sortDirRightPriorVes, sortIndVes] = sort(dirArrayRightPriorVes, 2);
sortRightRightPriorVes = rightChoiceRightPriorVes(sortIndVes);   
%%

%----Plot Online Psychometric Function----
clf(figure(10));    %for clearing the past graphs results (so dont cont in the next on the same graph).

figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

%% Plot for left priors.
if iDirLeftPriorVes>0
    subplot(2,3,1)
        
    %%
    title('vestibular only with left prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirLeftPriorVes, sortRightLeftPriorVes, '+b' ,'MarkerSize' , 5);
    hold off;
end

if iDirLeftPriorVisual>0
    subplot(2,3,2)
        
    %%
    title('visual only with left prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirLeftPriorVisual, sortRightLeftPriorVisual, 'xr' ,'MarkerSize' , 5);
    hold off;
end

if iDirLeftPriorCombined>0
    subplot(2,3,3)
        
    %%
    title('visual only with left prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirLeftPriorCombined, sortRightLeftPriorCombined, 'og' ,'MarkerSize' , 5);
    hold off;
end
%%

%% Plot for right priors.
if iDirRightPriorVes>0
    subplot(2,3,4)

    %%
    title('vestibular only with right prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirRightPriorVes, sortRightRightPriorVes, 'sb' ,'MarkerSize' , 5);
    hold off;
end

if iDirRightPriorVisual>0
    subplot(2,3,5)
    
    %%
    title('visual only with rigth prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirRightPriorVisual, sortRightRightPriorVisual, 'pr' ,'MarkerSize' , 5);
    hold off;
end

if iDirRightPriorCombined>0
    subplot(2,3,6)
    
    %%
    title('combine with right prior');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r' , 'MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y  , 'MarkerSize' , 5);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r' , 'MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirRightPriorCombined, sortRightRightPriorCombined, 'vg' ,'MarkerSize' , 5);
    hold off;
end
%%

%% Plot on the same graph the axes pf the graph. - Dont want all in one graph , in subplots maked upsatir code.
% subplot(3,3,8)
% title('Online Psychometric Function');
% i = strmatch('Heading Direction',{char(within.name)},'exact');
% x = within(i).parameters.moog;
% set(gca, 'XTick', x);
% hold on;
% y1 = 0.5*ones(size(x));
% plot(x,y1,'-r');
% 
% xlabel('Heading Angle (deg)');
% 
% y=0 : 0.1 : 1;
% ylim([0 1]);
% set(gca, 'YTick', y);
% ylabel('Rightward Dicisions%');
% 
% hold on;
% x1 = zeros(size(y));
% plot(x1,y,'-r');
% 
% grid on;
% hold off;
%%

%% saving the left prior online plot data.
plotData.iDirLeftPriorCombined = iDirLeftPriorCombined;
plotData.dirArrayLeftPriorCombined = dirArrayLeftPriorCombined;
plotData.dirRepNumLeftPriorCombined = dirRepNumLeftPriorCombined;
plotData.rightChoiceLeftPriorCombined = rightChoiceLeftPriorCombined;

plotData.iDirLeftPriorVisual = iDirLeftPriorVisual;
plotData.dirArrayLeftPriorVisual = dirArrayLeftPriorVisual;
plotData.dirRepNumLeftPriorVisual = dirRepNumLeftPriorVisual;
plotData.rightChoiceLeftPriorVisual = rightChoiceLeftPriorVisual;

plotData.iDirLeftPriorVes = iDirLeftPriorVes;
plotData.dirArrayLeftPriorVes = dirArrayLeftPriorVes;
plotData.dirRepNumLeftPriorVes = dirRepNumLeftPriorVes;
plotData.rightChoiceLeftPriorVes = rightChoiceLeftPriorVes;
%%

%% saving the right prior online plot data.
plotData.iDirRightPriorCombined = iDirRightPriorCombined;
plotData.dirArrayRightPriorCombined = dirArrayRightPriorCombined;
plotData.dirRepNumRightPriorCombined = dirRepNumRightPriorCombined;
plotData.rightChoiceRightPriorCombined = rightChoiceRightPriorCombined;

plotData.iDirRightPriorVisual = iDirRightPriorVisual;
plotData.dirArrayRightPriorVisual = dirArrayRightPriorVisual;
plotData.dirRepNumRightPriorVisual = dirRepNumRightPriorVisual;
plotData.rightChoiceRightPriorVisual = rightChoiceRightPriorVisual;

plotData.iDirRightPriorVes = iDirRightPriorVes;
plotData.dirArrayRightPriorVes = dirArrayRightPriorVes;
plotData.dirRepNumRightPriorVes = dirRepNumRightPriorVes;
plotData.rightChoiceRightPriorVes = rightChoiceRightPriorVes;
%%

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting adaptPlotPsychFunc')
end
