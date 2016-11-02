function [p] = weibullcdf(x, x0, alpha, beta)
%  WEIBULLCDF - Weibull cumulative distribution function
%    Usage: [p] = weibullcdf(x, x0, alpha, beta)
if nargin < 4, error('Not enough input arguments.'); end
p = 1-exp(log(1-alpha)*(x./x0).^beta);