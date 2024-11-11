function [timeStartEnd, intervalDuration, meanIntervalDuration] = calContinuousInterval(array)
CC = bwconncomp(array);
timeStartEnd = zeros(CC.NumObjects, 2);
intervalDuration = zeros(CC.NumObjects, 1);

for i = 1:CC.NumObjects
    timeStartEnd(i, :) = [min(CC.PixelIdxList{i}), max(CC.PixelIdxList{i})];
    intervalDuration(i) = length(CC.PixelIdxList{i});
end

meanIntervalDuration = mean(intervalDuration);