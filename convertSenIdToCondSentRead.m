function [EEG_output] = convertSenIdToCondSentRead(EEG, high_freq_high_lsa, high_freq_low_lsa, low_freq_high_lsa, low_freq_low_lsa, skip)
intersects = intersect(high_freq_high_lsa, skip);
high_freq_high_lsa = setxor(intersects, high_freq_high_lsa);

intersects1 = intersect(high_freq_low_lsa, skip);
high_freq_low_lsa = setxor(intersects1, high_freq_low_lsa);

intersects2 = intersect(low_freq_high_lsa, skip);
low_freq_high_lsa = setxor(intersects2, low_freq_high_lsa);

intersects3 = intersect(low_freq_low_lsa, skip);
low_freq_low_lsa = setxor(intersects3, low_freq_low_lsa);


%convertSenIdToCond
    for i =1:size(EEG.event, 2)
        event_temp = EEG.event(i).type;
        if(~isempty(event_temp))
            try
                y = regexp(event_temp, '^S\s?\s?(\d+)', 'tokens');
            catch err
                msgbox('Error for no reason');
            end
                if(~isempty(y))
                    n = str2num(y{1}{1});
                    if (ismember(n, high_freq_high_lsa))
                       EEG.event(i).type = 'hfhl';
                    elseif (ismember(n, high_freq_low_lsa))
                        EEG.event(i).type = 'hfll';
                    elseif (ismember(n, low_freq_high_lsa))
                        EEG.event(i).type = 'lfhl';
                    elseif (ismember(n, low_freq_low_lsa))
                        EEG.event(i).type = 'lfll';
                    end
                end
        end
    end
    EEG_output = EEG;
end

