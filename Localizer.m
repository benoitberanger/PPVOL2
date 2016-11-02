function Localizer(name,irm)

addpath(genpath('EzPTB'))

if nargin < 2
    irm=0;
end

if nargin < 1
    error('Name required!');
    endhelp 

if exist([name '_localizer.mat'],'file')
    error('The corresponding result file already exists, please choose another name !');
end

diary([name '_localizer.txt'])

clc;

gamma = 2.2;
screenwidth = 1024; % screen width (in pixels)
screenheight = 768; % screen height (in pixels)
refreshrate = 60; % refresh rate (in Hz)
background = .1; % percent of maximal intensity (max intensity = 60 cd/m2 so .2% -> 30 cd/m2)
ppd = 53.62; % pixels per degree for irm
max_lumi = 0.6;

% target parameters
targetexcentricity = 3*ppd; % target excentricity (in degrees of visual angle)
targetdiameter = 2*ppd; % target diameter
targetfwhm = 1*ppd; % target FWHM (in degrees of visual angle)
targetfrequency = 4/ppd; % target spatial frequency (in cycles per degree of visual angle)
targetdeclination = 30/180*pi; % in radians
targetx = targetexcentricity*cos(targetdeclination);
targety = targetexcentricity*sin(targetdeclination);
hor_vert_exclusion = 30; % in degrees : exclude +- hor_vert_exclusion around vert and hor axes from possible target orientation

% 3 conditions : stim left, stim right and blank, with a
% blank between each
%TR = 1.78; %in seconds
TR = 2.130; % 36 slices
n_flickers_per_TR = 40;
flicker_duration = TR/n_flickers_per_TR; 
flicker_freq = n_flickers_per_TR/TR;
n_TR_per_block = 8;
n_flicker_per_block = n_flickers_per_TR*n_TR_per_block;
block_duration = n_TR_per_block*TR;
nblocks_per_cond = 5;
n_blocks_per_session = 4*nblocks_per_cond;
ntrials = 4*nblocks_per_cond*n_TR_per_block*n_flickers_per_TR;
% first 5 volumes discarded
ndummies = 2;
n_TR_per_session = 4*nblocks_per_cond*n_TR_per_block+ndummies; %162 TRs; sur la séquence : 165 volumes pour être sûr



% session duration
session_duration = (block_duration*n_blocks_per_session + ndummies*TR)/60; % in minutes
session_duration2 = (block_duration*n_blocks_per_session)/60; % in minutes

%6.5 min d'acquisition reelle

