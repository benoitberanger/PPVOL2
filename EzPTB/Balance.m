function [stereosound] = Balance(monosound, sidebias)

% Creates a stereo sound with a side bias (between -1 and +1, respectively left and right)

if nargin < 2
    error('Not enough input arguments.');
end

if size(monosound,1) > 1
    error('The input mono sound needs to be a line vector')
end

stereosound = [monosound*(0.5-sidebias/2); monosound*(0.5+sidebias/2)];

end
