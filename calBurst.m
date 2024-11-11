function [burstConcat, burstBySyllable, burstBySyllableNormed] = calBurst(sua, timeWin, burstThresh)
% timeWin in ms

burstTiming = calBurstTiming(sua, timeWin/1000, burstThresh);
burstBySyllable = cell(size(timeWin,1), 1);

burstConcat = [];
for i = 1:size(timeWin, 1)
    curWin = timeWin(i,:);
    winBurst = zeros(length(sua), curWin(2)-curWin(1)+1);
    for j = 1:length(sua)
        thisBurst = burstTiming{j,i};
        for k = 1:size(thisBurst,1)
            winBurst(j, floor(thisBurst(k,1)*1000-curWin(1))+1:floor(thisBurst(k,2)*1000-curWin(1))+1) = 1;
        end
    end
    burstBySyllable{i} = winBurst;
    burstConcat = [burstConcat, winBurst];
end