function burstTiming = calBurstTiming(sua, intervals, burstThresh)
% for each 
burstTiming = cell(length(sua), size(intervals,1));
%burstTimingMS = cell(length(sua), size(intervals, 1));

for i = 1:length(sua)
    %i
    spTimes = sua(i).spikeTimes;
    for j = 1:size(intervals, 1)
        curSpTimes = spTimes(spTimes >= intervals(j,1) & spTimes <= intervals(j,2));
        spikeGap = [];
        if length(curSpTimes)>1
            spikeGap = curSpTimes(2:end) - curSpTimes(1:end-1);
        end
        burstGap = spikeGap <= 1/burstThresh;
        burstStartEnd = calContinuousInterval(burstGap);

        if ~isempty(burstStartEnd)
            burstTiming{i,j} = [curSpTimes(burstStartEnd(:,1)), curSpTimes(burstStartEnd(:,2)+1)];
            %burstTimingMS{i,j} = [floor(curSpTimes(burstStartEnd(:,1))*1000), floor(curSpTimes(burstStartEnd(:,2)+1)*1000)];
        end
    end
end