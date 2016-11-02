function y = gompertz(x, x0, y0, beta)
%  GOMPERTZ - Gompertz function
%    y = gompertz(x, x0, y0, beta)
%
%  [x0,y0] - threshold definition (y(x0) = y0)
%     beta - slope
%
if nargin < 4, error('Not enough input arguments.'); end
alpha = log(y0)/exp(-beta*x0);
y = exp(alpha*exp(-beta*x));
