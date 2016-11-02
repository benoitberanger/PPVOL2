function [width, height, refreshrate] = GetScreenResolution(screennumber)

if nargin < 1 || isempty(screennumber)
    screennumber = 0;
end

resolution = Screen('Resolution', screennumber);
width = resolution.width;
height = resolution.height;
refreshrate = resolution.hz;
