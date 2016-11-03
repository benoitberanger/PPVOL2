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

switch functionName
    case 'Meridian'
        multisample = 16;
    case'Localizer'
        multisample = 4;
end
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
DrawFormattedText(video.h,sprintf('En attente de l''experimentateur (''entrer'')'),'center',video.y*(3/4))
% Screen('Drawtext',video.h,sprintf('En attente de l''experimentateur (''entrer'')'),video.x/2,video.y*(3/4))
Screen('Flip',video.h);

% create fixation point
fixtex = Screen('MakeTexture',video.h,CreateFixationPointPatch(false),[],[],2); % texture
fixrect = CenterRectOnPoint(Screen('Rect',fixtex),video.x/2,video.y/2); % position

% create fixation with little white dot
whitedotpatch(:,:,1) = ones(2,2);
whitedotpatch(:,:,2) = ones(2,2);
whitedottex = Screen('MakeTexture',video.h,whitedotpatch,[],[],2); % texture
whitedotrect = CenterRectOnPoint(Screen('Rect',whitedottex),video.x/2,video.y/2); % position
