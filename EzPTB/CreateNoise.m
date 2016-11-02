function [noise] = CreateNoise(beta, noiseduration, samplingrate, attenuation)

% Creates a noise using the spatialPattern function
%     BETA defines the spectral distribution. 
%          Spectral density S(f) = N f^BETA
%          (f is the frequency, N is normalisation coeff).
%               BETA = 0 is random white noise.  
%               BETA = -1 is pink noise
%               BETA = -2 is Brownian noise


if nargin < 4 || isempty(attenuation)
    attenuation = 40;
end
if nargin < 3
    error('Not enough input arguments.');
end

dt = 0.010; % window length (in s)
dn = dt*samplingrate;
dattenuation = 40; % window maximum attenuation (in dB)
sigma = dn/sqrt(-2*log(10^(-dattenuation/20)));


noise = spatialPattern([round(samplingrate*noiseduration), 1], beta);
noise = noise';
noise = noise*10^(-attenuation/20);
noise(1:dn) = noise(1:dn).*exp(-((1:dn)-dn).^2/(2*sigma^2));
noise(end-dn+1:end) = noise(end-dn+1:end).*exp(-((1:dn)-1).^2/(2*sigma^2));
noise = min(max(noise, -1), +1);

end
