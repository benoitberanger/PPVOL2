function [patch] = CreateDot(pointdiameter)
%  CreateDot
%    Creates a dot of diameter 'pointdiameter' (in pixels, default: 8).
%
%  Usage:
%    >> [patch] = CreateDot(diameter)
%
%  Claire Sergent < clairesergent@yahoo.com >

if nargin < 1 || isempty(pointdiameter)
    pointdiameter = 8;
end

offset = [0,0]; % (x,y) offset (default: none)
falloff = 2; % falloff distance (in pixels, default: 2)
bbox = [pointdiameter,pointdiameter]+falloff+2*abs(offset);; % bounding box 

sigmoid = @(x, lims) lims(1)+(lims(2)-lims(1))./(1+exp(-x));

bbox = floor(bbox/2)*2;
cbox = floor(bbox/2) + 0.5;
[x,y] = meshgrid((1:bbox(1))-cbox(1)-offset(1), (1:bbox(2))-cbox(2)-offset(2));

patch = zeros([bbox([2,1]),1+1]);
lambda = log(1/0.01-1)*2/falloff;

patch(:,:,2) = sigmoid(lambda*(sqrt(x.^2+y.^2)-pointdiameter/2), [1,0]);

end
