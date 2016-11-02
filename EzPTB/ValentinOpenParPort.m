function OpenParPort
%  OpenParPort
%    Opens parallel port interface.
%    NTPort Library (www.zealsoftstudio.com/ntport/) need to be installed.
%
%  Usage:
%    >> OpenParPort;

%  Valentin Wyart (valentin.wyart@gmail.com)

global PAR_PORT
switch getenv('PTB_ID')
    
    case {'PC_VW1'}
        warning('Parallel port interface disabled.');
        PAR_PORT = 0;
        
    otherwise
        if ~isempty(PAR_PORT) && PAR_PORT == 1
            error('Parallel port interface already open.');
        end
        Matport('LicenseInfo', 'Valentin Wyart', 13104);
        if Matport('GetLPTPortAddress', 1) == 0
            error('Unable to find parallel port address.');
        end
        Matport('SetFastMode', 1);
        Matport('EnablePorts', 888, 890);
        Matport('Outp', 888, 0);
        Matport('Outp', 890, 4);
        if Matport('Inp', 888) ~= 0 || Matport('Inp', 890) ~= 4
            CloseParPort;
            error('Unable to open parallel port interface.');
        end
        PAR_PORT = 1;

end
