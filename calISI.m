function ISI = calISI(sua, timeWin)
ISI = cell(length(sua), 1);
parfor i = 1:length(sua)
    thisISI = [];
    if isempty(timeWin)
        ISI{i} = sua(i).spikeTimes(2:end) - sua(i).spikeTimes(1:end-1);
    else
        for j = 1:size(timeWin,1)
            goodSpikes = sua(i).spikeTimes(sua(i).spikeTimes>timeWin(j,1) & sua(i).spikeTimes<=timeWin(j,2));
            curISI = [];
            if length(goodSpikes)>2
                curISI = goodSpikes(2:end) - goodSpikes(1:end-1);
            end
            thisISI = [thisISI;curISI];
        end
        ISI{i} = thisISI;
    end
end