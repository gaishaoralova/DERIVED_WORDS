%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Utilize general pipeline in multi-subject study
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1- Define subject IDs
subjects = {'sen_01'
            'sen_02'
            'sen_03'
            };
            

%% 2- Apply pipeline on every subject
diary all_subjects.txt
for i=1:length(subjects)
    subName = char(subjects{i});
    clearvars -except subName i subjects;
    disp(strcat('---------- Analyzing subject: ', subName,' ----------'));
    try
        analyze_eyetrackingeeg;
    catch error
        disp(error);
        disp(strcat('Analyzing subject: ', subName,' failed'))
    end
end
diary off
