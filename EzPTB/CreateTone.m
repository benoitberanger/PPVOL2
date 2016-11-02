function [tone] = CreateTone(tonefrequency, toneduration, samplingrate, attenuation, noise, side)

if nargin < 6 || isempty(side)
    side = 0;
end
if nargin < 5 || isempty(noise)
    noise = 0;
end
if nargin < 4 || isempty(attenuation)
    attenuation = 40;
end
if nargin < 3
    error('Not enough input arguments.');
end

dt = 0.010; % window length (in s)
dattenuation = 40; % window maximum attenuation (in dB)

dn = dt*samplingrate;
sigma = dn/sqrt(-2*log(10^(-dattenuation/20)));

tone = sin(2*pi*tonefrequency*(0:toneduration*samplingrate)/samplingrate);
if noise > 0
    tone = tone+noise*randn(size(tone));
end
tone = tone*10^(-attenuation/20);
tone(1:dn) = tone(1:dn).*exp(-((1:dn)-dn).^2/(2*sigma^2));
tone(end-dn+1:end) = tone(end-dn+1:end).*exp(-((1:dn)-1).^2/(2*sigma^2));
tone = min(max(tone, -1), +1);

if side == 0
    tone = repmat(tone, 2, 1);
elseif side == 1
    tone = [tone;zeros(size(tone))];
elseif side == 2
    tone = [zeros(size(tone));tone];
end
