function [audio] = OpenAudio(delay)
%  OpenAudio
%    Opens audio interface using ASIO API.
%    ASIO4ALL (www.asio4all.com) needs to be installed.
%
%  Usage:
%    >> [audio] = OpenAudio(delay);
%
%  Arguments:
%    i) delay - playback delay (in s, default: 0.200)
%    o) audio - audio interface
%
%  Information:
%    Playback sample rate: 44100 Hz
%    Playback buffer size: 0.200 s

%  Valentin Wyart (valentin.wyart@gmail.com)

if nargin < 1 || isempty(delay)
    delay = 0.200;
end

InitializePsychSound(1);

switch getenv('PTB_ID')

    case 'PC_STIM1'
        deviceid = 8;
        if delay == 0.200
            latencybias = -0.0026;
        elseif delay == 0.400
            latencybias = +0.0041;
        else
            warning('No latency correction found.');
            latencybias = 0;
        end
        
    case 'PC_VW1'
        deviceid = 8;
        warning('No latency correction found.');
        latencybias = 0;
        
    otherwise
        warning('Unknown host, will pick an ASIO device automatically.');
        devices = PsychPortAudio('GetDevices', 3);
        if isempty(devices)
            error('No ASIO device found.');
        end
        deviceid = devices(1).DeviceIndex;
        warning('No latency correction found.');
        latencybias = 0;
        
end

audio = struct;
audio.samplerate = 44100;
audio.buffersize = 0.200;
audio.delay = delay;
audio.latencybias = latencybias;
audio.h = PsychPortAudio('Open', deviceid, 1, 1, audio.samplerate, 2, [], audio.buffersize);
PsychPortAudio('LatencyBias', audio.h, audio.latencybias);
