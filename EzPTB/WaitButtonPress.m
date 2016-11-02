function [button, t] = WaitButtonPress(whichbuttons, timeout, releasewait)

if nargin < 3 || isempty(releasewait)
    releasewait = true;
end
if nargin < 2 || isempty(timeout)
    timeout = 1;
end
if nargin < 1 || isempty(whichbuttons)
    whichbuttons = 1:5;
end

button = 0;
t = inf;
t0 = GetSecs;
while GetSecs-t0 < timeout
    buttons = ReadParPort;
    if any(buttons(whichbuttons))
        t = GetSecs;
        button = find(buttons(whichbuttons), 1);
        while releasewait
            buttons = ReadParPort;
            if ~any(buttons(whichbuttons)) && GetSecs-t > 0.010
                break
            end
        end
        break
    end
end
