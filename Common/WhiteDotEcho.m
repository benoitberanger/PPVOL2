% White dot echo in command window
if (nwhitedots(iblock) == 1) && (iflicker >= flicker_num) && (iflicker < flicker_num + 2)
    fprintf('White dot @ %1.3f \n',check_t(itrial)-t00)
end
