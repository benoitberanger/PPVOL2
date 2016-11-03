clc;

if nargin < 2
    irm=0;
end

if nargin < 1
    error('Name required!');
end

if strcmp(name,'')
    saveFlag = 0;
else
    saveFlag = 1;
end

if saveFlag
    
    stack = dbstack;
    functionName = stack(2).name;
    saveFileName = [fileparts(pwd) filesep 'data' filesep name '_' functionName];
    
    if exist([saveFileName '.mat'],'file')
        error('The corresponding result file already exists, please choose another name !');
    end
    
    diary([saveFileName '.txt'])
    
    fprintf('Data will be saved in : %s \n',saveFileName)
    
else
    
    fprintf('Data will not be saved')
    
end
