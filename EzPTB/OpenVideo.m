function [video] = OpenVideo(screennumber, clut)
%  OpenVideo
%    Opens video interface.
%
%  Usage:
%    >> [video] = OpenVideo(screennumber, clut);
%
%  Arguments:
%    i) screennumber - screen number (default: 0)
%    i)         clut - color lookup table (default: identity)
%    o)        video - video interface
%
%  Information:
%    Alpha-blending is enabled.
%    Normalized [0,1] range for color and luminance intensity levels.

%  Valentin Wyart (valentin.wyart@gmail.com)

if nargin < 2 || isempty(clut)
    clut = [];
end
if nargin < 1 || isempty(screennumber)
    screennumber = 0;
end

video = struct;
video.screennumber = screennumber;
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');
if ~isempty(clut)
    if ~isa(clut, 'uint8') || ndims(clut) ~= 2 || size(clut, 1) ~= 3
        error('Invalid luminance lookup table.');
    end
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    PsychImaging('AddTask', 'General', 'EnableGenericHighPrecisionLuminanceOutput', clut);
end
video.h = PsychImaging('OpenWindow', screennumber, 0);
[video.width, video.height] = Screen('WindowSize', video.h);
video.ifi = Screen('GetFlipInterval', video.h, 100, 50e-6, 10);
Screen('BlendFunction', video.h, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
if isempty(clut)
%     LoadIdentityClut(video.h);
end
