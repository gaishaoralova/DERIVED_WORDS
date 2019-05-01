%% Do it for Lexical Decision
eeglab
 
%% Sentence Reading
for sub=1:9
    for condition={'hfhl' 'hfll'  'lfhl'  'lfll'}
        %Open file
        condition = char(condition);
        EEG = pop_loadset('filename',sprintf('sen_%02d_%s.set',sub,condition),'filepath',sprintf('.\\EYE_DATA\\SEN_READ\\sen_%02d\\', sub));
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );

        %Convert to continuous
        EEG = pop_epoch2continuous(EEG);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');

        %Create events for ERPLab
        EEG  = pop_editeventlist( EEG , 'AlphanumericCleaning', 'on', 'List', '.\binlister_sen.txt',...
         'SendEL2', 'EEG', 'UpdateEEG', 'code', 'Warning', 'off' );

        %Split to Epochs again
        EEG = pop_epochbin( EEG , [-100.0  1000.0],  'none'); %
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off');

        %Create and save ERP file
        ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  3, 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', sprintf('sen_%02d_%s',sub,condition), 'filename', sprintf('sen_%02d_%s.erp',sub,condition), 'filepath',...
         '.\ERPs');

        %Clear before proceeding to next subject
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    end
end

%% Lexical Decision
for sub=1:9
    for condition={'hfhl_ld' 'hfll_ld'  'lfhl_ld'  'lfll_ld'}
        %Open file
        condition = char(condition);
        EEG = pop_loadset('filename',sprintf('ld_%02d_%s.set',sub,condition),'filepath',sprintf('.\\EYE_DATA\\LEX_DEC\\ld_%02d\\', sub));
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );

        %Convert to continuous
        EEG = pop_epoch2continuous(EEG);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');

        %Create events for ERPLab
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { 999 }, 'BoundaryString', { 'boundary' } );
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');

        %Bin according to events (takes from txt file}
        EEG  = pop_binlister( EEG , 'BDF', '.\binlister_lex.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

        %Split to Epochs again
        EEG = pop_epochbin( EEG , [-100.0  1000.0],  'none'); %
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off');

        %Create and save ERP file
        ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  4, 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname', sprintf('ld_%02d_%s',sub,condition), 'filename', sprintf('ld_%02d_%s.erp',sub,condition), 'filepath',...
         '.\ERPs');

        %Clear before proceeding to next subject
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    end
end