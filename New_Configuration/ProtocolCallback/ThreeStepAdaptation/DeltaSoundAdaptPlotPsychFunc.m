function DeltaSoundAdaptPlotPsychFunc(appHandle)

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
dirArray115 = plotData.dirArray115;
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
    
    %% sound only.
    elseif stim_type == 100 
        iInd = find(dirArray100 == dir);
        if isempty(iInd)
            iDir100 = iDir100+1;
            dirArray100(iDir100) = dir;
            dirRepNum100(iDir100) = 1;
            rightChoice100(iDir100) = 0;
            iInd = iDir100;
        else
            dirRepNum100(iInd)=dirRepNum100(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice100(iInd)=((dirRepNum100(iInd)-1)*rightChoice100(iInd)+right)/dirRepNum100(iInd);
    %%
    
    %% sound + ves
    elseif stim_type == 110 
        iInd = find(dirArray110 == dir);
        if isempty(iInd)
            iDir110 = iDir110+1;
            dirArray110(iDir110) = dir;
            dirRepNum110(iDir110) = 1;
            rightChoice110(iDir110) = 0;
            iInd = iDir110;
        else
            dirRepNum110(iInd)=dirRepNum110(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice110(iInd)=((dirRepNum110(iInd)-1)*rightChoice110(iInd)+right)/dirRepNum110(iInd);
    %%
    
    %% sound + vis
    elseif stim_type == 120 
        iInd = find(dirArray120 == dir);
        if isempty(iInd)
            iDir120 = iDir120+1;
            dirArray120(iDir120) = dir;
            dirRepNum120(iDir120) = 1;
            rightChoice120(iDir120) = 0;
            iInd = iDir120;
        else
            dirRepNum120(iInd)=dirRepNum120(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice120(iInd)=((dirRepNum120(iInd)-1)*rightChoice120(iInd)+right)/dirRepNum120(iInd);
    %%
    
    %% sound + ves + vis
 elseif stim_type == 130 
        iInd = find(dirArray130 == dir);
        if isempty(iInd)
            iDir130 = iDir130+1;
            dirArray130(iDir130) = dir;
            dirRepNum130(iDir130) = 1;
            rightChoice130(iDir130) = 0;
            iInd = iDir130;
        else
            dirRepNum130(iInd)=dirRepNum130(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice130(iInd)=((dirRepNum130(iInd)-1)*rightChoice130(iInd)+right)/dirRepNum130(iInd);
    %%
    
    %% delta sound < ves
 elseif stim_type == 114 
        iInd = find(dirArray114 == dir);
        if isempty(iInd)
            iDir114 = iDir114+1;
            dirArray114(iDir114) = dir;
            dirRepNum114(iDir114) = 1;
            rightChoice114(iDir114) = 0;
            iInd = iDir114;
        else
            dirRepNum114(iInd)=dirRepNum114(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice114(iInd)=((dirRepNum114(iInd)-1)*rightChoice114(iInd)+right)/dirRepNum114(iInd);
    %%
    
    %% delta sound > ves
 elseif stim_type == 115 
        iInd = find(dirArray115 == dir);
        if isempty(iInd)
            iDir115 = iDir115+1;
            dirArray115(iDir115) = dir;
            dirRepNum115(iDir115) = 1;
            rightChoice115(iDir115) = 0;
            iInd = iDir115;
        else
            dirRepNum115(iInd)=dirRepNum115(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice115(iInd)=((dirRepNum115(iInd)-1)*rightChoice115(iInd)+right)/dirRepNum115(iInd);
    %%
    
    %% delta sound < vis
     elseif stim_type == 124 
        iInd = find(dirArray124 == dir);
        if isempty(iInd)
            iDir124 = iDir124+1;
            dirArray124(iDir124) = dir;
            dirRepNum124(iDir124) = 1;
            rightChoice124(iDir124) = 0;
            iInd = iDir124;
        else
            dirRepNum124(iInd)=dirRepNum124(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice124(iInd)=((dirRepNum124(iInd)-1)*rightChoice124(iInd)+right)/dirRepNum124(iInd);
    %%
    
     %% delta sound > vis
     elseif stim_type == 125 
        iInd = find(dirArray125 == dir);
        if isempty(iInd)
            iDir125 = iDir125+1;
            dirArray125(iDir125) = dir;
            dirRepNum125(iDir125) = 1;
            rightChoice125(iDir125) = 0;
            iInd = iDir125;
        else
            dirRepNum125(iInd)=dirRepNum125(iInd)+1;
        end

        if response == 2
            right=1;
        else
            right=0;
        end

        rightChoice125(iInd)=((dirRepNum125(iInd)-1)*rightChoice125(iInd)+right)/dirRepNum125(iInd);
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
[sortDir1, sortInd1] = sort(dirArray1, 2);
sortRight1 = rightChoice1(sortInd1);   

[sortDir2, sortInd2] = sort(dirArray2, 2);
sortRight2 = rightChoice2(sortInd2);

[sortDir3, sortInd3] = sort(dirArray3, 2);
sortRight3 = rightChoice3(sortInd3);

[sortDir4, sortInd4] = sort(dirArray4, 2);
sortRight4 = rightChoice4(sortInd4);

[sortDir5, sortInd5] = sort(dirArray5, 2);
sortRight5 = rightChoice5(sortInd5);

[sortDir100, sortInd100] = sort(dirArray100, 2);
sortRight100 = rightChoice100(sortInd100);

[sortDir110, sortInd110] = sort(dirArray110, 2);
sortRight110 = rightChoice110(sortInd110);

[sortDir120, sortInd120] = sort(dirArray120, 2);
sortRight120 = rightChoice120(sortInd120);

[sortDir130, sortInd130] = sort(dirArray130, 2);
sortRight130 = rightChoice130(sortInd130);

[sortDir114, sortInd114] = sort(dirArray114, 2);
sortRight114 = rightChoice114(sortInd114);

[sortDir115, sortInd115] = sort(dirArray115, 2);
sortRight115 = rightChoice115(sortInd115);

[sortDir124, sortInd124] = sort(dirArray124, 2);
sortRight124 = rightChoice124(sortInd124);

[sortDir125, sortInd125] = sort(dirArray125, 2);
sortRight125 = rightChoice125(sortInd125);

[sortDirDuplicated, sortIndDuplicated] = sort(dirArrayDuplicated, 2);
sortRightDuplicated = rightChoiceDuplicated(sortIndDuplicated);
%%

%----Plot Online Psychometric Function----
clf(figure(10));    %for clearing the past graphs results (so dont cont in the next on the same graph).

figure(10)
set(gcf,'Name','Online Analysis','NumberTitle','off');

%% Plot for all stimulus type.

plot_lines = 4;
plot_columns = 4;

if iDir1>0
    subplot(plot_lines,plot_columns,1)
        
    %%
    title('Vestibular only (1)');
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
    
    plot(sortDir1, sortRight1, 'ob' , 'MarkerSize' , 5);
    hold off;
end

if iDir2>0
    subplot(plot_lines,plot_columns,2)
        
    %%
    title('Visual only (2)');
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
    
    plot(sortDir2, sortRight2, 'or' , 'MarkerSize' , 5);
    hold off;
end

if iDir3>0
    subplot(plot_lines,plot_columns,3)
        
    %%
    title('Combined (3)');
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
    
    plot(sortDir3, sortRight3, 'og' , 'MarkerSize' , 5);
    hold off;
end

if iDir4>0
    subplot(plot_lines,plot_columns,plot_columns+1)
        
    %%
    title('Left Delta (4)');
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
    
    plot(sortDir4, sortRight4, '>g' , 'MarkerSize' , 5);
    hold off;
end

if iDir5>0
    subplot(plot_lines,plot_columns,plot_columns+2)
        
    %%
    title('Right Delta (5)');
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
    
    plot(sortDir5, sortRight5, '<g' , 'MarkerSize' , 5);
    hold off;
end

if iDirDuplicated>0
    subplot(plot_lines,plot_columns,plot_columns+3)
        
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
    
    plot(sortDirDuplicated, sortRightDuplicated, 'sb' , 'MarkerSize' , 5);
    hold off;
end

if iDir100>0
    subplot(plot_lines,plot_columns,2*plot_columns+1)
        
    %%
    title('Audio (100)');
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
    
    plot(sortDir100, sortRight100, 'oc' , 'MarkerSize' , 5);
    hold off;
end

if iDir110>0
    subplot(plot_lines,plot_columns,2*plot_columns+2)
        
    %%
    title('Audio + Ves (110)');
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
    
    plot(sortDir110, sortRight110, 'ob' , 'MarkerSize' , 5);
    hold off;
end

if iDir120>0
    subplot(plot_lines,plot_columns,2*plot_columns+3)
        
    %%
    title('Audio + Vis (120)');
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
    
    plot(sortDir120, sortRight120, 'og' , 'MarkerSize' , 5);
    hold off;
end

if iDir130>0
    subplot(plot_lines,plot_columns,2*plot_columns+4)
        
    %%
    title('Audio + Ves + Vis (130)');
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
    
    plot(sortDir130, sortRight130, 'vg' , 'MarkerSize' , 5);
    hold off;
end

if iDir114>0
    subplot(plot_lines,plot_columns,3*plot_columns+1)
        
    %%
    title('Audio < Ves (114)');
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
    
    plot(sortDir114, sortRight114, '>g' , 'MarkerSize' , 5);
    hold off;
end

if iDir115>0
    subplot(plot_lines,plot_columns,3*plot_columns+2)
        
    %%
    title('Audio > Ves (115)');
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
    
    plot(sortDir115, sortRight115, '<g' , 'MarkerSize' , 5);
    hold off;
end

if iDir124>0
    subplot(plot_lines,plot_columns,3*plot_columns+3)
        
    %%
    title('Audio < Vis (124)');
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
    
    plot(sortDir124, sortRight124, '>g' , 'MarkerSize' , 5);
    hold off;
end

if iDir125>0
    subplot(plot_lines,plot_columns,3*plot_columns +4)
        
    %%
    title('Audio > Vis (125)');
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
    
    plot(sortDir125, sortRight125, '<g' , 'MarkerSize' , 5);
    hold off;
end

%%

%% saving the online plot data.
plotData.iDirVes = iDir1;
plotData.dirArrayVes = dirArray1;
plotData.dirRepNumVes = dirRepNum1;
plotData.rightChoiceVes= rightChoice1;

plotData.iDirVisual = iDir2;
plotData.dirArrayVisual = dirArray2;
plotData.dirRepNumVisual = dirRepNum2;
plotData.rightChoiceVisual = rightChoice2;

plotData.iDir = iDir3;
plotData.dirArray = dirArray3;
plotData.dirRepNum = dirRepNum3;
plotData.rightChoice= rightChoice3;

plotData.iDirLeftDelta = iDir4;
plotData.dirArrayLeftDelta = dirArray4;
plotData.dirRepNumLeftDelta = dirRepNum4;
plotData.rightChoiceLeftDelta= rightChoice4;

plotData.iDirRightDelta = iDir5;
plotData.dirArrayRightDelta = dirArray5;
plotData.dirRepNumRightDelta = dirRepNum5;
plotData.rightChoiceRightDelta = rightChoice5;

plotData.iDir100 = iDir100;
plotData.dirArray100 = dirArray100;
plotData.dirRepNum100 = dirRepNum100;
plotData.rightChoice100 = rightChoice100;

plotData.iDir110 = iDir110;
plotData.dirArray110 = dirArray110;
plotData.dirRepNum110 = dirRepNum110;
plotData.rightChoice110 = rightChoice110;

plotData.iDir120 = iDir120;
plotData.dirArray120 = dirArray120;
plotData.dirRepNum120 = dirRepNum120;
plotData.rightChoice120 = rightChoice120;

plotData.iDir130 = iDir130;
plotData.dirArray130 = dirArray130;
plotData.dirRepNum130 = dirRepNum130;
plotData.rightChoice130 = rightChoice130;

plotData.iDir114 = iDir114;
plotData.dirArray114 = dirArray114;
plotData.dirRepNum114 = dirRepNum114;
plotData.rightChoice114 = rightChoice114;

plotData.iDir115 = iDir115;
plotData.dirArray115 = dirArray115;
plotData.dirRepNum115 = dirRepNum115;
plotData.rightChoice115 = rightChoice115;

plotData.iDir124 = iDir124;
plotData.dirArray124 = dirArray124;
plotData.dirRepNum124 = dirRepNum124;
plotData.rightChoice124 = rightChoice124;

plotData.iDir125 = iDir125;
plotData.dirArray125 = dirArray125;
plotData.dirRepNum125 = dirRepNum125;
plotData.rightChoice125 = rightChoice125;

plotData.iDirDuplicated = iDirDuplicated;
plotData.dirArrayDuplicated = dirArrayDuplicated;
plotData.dirRepNumDuplicated = dirRepNumDuplicated;
plotData.rightChoiceDuplicated = rightChoiceDuplicated;
%%

setappdata(appHandle,'psychPlot', plotData);


if debug
    disp('Exiting adaptPlotPsychFunc')
end
