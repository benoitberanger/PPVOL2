function Localizer(name,irm,eyelink)

addpath(fullfile(pwd,'Common'))

ParseArguments % wrapper

ScreenParameters % wrapper

% 3 conditions : stim left, stim right and blank, with a
% blank between each
n_flickers_per_TR = 40;

StimParameters % wrapper

LocalizerTargetParameters % wrapper

try
    
    InitializerPTB
    
    % set target position
    targetrect = zeros(4,4);
    targetrect(1,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2-targetx,video.y/2+targety); % down - left
    targetrect(2,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2+targetx,video.y/2+targety); % down - right
    targetrect(3,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2+targetx,video.y/2-targety); % up - right
    targetrect(4,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2-targetx,video.y/2-targety); % up - left
    
    CreateTrialSequence % wrapper
    StartRecordingEyelink % wrapper
    WaitForTTL % wrapper
    
    % main loop
    for iblock = 1:size(block,1)
        
        nwhitedots(iblock) = round(rand);
        if nwhitedots(iblock) == 1
            flicker_num = randperm(size(flicker,1));
            flicker_num = flicker_num(1);
        end
        
        % create targets
        gaussianfun = @(x)exp(-x.^2/2);
        sigmoidfun = @(x,lim)lim(1)+diff(lim)./(1+exp(-x));
        falloff = 2;
        lambda = log(1/0.01-1)*2/falloff;
        
        targetorientation_up = rand*180; % target orientation (in degrees)
        targetorientation_down = rand*180; % target orientation (in degrees)
        
        while targetorientation_up < hor_vert_exclusion || (targetorientation_up > 90-hor_vert_exclusion & targetorientation_up < 90+hor_vert_exclusion) || targetorientation_up > 180-hor_vert_exclusion
            targetorientation_up = rand*180; % target orientation (in degrees)
        end
        
        while targetorientation_down < hor_vert_exclusion || (targetorientation_down > 90-hor_vert_exclusion & targetorientation_down < 90+hor_vert_exclusion) || targetorientation_down > 180-hor_vert_exclusion
            targetorientation_down = rand*180; % target orientation (in degrees)
        end
        
        targetphase_up = rand;
        targetphase_down = rand;
        targetpatch_up1 = CreateGratingPatch(targetdiameter, targetorientation_up, targetfrequency, targetphase_up, 1, [], [], true);
        targetpatch_up1(:,:,1) = background*(1+targetpatch_up1(:,:,1));
        targetpatch_up2 = CreateGratingPatch(targetdiameter, targetorientation_up, targetfrequency, targetphase_up+0.5, 1, [], [], true);
        targetpatch_up2(:,:,1) = background*(1+targetpatch_up2(:,:,1));
        targetpatch_down1 = CreateGratingPatch(targetdiameter, targetorientation_down, targetfrequency, targetphase_down, 1, [], [], true);
        targetpatch_down1(:,:,1) = background*(1+targetpatch_down1(:,:,1));
        targetpatch_down2 = CreateGratingPatch(targetdiameter, targetorientation_down, targetfrequency, targetphase_down+0.5, 1, [], [], true);
        targetpatch_down2(:,:,1) = background*(1+targetpatch_down2(:,:,1));
        
        targettex_up(1,:) = Screen('MakeTexture',video.h,targetpatch_up1,[],[],2); % up
        targettex_up(2,:) = Screen('MakeTexture',video.h,targetpatch_up2,[],[],2); % up
        targettex_down(1,:) = Screen('MakeTexture',video.h,targetpatch_down1,[],[],2); % down
        targettex_down(2,:) = Screen('MakeTexture',video.h,targetpatch_down2,[],[],2); % down
        
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
                break
            end
            
            Screen('DrawTexture',video.h,fixtex,[],fixrect);
            if (nwhitedots(iblock) == 1) && (iflicker == flicker_num)
                Screen('DrawTexture',video.h,whitedottex,[],whitedotrect);
            end
            if block(iblock) ~= 0
                Screen('DrawTexture',video.h,targettex_down(flicker(iflicker),:),[],targetrect(block(iblock),:));
                Screen('DrawTexture',video.h,targettex_up(flicker(iflicker),:),[],targetrect(block(iblock)+2,:));
            end
            itrial = (iblock-1)*n_TR_per_block*n_flickers_per_TR+iflicker;
            check_t(itrial) = Screen('Flip',video.h,t00+Time(itrial)-0.5*video.ifi);
            
            WhiteDotEcho % wrapper
            
            ClickEcho % wrapper
            
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
