function [instaneousFR, instFRConcat, interSpikeInterval, instaneousFRbySyllable, instaneousFRbySyllableNormed, instaneousFRbySyllableDivNormed, instaneousFRbySyllableZscored, winFR] = calInstFR(sua, instaneousFRTimeWin)

%instaneousFRTimeWin in ms.

interSpikeInterval = {};
instaneousFR = cell(length(sua), size(instaneousFRTimeWin,1));
for i = 1:length(sua)
    i
    spikeTimes = sua(i).spikeTimes;
    tmpInterval = [];%spikeTimes(2:end) - spikeTimes(1:end-1);
    parfor j = 1:size(instaneousFRTimeWin,1)
        goodSpikes = spikeTimes((spikeTimes>instaneousFRTimeWin(j,1)/1000) & (spikeTimes<instaneousFRTimeWin(j,2)/1000));
        tmpInterval = [tmpInterval; goodSpikes(2:end)-goodSpikes(1:end-1)];

        instaneousFR{i,j} = zeros(1, instaneousFRTimeWin(j,2)-instaneousFRTimeWin(j,1)+1);
        t = instaneousFRTimeWin(j,1);
        while t <= instaneousFRTimeWin(j,2)
            intervalBegin = spikeTimes(find(spikeTimes<t/1000, 1, 'last'));
            intervalEnd = spikeTimes(find(spikeTimes>=t/1000, 1, 'first'));
            if floor(intervalEnd*1000) > instaneousFRTimeWin(j,2)
                assignEnd = instaneousFRTimeWin(j,2) - instaneousFRTimeWin(j,1) + 1;
            else
                assignEnd = floor(intervalEnd*1000) - instaneousFRTimeWin(j,1) + 1;
            end
            if assignEnd < t-instaneousFRTimeWin(j,1)+1
                assignEnd = t-instaneousFRTimeWin(j,1)+1;   % to avoid floor precision error
            end
            instaneousFR{i,j}((t-instaneousFRTimeWin(j,1)+1): assignEnd) = 1/(intervalEnd-intervalBegin);
            oldT = t;
            t = floor(intervalEnd*1000)+1;
            if t<=oldT
                t = oldT+1;
            end
        end
    end
    if ~isempty(tmpInterval)
        interSpikeInterval{i} = tmpInterval;
    end
end

wholeLength = 0;
for i = 1:size(instaneousFR,2)
    wholeLength = wholeLength + length(instaneousFR{1,i});
end

instFRConcat = zeros(length(sua), wholeLength);
for i = 1:length(sua)
    k = 1;
    for j = 1:size(instaneousFR,2)
        instFRConcat(i, k:k+length(instaneousFR{i,j})-1) = instaneousFR{i,j};
        k = k+length(instaneousFR{i,j});
    end
end

if nargout > 3
    instaneousFRbySyllable = cell(size(instaneousFRTimeWin,1), 1);
    instaneousFRbySyllableNormed = cell(size(instaneousFRTimeWin,1), 1);
    instaneousFRbySyllableDivNormed = cell(size(instaneousFRTimeWin,1), 1);
    instaneousFRbySyllableZscored = cell(size(instaneousFRTimeWin,1), 1);
    meanFR = mean(instFRConcat, 2);
    stdFR = std(instFRConcat, [], 2);

    for i = 1:size(instaneousFR, 2)
        thisInstaneousFR = instaneousFR(:,i);
        instaneousFRbySyllable{i} = cell2mat(thisInstaneousFR);
        instaneousFRbySyllableNormed{i} = instaneousFRbySyllable{i} - meanFR;
        instaneousFRbySyllableDivNormed{i} = instaneousFRbySyllable{i} ./ repmat(meanFR, [1, size(instaneousFRbySyllable{i},2)]);
        instaneousFRbySyllableZscored{i} = (instaneousFRbySyllable{i} - meanFR) ./ repmat(stdFR, [1, size(instaneousFRbySyllable{i},2)]);
    end
end

% cal winFR
winFR = cell(size(instaneousFRTimeWin,1), 1);
winSize = 25; %25ms interval
step = 5; %5ms step
if nargout > 7
    for j = 1:size(instaneousFRTimeWin,1)
        j
        winStart = instaneousFRTimeWin(j,1):step:(instaneousFRTimeWin(j,2)-(winSize-1));
        thisWinFR = zeros(length(sua), length(winStart));
        for i = 1:length(sua)
            spikeTimes = sua(i).spikeTimes;
            parfor k = 1:length(winStart)
                thisWin = [winStart(k), winStart(k)+winSize-1];
                thisWinFR(i,k) = sum((spikeTimes>=thisWin(1)/1000) & (spikeTimes<=thisWin(2)/1000))/winSize*1000;
            end
        end
        winFR{j} = thisWinFR;
    end
end