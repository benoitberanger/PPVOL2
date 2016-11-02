function SetScreenResolution(screennumber, width, height, refreshrate)
%  SetScreenResolution
%    Sets screen resolution.
%
%  Usage:
%    >> SetScreenResolution(screennumber, width, height, refreshrate);
%
%  Arguments:
%    i) screennumber - screen number (default: 0)
%    i)        width - width (in pixels)
%    i)       height - height (in pixels)
%    i)  refreshrate - refresh rate (in Hz)

%  Valentin Wyart (valentin.wyart@gmail.com)

if nargin < 4
    error('Not enough input arguments.');
end
if isempty(screennumber)
    screennumber = 0;
end

Screen('Resolution', screennumber, width, height, refreshrate);
