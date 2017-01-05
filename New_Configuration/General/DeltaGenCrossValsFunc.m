% Function to create condition list, based on varying variables in config
% file.%=======Jing modify for combining multi-staiecase 12/01/08=========%
function GenCrossValsFunc(hObject, eventdata, handles, tag, fig)
% configfile is struct of variable data, r =1 => return cond list in
% random form, r=0 => return list in ordered form

global basicfig staircasefig
data = getappdata(basicfig,'protinfo');

cntrV = 1;   %counter for Varying
cntrA = 1;   %counter for AcrossStair
cntrW = 1;   %counter for WithinStair

if strmatch(tag,'first')  %first time open the BasicInterface window
    for i = 1:size(data.configinfo,2)
        if data.configinfo(i).status == 2   %Varying
            tempVect = genCondvect(i,tag);
            
            data.condvect.varying(cntrV).name = data.configinfo(i).nice_name;
            if isfield(data.configinfo(i).parameters,'moog')
                data.condvect.varying(cntrV).parameters.moog  = tempVect.vect;
                data.condvect.varying(cntrV).parameters.openGL = tempVect.vectGL;
            else
                data.condvect.varying(cntrV).parameters = tempVect.vect;
            end
            cntrV = cntrV+1;
        end  
        
        if data.configinfo(i).status == 3   %AcrossStair
            tempVect = genCondvect(i,tag);
            
            data.condvect.acrossStair(cntrA).name = data.configinfo(i).nice_name;
            if isfield(data.configinfo(i).parameters,'moog')
                data.condvect.acrossStair(cntrA).parameters.moog  = tempVect.vect;
                data.condvect.acrossStair(cntrA).parameters.openGL = tempVect.vectGL;
            else
                data.condvect.acrossStair(cntrA).parameters = tempVect.vect;
            end
              
            %% ------avi:for Adam1_Delta (sol) protocol - check if the duplicated value is enbled and if Sol Protocol.
            if(strmatch(data.configfile , '1Adam_Delta.mat' ,'exact'))
                    if(strmatch(data.configinfo(i).name, 'STIMULUS_TYPE'))
                        i_DUPLICATED_STYMULUS_TYPE = strmatch('DUPLICATE_STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');
                        duplicatedSimulusType = data.configinfo(i_DUPLICATED_STYMULUS_TYPE).parameters;
                        if(duplicatedSimulusType)  %'0' value means not enable duplicated type with coherence.
                            index = find(data.condvect.acrossStair(cntrA).parameters == duplicatedSimulusType , 1);
                            addedVectorValue = data.condvect.acrossStair(cntrA).parameters(index);
                            duplicatedIndex = size(data.condvect.acrossStair.parameters , 2) + 1;
                            data.condvect.acrossStair(cntrA).parameters(duplicatedIndex) = addedVectorValue;
                        end
                    end
            end
            %% ------
            
            cntrA = cntrA+1;
        end        
        
        if data.configinfo(i).status == 4   %WithinStair
            tempVect = genCondvect(i,tag);
            
            data.condvect.withinStair(cntrW).name = data.configinfo(i).nice_name;
            if isfield(data.configinfo(i).parameters,'moog')
                data.condvect.withinStair(cntrW).parameters.moog  = tempVect.vect;
                data.condvect.withinStair(cntrW).parameters.openGL = tempVect.vectGL;
            else
                data.condvect.withinStair(cntrW).parameters = tempVect.vect;
            end
            cntrW = cntrW+1;
        end        
    end