try

    % setup hardware
    AssertOpenGL;
    iscreen = [];
    res = [screenwidth screenheight];
    KbName('UnifyKeyNames');
    
    if isempty(iscreen)
        % iscreen = max(Screen('Screens'));
        iscreen = 1; % FOR IRM
    end
    if ~isempty(res)
        Screen('Resolution',iscreen,res(1),res(2),refreshrate);
    else
        res = Screen('Resolution',iscreen);
        if res.hz ~= refreshrate
            Screen('Resolution',iscreen,res.width,res.height,refreshrate);
        end
    end
    % FOR IRM
    OpenParPort; % Initialisation port parallele
    WriteParPort( 0);
    HideCursor;
    FlushEvents;
    ListenChar(2);
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask','General','UseFastOffscreenWindows');
    PsychImaging('AddTask','General','NormalizedHighresColorRange');
    PsychImaging('AddTask','FinalFormatting','DisplayColorCorrection','SimpleGamma');
    video = struct;
    video.i = iscreen;
    multisample = 4;
    video.h = PsychImaging('OpenWindow',video.i,0,[],[],[],[],multisample);
    [video.x,video.y] = Screen('WindowSize',video.h);
    video.fps = Screen('FrameRate',video.h);
    video.ifi = Screen('GetFlipInterval',video.h,100,50e-6,10);
    Screen('BlendFunction',video.h,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    LoadIdentityClut(video.h);
    PsychColorCorrection('SetColorClampingRange',video.h,0,1);
    PsychColorCorrection('SetEncodingGamma',video.h,1/gamma);
    Priority(MaxPriority(video.h));    
    
    Screen('ColorRange',video.h,1);
    Screen('TextFont',video.h,'Calibri');
    Screen('TextSize',video.h,round(0.5*ppd));
    
    % set background
    Screen('FillRect',video.h,background);
    Screen('Drawtext',video.h,sprintf('En attente de l''experimentateur (''entrer'')'),video.x/2-260,video.y/2+20)
    Screen('Flip',video.h);

    % create fixation point
    fixtex = Screen('MakeTexture',video.h,CreateFixationPointPatch(false),[],[],2); % texture
    fixrect = CenterRectOnPoint(Screen('Rect',fixtex),video.x/2,video.y/2); % position

    % create fixation with little white dot
    whitedotpatch(:,:,1) = ones(2,2);
    whitedotpatch(:,:,2) = ones(2,2);
    whitedottex = Screen('MakeTexture',video.h,whitedotpatch,[],[],2); % texture
    whitedotrect = CenterRectOnPoint(Screen('Rect',whitedottex),video.x/2,video.y/2); % position
    
    % set target position
    targetrect = zeros(4,4);
    targetrect(1,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2-targetx,video.y/2+targety); % down - left
    targetrect(2,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2+targetx,video.y/2+targety); % down - right
    targetrect(3,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2+targetx,video.y/2-targety); % up - right
    targetrect(4,:) = CenterRectOnPoint([0,0,targetdiameter,targetdiameter],video.x/2-targetx,video.y/2-targety); % up - left
    
    % create trial sequence
    % 1 -> diagonal 1, 2 -> diagonal 2, 0 -> blank
    block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
    flicker = repmat([1;2],round(n_TR_per_block*n_flickers_per_TR/2),1);
    time = ndummies*TR + flicker_duration*[0:1:4*nblocks_per_cond*n_TR_per_block*n_flickers_per_TR];
    
    % Display fixation wait for TTL
    WaitKeyPress(KbName({'return'}),10);
    Screen('DrawTexture',video.h,fixtex,[],fixrect);
    Screen('Drawtext',video.h,sprintf('Préparez-vous, ça va démarrer !'),video.x/2-260,video.y/2+20)
    t0 = Screen('Flip',video.h);
    WriteParPort(255);  % for eye tracker FOR IRM

    % wait for TTL (derive des 2 horloge : 1 ms toutes les 2 mins)
    if irm == 1
        WaitKeyPress(KbName({'t', '5%'}),Inf);  % '(' = '5%'
    elseif irm == 0
        WaitKeyPress(KbName({'return'}),Inf);  % '(' = '5%'
    end
    Screen('DrawTexture',video.h,fixtex,[],fixrect);
    t00 = Screen('Flip',video.h);
    WriteParPort(0); % For eye tracker
    disp('Trigger reçu');

    % dummy TRs
    Screen('Flip',video.h,t00+ndummies*TR-video.ifi)
    
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
            check_t(itrial) = Screen('Flip',video.h,t00+time(itrial)-0.5*video.ifi);

            % White dot echo in command window
            if (nwhitedots(iblock) == 1) && (iflicker >= flicker_num) && (iflicker < flicker_num + 2)
                fprintf('White dot @ %1.3f \n',check_t(itrial)-t00)
            end
            
            % Click of the subject
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(KbName('1!'))
                    fprintf('Click @ %1.3f \n',secs-t00)
                end
            end
            
        end
    end
    
    total_nwhitedots = sum(nwhitedots)

% save all variables
save([name '_localizer.mat']);


sca;
Priority(0);
FlushEvents;
ListenChar(0);
ShowCursor;
diary off

catch

    save([name '_localizer_ERROR.mat']);

    sca;
    Priority(0);
    FlushEvents;
    ListenChar(0);
    ShowCursor;
    psychrethrow(psychlasterror);
    diary off

end


end
