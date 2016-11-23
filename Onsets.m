% Create onsets etc... for SPM analysis

%% Localizer
clear all
realTR = 1;
TR = 2*realTR;
%n_flickers_per_TR = 40; this is specific to localizer or meridian
n_TR_per_block = 8;
block_duration = n_TR_per_block*TR;
nblocks_per_cond = 5;
block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
allonsets = ((1:length(block))-1)*block_duration;

names{1,1} = 'stimleft';
names{1,2} = 'blank';
names{1,3} = 'stimright';

onsets{1,1} = allonsets(block==1);
onsets{1,2} = allonsets(block==0);
onsets{1,3} = allonsets(block==2);

durations{1,1} = block_duration*ones(1,length(onsets{1,1}));
durations{1,2} = block_duration*ones(1,length(onsets{1,2}));
durations{1,3} = block_duration*ones(1,length(onsets{1,3}));

save localizer_onsets names onsets durations



%% Meridian
clear all
realTR = 1;
TR = 2*realTR;
%n_flickers_per_TR = 60; this is specific to localizer or meridian
n_TR_per_block = 8;
block_duration = n_TR_per_block*TR;
nblocks_per_cond = 5;
block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
allonsets = ((1:length(block))-1)*block_duration;

names{1,1} = 'horz';
names{1,2} = 'blank';
names{1,3} = 'vert';

onsets{1,1} = allonsets(block==1);
onsets{1,2} = allonsets(block==0);
onsets{1,3} = allonsets(block==2);

durations{1,1} = block_duration*ones(1,length(onsets{1,1}));
durations{1,2} = block_duration*ones(1,length(onsets{1,2}));
durations{1,3} = block_duration*ones(1,length(onsets{1,3}));

save meridian_onsets names onsets durations

%% Localizer for previous version
clear all
TR = 2.130;
%n_flickers_per_TR = 40; this is specific to localizer or meridian
n_TR_per_block = 8;
block_duration = n_TR_per_block*TR;
nblocks_per_cond = 5;
block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
allonsets = ((1:length(block))-1)*block_duration;

names{1,1} = 'stimleft';
names{1,2} = 'blank';
names{1,3} = 'stimright';

onsets{1,1} = allonsets(block==1);
onsets{1,2} = allonsets(block==0);
onsets{1,3} = allonsets(block==2);

durations{1,1} = block_duration*ones(1,length(onsets{1,1}));
durations{1,2} = block_duration*ones(1,length(onsets{1,2}));
durations{1,3} = block_duration*ones(1,length(onsets{1,3}));

save localizer_onsets_prev names onsets durations

%% Meridian for previous version
clear all
TR = 2.130;
%n_flickers_per_TR = 60; this is specific to localizer or meridian
n_TR_per_block = 8;
block_duration = n_TR_per_block*TR;
nblocks_per_cond = 5;
block = repmat([1; 0; 2; 0],nblocks_per_cond,1);
allonsets = ((1:length(block))-1)*block_duration;

names{1,1} = 'horz';
names{1,2} = 'blank';
names{1,3} = 'vert';

onsets{1,1} = allonsets(block==1);
onsets{1,2} = allonsets(block==0);
onsets{1,3} = allonsets(block==2);

durations{1,1} = block_duration*ones(1,length(onsets{1,1}));
durations{1,2} = block_duration*ones(1,length(onsets{1,2}));
durations{1,3} = block_duration*ones(1,length(onsets{1,3}));

save meridian_onsets_prev names onsets durations
