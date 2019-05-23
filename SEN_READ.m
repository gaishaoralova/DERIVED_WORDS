%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  General layout for EEG/EYE processing pipeline    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0- Prep
if(~exist('subName', 'var'))
    clear; clc;
    subName = 'sen_01';
    i=1;
end

%% 1-  Convert asc to mat then import data

%Convert asc to mat (Uncomment when running new data)
parseeyelink(strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\',subName, '.asc'),strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\',subName, '.mat'));

% Open file
EEG = pop_fileio(strcat('.\\EEG_DATA\\SEN_READ\\',subName, '.bdf'));
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw

EEG = pop_reref( EEG, [66 67], 'keepref','on');
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, 0.1,30,16896,0,[],1);

%EEG = pop_fileio(strcat('.\\Data\\',subName,'\\',subName, '_Raw Data Inspection_binary.vhdr'));
EEG.chanlocs = loadbvef('locations.bvef');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0);


%% REMOVE ARTIFACT MARKER
EEG.event(1) = [];
EEG.urevent(1) = [];

%% 2- Convert sentence ids to 512s for synchornization
convertForSynch;

%% 3- synchronize with eyetracking data
EEG = pop_importeyetracker(EEG,strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\',subName, '.mat'),[512 512] ,[1:4] ,{'TIME' 'R-GAZE-X' 'R-GAZE-Y' 'R-AREA'},1,1,0,1,4);

%% 4- Return sentence ids to normal
convertBackAfterSynch;

[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );
eeglab redraw;


%% 5- Do raw data inspection before running the next script
