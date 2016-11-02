function [staircase] = CreateStaircase(pctarget,xstart,sstart,dstart,pfdir)

if nargin < 5, pfdir = +1; end
if nargin < 4, error('Not enough input arguments.'); end

staircase = struct;

staircase.pctarget = pctarget; % the aim in percent correct on target
staircase.xstart = xstart; % contrast start
staircase.sstart = sstart; % step size start
staircase.dstart = dstart; % step duration (1 = 1 trial)
staircase.pfdir = sign(pfdir);

staircase.i = 1;
staircase.x = nan(1,1000); staircase.x(1) = xstart;
staircase.r = nan(1,1000);

staircase.scur = staircase.sstart;
staircase.dcur = staircase.dstart;

staircase.j = 0;
staircase.w = ComputeStaircaseWeights(staircase.pctarget,staircase.dcur);

staircase.wcur = 0;
staircase.wold = 0;

staircase.nstp = 0;
staircase.istp = nan(1,1000);

staircase.nrev = 0;
staircase.irev = nan(1,1000);

staircase.nupd = 0;
staircase.iupd = nan(1,1000);

end
