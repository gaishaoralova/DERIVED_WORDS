%% 5- Epoch at -0.1 to 0.5, apply ICA, then copy ICA weights
EEG = applytochannels(EEG, [1:64] , 'pop_eegfiltnew(EEG, [],1,1690,1,[],0);');
EEG = pop_epoch( EEG, {  'R_fixation' 'L_fixation' }, [-0.1         0.5], 'newname', 'After_ICA epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
EEG = pop_select(EEG, 'trial', 1:100)
EEG = pop_rejspec( EEG, 1,'elecrange',[1:64] ,'method','fft','threshold',[-50 50] ,'freqlimits',[15 30] ,'eegplotcom','','eegplotplotallrej',0,'eegplotreject',1);
EEG = pop_runica(EEG, 'extended',1,'interupt','on', 'maxsteps', 512);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% STOP HERE. RUN ICA REJECT WITH EYETRACKER. NOTE DOWN NUMBERS. RUN UNTIL
% NEXT NOTE
icasphere = EEG.icasphere;
icaweights = EEG.icaweights;
icachansind = EEG.icachansind;
icawinv = EEG.icawinv;
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',3,'study',0);
EEG.icasphere = icasphere;
EEG.icaweights = icaweights;
EEG.icachansind = icachansind;
EEG.icawinv = icawinv;
eeglab redraw;

%% 6- Reject components, epoch, baseline correct
if(ismember(i, [1000,100])) %% These are indices for participants that used their left eyes
    [EEG vartable] = pop_eyetrackerica(EEG,'L_saccade', 'L_fixation',[5 0] ,1.1,3,0,4);
else
    [EEG vartable] = pop_eyetrackerica(EEG,'R_saccade', 'R_fixation',[5 0] ,1.1,3,0,4);
end
%% RUN ICA REJECT COMPONENT AND CHOOSE ONES FROM ABOVE. RUN BELOW

EEG = pop_subcomp(EEG, find(EEG.reject.gcompreject == 1)');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

%% Save dataset for later
EEG = pop_saveset( EEG, 'filename',strcat(subName, '_afterica.set'),'filepath',strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\'));

%% List of skips
listOfSamples = [649216, 708608, 739840, 692736, 872448,785920, 956416, 900096, 770560];
listOfSkips =   {[70 151 117 125 149  30   6   5 138 159 144  97  53  45 153  32  11  73   8 121 150 107 118 105 44  47  77  69 128  90 109  48 127  17  59  36  61  78 131 116 155  40  95  41  49  13  37 156 124  81  96  21 154 137 140 101  93  57  65 145 157  46];
[160  70  79  60 158 151 106 117  54  29 130 125 149  30   6 143   5 113 159 144 110  97 129  53 45  18 153  11  73   8  85 121  14  89 105  77  88  22  69  31   3 128  99  43  28  25 146  91 109   2  48  17  27  59 152  75 111  12 119 141  78 131 135  19  55  40  87   9 126  71  13  37 148 124  81 122  98  21   4  33 147 137 140 139  66   1 101  93  51  67  57  65  63 145 133 157];
[35  29 130  68 125 149  30   6 143   5  92  97 129  16  45  18 153  73  85 121 107  14 118  89 105  44  77  22  69  76  31 128  99  43 146 103 109  74  48 142  27  59  36 152  84  34  52  64 141  61  23 135 134  19 155  55  40  56  10  87  41  49  71  37   7  15  38 148 112  83 124  20 96 122  98 132  21   4 147 140 139 101  93  51  67  57  65 136  63 133 157];
[60  35 158 151 106 117  29 125 149  30  42   6 143   5 138  72 144  97  53  45 153  11  73   8 121 150 107  14 118  89 105  44  77  69   3 128  99  90   2  48 142 127  17  27  39  59 120 141 82 155  55  10  87  41  49  13  37  38 156  81  20  21   4  80 102 154 139  66 101  93  51 104 67  57  65 136  63 145 133 157  46];
[79  60  35 151 106 117  29 115  68 125 149  42 138  92 113  72  97 129  53  45  18 153  11  73  85 121  14 118 105  44  47  77  88  22  69  76   3 128  99  43  25 146  91 103  90 109  74 2 142 127  17 123  59  36 152  52  64 141  61  24  78  23 131  82 135 134  19  55  10  87  41 49   9 126 114  13  37   7  15 148  83  81  20  96 122 132  21   4  80  33  58 147 140 139  66  1 101  62  93  51  67  57  65 136  63 145 133 157  46];
[79 158  54  29 115  68 125 149  42   6   5 138 113  97  16  53  45 153  32  11  73   8 121  14 118  86  89 105  44  47  77  22  69  76  31   3  99  43  25  91  90 109  48 127  50  27  59 111 84  64  61 131 135 134 116  19 155  40  56  10  87  41  49   9  71 114  13  37  38 156 148 112  83  81  21  80  33 154  58 147 137 140  66   1 101  62  93 104  57  65 136  63 145 133 157];
[160  60  35 158 151 117  29 115  68 125 149  30   6   5 138  92 159  97 129  16  53  45 153  73 85 150 107  14 118  86  89 105  44  47  77  69  31   3 128  99  43  28 103 109   2  48 142  17 123  39  36 152 111  12  34  52  64 141  61  24  78  23  82 116 155  40  10  49   9  71 114  13 7  15 148 112 124  98 132  21  80 102  33  58 147 137  66   1 101  62  93 104  67  57  65 136 63 145 133  46];
[160  35 151 106 117  54  29 115 130  68 125 149  42 143   5 138 113 159  72 144  97 129  53  45 18 153  32  11 100  73   8 121 150 107  14 118  86  44  47  77  88  22  69  76   3 128  99  43 28  25 146  91 103  90 109  74   2  48  50  17  27 123 152  75 111 120  12  94  64 141  24  78 23  82 135  19  55  10  87  95  41   9  71  13  37   7  15 156 148  83 124  20  96 122  98 132 21   4  80 102  33 137 139  66 101  62  93 104  57  65  63 145 133 157  46];
[160  79  60  29 125 149  30  42   6 143   5  92 113 159  72 110  97 129  53  45 153  32  11  73  8 121 150 107  89 105  44  47  77  22  69  76   3 128  99  28 109  48 142 127  50  17  27 123 39 152 111  34 141  23 131  82 135  19  40  56  87  41  49   9 126  71 114  13  37  38 112  83 124  20  96 122 132  21  80 102  33 154  58 137 140  66   1 101  62  93  51  57  65 136  63 145 133 157  46] }; 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% 7- Split the sentences into 4 conditions (high_freq-high_lsa, high-freq-low_lsa, low_freq-low_lsa, low_freq-high_lsa) 

high_freq_high_lsa = [4	18	20	24	25	29	43	44	46	50	52	54	55	61	62	64	66	67	70	72	86	87	88	95	99	100	111	112	116	118	124	127	131	132	137	140	141	148	155	156
];
high_freq_low_lsa = [1	3	5	8	9	12	13	19	21	26	28	33	36	40	41	48	51	63	65	69	83	90	91	93	97	101	102	104	107	110	117	119	125	136	143	144	146	152	153	159
];
low_freq_high_lsa = [2	7	10	16	23	30	31	34	35	37	39	42	45	57	58	68	74	75	76	77	78	80	81	82	84	85	89	103	106	114	115	122	129	130	133	135	139	145	154	157
];
low_freq_low_lsa = [6	11	14	15	17	22	27	32	38	47	49	53	56	59	60	71	73	79	92	94	96	98	105	108	109	113	120	121	123	126	128	134	138	142	147	149	150	151	158	160
];
EEG = convertSenIdToCondSentRead(EEG, high_freq_high_lsa, high_freq_low_lsa,low_freq_high_lsa,low_freq_low_lsa, listOfSkips{i});
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);


%% 8- For each of the above conditions, slice at sentence id, slice at invboundary, slice at first fixation (0-100ms)
mkdir(strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\'));
count = 1;
for i={'hfhl' 'hfll'  'lfhl'  'lfll'}
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);

    EEG = pop_epoch( EEG,  { char(i) }, [0  7], 'newname', char(i), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    count = count + 1;
    EEG = pop_epoch( EEG,  { 'S169' }, [-0.1  3.0], 'newname', strcat(char(i),'_epoch'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    count = count + 1;
    EEG = pop_selectevent( EEG, 'latency','0<=100','type',{'R_fixation' 'L_fixation'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG = pop_epoch( EEG,  { 'R_fixation' 'L_fixation' }, [-0.1  1], 'newname', strcat(char(i),'_epoch_fixation'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    count = count +1;
    EEG = pop_rmbase( EEG, [-99.6094 0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    
    %artifact rejection
    
    EEG = pop_saveset( EEG, 'filename',strcat(subName,'_', char(i), '.set'),'filepath',strcat('.\\EYE_DATA\\SEN_READ\\',subName,'\\'));
    count = count + 1;

end
eeglab redraw;