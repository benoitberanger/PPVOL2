function [w] = ComputeStaircaseWeights(pc,d)

b = factorial(d)./(factorial(0:+1:d).*factorial(d:-1:0)).*pc.^(0:+1:d).*(1-pc).^(d:-1:0);
w = pc-linspace(0,1,d+1);
w = w./min(abs(w(w ~= 0)));
% w = w./max(abs(w));

end
