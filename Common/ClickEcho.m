% Click of the subject
[keyIsDown, secs, keyCode] = KbCheck;
if keyIsDown
    if keyCode(KbName('1!'))
        fprintf('Click Right @ %1.3f \n',secs-t00)
    elseif keyCode(KbName('2@'))
        fprintf('Click Left  @ %1.3f \n',secs-t00)
    end
end
