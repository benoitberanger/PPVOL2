function WriteParPort(data)
%  WriteParPort
%    Write one byte of data to parallel port.
%
%  Usage:
%    >> WriteParPort(data);
%
%  Arguments:
%    i) data - input byte of data (in [0,255] range)

%  Valentin Wyart (valentin.wyart@gmail.com)

global PAR_PORT
if isempty(PAR_PORT)
    error('Parallel port interface not open.');
end

if nargin < 1
    error('Not enough input arguments.');
end

if PAR_PORT == 1
    Matport('Outp', 888, data);
end
