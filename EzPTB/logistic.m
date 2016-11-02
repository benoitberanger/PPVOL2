function y = logistic(x, x0, y0, beta, nu)
%  LOGISTIC - Generalized logistic function
%    y = logistic(x, x0, y0, beta, nu)


% x0

%  [x0,y0] - threshold definition (y(x0) = y0)
%     beta - slope
%       nu - skewness of the slope (nu < 1 <=> positive skew, nu > 1 <=> negative skew, nu = 1 <=> classical logistic function)
%
if nargin < 5, nu = 1; end
if nargin < 4, error('Not enough input arguments.'); end
if ~nu
    y = gompertz(x, x0, y0, beta);
else
    alpha = x0+log(y0^(-nu)-1)/beta;
    y = 1./(1+exp(-beta*(x-alpha))).^(1/nu);
end
