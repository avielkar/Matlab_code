function DeltaAdaptPlotPsychFunc(appHandle)

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

%% plot data veriables initialization.
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

iDirLeftDelta = plotData.iDirLeftDelta;
dirArrayLeftDelta = plotData.dirArrayLeftDelta;
dirRepNumLeftDelta = plotData.dirRepNumLeftDelta;
rightChoiceLeftDelta = plotData.rightChoiceLeftDelta;

iDirRightDelta = plotData.iDirRightDelta;
dirArrayRightDelta = plotData.dirArrayRightDelta;
dirRepNumRightDelta = plotData.dirRepNumRightDelta;
rightChoiceRightDelta = plotData.rightChoiceRightDelta;

iDirDuplicated = plotData.iDirDuplicated;
dirArrayDuplicated = plotData.dirArrayDuplicated;
dirRepNumDuplicated = plotData.dirRepNumDuplicated;
rightChoiceDuplicated = plotData.rightChoiceDuplicated;
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
%-----avi:for Adam1_Delta protocol(only with staircase for now).
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
     
%% check the type of the current stimulus type to update(include the duplicated one)
if(~trial(activeStair,activeRule).duplicatedTrial)
    
    %% Vestibular only.
    if stim_type == 1 
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
    %%

    %% visual only.
    elseif stim_type == 2 
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
    %%

    %% combine.
    elseif stim_type == 3 
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
    %%

    %% combine with left delta.
    elseif stim_type == 4 
        iInd = find(dirArrayLeftDelta == dir);
        if isempty(iInd)
            iDirLeftDelta = iDirLeftDelta+1;
            dirArrayLeftDelta(iDirLeftDelta) = dir;
            dirRepNumLeftDelta(iDirLeftDelta) = 1;
            rightChoiceLeftDelta(iDirLeftDelta) = 0;
            iInd = iDirLeftDelta;
        else
            dirRepNumLeftDelta(iInd)=dirRepNumLeftDelta(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoiceLeftDelta(iInd)=((dirRepNumLeftDelta(iInd)-1)*rightChoiceLeftDelta(iInd)+right)/dirRepNumLeftDelta(iInd);
    %%

    %% combine with right delta.
    elseif stim_type == 5 
        iInd = find(dirArrayRightDelta == dir);
        if isempty(iInd)
            iDirRightDelta = iDirRightDelta+1;
            dirArrayRightDelta(iDirRightDelta) = dir;
            dirRepNumRightDelta(iDirRightDelta) = 1;
            rightChoiceRightDelta(iDirRightDelta) = 0;
            iInd = iDirRightDelta;
        else
            dirRepNumRightDelta(iInd)=dirRepNumRightDelta(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoiceRightDelta(iInd)=((dirRepNumRightDelta(iInd)-1)*rightChoiceRightDelta(iInd)+right)/dirRepNumRightDelta(iInd);
    %%
    end
%if the trial is the duplicated type trial    
else
    %% duplicated type trial
        iInd = find(dirArrayDuplicated == dir);
        if isempty(iInd)
            iDirDuplicated = iDirDuplicated+1;
            dirArrayDuplicated(iDirDuplicated) = dir;
            dirRepNumDuplicated(iDirDuplicated) = 1;
            rightChoiceDuplicated(iDirDuplicated) = 0;
            iInd = iDirDuplicated;
        else
            dirRepNumDuplicated(iInd)=dirRepNumDuplicated(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoiceDuplicated(iInd)=((dirRepNumDuplicated(iInd)-1)*rightChoiceDuplicated(iInd)+right)/dirRepNumDuplicated(iInd);
    %% 
end

%% sorting stimulus types for plot include duplicated.
[sortDir, sortInd] = sort(dirArray, 2);
sortRight = rightChoice(sortInd);

[sortDirVisual, sortIndVisual] = sort(dirArrayVisual, 2);
sortRightVisual = rightChoiceVisual(sortIndVisual);

[sortDirVes, sortIndVes] = sort(dirArrayVes, 2);
sortRightVes = rightChoiceVes(sortIndVes);   

[sortDirLeftDelta, sortIndLeftDelta] = sort(dirArrayLeftDelta, 2);
sortRightLeftDelta = rightChoiceLeftDelta(sortIndLeftDelta);

[sortDirRightDelta, sortIndRightDelta] = sort(dirArrayRightDelta, 2);
sortRightRightDelta = rightChoiceRightDelta(sortIndRightDelta);

[sortDirDuplicated, sortIndDuplicated] = sort(dirArrayDuplicated, 2);
sortRightDuplicated = rightChoiceDuplicated(sortIndDuplicated);
%%

%----Plot Online Psychometric Function----
clf(figure(10));    %for clearing the past graphs results (so dont cont in the next on the same graph).

figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

%% Plot for all stimulus type.
if iDirVes>0
    subplot(2,3,1)
        
    %%
    title('Vestibular only');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirVes, sortRightVes, 'og' ,'MarkerSize' , 5);
    hold off;
end

if iDirVisual>0
    subplot(2,3,2)
        
    %%
    title('Visual only');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirVisual, sortRightVisual, 'xr' ,'MarkerSize' , 5);
    hold off;
end


if iDir>0
    subplot(2,3,3)
        
    %%
    title('Combined');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDir, sortRight, '+b' ,'MarkerSize' , 5);
    hold off;
