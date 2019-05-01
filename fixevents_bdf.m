ind = 1;

for j =1:size(EEG.urevent, 2)
    event_temp = EEG.event(j).value;
    if(strcmp(event_temp, 'STATUS'))
        EEG.event(j).type = num2str(bitand(EEG.event(j).type, 255));
    end
end