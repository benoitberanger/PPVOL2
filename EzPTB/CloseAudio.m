function CloseAudio()
%  CloseAudio
%    Closes audio interface.
%
%  Usage:
%    >> CloseAudio;

%  Valentin Wyart (valentin.wyart@gmail.com)

PsychPortAudio('Close');
