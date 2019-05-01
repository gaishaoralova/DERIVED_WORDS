ind=1;
for j =1:size(EEG.urevent, 2)
    event_temp = EEG.urevent(j).type;
    if(~isempty(event_temp))
    y = regexp(event_temp, '^S\s?\s?(\d+)', 'tokens');
        if(~isempty(y))
            n = str2num(y{1}{1});
            if (n==512)
               EEG.urevent(j).type = sentence_ids{ind};
               ind = ind + 1;
            end
        end
    end
end

ind=1;

for j =1:size(EEG.event, 2)
    event_temp = EEG.event(j).type;
    if(~isempty(event_temp))
    y = regexp(event_temp, '^S\s?\s?(\d+)', 'tokens');
        if(~isempty(y))
            n = str2num(y{1}{1});
            if (n==512)
               EEG.event(j).type = sentence_ids{ind};
               ind = ind + 1;
            end
        end
    end
end