elseif strmatch(tag,'Insert')   %For add trial combination
else %whenever something in BasicInterfce is changed.
    varname = strtok(tag,'-');
    iVar = strmatch(varname, {char(data.configinfo.name)}, 'exact');
    nicename = data.configinfo(iVar).nice_name;
    tempStatus = get(findobj(fig,'Tag',[varname '-StatusPopupMenu']),'Value');
    
    if tempStatus == 3 && ~isempty(data.condvect.acrossStair) &&...
       isempty(strmatch(nicename, {char(data.condvect.acrossStair.name)}, 'exact'))
        message = 'You can only have one AcrossStair parameter';
        title = 'Warning Message';
        msgbox(message,title,'warn');
        set(findobj(fig,'Tag',[varname '-StatusPopupMenu']),'Value',data.oriStatus);
        data.configinfo(iVar).status = data.oriStatus;
    elseif tempStatus == 4 && ~isempty(data.condvect.withinStair) && ...
           isempty(strmatch(nicename, {char(data.condvect.withinStair.name)}, 'exact'))
        message = 'You can only have one WithinStair parameter';
        title = 'Warning Message';
        msgbox(message,title,'warn');
        set(findobj(fig,'Tag',[varname '-StatusPopupMenu']),'Value',data.oriStatus);
        data.configinfo(iVar).status = data.oriStatus;
    else
        if tempStatus >=2  % varying/AcrossStair/WithinStair
            tempVect = genCondvect(iVar, tag);
        end

        isMoog = 0;
        if isfield(data.configinfo(iVar).parameters,'moog')
            isMoog = 1;
        end

        isNew = 1;
        iVarying = strmatch(nicename, {char(data.condvect.varying.name)}, 'exact');
        iAcross = strmatch(nicename, {char(data.condvect.acrossStair.name)}, 'exact');
        iWithin = strmatch(nicename, {char(data.condvect.withinStair.name)}, 'exact');

        if ~isempty(iVarying) % already in varying condvect
            if tempStatus == 2 % still varying status.
                isNew = 0;
                if isMoog
                    data.condvect.varying(iVarying).parameters.moog = tempVect.vect;
                    data.condvect.varying(iVarying).parameters.openGL = tempVect.vectGL;
                else
                    data.condvect.varying(iVarying).parameters = tempVect.vect;
                end
            else %changed from Varying to Others.
                data.condvect.varying(iVarying).parameters = []; % remove vect from Varing conditions list
                ind = ~cellfun(@isempty,{data.condvect.varying.parameters});
                data.condvect.varying = data.condvect.varying(ind);
            end
        end

        if ~isempty(iAcross)  % already in acrossStair condvect
            if tempStatus == 3   % still acrossStair status.
                isNew = 0;
                if isMoog
                    data.condvect.acrossStair(iAcross).parameters.moog = tempVect.vect;
                    data.condvect.acrossStair(iAcross).parameters.openGL = tempVect.vectGL;
                else
                    data.condvect.acrossStair(iAcross).parameters = tempVect.vect;
                    %% ------avi:for Adam1_Delta (sol) protocol - check if the duplicated value is enbled and if Sol Protocol.
                    if(strmatch(data.configfile , '1Adam_Delta.mat' ,'exact'))
                            if(strmatch(data.configinfo(i).name, 'STIMULUS_TYPE'))
                                i_DUPLICATED_STYMULUS_TYPE = strmatch('DUPLICATE_STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');
                                duplicatedSimulusType = data.configinfo(i_DUPLICATED_STYMULUS_TYPE).parameters;
                                if(duplicatedSimulusType)  %'0' value means not enable duplicated type with coherence.
                                    index = find(data.condvect.acrossStair(cntrA).parameters == duplicatedSimulusType , 1);
                                    addedVectorValue = data.condvect.acrossStair(cntrA).parameters(index);
                                    duplicatedIndex = size(data.condvect.acrossStair.parameters , 2) + 1;
                                    data.condvect.acrossStair(cntrA).parameters(duplicatedIndex) = addedVectorValue;
                                end
                            end
                    end
                    %% ------
                end
            else % changed from AcrossStair to Others.
                data.condvect.acrossStair(iAcross).parameters = []; % remove vect from AcrossStair conditions list
                ind = ~cellfun(@isempty,{data.condvect.acrossStair.parameters});
                data.condvect.acrossStair = data.condvect.acrossStair(ind);
            end
        end

        if ~isempty(iWithin)  % already in withinStair condvect
            if tempStatus == 4  %still withinStair status.
                isNew = 0;
                if isMoog
                    data.condvect.withinStair(iWithin).parameters.moog = tempVect.vect;
                    data.condvect.withinStair(iWithin).parameters.openGL = tempVect.vectGL;
                else
                    data.condvect.withinStair(iWithin).parameters = tempVect.vect;
                end
            else %changed from WithinStair to Others.
                data.condvect.withinStair(iWithin).parameters = []; % remove vect from WithinStair conditions list
                ind = ~cellfun(@isempty,{data.condvect.withinStair.parameters});
                data.condvect.withinStair = data.condvect.withinStair(ind);
            end
        end

        if isNew  % new var for varying/acrossStair/withinStair condvect
            if tempStatus == 2   %varying
                i = size(data.condvect.varying,2)+1; % places at end of varying condvect
                if isMoog
                    data.condvect.varying(i).parameters.moog = tempVect.vect;
                    data.condvect.varying(i).parameters.openGL =tempVect. vectGL;
                else
                    data.condvect.varying(i).parameters = tempVect.vect;
                end
                data.condvect.varying(i).name = nicename;
            end

            if tempStatus == 3   %acrossStair
                i = size(data.condvect.acrossStair,2)+1; % places at end of acrossStair condvect
                if isMoog
                    data.condvect.acrossStair(i).parameters.moog = tempVect.vect;
                    data.condvect.acrossStair(i).parameters.openGL =tempVect. vectGL;
                else
                    data.condvect.acrossStair(i).parameters = tempVect.vect;
                    %% ------avi:for Adam1_Delta (sol) protocol - check if the duplicated value is enbled and if Sol Protocol.
                    if(strmatch(data.configfile , '1Adam_Delta.mat' ,'exact'))
                            if(strmatch(data.configinfo(i).name, 'STIMULUS_TYPE'))
                                i_DUPLICATED_STYMULUS_TYPE = strmatch('DUPLICATE_STIMULUS_TYPE' ,{char(data.configinfo.name)},'exact');
                                duplicatedSimulusType = data.configinfo(i_DUPLICATED_STYMULUS_TYPE).parameters;
                                if(duplicatedSimulusType)  %'0' value means not enable duplicated type with coherence.
                                    index = find(data.condvect.acrossStair(cntrA).parameters == duplicatedSimulusType , 1);
                                    addedVectorValue = data.condvect.acrossStair(cntrA).parameters(index);
                                    duplicatedIndex = size(data.condvect.acrossStair.parameters , 2) + 1;
                                    data.condvect.acrossStair(cntrA).parameters(duplicatedIndex) = addedVectorValue;
                                end
                            end
                    end
                    %% ------
                end
                data.condvect.acrossStair(i).name = nicename;
            end

            if tempStatus == 4   %withinStair
                i = size(data.condvect.withinStair,2)+1; % places at end of withinStair condvect
                if isMoog
                    data.condvect.withinStair(i).parameters.moog = tempVect.vect;
                    data.condvect.withinStair(i).parameters.openGL =tempVect. vectGL;
                else
                    data.condvect.withinStair(i).parameters = tempVect.vect;
                end
                data.condvect.withinStair(i).name = nicename;
            end
        end        
    end
