%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  General layout for EEG/EYE processing pipeline  %%%%
%%  Lexical decision                                %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0- Prep
if(~exist('subName', 'var'))
    clear; clc;
    subName = 'ld_09';
    i=9;
end
% listOfSamples = [1056768, 1570816, 879616];
% listOfSkips =   {[24 57 39 11 17 56 52 55 70 45 67 42 58 179 205 165 204 207 184 107 198 206  90 143 141 202  87 197 133  81 160  98 144 176 145 155 121  92 156 158 178 142 152 131 122  99 203 146 174 105 112];
%                 [40 39 64  6 30 113 167 205 151  78 206 170 86 154];
%                 [51 65 24 59 70  7 50 60 15 41 18 64 66 11 23 37 56 35 38  8 47 63 48 10 22 45 16 57 36 21 68 112 115 165 204 150 190 108 182 140 131 172 146 207 125 130 126  85 113 117 205 118 107 170 175 208  96 149 163 187 160 202  89 135 100 169 116 104 195 186  78]
%                 };
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% 1-  Convert asc to mat then import data

%Convert asc to mat (Uncomment when running new data)
parseeyelink(strcat('.\\EYE_DATA\\LEX_DEC\\',subName,'\\',subName, '.asc'),strcat('.\\EYE_DATA\\LEX_DEC\\',subName,'\\',subName, '.mat'));

% Open file
EEG = pop_fileio(strcat('.\\EEG_DATA\\LEX_DEC\\',subName, '.bdf'));
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_reref( EEG, [66 67], 'keepref','on');
EEG = pop_eegfiltnew(EEG, 0.1,30,16896,0,[],1);

%EEG = pop_fileio(strcat('.\\Data\\',subName,'\\',subName, '_Raw Data Inspection_binary.vhdr'));
EEG.chanlocs = loadbvef('locations.bvef');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% %% REMOVE ARTIFACT MARKER
EEG.event(1) = [];
EEG.urevent(1) = [];

%% 2- Convert sentence ids to 512s for synchornization
convertForSynch;

%% 3- synchronize with eyetracking data
EEG = pop_importeyetracker(EEG,strcat('.\\EYE_DATA\\LEX_DEC\\',subName,'\\',subName, '.mat'),[512 512] ,[1:4] ,{'TIME' 'R-GAZE-X' 'R-GAZE-Y' 'R-AREA'},1,1,0,1,4);

%% 4- Return sentence ids to normal
convertBackAfterSynch;

[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );
eeglab redraw;


%% 5- Do raw data inspection before running the next script
