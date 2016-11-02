function p = normalpdf(x, mu, sigma)
%  NORMALPDF Normal probability density function
%    >> p = normalpdf(x, [mu], [sigma])
if nargin < 3, sigma = 1; end
if nargin < 2, mu = 0; end
if nargin < 1, error('Not enough input arguments.'); end
p = exp(-0.5*((x-mu)./sigma).^2)./(sqrt(2*pi).*sigma);
