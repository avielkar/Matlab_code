% cldata.beginWav = sin(500*2*pi*(0:.00001:.125));
%  
% soundsc(cldata.beginWav,100000);

SAMPLE_FREQ = 44100;

jumper = 1/SAMPLE_FREQ;

beginWav = sin(500*2*pi*(0:jumper:.125));


portAudio = PsychPortAudio('Open' , 3);
pause(1);

PsychPortAudio('FillBuffer', portAudio, [beginWav;beginWav]);

PsychPortAudio('Start', portAudio, 1,0);

pause(2)

 a = [ones(220,25);zeros(220,25)];
 a_timeout = a(:)';
 
 PsychPortAudio('FillBuffer', portAudio, [a_timeout;a_timeout]);
 PsychPortAudio('Start', portAudio, 1,0);
 
 
 
 
 
 
 a = [ones(22,200);zeros(22,200)];
 a_legit = a(:)';
 
 PsychPortAudio('FillBuffer', portAudio, [a_legit;a_legit]);
 PsychPortAudio('Start', portAudio, 1,0);
 
 
 
 