function [button] = CheckButtonPress(whichbuttons)

if nargin < 1
    whichbuttons = 1:5;
end

button = 0;
buttons = ReadParPort;
if any(buttons(whichbuttons))
    button = find(buttons(whichbuttons), 1);
end
