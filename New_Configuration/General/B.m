function B(hObject, eventdata)%, appHandle)
    global b_timer
    global cedrus_result
% % % %     data = getappdata(appHandle,'protinfo');
% % % %     trial = getappdata(appHandle,'trialInfo');
% % % %     savedInfo = getappdata(appHandle,'SavedInfo');
% % % %     cldata = getappdata(appHandle,'ControlLoopData');
    if(cedrus_result ~= 0)
% % % %         activeStair = data.activeStair;   %---Jing for combine multi-staircase 12/01/08
% % % %         activeRule = data.activeRule;
% % % %         savedInfo(activeStair,activeRule).Resp(data.repNum).response(trial(activeStair,activeRule).cntr) = cedrus_result;
% % % %         setappdata(appHandle,'SavedInfo',savedInfo);
        fprintf('the answer was received');
        display(timerfind('Tag','CLoop'));
        stop(b_timer);
    end
    fprintf('in the timer now!!!!!!!!!!\n');