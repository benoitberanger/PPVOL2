function [staircase] = UpdateStaircase(staircase,snew,dnew)

staircase = RefreshStaircase(staircase);

staircase.scur = snew;
staircase.dcur = dnew;

staircase.w = ComputeStaircaseWeights(staircase.pctarget,staircase.dcur);
staircase.j = staircase.i-1;

staircase.nupd = staircase.nupd+1;
staircase.iupd(staircase.nupd) = staircase.i;

end
