function [rt0] = getrt0(rt)
rt0 = 1000*1/mean(1./rt);
