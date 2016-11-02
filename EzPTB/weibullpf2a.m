function [p] = weibullpf2a(x, x0, pc, beta)
%  WEIBULLPF2A - Weibull 2A psychometric function
%    Usage: [p] = weibullpf2a(x, x0, pc, beta)
if nargin < 4, error('Not enough input arguments.'); end
p = weibullpf(x, x0, pc, beta, 0.5, 1);
