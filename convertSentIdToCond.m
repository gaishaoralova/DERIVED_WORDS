ind = 1;

for i =1:size(EEG.event, 2)
    event_temp = EEG.event(i).type;
    if(~isempty(event_temp))
    y = regexp(event_temp, '^S\s?\s?(\d+)', 'tokens');
        if(~isempty(y))
            n = str2num(y{1}{1});
        
        if (n>0 && n<=210)
           sentence_ids{ind} = EEG.event(i).type;
           ind = ind + 1;
           EEG.event(i).type = 'S512';
           EEG.urevent(i).type = 'S512';
        end
        end
    end
end