%TR = 1.78; %in seconds, probably even older version than PPVOL1
% Previous TR = 2.130; % 36 slices 
% The real TR is now 1 sec, multiband
realTR = 1;
TR = 2*realTR;
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
