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
iDir1 = plotData.iDirVes;
dirArray1 = plotData.dirArrayVes;
dirRepNum1 = plotData.dirRepNumVes;
rightChoice1 = plotData.rightChoiceVes;

iDir2 = plotData.iDirVisual;
dirArray2 = plotData.dirArrayVisual;
dirRepNum2 = plotData.dirRepNumVisual;
rightChoice2 = plotData.rightChoiceVisual;

iDir3 = plotData.iDir;
dirArray3 = plotData.dirArray;
dirRepNum3 = plotData.dirRepNum;
rightChoice3 = plotData.rightChoice;

iDir4 = plotData.iDirLeftDelta;
dirArray4 = plotData.dirArrayLeftDelta;
dirRepNum4 = plotData.dirRepNumLeftDelta;
rightChoice4 = plotData.rightChoiceLeftDelta;

iDir5 = plotData.iDirRightDelta;
dirArray5 = plotData.dirArrayRightDelta;
dirRepNum5 = plotData.dirRepNumRightDelta;
rightChoice5 = plotData.rightChoiceRightDelta;

iDir100 = plotData.iDir100;
dirArray100 = plotData.dirArray100;
dirRepNum100 = plotData.dirRepNum100;
rightChoice100 = plotData.rightChoice100;

iDir110 = plotData.iDir110;
dirArray110 = plotData.dirArray110;
dirRepNum110 = plotData.dirRepNum110;
rightChoice110 = plotData.rightChoice110;

iDir120 = plotData.iDir120;
dirArray120 = plotData.dirArray120;
dirRepNum120 = plotData.dirRepNum120;
rightChoice120 = plotData.rightChoice120;

iDir130 = plotData.iDir130;
dirArray130 = plotData.dirArray130;
dirRepNum130 = plotData.dirRepNum130;
rightChoice130 = plotData.rightChoice130;

iDir114 = plotData.iDir114;
dirArray114 = plotData.dirArray114;
dirRepNum114 = plotData.dirRepNum114;
rightChoice114 = plotData.rightChoice114;

iDir115 = plotData.iDir115;
dirArray115 = plotData.dirArray115Delta;
dirRepNum115 = plotData.dirRepNum115;
rightChoice115 = plotData.rightChoice115;

iDir124 = plotData.iDir124;
dirArray124 = plotData.dirArray124;
dirRepNum124 = plotData.dirRepNum124;
rightChoice124 = plotData.rightChoice124;

