function plotPsychFunc_RTT_Rot(appHandle)

global debug

if debug
    disp('Entering plotPsychFunc_RTT_Rot')
end

data = getappdata(appHandle,'protinfo');
within = data.condvect.withinStair;
varying = data.condvect.varying;

if ~isempty(varying) || ~isempty(within)
    trial = getappdata(appHandle,'trialInfo');
    cldata = getappdata(appHandle, 'ControlLoopData');
    savedInfo = getappdata(appHandle,'SavedInfo');
    plotData = getappdata(appHandle,'psychPlot');

    iDir = plotData.iDir;
    dirArray = plotData.dirArray;
    dirRepNum = plotData.dirRepNum;
    rightChoice = plotData.rightChoice;
    trialDir=plotData.trialDir;
    trialCorr=plotData.trialCorr;

    activeStair = data.activeStair;
    activeRule = data.activeRule;
    currRep = data.repNum;
    currTrial = trial(activeStair,activeRule).cntr;

    if cldata.staircase
        xtick = within.parameters.moog;
    end
    if ~isempty(varying)
        xtick = varying.parameters.moog;
    end
    xticktmp = round(xtick(1)) : ceil((xtick(end)-xtick(1))/30): ceil(xtick(end));

    dir = savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial);
    corr = savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial);
    response = savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
    trialDir = [trialDir dir];
    trialCorr = [trialCorr corr];

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

    [sortDir, sortInd] = sort(dirArray, 2);
    sortRight = rightChoice(sortInd);
    sortDirRepNum = dirRepNum(sortInd);

    %----Plot Online Psychometric Function----
    figure(10)
    set(gcf,'Name','Online Analysis','NumberTitle','off');

    if iDir>0
        subplot(3,1,1), plot(sortDir, sortRight, 'o');
        hold on;
    end

    title('Online Psychometric Function');
    set(gca, 'XTick', xticktmp);
    hold on;
    y1 = 0.5*ones(size(xtick));
    plot(xtick,y1,'-r');

    xlabel('Rotation Offset Angle (deg)');

    y=0 : 0.1 : 1;
    ylim([0 1]);
    set(gca, 'YTick', y);
    ylabel('Rightward Dicisions%');

    hold on;
    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    hold off;

    %----Plot Online Stimuli Distribution---------
    if iDir>0
        subplot(3,1,2), plot(sortDir, sortDirRepNum, 'o');
        hold on;
    end

    title('Online Stimuli Distribution');
    set(gca, 'XTick', xticktmp);
    xlim([xtick(1) xtick(end)]);
    hold on;
    xlabel('Rotation Offset Angle (deg)');

    y = 0:max(sortDirRepNum);
    y1 = 0:ceil(max(sortDirRepNum)/10):max(sortDirRepNum);
    ylim([0 y(end)]);
    set(gca, 'YTick', y1);
    ylabel('Number of Trial');

    hold on;
    x1 = zeros(size(y));
    plot(x1,y,'-r');

    grid on;
    hold off;

    %-----Plot Online Trial History-------
    x=1:length(trialDir);
    for i=1:length(x)
        if trialCorr(i)==1
            subplot(3,1,3), plot(x(i), trialDir(i), 'o');
        else
            subplot(3,1,3), plot(x(i), trialDir(i), 'or');
        end
        hold on;
    end
    if length(trialDir)>1
        x1=1:ceil(length(trialDir)/30):x(end);
        xlim([x(1) x(end)]);
        set(gca, 'XTick', x1);

        hold on;
        y1 = zeros(size(x));
        plot(x,y1,'-r');
    end
    title('Online Trial History');
    xlabel('Trial Number');

    set(gca, 'YTick', xticktmp);
    ylim([xtick(1) xtick(end)]);
    ylabel('Rotation Offset Angle (deg)');

    grid on;
    hold off;

    plotData.iDir = iDir;
    plotData.dirArray = dirArray;
    plotData.dirRepNum = dirRepNum;
    plotData.rightChoice = rightChoice;
    plotData.trialDir = trialDir;
    plotData.trialCorr = trialCorr;

    setappdata(appHandle,'psychPlot', plotData);
end

if debug
    disp('Exiting plotPsychFunc_RTT_Rot')
end

