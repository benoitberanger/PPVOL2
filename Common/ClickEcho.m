% Click of the subject
[keyIsDown, secs, keyCode] = KbCheck;
if keyIsDown
    if keyCode(KbName('1!'))
        fprintf('Click @ %1.3f \n',secs-t00)
    end
end
