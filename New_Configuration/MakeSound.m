freq = 2000;
count_from = 1;
count_time = 1;
window_size = 0;
sound_time = 1;

silence_time = count_time - sound_time;    

SAMPLE_FREQ = 44100;

duration = count_from*count_time;
sound_duration = duration - window_size/2;
total_number_of_samples = sound_duration*SAMPLE_FREQ;

jumper = 1/SAMPLE_FREQ;

beginWav3 = [];
for i=1:1:count_from
    beginWav3 = [beginWav3 sin(freq*2*pi*(0:jumper:sound_time))];
    beginWav3 =[beginWav3 sin(0*2*pi*(0:jumper:silence_time))];
end    

beginWav3 = beginWav3(1:1:total_number_of_samples);

plot(beginWav3);

InitializePsychSound(true);

str_port_audio = 'Speakers (Sound BlasterX AE-5)';
devices = PsychPortAudio('GetDevices');

match_index = 0;
for i=1:1:size(devices,2)
    if(strcmp(devices(i).DeviceName ,str_port_audio) == 1)
        match_index = i - 1;
    end
end

portAudio = PsychPortAudio('Open' , match_index);

PsychPortAudio('FillBuffer', portAudio, [beginWav3;beginWav3]);

PsychPortAudio('Start', portAudio, 1,0);

