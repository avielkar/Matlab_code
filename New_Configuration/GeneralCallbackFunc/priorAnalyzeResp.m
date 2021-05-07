function priorAnalyzeResp(appHandle)
global  debug 
global portAudio
global responseCorrectnessFeedback

% Received legit answer sound
 a = [ones(22,200);zeros(22,200)];
 a_legit = a(:)';
% Time Out Sound
a = [ones(220,25);zeros(220,25)];
a_timeout = a(:)';
% received non legit answer sound
a = [ones(110,50);zeros(110,50)];
a_non_legit = a(:)';

if debug
    disp('Entering  PriorAnalyzeResp')
end

trial = getappdata(appHandle,'trialInfo');
savedInfo = getappdata(appHandle,'SavedInfo');
data = getappdata(appHandle,'protinfo');
cldata = getappdata(appHandle, 'ControlLoopData');
crossVals = getappdata(appHandle,'CrossVals');
flagdata = getappdata(appHandle,'flagdata');

within = data.condvect.withinStair;
across = data.condvect.acrossStair;
varying = data.condvect.varying;
priors = data.condvect.priors;

activeStair = data.activeStair;
activeRule = data.activeRule;
currRep = data.repNum;
currTrial = trial(activeStair,activeRule).priorCntr;

%response =savedInfo(activeStair,activeRule).Resp(currRep).response(currTrial);
response =savedInfo(activeStair,activeRule).PriorResp.response(trial(activeStair,activeRule).priorCntr);
HR = cldata.hReference;
dir = priors.currentPrior.Dir;
savedInfo(activeStair,activeRule).PriorResp(currRep).dir(currTrial) = dir;

%if regular analyze for the priors
if cldata.is_flashing_priors == false
    if response == 1 % Respond 1 %Left/Down
        if debug
            disp('You answered Left/Down')
        end
        if dir < 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir > 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == 2 % Respond 2 Right/Up
        if debug
            disp('you answered right/up')
        end
        if dir > 0
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif dir < 0
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
    end
%if flashing analyze for the priors
else
    %take the curretnt button response option in order to know how to
    %analyze.
    button_option = priors.currentPrior.ButtonOption;
    num_of_flashes = cldata.num_of_flashes;
    
    %for analyzing in priors we dont need the response option, but only the
    %response, because 1 always says was valid response and means "ODD" and
    %2 always says was a valid response and means "EVEN".
%    if(button_option == 1)
%         %even - right ,odd - left
%         even_button = 2;    %right button
%         odd_button = 1;     %left button
%     elseif(button_option == 2)
%         %even - left ,odd - right
%         even_button = 1;    %left button
%         odd_button = 2;     %right button
%     elseif(button_option == 3)
%         %even - up ,odd - down
%         even_button = 3;    %up button
%         odd_button = 4;     %down button
%     elseif(button_option == 4)
%         %even - down ,odd - up
%         even_button = 4;    %down button
%         odd_button = 3;     %up button
%    end
    odd_button = 1;
    even_button = 2;
    if response == odd_button % Respond was odd number of flashes.
        if debug
            disp('You answered Left/Down')
        end
        if num_of_flashes == 1 || num_of_flashes == 3
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif num_of_flashes == 2
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    elseif response == even_button % Respond was even number of flashes.
        if debug
            disp('you answered right/up')
        end
        if num_of_flashes ==2
            if debug
                disp('correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        elseif num_of_flashes == 1 || num_of_flashes == 3
            if debug
                disp('Not correct')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        else
            if debug
                disp('No Answer')
            end
            savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
            savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
            savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
        end
    else % Unrecognized answer  Question: What to do when straight ahead is the heading? There is not corr/incorr
        if debug
            disp('Time Expired: Move Faster!!')
        end
        savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).incorr(currTrial) = 0;
        savedInfo(activeStair,activeRule).PriorResp(currRep).null(currTrial) = 1;
        savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow(currTrial) = 0;
    end
end


savedInfo(activeStair,activeRule).PriorResp(currRep).totalCorr = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).corr);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalIncorr = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).incorr);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalNull = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).null);
savedInfo(activeStair,activeRule).PriorResp(currRep).totalDontKnow = sum(savedInfo(activeStair,activeRule).PriorResp(currRep).dontKnow);

if~isempty(across)
    if isfield(across.parameters, 'moog')   % Adds in the across staircase value into the 'SavedInfo' matrix
        savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = across.parameters.moog(activeStair);
    else
        savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = across.parameters(activeStair);
    end
else
    savedInfo(activeStair,activeRule).PriorResp(currRep).acrossVal = '';
end

setappdata(appHandle,'SavedInfo',savedInfo);

%giving feedback sound correctness in the analyze stage.
if responseCorrectnessFeedback
    if savedInfo(activeStair,activeRule).Resp(currRep).corr(currTrial) == 1
        PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
        PsychPortAudio('Start', portAudio, 1,0);
    elseif response == 0
        PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
        PsychPortAudio('Start', portAudio, 1,0);
    else 
        PsychPortAudio('FillBuffer', portAudio, [a_non_legit;a_non_legit]);
        PsychPortAudio('Start', portAudio, 1,0);
    end 
end

if debug || flagdata.isSubControl
    if savedInfo(activeStair,activeRule).PriorResp(currRep).corr(currTrial) == 1
        %soundsc(data.correctWav,42000);
    else
        %soundsc(data.wrongWav,42000);
    end
    disp('Exiting general analyzeResp')
end


