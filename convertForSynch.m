ind = 1;

for j =1:size(EEG.urevent, 2)
    event_temp = EEG.event(j).type;
    if(strcmp(EEG.event(j).value, 'STATUS'))
        n = event_temp;
        if ((n>0 && n<=160) || n == 170)
           sentence_ids{ind} = strcat('S', num2str(EEG.event(j).type));
           ind = ind + 1;
           EEG.event(j).type = 'S512';
           EEG.urevent(j).type = 'S512';
        else
            EEG.event(j).type = strcat('S', num2str(EEG.event(j).type));
            EEG.urevent(j).type = strcat('S',num2str(EEG.urevent(j).type));
        end
    else
        EEG.event(j).type = '';
        EEG.urevent(j).type = '';
    end
end