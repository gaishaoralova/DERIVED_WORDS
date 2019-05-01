%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  General layout for EEG/EYE processing pipeline    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0- Prep
if(~exist('subName', 'var'))
    clear; clc;
    subName = 'sen_09';
    i=9;
end
listOfSamples = [649216, 708608, 739840, 692736, 872448,785920, 956416, 900096, 770560];
listOfSkips =   {[160 131  70  59  36  47];
[144 158  18  54  88 119 124  79  73 148   4   2 126  40 131];
[36  68  84  74  64 103  38  59  44  40  83  61 112  85  51  92 155  98  52  16];
[63 104  46  67 136  51];
[103  10  87   2 114  24 127  42 122  46  92  58  79  74];
[56  59 112  32 156  50 116  47  90  38  40  79 138  41 115];
[160  80 115  44  78 150 155  61  40  15  35  31 129  92  52   7 104 103  36  68  28  12 151 2 132];
[24  90 111 104  54 102  68 106  64  50 113  22   2 138];
[22 40 58 63 60] }; 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

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
