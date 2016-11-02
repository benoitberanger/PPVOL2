function [buttons] = ReadParPort
%  ReadParPort
%    Reads button status from parallel port.
%
%  Usage:
%    >> [buttons] = ReadParPort;
%
%  Argument:
%    o) buttons - button status (0/1 if inactive/active)

%  Valentin Wyart (valentin.wyart@gmail.com)

global PAR_PORT
if isempty(PAR_PORT)
    error('Parallel port interface not open.');
end

buttons = zeros(1, 5);
if PAR_PORT == 1
    buffer = Matport('Inp', 889);
    buttons = [bitget(buffer, 8),~bitget(buffer, 6),~bitget(buffer, 5),~bitget(buffer, 7),~bitget(buffer, 4)];
end
