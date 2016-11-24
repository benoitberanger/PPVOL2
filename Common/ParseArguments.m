clc;

addpath(fullfile(pwd,'EzPTB'))

if nargin < 3
    eyelink = 0;
end

if nargin < 2
    irm = 0;
end

if nargin < 1
    error('Name required!');
end

if strcmp(name,'')
    saveFlag = 0;
else
    if eyelink && length(name)~= 5
        error('name must be 5 chars (for eyelink)')
    end
    saveFlag = 1;
end

timeNow = now;
TimeStamp = datestr(timeNow);
TimeStampISO = datestr(timeNow,30);

stack = dbstack;
functionName = stack(2).name;

if saveFlag
    
    saveFilePath = [fileparts(pwd) filesep 'data' filesep];

    saveFileName = [saveFilePath TimeStampISO '_' name '_' functionName];
    
    if exist([saveFileName '.mat'],'file')
        error('The corresponding result file already exists, please choose another name !');
    end
    
    diary([saveFileName '.txt'])
    
    fprintf('Data will be saved in : %s \n',saveFileName)
    
    eyelinkFileName = ['PP' name functionName(1)];
    
else
    
    fprintf('Data will not be saved')
    
end
