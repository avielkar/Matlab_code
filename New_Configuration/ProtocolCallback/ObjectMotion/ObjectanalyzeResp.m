function analyzeResp_jimmy(appHandle,HR)

global  debug %connected

if debug
    disp('Entering analyzeResp')
end

Resp = getappdata(appHandle,'ResponseInfo');
trial = getappdata(appHandle,'trialInfo');
data = getappdata(appHandle,'protinfo');
crossVals = getappdata(appHandle,'CrossVals');

response = Resp(data.repNum).response(trial.cntr);

i = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
if data.configinfo(i).parameters == 1   % For single interval
    if ~isempty(strmatch('Object Deviation',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Object Deviation',{char(data.condvect.name)},'exact');
        obj_traj_scale = crossVals(trial.list(trial.cntr),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        obj_traj_scale = data.configinfo(i).parameters.moog;
    end

    Resp(data.repNum).obj_traj_scale(trial.cntr,1) = obj_traj_scale;

%    if connected ---jing comment out, 01/05/07
        if response == 1 % Respond 1 %Left/Down
%            Resp(data.repNum).response(trial.cntr) = 1;---jing comment out, 01/05/07
            if debug
                disp('You answered Left/Down')
            end
            if obj_traj_scale < 0
                if debug
                    disp('correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 1;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            elseif obj_traj_scale > 0
                if debug
                    disp('Not correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 1;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 1;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            end
        elseif response == 2 % Respond 2 Right/Up
%            Resp(data.repNum).response(trial.cntr) = 2;----jing comment out, 01/05/07
            if debug
                disp('you answered right/up')
            end
            if obj_traj_scale > 0
                if debug
                    disp('correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 1;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            elseif obj_traj_scale < 0
                if debug
                    disp('Not correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 1;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 1;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            end
        %----Jing comment out for not using red button as response %03/21/07---
        %elseif response == 4 % Respond 3 (Don't Know, Baili)
 %           Resp(data.repNum).response(trial.cntr) = 4; ---jing comment out 01/05/07
            %if debug
            %    disp('What are you, Stupid? (Don''t Know)')
            %end
            %Resp(data.repNum).corr(trial.cntr) = 0;
            %Resp(data.repNum).incorr(trial.cntr) = 0;
            %Resp(data.repNum).null(trial.cntr) = 0;
            %Resp(data.repNum).dontKnow(trial.cntr) = 1;
        else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
%            Resp(data.repNum).response(trial.cntr) = response;---jing comment out 01/05/07----
            if debug
                disp('Time Expired: Move Faster!!')
            end
            Resp(data.repNum).corr(trial.cntr) = 0;
            Resp(data.repNum).incorr(trial.cntr) = 0;
            Resp(data.repNum).null(trial.cntr) = 1;
            Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end
 %   else % Use Keyboard response---jing comment out 01/05/07
 %       if strcmp(response,'j') % right/up
 %           Resp(data.repNum).response(trial.cntr) = 2;
 %           if dir > 0 % Correct
 %               Resp(data.repNum).corr(trial.cntr) = 1;
 %               Resp(data.repNum).incorr(trial.cntr) = 0;
 %               Resp(data.repNum).null(trial.cntr) = 0;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           elseif dir < 0 % Incorrect
 %               Resp(data.repNum).corr(trial.cntr) = 0;
 %               Resp(data.repNum).incorr(trial.cntr) = 1;
 %               Resp(data.repNum).null(trial.cntr) = 0;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           else % If for some reason, straight ahead
 %               Resp(data.repNum).corr(trial.cntr) = 0;
 %               Resp(data.repNum).incorr(trial.cntr) = 0;
 %               Resp(data.repNum).null(trial.cntr) = 1;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           end
 %       elseif strcmp(response,'f') % Left/down
 %           Resp(data.repNum).response(trial.cntr) = 1;
 %           if dir < 0  % Correct
 %               Resp(data.repNum).corr(trial.cntr) = 1;
 %               Resp(data.repNum).incorr(trial.cntr) = 0;
 %               Resp(data.repNum).null(trial.cntr) = 0;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           elseif dir > 0 % Incorrect
 %               Resp(data.repNum).corr(trial.cntr) = 0;
 %               Resp(data.repNum).incorr(trial.cntr) = 1;
 %               Resp(data.repNum).null(trial.cntr) = 0;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           else
 %               Resp(data.repNum).corr(trial.cntr) = 0;
 %               Resp(data.repNum).incorr(trial.cntr) = 0;
 %               Resp(data.repNum).null(trial.cntr) = 1;
 %               Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %           end
 %       elseif strcmp(response,'i') % Don't Know, Too hard
 %         Resp(data.repNum).response(trial.cntr) = 4;
 %         Resp(data.repNum).corr(trial.cntr) = 0;
 %           Resp(data.repNum).incorr(trial.cntr) = 0;
 %           Resp(data.repNum).null(trial.cntr) = 0;
 %           Resp(data.repNum).dontKnow(trial.cntr) = 1;
 %       else % Unrecognized Answer
 %           Resp(data.repNum).response(trial.cntr) = 5;
 %           Resp(data.repNum).corr(trial.cntr) = 0;
 %           Resp(data.repNum).incorr(trial.cntr) = 0;
 %           Resp(data.repNum).null(trial.cntr) = 1;
 %           Resp(data.repNum).dontKnow(trial.cntr) = 0;
 %       end
 %  end  ---end jing comment out 01/05/07
else  % For 2 interval
    if ~isempty(strmatch('Heading Direction',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Heading Direction',{char(data.condvect.name)},'exact');
        dir(1) = crossVals(trial.list(trial.cntr),i1);
    else
        i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');
        dir(1) = data.configinfo(i).parameters.moog;
    end
    if ~isempty(strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact'))
        i1 = strmatch('Heading Direction 2nd Int',{char(data.condvect.name)},'exact');
        dir(2) = crossVals(trial.list(trial.cntr),i1);
    else
        %i = strmatch('DISC_AMPLITUDES',{char(data.configinfo.name)},'exact');%-----Jing correct it 03/30/07----
        i = strmatch('DISC_AMPLITUDES_2I',{char(data.configinfo.name)},'exact');
        dir(2) = data.configinfo(i).parameters.moog;
    end
    
    if HR %------Jing for different heading reference 03/14/07----
        dir(2) = dir(2) + dir(1);
    end %----end 03/14/07----
    
    intOrder = getappdata(appHandle,'Order'); % setting directions same order as in trajectory
    dir1 = dir(intOrder(1));
    dir2 = dir(intOrder(2));
        
    %Resp(data.repNum).dir(trial.cntr,:) = [dir1 dir2];
    Resp(data.repNum).dir(trial.cntr,:) = dir2 - dir1;
    Resp(data.repNum).intOrder(trial.cntr,:) = intOrder; %----Jing added 02/16/07--
    
%     if connected
        if response == 1 % Respond 1 (Left/Down)
%            Resp(data.repNum).response(trial.cntr) = 1;---jing comment out 01/05/07
            if debug
                disp('You answered Left/Down')
            end
            if dir2 < dir1
                if debug
                    disp('correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 1;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            elseif dir2 > dir1
                if debug
                    disp('Not correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 1;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 1;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            end
        elseif response == 2 % Respond 2 (Right/Up)
%            Resp(data.repNum).dirStand(trial.cntr) = dir(1);---jing comment out 02/16/07
%            Resp(data.repNum).dirComp(trial.cntr) = dir(2); ---jing comment out 02/16/07
%           Resp(data.repNum).response(trial.cntr) = 2; ---jing comment out 01/05/07
            if debug
                disp('you answered right')
            end
            if dir2 > dir1
                if debug
                    disp('correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 1;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            elseif dir2 < dir1
                if debug
                    disp('Not correct')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 1;
                Resp(data.repNum).null(trial.cntr) = 0;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            else
                if debug
                    disp('No Answer')
                end
                Resp(data.repNum).corr(trial.cntr) = 0;
                Resp(data.repNum).incorr(trial.cntr) = 0;
                Resp(data.repNum).null(trial.cntr) = 1;
                Resp(data.repNum).dontKnow(trial.cntr) = 0;
            end
        %----Jing comment out for not using red button as response 03/21/07---
        %elseif response == 4 % Respond 3 (Don't Know, Baili)
%            Resp(data.repNum).response(trial.cntr) = 4;---jing comment out 01/05/07
            %if debug
            %   disp('What are you, Stupid? (Don''t Know)')
            %end
            %Resp(data.repNum).corr(trial.cntr) = 0;
            %Resp(data.repNum).incorr(trial.cntr) = 0;
            %Resp(data.repNum).null(trial.cntr) = 0;
            %Resp(data.repNum).dontKnow(trial.cntr) = 1;
        else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
%            Resp(data.repNum).response(trial.cntr) = response;---jing comment out 01/05/07
            if debug
                disp('Time Expired: Move Faster!!')
            end
            Resp(data.repNum).corr(trial.cntr) = 0;
            Resp(data.repNum).incorr(trial.cntr) = 0;
            Resp(data.repNum).null(trial.cntr) = 1;
            Resp(data.repNum).dontKnow(trial.cntr) = 0;
        end
%     else % Use Keyboard response
%         if strcmp(response,'j') % right
%             Resp(data.repNum).response(trial.cntr) = 2;
%             if dir2 < dir1 % Correct
%                 Resp(data.repNum).corr(trial.cntr) = 1;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             elseif dir2 > dir1 % Incorrect
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 1;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             else % If for some reason, straight ahead
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 1;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             end
%         elseif strcmp(response,'f') % Left
%             Resp(data.repNum).response(trial.cntr) = 1;
%             if dir2 > dir1  % Correct
%                 Resp(data.repNum).corr(trial.cntr) = 1;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             elseif dir2 < dir1 % Incorrect
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 1;
%                 Resp(data.repNum).null(trial.cntr) = 0;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             else
%                 Resp(data.repNum).corr(trial.cntr) = 0;
%                 Resp(data.repNum).incorr(trial.cntr) = 0;
%                 Resp(data.repNum).null(trial.cntr) = 1;
%                 Resp(data.repNum).dontKnow(trial.cntr) = 0;
%             end
%         elseif strcmp(response,'i') % Don't Know, Too hard
%             Resp(data.repNum).response(trial.cntr) = 4;
%             Resp(data.repNum).corr(trial.cntr) = 0;
%             Resp(data.repNum).incorr(trial.cntr) = 0;
%             Resp(data.repNum).null(trial.cntr) = 0;
%             Resp(data.repNum).dontKnow(trial.cntr) = 1;
%         else % Unrecognized Answer
%             Resp(data.repNum).response(trial.cntr) = 5;
%             Resp(data.repNum).corr(trial.cntr) = 0;
%             Resp(data.repNum).incorr(trial.cntr) = 0;
%             Resp(data.repNum).null(trial.cntr) = 1;
%             Resp(data.repNum).dontKnow(trial.cntr) = 0;
%         end
%     end
end

Resp(data.repNum).totalCorr = sum(Resp(data.repNum).corr);
Resp(data.repNum).totalIncorr = sum(Resp(data.repNum).incorr);
Resp(data.repNum).totalNull = sum(Resp(data.repNum).null);
Resp(data.repNum).totalDontKnow = sum(Resp(data.repNum).dontKnow);


setappdata(appHandle,'ResponseInfo',Resp);
%+++++++++ Commented out for now, put in analyzeResp+++++++++++++++++++++++

if debug
    if Resp(data.repNum).corr(trial.cntr) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting analyzeResp')
end