end

if iDirLeftDelta>0
    subplot(2,3,4)
        
    %%
    title('Left Delta');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirLeftDelta, sortRightLeftDelta, 'sb' ,'MarkerSize' , 5);
    hold off;
end

if iDirRightDelta>0
    subplot(2,3,5)
        
    %%
    title('Right Delta');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirRightDelta, sortRightRightDelta, 'pr' ,'MarkerSize' , 5);
    hold off;
end

if iDirDuplicated>0
    subplot(2,3,6)
        
    %%
    title('Duplicated');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    if(~isempty(i))
        x = within(i).parameters.moog;
    else
        i = strmatch('Heading Direction',{char(varying.name)},'exact');
        x = varying(i).parameters.moog;
    end
    
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r','MarkerSize' , 5);

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r','MarkerSize' , 5);

    grid on;
    %%
    
    plot(sortDirDuplicated, sortRightDuplicated, 'vg' ,'MarkerSize' , 5);
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

%% saving the online plot data.
plotData.iDir = iDir;
plotData.dirArray = dirArray;
plotData.dirRepNum = dirRepNum;
plotData.rightChoice= rightChoice;

plotData.iDirVes = iDirVes;
plotData.dirArrayVes = dirArrayVes;
plotData.dirRepNumVes = dirRepNumVes;
plotData.rightChoiceVes= rightChoiceVes;

plotData.iDirVisual = iDirVisual;
plotData.dirArrayVisual = dirArrayVisual;
plotData.dirRepNumVisual = dirRepNumVisual;
plotData.rightChoiceVisual = rightChoiceVisual;

plotData.iDirLeftDelta = iDirLeftDelta;
plotData.dirArrayLeftDelta = dirArrayLeftDelta;
plotData.dirRepNumLeftDelta = dirRepNumLeftDelta;
plotData.rightChoiceLeftDelta= rightChoiceLeftDelta;

plotData.iDirRightDelta = iDirRightDelta;
plotData.dirArrayRightDelta = dirArrayRightDelta;
plotData.dirRepNumRightDelta = dirRepNumRightDelta;
plotData.rightChoiceRightDelta = rightChoiceRightDelta;

plotData.iDirDuplicated = iDirDuplicated;
plotData.dirArrayDuplicated = dirArrayDuplicated;
plotData.dirRepNumDuplicated = dirRepNumDuplicated;
plotData.rightChoiceDuplicated = rightChoiceDuplicated;
%%

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting adaptPlotPsychFunc')
end
