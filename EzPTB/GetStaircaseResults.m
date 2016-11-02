function [results] = GetStaircaseResults(staircase, icvg)

if nargin < 2, icvg = []; end
if nargin < 1, error('Not enough input arguments.'); end

results = struct;

results.pctarget = staircase.pctarget;
results.stepinfo = staircase.stepinfo;
results.pfdir = staircase.pfdir;

results.n = staircase.i-1;
results.x = staircase.x(1:results.n);
results.r = staircase.r(1:results.n);

results.nstp = staircase.nstp;
results.istp = staircase.istp(1:results.nstp);

results.nrev = staircase.nrev;
results.irev = staircase.irev(1:results.nrev);

results.ndec = staircase.ndec;
results.idec = staircase.idec;

if isempty(icvg)
    if isempty(results.idec)
        icvg = nan;
    else
        icvg = results.idec(end);
    end
elseif icvg > results.n
    icvg = nan;
end
results.icvg = icvg;
if ~isnan(icvg)
    results.pc = mean(results.r(icvg:end));
    results.x0 = quantile(results.x(icvg:end), [0.25,0.50,0.75]);
else
    results.pc = nan;
    results.x0 = [nan,nan,nan];
end
