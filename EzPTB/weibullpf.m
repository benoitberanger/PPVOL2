function [p] = weibullpf(x, x0, pc, beta, pmin, pmax)
%  WEIBULLPF - Weibull psychometric function
%    Usage: [p] = weibullpf(x, x0, pc, beta, pmin, pmax)
if nargin < 6, error('Not enough input arguments.'); end
p = pmin+(pmax-pmin)*weibullcdf(x, x0, (pc-pmin)/(pmax-pmin), beta);
