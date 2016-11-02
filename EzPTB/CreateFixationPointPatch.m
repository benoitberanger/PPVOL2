function [patch] = CreateFixationPointPatch(onlypoint)
%  CreateFixationPointPatch
%    Creates fixation point patch.
%
%  Usage:
%    >> [patch] = CreateFixationPointPatch(onlypoint)
%
%  Arguments:
%    i) onlypoint - only fixation point? (default: false)
%    o)     patch - patch with L/A planes

%  Valentin Wyart <valentin.wyart@gmail.com>

if nargin < 1 || isempty(onlypoint)
    onlypoint = false;
end

pointdiameter = 8; % point diameter (in pixels, default: 8)
innerdiameter = 16; % inner diameter (in pixels, default: 16)
outerdiameter = 20; % outer diameter (in pixels, default: 20)

falloff = 2; % falloff distance (in pixels, default: 2)
bbox = []; % bounding box (default: automatic)
offset = [0,0]; % (x,y) offset (default: none)

sigmoid = @(x, lims) lims(1)+(lims(2)-lims(1))./(1+exp(-x));

if isempty(bbox)
    bbox = [outerdiameter,outerdiameter]+falloff+2*abs(offset);
end
bbox = floor(bbox/2)*2;
cbox = floor(bbox/2) + 0.5;
[x,y] = meshgrid((1:bbox(1))-cbox(1)-offset(1), (1:bbox(2))-cbox(2)-offset(2));

patch = zeros([bbox([2,1]),1+1]);
lambda = log(1/0.01-1)*2/falloff;
patch(:,:,2) = sigmoid(lambda*(sqrt(x.^2+y.^2)-innerdiameter/2), [0,1]);
patch(:,:,2) = min(patch(:,:,2), sigmoid(lambda*(sqrt(x.^2+y.^2)-outerdiameter/2), [1,0]));
if ~onlypoint
    patch(:,:,2) = max(patch(:,:,2), sigmoid(lambda*(sqrt(x.^2+y.^2)-pointdiameter/2), [1,0]));
end