end

%sets up crossed parameter matrix for varying condvect and display it.
str1 = '';
str3 = '';
yM = [];
yGL = [];
if ~isempty(data.condvect.varying)
    numvars = size(data.condvect.varying, 2);
    for i = 1:numvars
        if isfield(data.condvect.varying(i).parameters,'moog')
            lenvect(i) = length(data.condvect.varying(i).parameters.moog);
        else
            lenvect(i) = length(data.condvect.varying(i).parameters);
        end
    end

    numconds = prod(lenvect);
    yM = zeros(numconds,numvars);
    yGL = zeros(numconds,numvars);

% Expands vector with repeating values then expands vector to repeating vectors
    for i = 1:numvars
        len = prod(lenvect(1:i));
        if isfield(data.condvect.varying(i).parameters,'moog')
            t = ones((numconds/len),1) * data.condvect.varying(i).parameters.moog(1,:);
            tGL = ones((numconds/len),1) * data.condvect.varying(i).parameters.openGL(1,:);
        else
            t = ones((numconds/len),1) * data.condvect.varying(i).parameters(1,:);
            tGL = t;
        end
        
        t = t(:);
        tGL = tGL(:);
        t = t*ones(1,numconds/length(t));
        tGL = tGL*ones(1,numconds/length(tGL));
        t = t(:);
        tGL = tGL(:);
        
        yM(:,i) = t;
        yGL(:,i) = tGL;
    end
    
    %=== additional combination for Ardira's protocol. Jian 09/09/2012=========
     if strcmp(data.configfile,'rEyePursuitWithAZTuning.mat')        
        i1=strmatch('Azimuth',{char(data.condvect.varying.name)},'exact');
        i2=strmatch('cylinder depth',{char(data.condvect.varying.name)},'exact');
        if ~isempty(i1) && ~isempty(i2) 
            for j1=1:lenvect(i1)
                for j2=1:lenvect(i2)
                    numconds = numconds+1;
                    for i=1:numvars
                        if strmatch(data.condvect.varying(i).name, 'Azimuth')
                            yM(numconds, i)=data.condvect.varying(i).parameters.moog(1,j1);
                            yGL(numconds, i)=data.condvect.varying(i).parameters.openGL(1,j1);
                        end
                        
                        if strmatch(data.condvect.varying(i).name, 'Rotation Amplitude')
                            yM(numconds, i)=0;
                            yGL(numconds, i)=0;
                        end
                
                        if strmatch(data.condvect.varying(i).name, 'cylinder depth')
                            yM(numconds, i)=data.condvect.varying(i).parameters(1,j2);
                            yGL(numconds, i)=data.condvect.varying(i).parameters(1,j2);
                        end
                
                        if strmatch(data.condvect.varying(i).name, 'FP Rotate')
                            yM(numconds, i)=0;
                            yGL(numconds, i)=0;
                        end               
                    end
                end 
            end
        end       
     end
    %===End 09/09/2012======================================================
   
    %%=== below is how the text gets displayed in the box on the right side of basicInterface===%
    spac = {}; %create spacing array to place between columns of vars in cond list.
    for i = 1:numconds
        spac{i} = blanks(10); % 10 spaces
    end

    for i = 1:numvars
        str2 = sprintf('%s,  ',char(data.condvect.varying(i).name));
        str1 = [str1 str2];
        str3 = [str3 num2str(yM(:,i)) char(spac)];
    end
