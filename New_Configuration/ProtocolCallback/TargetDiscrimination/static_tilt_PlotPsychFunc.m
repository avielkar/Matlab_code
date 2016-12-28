function static_tilt_PlotPsychFunc(appHandle)

global debug

if debug
    disp('Entering general static plotPsychFunc')
end




data = getappdata(appHandle,'protinfo');
trial = getappdata(appHandle,'trialInfo');
%Resp = getappdata(appHandle,'ResponseInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
plotData = getappdata(appHandle,'psychPlot');
intOrder = getappdata(appHandle,'Order');%---2/15--
iDir = plotData.iDir;
trialDir=plotData.trialDir;
trialCorr=plotData.trialCorr; %---2/22---
dirArray = plotData.dirArray;
dirRepNum = plotData.dirRepNum;
rightChoice = plotData.rightChoice;
i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
motiontype = data.configinfo(i).parameters;

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).cntr;

i = strmatch('Tunnel Elevation',{char(data.configinfo.nice_name)},'exact');
tunnel_elevation_status = data.configinfo(i).status;
j = strmatch('Tunnel Roll',{char(data.configinfo.nice_name)},'exact');
tunnel_roll_status = data.configinfo(j).status;

if (tunnel_elevation_status == 4 && tunnel_roll_status == 1)
    % val1 = strmatch('Heading Direction',{char(data.condvect.withinStair.name)},'exact');
    % val2 = strmatch('Heading Direction 2nd Int',{char(data.condvect.withinStair.name)},'exact');
    val1 = strmatch('Tunnel Elevation Reference',{char(data.condvect.withinStair.name)},'exact');
    val2 = strmatch('Tunnel Elevation',{char(data.condvect.withinStair.name)},'exact');
elseif (tunnel_elevation_status == 1 && tunnel_roll_status == 4)
    val1 = strmatch('Tunnel Roll Reference',{char(data.condvect.withinStair.name)},'exact');
    val2 = strmatch('Tunnel Roll',{char(data.condvect.withinStair.name)},'exact');
else
    disp('You should not have BOTH roll and elevation simultaneously static or varying.')
end



if ~isempty(val1) || ~isempty(val2)
    dir = savedInfo(activeStair,activeRule).Resp(currRep).dir(currTrial);
    corr = savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial);
    if intOrder(1)==2%---for random order 2/15---
        dir = -dir;
    end%---2/15---
    trialDir = [trialDir dir];
    trialCorr = [trialCorr corr];%---2/22---
    response = savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
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
    if response == 2 && intOrder(1)==1 %---add second condition 2/15---
        right=1;
    elseif response == 1 && intOrder(1)==2 %---2/15---
        right=1; %---2/15---
    else 
        right=0;
    end
    rightChoice(iInd)=((dirRepNum(iInd)-1)*rightChoice(iInd)+right)/dirRepNum(iInd);
    [sortDir, sortInd] = sort(dirArray, 2);
    sortRight = rightChoice(sortInd);
    sortDirRepNum = dirRepNum(sortInd);    
   
    figure(10)   
    
%----Plot Online Psychometric Function----    
    set(gcf,'Name','Online Analysis','NumberTitle','off');
    subplot(3,1,1), plot(sortDir, sortRight, 'o');
    title('Online Psychometric Function');
    if(length(sortDir)>1)
        x=round(sortDir(1)) : ceil((sortDir(end)-sortDir(1))/30): ceil(sortDir(end));
        xlim([x(1) ceil(sortDir(end))]);       
        set(gca, 'XTick', x);
                
        hold on;
        y1 = 0.5*ones(size(x));
        plot(x,y1,'-r');        
    end
    if motiontype==3
        xlabel('Tilt Direction(Comp-Stand)');
    else
        xlabel('Tilt Dirction');
    end
       
    y=0 : 0.1 : 1;   
    ylim([0 1]);    
    set(gca, 'YTick', y);
    ylabel('% of the Comp Judge to Right of Stand');
        
    hold on; 
    x1 = zeros(size(y));
    plot(x1,y,'-r'); 
    
    grid on;    
    hold off;
    
%----Plot Online Stimuli Distribution---------  
    subplot(3,1,2), plot(sortDir, sortDirRepNum, 'o');
    title('Online Stimuli Distribution');
    if(length(sortDir)>1)
        x=round(sortDir(1)) : ceil((sortDir(end)-sortDir(1))/30) : ceil(sortDir(end));
        xlim([x(1) ceil(sortDir(end))]);       
        set(gca, 'XTick', x);
    end
    if motiontype==3
        xlabel('Tilt Direction(Comp-Stand)');
    else
        xlabel('Tilt Direction');
    end
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
    for i=1:length(x)%---2/22 begin---
        if trialCorr(i)==1
            subplot(3,1,3), plot(x(i), trialDir(i), 'o'); 
        else
            subplot(3,1,3), plot(x(i), trialDir(i), 'or'); 
        end
        hold on;
    end%---2/22 end---
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
    
    if(length(sortDir)>1)
        y=round(sortDir(1)) : ceil((sortDir(end)-sortDir(1))/20) : ceil(sortDir(end));
        ylim([y(1) ceil(sortDir(end))]);
        set(gca, 'YTick', y);
    end
    if motiontype==3
        ylabel('Tilt Direction(Comp-Stand)');
    else
        ylabel('Tilt Direction');
    end
        
    grid on;   
    hold off;
end


plotData.iDir = iDir;
plotData.dirArray = dirArray;
plotData.dirRepNum = dirRepNum;
plotData.rightChoice = rightChoice;
plotData.trialDir = trialDir;
plotData.trialCorr = trialCorr;

setappdata(appHandle,'psychPlot', plotData);

total_trial_num = length(trial) * trial(1).num;

for j = 1:length(trial)
    staircase_counter(j) = trial(j).cntr;
end


if ( total_trial_num == sum(staircase_counter) )
    % fitting sigmoidal function
    % pfit_percentage_left_format = cat(2, trans_direction', percentage_rightc', direction_total' );
    % pfit_percentage_left_format = cat(2, plotData.iDir', dirArray', direction_total' );
%     total_trial_num = length(trial) * trial(1).num
save('C:\Program Files\MATLAB\R2006a\work\New Configuration\ProtocolCallback\TargetDiscrimination\data_for_psycho_fit.mat')
FitPsychometricOnline
end



if debug
    disp('Exiting general plotPsychFunc')
end


