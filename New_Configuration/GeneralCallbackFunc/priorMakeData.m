function priorMakeData(appHandle)
% take configfile and condvect and create a trial by trial parameter list
% for saving priorData. Jing modified for combining Multi-Staircase 12/01/08 

global debug

if debug
    disp('Entering makeData')
end

SavedInfo = getappdata(appHandle,'SavedInfo');
data = getappdata(appHandle,'protinfo');
cldata = getappdata(appHandle, 'ControlLoopData');
crossvals = getappdata(appHandle,'CrossVals');
trial = getappdata(appHandle,'trialInfo');

within = data.condvect.withinStair;
across = data.condvect.acrossStair;
varying = data.condvect.varying;
priors = data.condvect.priors;

rep = data.repNum;
activeStair = data.activeStair;
activeRule = data.activeRule;
cntr = trial(activeStair,activeRule).priorCntr;
%%%%cnInd = trial(activeStair,activeRule).list(cntr);

%avi - should check here waht to change in the saving settings.
for i = 1:size(data.configinfo,2)
    name = data.configinfo(i).name;
%% ----avi:deleted    
% % % %     if data.configinfo(i).status == 2 %varying   
% % % %         niceName = char(data.configinfo(i).nice_name);
% % % %         icol = strmatch(niceName,{char(varying.name)},'exact');
% % % %         if cldata.staircase
% % % %             val = crossvals(cldata.varyingCurrInd,icol);
% % % %         else            
% % % %             val = crossvals(cnInd,icol);
% % % %         end       
% % % %     elseif data.configinfo(i).status == 3  %acrossStair
% % % %         niceName = char(data.configinfo(i).nice_name);
% % % %         icol = strmatch(niceName,{char(across.name)},'exact');
% % % %         if isfield(across(icol).parameters, 'moog')
% % % %             val = across(icol).parameters.moog(activeStair);
% % % %         else
% % % %             val = across(icol).parameters(activeStair);
% % % %         end
% % % %     elseif data.configinfo(i).status == 4  %withinStair
% % % %         niceName = char(data.configinfo(i).nice_name);
% % % %         icol = strmatch(niceName,{char(within.name)},'exact');
% % % %         if isfield(within(icol).parameters, 'moog')
% % % %             val = within(icol).parameters.moog(cnInd);
% % % %         else
% % % %             val = within(icol).parameters(cnInd);
% % % %         end
% % % %     else
% % % %         val = data.configinfo(i).parameters;
% % % %     end
%% ----end
    if(~strcmp(name, 'DISC_AMPLITUDES'))
        val = data.configinfo(i).parameters;
    else
        val = priors.currentPrior.Dir;
    end
    SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).name = name;
    SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).value = val;
    
end

%countinue to add dynamic parameter according to the priors control loop
%data.
    if(cldata.is_flashing_priors == true) 
        %increse the ith place of the parameter.
        i = i + 1;
        SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).name = 'NUM_OF_FLASHES';
        SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).value = cldata.num_of_flashes;
        i = i + 1;
        SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).name = 'FLASH_SQUARE_DATA';
        SavedInfo(activeStair,activeRule).PriorRep(rep).Trial(cntr).Param(i).value = cldata.flash_square_data;
    end


%% ======Save eye Data for each trial. Jing 01/27/09=========
flagdata = getappdata(appHandle,'flagdata');
if flagdata.isEyeTracking
    eyeDataSampleObj = getappdata(appHandle, 'eyeDataSample');
    eyeWinData = getappdata(appHandle, 'eyeWinData');
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).data = eyeDataSampleObj.data;
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).eyecode = eyeWinData.eyecode;
    SavedInfo(activeStair,activeRule).Resp(rep).eyeTrack(cntr).channels = data.channels(1:6);
end
%% ======End 01/27/09=========

%======Save the trial history info. Jing 5/15/09========
SavedInfo(activeStair,activeRule).PriorResp(rep).trialCount(cntr) = cldata.trialCount;
SavedInfo(activeStair,activeRule).PriorResp(rep).preNumber(cntr) = priors.left;
SavedInfo(activeStair,activeRule).PriorResp(rep).RealTrialCntr(cntr) = trial(activeStair,activeRule).cntr;

setappdata(appHandle,'SavedInfo',SavedInfo);

if debug
    disp('Existing makeData')
end





