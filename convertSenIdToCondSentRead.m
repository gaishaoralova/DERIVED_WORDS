function [EEG_output] = convertSenIdToCondSentRead(EEG, high_freq_high_lsa, high_freq_low_lsa, low_freq_high_lsa, low_freq_low_lsa)

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

