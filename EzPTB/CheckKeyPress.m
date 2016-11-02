function [key] = CheckKeyPress(whichkeys)

if nargin < 1
    whichkeys = 1:256;
end

key = 0;
[iskeydown, keytime, keys] = KbCheck;
if any(keys(whichkeys))
    key = find(keys(whichkeys), 1);
end
