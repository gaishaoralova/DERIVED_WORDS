%% 5- Epoch at -0.1 to 0.5, apply ICA, then copy ICA weights
EEG = applytochannels(EEG, [1:64] , 'pop_eegfiltnew(EEG, [],1,1690,1,[],0);');
EEG = pop_epoch( EEG, {  'R_fixation' 'L_fixation' }, [-0.1         0.5], 'newname', 'After_ICA epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
%EEG = pop_select(EEG, 'trial', 1:500)
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
if(ismember(i, [200, 201])) %% These are indices for participants that used their left eyes
    [EEG vartable] = pop_eyetrackerica(EEG,'L_saccade', 'L_fixation',[5 0] ,1.1,3,0,4);
else
    [EEG vartable] = pop_eyetrackerica(EEG,'R_saccade', 'R_fixation',[5 0] ,1.1,3,0,4);
end

%% RUN ICA REJECT COMPONENT AND CHOOSE ONES FROM ABOVE. RUN BELOW

%% This part of rejecting ICA components needs to be done after visually inspecting the components for rejection
EEG = pop_subcomp(EEG, find(EEG.reject.gcompreject == 1)');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);


%% 7- Split the sentences into 4 conditions (high_freq-high_lsa, high-freq-low_lsa, low_freq-low_lsa, low_freq-high_lsa) 

high_freq_high_lsa = [4	18	20	24	25	29	43	44	46	50	52	54	55	61	62	64	66	67	70	72	86	87	88	95	99	100	111	112	116	118	124	127	131	132	137	140	141	148	155	156
];
high_freq_low_lsa = [1	3	5	8	9	12	13	19	21	26	28	33	36	40	41	48	51	63	65	69	83	90	91	93	97	101	102	104	107	110	117	119	125	136	143	144	146	152	153	159
];
low_freq_high_lsa = [2	7	10	16	23	30	31	34	35	37	39	42	45	57	58	68	74	75	76	77	78	80	81	82	84	85	89	103	106	114	115	122	129	130	133	135	139	145	154	157
];
low_freq_low_lsa = [6	11	14	15	17	22	27	32	38	47	49	53	56	59	60	71	73	79	92	94	96	98	105	108	109	113	120	121	123	126	128	134	138	142	147	149	150	151	158	160
];
EEG = convertSenIdToCondLexDec(EEG, high_freq_high_lsa, high_freq_low_lsa,low_freq_high_lsa,low_freq_low_lsa);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);


%% 8- For each of the above conditions, slice at word id(-0.1-1400), slice at when the word was shown (0-1000ms)
mkdir(strcat('.\\EYE_DATA\\LEX_DEC\\',subName,'\\'));
count = 4;
for i={'hfhl_ld' 'hfll_ld'  'lfhl_ld'  'lfll_ld'}
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'retrieve',3,'study',0);

    EEG = pop_epoch( EEG,  { char(i) }, [-0.1  1.4], 'newname', char(i), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    count = count + 1;
    
    EEG = pop_epoch( EEG,  { 'S167' }, [-0.1  1.0], 'newname', strcat(char(i),'_epoch'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    count = count + 1;
   
    EEG = pop_rmbase( EEG, [-99.6094 0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, count,'gui','off');
    EEG = pop_saveset( EEG, 'filename',strcat(subName,'_', char(i), '.set'),'filepath',strcat('.\\EYE_DATA\\LEX_DEC\\',subName,'\\'));
    count = count + 1;

end
eeglab redraw;