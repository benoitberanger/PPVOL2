function [w,dprime0] = getw(dprimec,dprimei)
w = nan(size(dprimei));
dprime0 = nan(size(dprimei));
i0 = (dprimei == 0);
w(~i0) = (dprimec(~i0)./dprimei(~i0)-1)./(dprimec(~i0)./dprimei(~i0)+1);
dprime0(~i0) = dprimei(~i0).*sqrt(1+w(~i0).^2)./(1-w(~i0));
w(i0) = 1;
dprime0(i0) = dprimec(i0).*sqrt(1+w(i0).^2)./(1+w(i0));
