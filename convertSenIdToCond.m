function [EEG_output] = convertSenIdToCond(EEG, low, high,expN, skip)
low_intersects = intersect(low, skip);
low = setxor(low_intersects, low);
high_intersects = intersect(high, skip);
high = setxor(high_intersects, high);

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
                if (ismember(n, low))
                   EEG.event(i).type = strcat('low_',num2str(expN));
%                elseif (ismember(n, mid))
%                    EEG.event(i).type = strcat('mid_',num2str(expN));
                elseif (ismember(n, high))
                    EEG.event(i).type = strcat('high_',num2str(expN));
                end
            end
        end
    end
    EEG_output = EEG;
end

