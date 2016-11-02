function [u,p] = ustat(x1,x2)
if nargin < 2
    error('Not enough input arguments.');
end
n1 = length(x1);
n2 = length(x2);
if n1 == 0 || n2 == 0
    u = 1-1/(max(n1,0.5)*max(n2,0.5));
    return
elseif all(x1 == 0) && all(x2 == 0)
    u = nan;
    return
end
r = tiedrank([x1(:);x2(:)]);
u = (sum(r(1:n1))-n1*(n1+1)/2)/(n1*n2);
if u == 1
    u = 1-1/(n1*n2);
end
if nargout == 2
    p = ranksum(x1,x2);
end
end
