switch functionName
    case 'Meridian'
        % 1 > vertical, 2 > horizontal, 0 > blank
        block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
        flicker = repmat([0;2],round(n_TR_per_block*n_flickers_per_TR/2),1);
        Time = ndummies*TR + flicker_duration*[0:1:4*nblocks_per_cond*n_TR_per_block*n_flickers_per_TR];
    case'Localizer'
        % 1 -> diagonal 1, 2 -> diagonal 2, 0 -> blank
        block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
        flicker = repmat([1;2],round(n_TR_per_block*n_flickers_per_TR/2),1);
        Time = ndummies*TR + flicker_duration*[0:1:4*nblocks_per_cond*n_TR_per_block*n_flickers_per_TR];
end
