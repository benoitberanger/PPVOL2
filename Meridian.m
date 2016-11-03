function Meridian(name,irm,eyelink)

addpath(fullfile(pwd,'Common'))

ParseArguments % wrapper

ScreenParameters % wrapper

% 3 conditions : horizontal meridian, vertical meridian and blank, with a
% blank between each
n_flickers_per_TR = 71;

StimParameters % wrapper


try
    
    InitializerPTB
    
    
    % create meridians
    length = video.x;
    height = video.y;
    [x,y] = meshgrid(1:length,1:height);
    truc = sin(2*pi/(ppd*period)*sqrt((x-round(length/2)).^2 + (y-round(height/2)).^2));
    truc(truc >= 0) = 1;
    truc(truc < 0) = -1;
    bidule = sin(atan((x-(length+1)/2)./((height+1)/2-y))*24);
    bidule(bidule >= 0) = 1;
    bidule(bidule < 0) = -1;
    
    damier1 = truc.*bidule;
    damier2 = -damier1;
    damier1(damier1==-1) = 0;
    damier2(damier2==-1) = 0;
    damier1(damier1==1) = max_lumi;
    damier2(damier2==1) = max_lumi;
    
    mask_central = sqrt((x-round(length/2)).^2 + (y-round(height/2)).^2) > ppd/2;
    mask_vert = abs(((height+1)/2-y)./((x-(length+1)/2))) > tan(70/180*pi);
    mask_vert = mask_vert.*mask_central;
    mask_hori = abs(((height+1)/2-y)./((x-(length+1)/2))) < tan(20/180*pi);
    mask_hori = mask_hori.*mask_central;
    
    vert_meridian_1 = cat(3,damier1,mask_vert); % first 2D layer (damier) : luminance, second 2D layer (mask) : alpha (if 1 : opaque, if 0 transparent)
    vert_meridian_2 = cat(3,damier2,mask_vert);
    hori_meridian_1 = cat(3,damier1,mask_hori);
    hori_meridian_2 = cat(3,damier2,mask_hori);
    
    meridiantex(1,:) = Screen('MakeTexture',video.h,vert_meridian_1,[],[],2); %
    meridiantex(2,:) = Screen('MakeTexture',video.h,hori_meridian_1,[],[],2); %
    meridiantex(3,:) = Screen('MakeTexture',video.h,vert_meridian_2,[],[],2); %
    meridiantex(4,:) = Screen('MakeTexture',video.h,hori_meridian_2,[],[],2); %
    meridianrect = CenterRectOnPoint(Screen('Rect',meridiantex(1,:)),video.x/2,video.y/2);
    
    CreateTrialSequence % wrapper
    StartRecordingEyelink % wrapper
    WaitForTTL % wrapper
    
    % main loop
    escFlag = 0;
    for iblock = 1:size(block,1)
        
        nwhitedots(iblock) = round(rand);
        if nwhitedots(iblock) == 1
            flicker_num = randperm(size(flicker,1)-2);
            flicker_num = flicker_num(1);
        end
        
        % FOR IRM
        if block(iblock) == 0
            WriteParPort(0);
        elseif block(iblock) == 1
            WriteParPort(255);
        elseif block(iblock) == 2
            WriteParPort(15);
        end
        
        for iflicker = 1:size(flicker,1)
            
            % if ESC is pressed, then abort session
            event = CheckKeyPress(KbName({'escape'}));
            if event == 1
                escFlag = 1;
                break
            end
            
            Screen('DrawTexture',video.h,fixtex,[],fixrect);
            if (nwhitedots(iblock) == 1) && (iflicker >= flicker_num) && (iflicker < flicker_num + 2)
                Screen('DrawTexture',video.h,whitedottex,[],whitedotrect);
            end
            if block(iblock) ~= 0
                Screen('DrawTexture',video.h,meridiantex(block(iblock)+flicker(iflicker),:),[],meridianrect);
            end
            itrial = (iblock-1)*n_TR_per_block*n_flickers_per_TR+iflicker;
            check_t(itrial) = Screen('Flip',video.h,t00+Time(itrial)-0.5*video.ifi);
            
            WhiteDotEcho % wrapper
            
            ClickEcho % wrapper
            
        end
        
        if escFlag == 1;
            break
        end
        
    end
    
    total_nwhitedots = sum(nwhitedots)
    
    % save all variables
    if saveFlag
        save([saveFileName '.mat']);
    end
    
    StopPTB; % wrapper
    
    EyelinkStopAndDownload
    
catch
    
    if saveFlag
        save([saveFileName '_ERROR.mat']);
    end
    StopPTB; % wrapper
    EyelinkEmergencySTOP
    psychrethrow(psychlasterror);
    
end


end
