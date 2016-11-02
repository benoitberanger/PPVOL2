function [cf0] = getcf0(cf)
cf0 = 100*(mean(cf(cf > 0))-1)/7;
