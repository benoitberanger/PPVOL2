% Display fixation wait for TTL
WaitKeyPress(KbName({'return'}),10);
Screen('DrawTexture',video.h,fixtex,[],fixrect);
DrawFormattedText(video.h,sprintf('Préparez-vous, ça va démarrer !'),'center',video.y*(3/4))
% Screen('Drawtext',video.h,sprintf('Préparez-vous, ça va démarrer !'),video.x/2-260,video.y/2+20)
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
fprintf('Trigger reçu \n');

% dummy TRs
Screen('Flip',video.h,t00+ndummies*TR-video.ifi)
