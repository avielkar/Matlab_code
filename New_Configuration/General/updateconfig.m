% Callback for text and checkbox objects
function updateconfig(hObject)
global basicfig basicdispfig

%jing added for changing variables while control loop
%running.01/29/07---
flagdata = getappdata(basicfig,'flagdata');

%%%% ADDED BY AZ 2018_02_05
%paused = get(findobj(basicfig,'Tag','PauseButton'),'Value');
paused=0;
%%%%%%%%%
%end---

data = getappdata(basicfig,'protinfo');
tag = get(hObject,'Tag');

varname = strtok(tag,'-');
datapart = tag(strfind(tag,'-')+1:end);
i = strmatch(varname, {char(data.configinfo.name)}, 'exact');

%jing added for changing variables while control loop
%running.01/29/07---
if  ~paused && flagdata.isTrialStart
    %---Jing make change 04/01/07----
    message =[ 'You should pause the experiment first, ' sprintf('\n') 'and then change parameters'];
    title = 'Warning Message';
    msgbox(message,title,'warn');
    %end %------Jing 04/01/07-----
else %----jing end----Jing comment out 04/01/07----
    i1 = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
    if data.configinfo(i1).parameters == 1 % should be 1 interval
        if isfield(data.configinfo(i).parameters,'moog')
            if length(data.configinfo(i).parameters.moog) >= 3
                inds = 1:3;
            else
                inds = 1;
            end
        else
            if length(data.configinfo(i).parameters) >= 2
                inds = 1:length(data.configinfo(i).parameters);
            else
                inds = 1;
            end
        end
    elseif data.configinfo(i1).parameters == 3 % should be 2 interval
        if isfield(data.configinfo(i).parameters,'moog')
            inds = 1:length(data.configinfo(i).parameters.moog);
        else
            inds = 1:length(data.configinfo(i).parameters);
        end
    end

    tagstr = data.configinfo(i).name;
    statusval = data.configinfo(i).status;

    if isfield(data.configinfo(i).parameters,'moog')
        lowstr = [num2str(data.configinfo(i).low_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).low_bound.openGL(inds))];
        highstr = [num2str(data.configinfo(i).high_bound.moog(inds)) ,' ',...
            num2str(data.configinfo(i).high_bound.openGL(inds))];
        incrstr = [num2str(data.configinfo(i).increment.moog(inds)) ,' ',...
            num2str(data.configinfo(i).increment.openGL(inds))];
        multstr = [num2str(data.configinfo(i).multiplier.moog(inds)) ,' ',...
            num2str(data.configinfo(i).multiplier.openGL(inds))];
        datastr = [num2str(data.configinfo(i).parameters.moog(inds)) ,' ',...
            num2str(data.configinfo(i).parameters.openGL(inds))];
    else
        lowstr = num2str(data.configinfo(i).low_bound(inds));
        highstr = num2str(data.configinfo(i).high_bound(inds));
        incrstr = num2str(data.configinfo(i).increment(inds));
        multstr = num2str(data.configinfo(i).multiplier(inds));
        datastr = num2str(data.configinfo(i).parameters(inds));
    end

    %----From here jing comment out some codes and change something for incorrect input
    if strmatch(datapart, 'DataText', 'exact');
        val = str2num(get(findobj(basicdispfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if(data.configinfo(i).name ~= 'ROT_CENTER_OFFSETS')
                if size(val,2)==2
                    data.configinfo(i).parameters.moog(inds) = val(1);
                    data.configinfo(i).parameters.openGL(inds) = val(2);
                else
                    WarningOne;
                end
            else
                if size(val,2) == 6
                    data.configinfo(i).parameters.moog(inds) = val(1:3);
                    data.configinfo(i).parameters.openGL(inds) = val(4:6);
                else
                    WarningTwo('6');
                end
            end
        else
            len=size(data.configinfo(i).parameters, 2);
            if size(val,2)==len
                data.configinfo(i).parameters(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'LowText', 'exact');
        val = str2num(get(findobj(basicdispfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if(data.configinfo(i).name ~= 'ROT_CENTER_OFFSETS')
                if size(val,2)==2
                    data.configinfo(i).low_bound.moog(inds) = val(1);
                    data.configinfo(i).low_bound.openGL(inds) = val(2);
                else
                    WarningOne;
                end
            else
                  if size(val,2) == 6
                    data.configinfo(i).parameters.moog(inds) = val(1:3);
                    data.configinfo(i).parameters.openGL(inds) = val(4:6);
                else
                    WarningTwo('6');
                end
            end
        else
            len=size(data.configinfo(i).low_bound,2);
            if size(val,2)==len
                data.configinfo(i).low_bound(inds)=val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'HighText', 'exact');
        val = str2num(get(findobj(basicdispfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if(data.configinfo(i).name ~= 'ROT_CENTER_OFFSETS')
                if size(val,2)==2
                    data.configinfo(i).high_bound.moog(inds) = val(1);
                    data.configinfo(i).high_bound.openGL(inds) = val(2);
                else
                    WarningOne;
                end
            else
                if size(val,2) == 6
                    data.configinfo(i).parameters.moog(inds) = val(1:3);
                    data.configinfo(i).parameters.openGL(inds) = val(4:6);
                else
                    WarningTwo('6');
                end
            end
        else
            len=size(data.configinfo(i).high_bound,2);
            if size(val,2)==len
                data.configinfo(i).high_bound(inds)=val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'IncrText', 'exact');
        val = str2num(get(findobj(basicdispfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if(data.configinfo(i).name ~= 'ROT_CENTER_OFFSETS')
                if size(val,2)==2
                    data.configinfo(i).increment.moog(inds) = val(1);
                    data.configinfo(i).increment.openGL(inds) = val(2);
                else
                    WarningOne;
                end
            else
                if size(val,2) == 6
                    data.configinfo(i).parameters.moog(inds) = val(1:3);
                    data.configinfo(i).parameters.openGL(inds) = val(4:6);
                else
                    WarningTwo('6');
                end
            end
        else
            len=size(data.configinfo(i).increment,2);
            if size(val,2)==len
                data.configinfo(i).increment(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'MultText', 'exact');
        val = str2num(get(findobj(basicdispfig,'Tag',tag),'String'));
        if isfield(data.configinfo(i).parameters,'moog')
            if size(val,2)==2
                data.configinfo(i).multiplier.moog(inds) = val(1);
                data.configinfo(i).multiplier.openGL(inds) = val(2);
            else
                WarningOne;
            end
        else
            len=size(data.configinfo(i).multiplier,2);
            if size(val,2)==len
                data.configinfo(i).multiplier(inds) = val;
            else
                WarningTwo(len);
            end
        end
    elseif strmatch(datapart, 'SpacingPopupMenu', 'exact');
        data.configinfo(i).vectgen = get(findobj(basicdispfig,'Tag',tag),'Value') - 1;


    elseif strmatch(datapart, 'StatusPopupMenu', 'exact');
        statusval = get(findobj(basicdispfig,'Tag',tag),'Value');
        data.oriStatus = data.configinfo(i).status;   %Jing 12/01/08
        data.configinfo(i).status = statusval;
    else
        disp('Didn''t know what to do here')
    end

    setappdata(basicfig,'protinfo',data);

    % Disable all non relavent variable parameters
    if data.configinfo(i).status <= 1 % Static or Fixed
        set(findobj(basicdispfig,'Tag',[tagstr '-LowText']),'Enable','off');
        set(findobj(basicdispfig,'Tag',[tagstr '-HighText']),'Enable','off');
        set(findobj(basicdispfig,'Tag',[tagstr '-MultText']),'Enable','off');
        set(findobj(basicdispfig,'Tag',[tagstr '-IncrText']),'Enable','off');
        set(findobj(basicdispfig,'Tag',[tagstr '-SpacingPopupMenu']),'Enable','off');
        set(findobj(basicdispfig,'Tag',[tagstr '-DataText']),'String',datastr);
    else % Varying
        set(findobj(basicdispfig,'Tag',[tagstr '-LowText']),'Enable','on');
        set(findobj(basicdispfig,'Tag',[tagstr '-HighText']),'Enable','on');
        set(findobj(basicdispfig,'Tag',[tagstr '-SpacingPopupMenu']),'Enable','on');
        set(findobj(basicdispfig,'Tag',[tagstr '-DataText']),'String',...
            [lowstr ':' incrstr ':' highstr]);
        if data.configinfo(i).vectgen == 0 % Linear spacing
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','off');
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','on');
        elseif data.configinfo(i).vectgen == 1 % Log Spacing
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','on');
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','off');
        elseif data.configinfo(i).vectgen == 2 % Custom vector generation
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-MultText']),...
                'Enable','off');
            set(findobj(basicdispfig,'Tag',[data.configinfo(i).name '-IncrText']),...
                'Enable','off');
            set(findobj(basicdispfig,'Tag',[tagstr '-LowText']),'Enable','off');
            set(findobj(basicdispfig,'Tag',[tagstr '-HighText']),'Enable','off');
        else
            disp('Vector Generation parameter does not match any known format')
        end
    end

    % set all strings to show 1 or 2 values based on whether cue conflict or
    % not
    for i = data.visible
        i1 = strmatch('MOTION_TYPE',{char(data.configinfo.name)},'exact');
        if data.configinfo(i1).parameters == 1 % should be 1 interval
            if isfield(data.configinfo(i).parameters,'moog')
                if length(data.configinfo(i).parameters.moog) >= 3
                    inds = 1:3;
                else
                    inds = 1;
                end
            else
                if length(data.configinfo(i).parameters) >= 2
                    inds = 1:length(data.configinfo(i).parameters);
                else
                    inds = 1;
                end
            end
        elseif data.configinfo(i1).parameters == 3 % should be 2 interval
            if isfield(data.configinfo(i).parameters,'moog')
                inds = 1:length(data.configinfo(i).parameters.moog);
            else
                inds = 1:length(data.configinfo(i).parameters);
            end
        end

        if isfield(data.configinfo(i).parameters,'moog')
            lowstr = [num2str(data.configinfo(i).low_bound.moog(inds)) ,' ',...
                num2str(data.configinfo(i).low_bound.openGL(inds))];
            highstr = [num2str(data.configinfo(i).high_bound.moog(inds)) ,' ',...
                num2str(data.configinfo(i).high_bound.openGL(inds))];
            incrstr = [num2str(data.configinfo(i).increment.moog(inds)) ,' ',...
                num2str(data.configinfo(i).increment.openGL(inds))];
            multstr = [num2str(data.configinfo(i).multiplier.moog(inds)) ,' ',...
                num2str(data.configinfo(i).multiplier.openGL(inds))];
            datastr = [num2str(data.configinfo(i).parameters.moog(inds)) ,' ',...
                num2str(data.configinfo(i).parameters.openGL(inds))];
        else
            lowstr = num2str(data.configinfo(i).low_bound(inds));
            highstr = num2str(data.configinfo(i).high_bound(inds));
            incrstr = num2str(data.configinfo(i).increment(inds));
            multstr = num2str(data.configinfo(i).multiplier(inds));
            datastr = num2str(data.configinfo(i).parameters(inds));
        end

        tagstr = data.configinfo(i).name;
        set(findobj(basicdispfig,'Tag',[tagstr '-LowText']),'String', lowstr);
        set(findobj(basicdispfig,'Tag',[tagstr '-HighText']),'String', highstr);
        set(findobj(basicdispfig,'Tag',[tagstr '-IncrText']),'String', incrstr);
        set(findobj(basicdispfig,'Tag',[tagstr '-MultText']),'String', multstr);
        if data.configinfo(i).status <= 1
            set(findobj(basicdispfig,'Tag',[tagstr '-DataText']),'String',datastr);
        else
            if isfield(data.configinfo(i).parameters,'moog')
                set(findobj(basicdispfig,'Tag',[tagstr '-DataText']),'String', ...
                    [num2str(data.configinfo(i).low_bound.moog(inds)) ,...
                    num2str(data.configinfo(i).low_bound.openGL(inds)) ':'...
                    num2str(data.configinfo(i).increment.moog(inds)) ,...
                    num2str(data.configinfo(i).increment.openGL(inds)) ':'...
                    num2str(data.configinfo(i).high_bound.moog(inds)) ,...
                    num2str(data.configinfo(i).high_bound.openGL(inds))]);
            else
                set(findobj(basicdispfig,'Tag',[tagstr '-DataText']),'String', ...
                    [num2str(data.configinfo(i).low_bound(inds)) ':'...
                    num2str(data.configinfo(i).increment(inds)) ':'...
                    num2str(data.configinfo(i).high_bound(inds))]);
            end
        end
    end


    % Runs GenCrossVals to update parameter list when anytime the status is
    % changed, or only it that particular var is status = varying [Jimmy
    % Modified] Or when particular var is status = acrossStatus and status =
    % withinStatus.
    if strmatch('StatusPopupMenu',datapart,'exact')
        BasicInterface('GenCrossVals',gcbo,[],guidata(gcbo),tag,basicdispfig);
    else
        if statusval == 2 || statusval == 3 || statusval == 4
            BasicInterface('GenCrossVals',gcbo,[],guidata(gcbo),tag,basicdispfig);
        end
    end
end %----Jing comment out 04/01/07----

function WarningOne

message = 'You should input 2 values';
title = 'Warning Message';
msgbox(message,title,'warn');


function WarningTwo(str)

message = ['You should input ' num2str(str) ' values'];
title = 'Warning Message';
msgbox(message,title,'warn');
