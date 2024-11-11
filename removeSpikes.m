function newFlag = removeSpikes(flag, spikeSize)

%%% this is not removing neural spikes, but remove audio signal spikes.

    [timeStartEnd, intervalDuration] = calContinuousInterval(flag);
    badInterval = find(intervalDuration<=spikeSize);
    newFlag = flag;
    for i = 1:length(badInterval)
        newFlag(timeStartEnd(badInterval(i), 1):timeStartEnd(badInterval(i), 2)) = 0;
    end
end