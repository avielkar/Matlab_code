function analyzeResp(appHandle)

global  debug %connected

if debug
    disp('Entering analyzeResp new')
end

Resp = getappdata(appHandle,'ResponseInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
% crossVals = getappdata(appHandle,'CrossVals')
stairInfo = getappdata(appHandle,'stairInfo');
response = Resp(stairInfo.currStair).response(stairInfo.trialCount(stairInfo.currStair));

Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair)) = getappdata(appHandle,'samediff');
Resp(stairInfo.currStair).intOrder(:,stairInfo.trialCount(stairInfo.currStair)) = getappdata(appHandle,'Order');  

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');

% SINGLE INTERVAL // We should never enter this part
if data.configinfo(i).parameters == 1
%     if ~isempty(strmatch('Heading Direction',{char(data.condvect.name)},'exact'))
%         i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
%         dir = crossVals(trial.list(trial.cntr),i1);
%     else
%         i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
%         dir = data.configinfo(i).parameters.moog;
%     end
% 
%     Resp(data.repNum).dir(trial.cntr,1) = dir;
% 
% %    if connected ---jing comment out, 01/05/07
%         if response == 1 % Respond 1 %Left/Down
% %            Resp(data.repNum).response(trial.cntr) = 1;---jing comment out, 01/05/07
%             if debug
%                 disp('You answered Left/Down')
%             end
%             if dir < 0
%                 if debug
%                     disp('correct')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 1;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             elseif dir > 0
%                 if debug
%                     disp('Not correct')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 1;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             else
%                 if debug
%                     disp('No Answer')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 1;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             end
%         elseif response == 2 % Respond 2 Right/Up
% %            Resp(data.repNum).response(trial.cntr) = 2;----jing comment out, 01/05/07
%             if debug
%                 disp('you answered right/up')
%             end
%             if dir > 0
%                 if debug
%                     disp('correct')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 1;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             elseif dir < 0
%                 if debug
%                     disp('Not correct')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 1;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             else
%                 if debug
%                     disp('No Answer')
%                 end
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 1;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             end
%         %----Jing comment out for not using red button as response %03/21/07---
%         %elseif response == 4 % Respond 3 (Don't Know, Baili)
%  %           Resp(data.repNum).response(trial.cntr) = 4; ---jing comment out 01/05/07
%             %if debug
%             %    disp('What are you, Stupid? (Don''t Know)')
%             %end
%             %Resp(data.repNum).corr(trial.cntr) = 0;
%             %Resp(data.repNum).incorr(trial.cntr) = 0;
%             %Resp(data.repNum).null(trial.cntr) = 0;
%             %Resp(data.repNum).dontKnow(trial.cntr) = 1;
%         else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
% %            Resp(data.repNum).response(trial.cntr) = response;---jing comment out 01/05/07----
%             if debug
%                 disp('Time Expired: Move Faster!!')
%             end
%             Resp(data.repNum).corr(trial.cntr) = 0;
%             Resp(data.repNum).incorr(trial.cntr) = 0;
%             Resp(data.repNum).null(trial.cntr) = 1;
%             Resp(data.repNum).dontKnow(trial.cntr) = 0;
%         end
 
else  % TWO INTERVAL
    
    % SET Resp.dir (which staircase)
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
%         dir(1) = crossVals(trial(stairInfo.currStair).list(stairInfo.trialCount(stairInfo.currStair)),i1);
        dir(1) = 0; % default
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact'))
%         i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact');
        dir(2) = stairInfo.stairs(stairInfo.currStair);
    else
%         i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
%         dir(2) = data.configinfo(i).parameters.moog;
        dir(2) = stairInfo.stairs(stairInfo.currStair);
    end
    Resp(stairInfo.currStair).dir(:,stairInfo.trialCount(stairInfo.currStair)) = [dir(2)];

    % SET Resp.amp (which step)
    if ~isempty(strmatch('Distance',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Distance',{char(data.condvect.name)},'exact');
%         amp(1) = crossVals(trial(stairInfo.currStair).list(stairInfo.trialCount(stairInfo.currStair)),i1);
        amp(1) = 1; %default
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact'); % I need to change this somehow?
        amp(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Distance 2nd Int',{char(data.condvect.name)},'exact');
        amp(2) = stairInfo.steps(stairInfo.currStep(stairInfo.currStair));
    else
        i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact'); % Do I need to change this somehow?
        amp(2) = data.configinfo(i).parameters.moog;
    end
    Resp(stairInfo.currStair).amp(:,stairInfo.trialCount(stairInfo.currStair)) = [amp(2)];
    
        if response == 1 % Left button press = first
            if debug
                disp('You answered first')
            end
            if Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==1 % odd first
                if debug
                    disp('Correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            elseif Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==2 || Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==3% odd second or third 
                if debug
                    disp('Not correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            end
        elseif response == 2 % Right button press = second
            if debug
                disp('You answered second')
            end
            if Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==2 % odd second
                if debug
                    disp('Correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            elseif Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==1 || Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==3 % odd first or third
                if debug
                    disp('Not correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            end
        elseif response == 4 % Skip trial button pressed
            if debug
                disp('You answered third')
            end
            if Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==3 % odd third
                if debug
                    disp('Correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            elseif Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==1 || Resp(stairInfo.currStair).samediff(stairInfo.trialCount(stairInfo.currStair))==2 % odd first or second
                if debug
                    disp('Not correct')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
                Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 1;
                Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
            end
        else % Unrecognized answer 
            if debug
                disp('Unrecognized answer')
            end
            Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) = 0;
            Resp(stairInfo.currStair).incorr(stairInfo.trialCount(stairInfo.currStair)) = 0;
            Resp(stairInfo.currStair).null(stairInfo.trialCount(stairInfo.currStair)) = 1;
            Resp(stairInfo.currStair).dontKnow(stairInfo.trialCount(stairInfo.currStair)) = 0;
        end
end

Resp(stairInfo.currStair).totalCorr = sum(Resp(stairInfo.currStair).corr);
Resp(stairInfo.currStair).totalIncorr = sum(Resp(stairInfo.currStair).incorr);
Resp(stairInfo.currStair).totalNull = sum(Resp(stairInfo.currStair).null);
Resp(stairInfo.currStair).totalDontKnow = sum(Resp(stairInfo.currStair).dontKnow);

Resp(stairInfo.currStair)
setappdata(appHandle,'ResponseInfo',Resp);
%+++++++++ Commented out for now, put in analyzeResp+++++++++++++++++++++++

if debug
    if Resp(stairInfo.currStair).corr(stairInfo.trialCount(stairInfo.currStair)) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting analyzeResp new')
end


