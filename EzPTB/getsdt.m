function [dprime,lambda,beta,hrbnd,fabnd] = getsdt(s,r)
hr = nnz(s == 1 & r == 1)/nnz(s == 1);
fa = nnz(s == 2 & r == 1)/nnz(s == 2);
hrbnd = min(max(hr,0.5/nnz(s == 1)),1-0.5/nnz(s == 1));
fabnd = min(max(fa,0.5/nnz(s == 2)),1-0.5/nnz(s == 2));
dprime = normalz(hrbnd)-normalz(fabnd);
lambda = -0.5*(normalz(fabnd)+normalz(hrbnd));
beta = 0.5*(normalz(fabnd)^2-normalz(hrbnd)^2);
