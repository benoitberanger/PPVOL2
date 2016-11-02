function [patch] = CreateGratingPatch(diameter, orientation, frequency, phase, contrast, noise, falloff, binary)

if nargin < 8 || isempty(binary)
    binary = false;
end
if nargin < 7 || isempty(falloff)
    falloff = 2;
end
if nargin < 6 || isempty(noise)
    noise = 0;
end
if nargin < 5 || isempty(contrast)
    contrast = 1;
end
if nargin < 4
    error('Not enough input arguments.');
end

diameter = floor(diameter/2)*2;
orientation = mod(orientation, 360);
frequency = min(frequency, 0.25);
phase = mod(phase, 1);

sigmoid = @(x, lim) lim(1)+diff(lim)./(1+exp(-x));

bbox = floor([diameter,diameter]/2)*2;
cbox = floor(bbox/2)+0.5;
[x, y] = meshgrid((1:bbox(1))-cbox(1), (1:bbox(2))-cbox(2));

patch = zeros([bbox,2]);

patch(:,:,1) = cos(2*pi*(frequency*(sin(pi/180*orientation)*x+cos(pi/180*orientation)*y)+phase));
if binary
    lambda = log(1/0.01-1)/sin(2*pi*frequency);
    patch(:,:,1) = sigmoid(lambda*patch(:,:,1), [-1,+1]);
end
if noise
    patch(:,:,1) = patch(:,:,1)+noise*patch(:,:,1);
end
patch(:,:,1) = contrast*patch(:,:,1);
% patch(:,:,1) = min(max(patch(:,:,1), 0), 1);

lambda = log(1/0.01-1)*2/falloff;
patch(:,:,2) = sigmoid(lambda*(sqrt(x.^2+y.^2)-(diameter-falloff)/2), [1,0]);