iDir125 = plotData.iDir125;
dirArray125 = plotData.dirArray125;
dirRepNum125 = plotData.dirRepNum125;
rightChoice125 = plotData.rightChoice125;

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
        iInd = find(dirArray1 == dir);
        if isempty(iInd)
            iDir1 = iDir1+1;
            dirArray1(iDir1) = dir;
            dirRepNum1(iDir1) = 1;
            rightChoice1(iDir1) = 0;
            iInd = iDir1;
        else
            dirRepNum1(iInd)=dirRepNum1(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice1(iInd)=((dirRepNum1(iInd)-1)*rightChoice1(iInd)+right)/dirRepNum1(iInd);
    %%

    %% visual only.
    elseif stim_type == 2 
        iInd = find(dirArray2 == dir);
        if isempty(iInd)
            iDir2 = iDir2+1;
            dirArray2(iDir2) = dir;
            dirRepNum2(iDir2) = 1;
            rightChoice2(iDir2) = 0;
            iInd = iDir2;
        else
            dirRepNum2(iInd)=dirRepNum2(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice2(iInd)=((dirRepNum2(iInd)-1)*rightChoice2(iInd)+right)/dirRepNum2(iInd);
    %%

    %% combine.
    elseif stim_type == 3 
        iInd = find(dirArray3 == dir);
        if isempty(iInd)
            iDir3 = iDir3+1;
            dirArray3(iDir3) = dir;
            dirRepNum3(iDir3) = 1;
            rightChoice3(iDir3) = 0;
            iInd = iDir3;
        else
            dirRepNum3(iInd)=dirRepNum3(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice3(iInd)=((dirRepNum3(iInd)-1)*rightChoice3(iInd)+right)/dirRepNum3(iInd);
    %%

    %% combine with left delta.
    elseif stim_type == 4 
        iInd = find(dirArray4 == dir);
        if isempty(iInd)
            iDir4 = iDir4+1;
            dirArray4(iDir4) = dir;
            dirRepNum4(iDir4) = 1;
            rightChoice4(iDir4) = 0;
            iInd = iDir4;
        else
            dirRepNum4(iInd)=dirRepNum4(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice4(iInd)=((dirRepNum4(iInd)-1)*rightChoice4(iInd)+right)/dirRepNum4(iInd);
    %%

    %% combine with right delta.
    elseif stim_type == 5 
        iInd = find(dirArray5 == dir);
        if isempty(iInd)
            iDir5 = iDir5+1;
            dirArray5(iDir5) = dir;
            dirRepNum5(iDir5) = 1;
            rightChoice5(iDir5) = 0;
            iInd = iDir5;
        else
            dirRepNum5(iInd)=dirRepNum5(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice5(iInd)=((dirRepNum5(iInd)-1)*rightChoice5(iInd)+right)/dirRepNum5(iInd);
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
[sortDir, sortInd] = sort(dirArray3, 2);
sortRight = rightChoice3(sortInd);

[sortDirVisual, sortIndVisual] = sort(dirArray2, 2);
sortRightVisual = rightChoice2(sortIndVisual);

[sortDirVes, sortIndVes] = sort(dirArray1, 2);
sortRightVes = rightChoice1(sortIndVes);   

[sortDirLeftDelta, sortIndLeftDelta] = sort(dirArray4, 2);
sortRightLeftDelta = rightChoice4(sortIndLeftDelta);

[sortDirRightDelta, sortIndRightDelta] = sort(dirArray5, 2);
sortRightRightDelta = rightChoice5(sortIndRightDelta);

[sortDirDuplicated, sortIndDuplicated] = sort(dirArrayDuplicated, 2);
sortRightDuplicated = rightChoiceDuplicated(sortIndDuplicated);
%%

%----Plot Online Psychometric Function----
clf(figure(10));    %for clearing the past graphs results (so dont cont in the next on the same graph).

figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

%% Plot for all stimulus type.
if iDir1>0
    subplot(2,3,1)
        
    %%
    title('Vestibular only');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDirVes, sortRightVes, 'og' , 'MarkerSize' , 20);
    hold off;
end

if iDir2>0
    subplot(2,3,2)
        
    %%
    title('Visual only');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDirVisual, sortRightVisual, 'xr' , 'MarkerSize' , 20);
    hold off;
end


if iDir3>0
    subplot(2,3,3)
        
    %%
    title('Combined');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDir, sortRight, '+b' , 'MarkerSize' , 20);
    hold off;
end

if iDir4>0
    subplot(2,3,4)
        
    %%
    title('Left Delta');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDirLeftDelta, sortRightLeftDelta, 'sb' , 'MarkerSize' , 20);
    hold off;
end

if iDir5>0
    subplot(2,3,5)
        
    %%
    title('Right Delta');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDirRightDelta, sortRightRightDelta, 'pr' , 'MarkerSize' , 20);
    hold off;
end

if iDirDuplicated>0
    subplot(2,3,6)
        
    %%
    title('Duplicated');
    i = strmatch('Heading Direction',{char(within.name)},'exact');
    x = within(i).parameters.moog;
    set(gca, 'XTick', x);
    hold on;
    y1 = 0.5*ones(size(x));
    plot(x,y1,'-r');

    xlabel('Heading Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    %%
    
    plot(sortDirDuplicated, sortRightDuplicated, 'vg' , 'MarkerSize' , 20);
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
plotData.iDir = iDir3;
plotData.dirArray = dirArray3;
plotData.dirRepNum = dirRepNum3;
plotData.rightChoice= rightChoice3;

plotData.iDirVes = iDir1;
plotData.dirArrayVes = dirArray1;
plotData.dirRepNumVes = dirRepNum1;
plotData.rightChoiceVes= rightChoice1;

plotData.iDirVisual = iDir2;
plotData.dirArrayVisual = dirArray2;
plotData.dirRepNumVisual = dirRepNum2;
plotData.rightChoiceVisual = rightChoice2;

plotData.iDirLeftDelta = iDir4;
plotData.dirArrayLeftDelta = dirArray4;
plotData.dirRepNumLeftDelta = dirRepNum4;
plotData.rightChoiceLeftDelta= rightChoice4;

plotData.iDirRightDelta = iDir5;
plotData.dirArrayRightDelta = dirArray5;
plotData.dirRepNumRightDelta = dirRepNum5;
plotData.rightChoiceRightDelta = rightChoice5;

plotData.iDirDuplicated = iDirDuplicated;
plotData.dirArrayDuplicated = dirArrayDuplicated;
plotData.dirRepNumDuplicated = dirRepNumDuplicated;
plotData.rightChoiceDuplicated = rightChoiceDuplicated;
%%

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting adaptPlotPsychFunc')
end