end

set(findobj(basicfig,'Tag','DisplayLabelText'),'String',str1)
set(findobj(basicfig,'Tag','DisplayListBox'),'String',str3)

setappdata(basicfig,'CrossVals',yM);
setappdata(basicfig,'CrossValsGL',yGL);
setappdata(basicfig,'protinfo',data);

if ~isempty(data.condvect.acrossStair) || ~isempty(data.condvect.withinStair) 
     StaircaseWindow;
else
    scwinH = findobj('Name','StaircaseWindow');
    if ~isempty(scwinH)
        close(scwinH);
    end
end

    

%Jing added this function because we use same methods to generate the condvect
%in different status. I don't like to write the same code again and again which 
%is a bad programming way. 12/01/08==================================
function V = genCondvect(ind,tagstr)
global basicfig

data = getappdata(basicfig,'protinfo');
if isfield(data.configinfo(ind).parameters,'moog') % moog/OpenGL
    siz = size(data.configinfo(ind).parameters.moog,2);
else
    siz = size(data.configinfo(ind).parameters,2);
end

for i = 1:siz
    if isfield(data.configinfo(ind).parameters,'moog')
        low = data.configinfo(ind).low_bound.moog(i);
        incr = data.configinfo(ind).increment.moog(i);
        mult = data.configinfo(ind).multiplier.moog(i);
        high = data.configinfo(ind).high_bound.moog(i);
        lowGL = data.configinfo(ind).low_bound.openGL(i);
        incrGL = data.configinfo(ind).increment.openGL(i);
        multGL = data.configinfo(ind).multiplier.openGL(i);
        highGL = data.configinfo(ind).high_bound.openGL(i);
    else
        low = data.configinfo(ind).low_bound(i);
        incr = data.configinfo(ind).increment(i);
        mult = data.configinfo(ind).multiplier(i);
        high = data.configinfo(ind).high_bound(i);
        lowGL = data.configinfo(ind).low_bound(i);
        incrGL = data.configinfo(ind).increment(i);
        multGL = data.configinfo(ind).multiplier(i);
        highGL = data.configinfo(ind).high_bound(i);
    end

    if data.configinfo(ind).vectgen == 0 % linear vector generation
        if ~isempty(strmatch(data.configinfo(ind).name, 'DISC_AMPLITUDES', 'exact')) ||...
           ~isempty(strmatch(data.configinfo(ind).name, 'DISC_AMPLITUDES_2I', 'exact'))
            tmpVect = low : incr : high;
            vect(i,:) = [-fliplr(tmpVect) tmpVect];
            tmpVect = lowGL : incrGL : highGL;
            vectGL(i,:) = [-fliplr(tmpVect) tmpVect];
        else
            vect(i,:) = low : incr : high;
            vectGL(i,:) = lowGL : incrGL : highGL;
        end
    elseif data.configinfo(ind).vectgen == 1 % log vector generation
        if mult == 1 || multGL == 1
            vect = 0;
            vectGL = 0;
            disp('Cannot log space with multiplier of 1')
        else
            if ~isempty(strmatch(data.configinfo(ind).name, 'DISC_AMPLITUDES', 'exact')) ||...
               ~isempty(strmatch(data.configinfo(ind).name, 'DISC_AMPLITUDES_2I', 'exact'))
                hi=high;
                i1 = 1;
                while hi > low
                    tmpvect(i1) = hi;
                    hi = hi * mult;
                    i1 = i1+1;
                end
                tmpvect(i1)=low;
                vect(i,:) = [-tmpvect fliplr(tmpvect)];

                i1 = 1;
                hi=highGL;
                while hi > lowGL
                    tmpvect(i1) = hi;
                    hi = hi * multGL;
                    i1 = i1+1;
                end
                tmpvect(i1)=lowGL;
                vectGL(i,:) = [-tmpvect fliplr(tmpvect)];
            else
                midpt = (high+low)/2;
                hi = high - midpt;
                lo = .2; % CHANGE THIS SOMEHOW, HOW CLOSE TO ZERO, LOG SHOULD GET!!
                i1 = 1;
                tmpvect(i1) = hi; %Jing added on 01/05/09
                while hi > lo
                    tmpvect(i1) = hi;
                    hi = hi * mult;
                    i1 = i1+1;
                end
                vect(i,:) = [-tmpvect 0 fliplr(tmpvect)];
                vect(i,:) = vect(i,:) + midpt;

                midpt = (highGL+lowGL)/2;
                hi = highGL - midpt;
                lo = .2; % CHANGE THIS SOMEHOW, HOW CLOSE TO ZERO, LOG SHOULD GET!!
                i1 = 1;
                tmpvect(i1) = hi; %Jing added on 01/05/09
                while hi > lo
                    tmpvect(i1) = hi;
                    hi = hi * multGL;
                    i1 = i1+1;
                end
                vectGL(i,:) = [-tmpvect 0 fliplr(tmpvect)];
                vectGL(i,:) = vectGL(i,:) + midpt;
            end
        end
    elseif data.configinfo(i).vectgen == 2  % custom vector generation,...
        %  returned by specified mfile or function
        if strmatch(tagstr, 'first')
            filename = char(data.configinfo(ind).callback);
            eval(['vect = ' filename ';'])
            eval(['vectGL = ' filename ';'])
        else
            if isempty(data.configinfo(ind).callback) % no callback given in config file
                %                 filename = uigetfile('.m','Choose m.file',data.genconfigpath);
                prompt = {'Enter mfile of func to create vector of vars:',...
                    'Or Enter a vector (MatLab code):'};
                dlg_title = 'Custom Generation of conditions';
                numlines = 1;
                answer = inputdlg(prompt, dlg_title,numlines);
                if ~isempty(char(answer)) % NOT(no input or pressed cancel)
                    if isempty(char(answer(1))) % no callback given, so vector
                        vect = str2num(char(answer(2)));
                        vectGL = str2num(char(answer(2)));
                        set(findobj(fig,'Tag',[varname '-DataText']),'String',...
                            char(answer(2)));
                    else % use mfile or function
                        eval(['vect = ' char(answer(1)) ';']);
                        eval(['vectGL = ' char(answer(1)) ';']);
                        set(findobj(fig,'Tag',[varname '-DataText']),'String',...
                            char(answer(1)));
                    end
                else
                    error(['Line ~917: Must select a mfile/function, '...
                        'define a vector or deselect ''Custom'''])
                end
            else
                eval(['vect = ' char(data.configinfo(ind).callback) ';']);
                eval(['vectGL = ' char(data.configinfo(ind).callback) ';']);
            end
        end
    end
end

V.vect = vect;
V.vectGL = vectGL;



