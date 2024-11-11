function meanFr = calAveFR(sua, timeWin)
    meanFr = zeros(length(sua), 1);
    if isempty(timeWin)
        meanFr = [];
        return
    end
    parfor j = 1:length(sua)
        %j
        timeDur = 0;
        nSpikes = 0;
        for i = 1:size(timeWin, 1)
            timeDur = timeDur + timeWin(i, 2) - timeWin(i, 1);
            nGoodSpikes = sum(sua(j).spikeTimes > timeWin(i,1) & sua(j).spikeTimes <= timeWin(i,2));
            nSpikes = nSpikes + nGoodSpikes;
        end
        meanFr(j) = nSpikes / timeDur;
    end
end