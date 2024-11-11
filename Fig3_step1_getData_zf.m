clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);


birdIds = {'A413', 'B1', 'B3', 'B5', 'C29', 'C44', 'C47'};

leftShanks = {[3,4], [1, 2], [1:4], [2,3,4], [], [], []};
rightShanks = {[1,2], [5, 6], [5:8], [5,6,7,8], [], [], []};

zfPitch = struct();

for b = 1:length(birdIds)

    birdId = birdIds{b};

    dataDir = 'ZF\Zebra Finch RA from Margot\ZF_data\';
    audioFile = ['ZF\Zebra Finch RA from Margot\ZF_data\audioFull\audioFull_', birdId, '.wav'];
    vocalFile = ['ZF\Zebra Finch RA from Margot\ZF_data\audioFull\' birdId 'vocal.txt'];
    syllableFile = ['ZF\Zebra Finch RA from Margot\ZF_data\audioFull\' birdId 'syllable.txt'];
    outputDir = ['ZF\' birdId '\'];
    featureFile = ['ZF\' birdId '\alignedSyllables.mat'];
    scaleFile = ['ZF\' birdId '\scaleFactors.mat'];

    load(featureFile, 'newSyllableTimeWins', 'syllablePitch', 'newFeatures');

    load(scaleFile, 'maxScales', 'maxShifts', 'meanSpecs');


    sua = getZfSua([dataDir, birdId, 'data.mat']);

    leftShank = leftShanks{b};
    rightShank = rightShanks{b};

    shankIds = [sua.shank];
    leftUnits = ismember(shankIds, leftShank);
    rightUnits = ismember(shankIds, rightShank);

    vocalTimeWin = [];
    features = struct;
    fi = 1;
    curIdx = 1;
    for k = 1:length(newSyllableTimeWins)
        vocalTimeWin = [vocalTimeWin; newSyllableTimeWins{k}];
        for m = 1:size(newSyllableTimeWins{k}, 1)
            if k <= length(newSyllableTimeWins) - 2
                features(fi).songId = m;
                features(fi).syIdInSong = k;
            end
            features(fi).pitch = syllablePitch{k, m};
            features(fi).pitchFlag = ~isnan(syllablePitch{k, m});
            features(fi).entropy = newFeatures{k, m}.entropy;
            features(fi).amplitude = newFeatures{k, m}.amplitude;
            features(fi).harmRatio = newFeatures{k, m}.harmRatio;
            features(fi).freqMod = newFeatures{k, m}.FM;
            features(fi).lowHighFreqEnergyRatioLog = newFeatures{k,m}.lowHighFreqEnergyRatioLog;
            features(fi).fundamentalRatioLog = newFeatures{k,m}.fundamentalRatioLog;
            features(fi).fundamentalRatioLog2 = newFeatures{k,m}.fundamentalRatioLog2;
            features(fi).timeWithinSy = 1:length(features(fi).pitch);
            features(fi).time = round(newSyllableTimeWins{k}(m,1)*1000) + features(fi).timeWithinSy - 1;  % absolute time in ms
            features(fi).syGroup = k;
            features(fi).syIdx = curIdx:(curIdx+length(features(fi).pitch)-1);
            curIdx = curIdx+length(features(fi).pitch);
            fi = fi+1;
        end
    end

    syllableLength = zeros(1, length(features));
    for i = 1:length(features)
        syllableLength(i) = length(features(i).pitch);
    end


    allPitch = [features(:).pitch];
    allPitchFlag = [features(:).pitchFlag];
    allGoodPitch = allPitch(allPitchFlag);

    allEntropy = [features(:).entropy];
    allAmplitude = [features(:).amplitude];
    allFM = [features(:).freqMod];
    
    allHarmRatio = [features(:).harmRatio];
    allLowHighFreqEnergyRatioLog = [features(:).lowHighFreqEnergyRatioLog];
    allFundamentalRatioLog = [features(:).fundamentalRatioLog];
    allFundamentalRatioLog2 = [features(:).fundamentalRatioLog2];


    x = allFundamentalRatioLog;
    minX = min(x);
    rangeX = range(x);
    xnorm = (x-minX)/rangeX;
    allWeightedHarmRatio = xnorm.*allHarmRatio;

    x = allFundamentalRatioLog2;
    minX = min(x);
    rangeX = range(x);
    xnorm = (x-minX)/rangeX;
    allWeightedHarmRatio2 = xnorm.*allHarmRatio;

    allTimeWithinSy = [features(:).timeWithinSy];
    allTime = [features(:).time];


    neuralWinShift = [-30, -5]/1000;
    allUnitResp = cell(length(sua), 1);
    allUnitRespMatrix = zeros(length(sua), length(allPitch));
    for i = 1:length(sua)
        i
        spikeTimes = sua(i).spikeTimes;
        allVocalResp = struct([]);
        for j = 1:size(vocalTimeWin,1)
            resp = zeros(1, length(features(j).pitch));
            curTime = vocalTimeWin(j,1);
            curIdx = 1;
            for curIdx = 1:length(features(j).pitch)
                neuralWin = [curTime+neuralWinShift(1), curTime+neuralWinShift(2)];
                resp(curIdx) = sum((spikeTimes >= neuralWin(1)) & (spikeTimes <= neuralWin(2)));
                curTime = curTime+0.001; %1ms step.
            end
            allVocalResp(j).resp = resp;
        end
        allUnitResp{i} = allVocalResp;
        allUnitRespMatrix(i,:) = [allUnitResp{i}(:).resp];
    end

    zfPitch(b).allUnitRespMatrix = allUnitRespMatrix;
    zfPitch(b).neuralWinShift = neuralWinShift;
    zfPitch(b).syTimeWins = vocalTimeWin;
    zfPitch(b).syFeatures = features;
    zfPitch(b).allPitch = allPitch;
    zfPitch(b).allPitchFlag = allPitchFlag;
    zfPitch(b).allGoodPitch = allGoodPitch;
    zfPitch(b).allEntropy = allEntropy;
    zfPitch(b).allAmplitude = allAmplitude;
    zfPitch(b).allFM = allFM;
    zfPitch(b).allTimeWithinSy = allTimeWithinSy;
    zfPitch(b).allTime = allTime;

    zfPitch(b).leftUnits = leftUnits;
    zfPitch(b).rightUnits = rightUnits;
    zfPitch(b).maxScales = maxScales;
    zfPitch(b).maxShifts = maxShifts;
    zfPitch(b).meanSpecs = meanSpecs;

    zfPitch(b).birdId = birdId;

    zfPitch(b).allHarmRatio = allHarmRatio;
    zfPitch(b).allLowHighFreqEnergyRatioLog = allLowHighFreqEnergyRatioLog;
    zfPitch(b).allFundamentalRatioLog = allFundamentalRatioLog;
    zfPitch(b).allWeightedHarmRatio = allWeightedHarmRatio;
    zfPitch(b).allWeightedHarmRatio2 = allWeightedHarmRatio2;
end


for b = 1:length(birdIds)
    [coeff, score, latent, tsquared, explained] = pca(zfPitch(b).allUnitRespMatrix');

    zfPitch(b).coeff = coeff;
    zfPitch(b).score = score;
    zfPitch(b).latent = latent;
    zfPitch(b).explained = explained;
end



%%% quantify tuning
gap = 200;
pitchEdges = 0:gap:7000;
pitchMidPoint = pitchEdges(1:end-1)+gap/2;

pitchCurveWin = 200;
pitchStep = 200;
pitchCurveMidPoint = 500:pitchStep:7000;

biggerGap = 1000;
biggerPitchEdges = [1000:1000:5000];
biggerPitchMidPoint = biggerPitchEdges(1:end-1)+biggerGap/2;

tuningThresh = 6;

includeThreshN = 20;

zfPitchTuning = struct();
for b = 1:length(zfPitch)
    nUnits = size(zfPitch(b).allUnitRespMatrix, 1);
    pitchTuningCurve = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSd = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSe = zeros(nUnits, length(pitchCurveMidPoint));
    pitchRespSd = zeros(1, nUnits);
    pitchRespMean = zeros(1, nUnits);
    pitchRespRange = zeros(1, nUnits);
    
    biggerPitchTuningCurve = zeros(nUnits, length(biggerPitchMidPoint));

    pitchRsquare = zeros(1, nUnits);
    pitchRoughness = zeros(1, nUnits);
    pitchReliability = zeros(1, nUnits);
    pitchMod = zeros(1, nUnits);
    pitchMod2 = zeros(1, nUnits);
    pitchBest = zeros(1, nUnits);
    pitchFWHM = zeros(1, nUnits);
    pitchFWHMNorm = zeros(1, nUnits);
    pitchNBumps = zeros(1, nUnits);
    pitchBumpLength = cell(1, nUnits);
    pitchCurveRange = zeros(1, nUnits);
    pitchCurveSd = zeros(1, nUnits);
    pitchCurveRespSd = zeros(1, nUnits);
    pitch2ndDer = zeros(1, nUnits);

    biggerPitchMod = zeros(1, nUnits);
    biggerPitchCurveRange = zeros(1, nUnits);
    biggerPitchCurveSd = zeros(1, nUnits);
    biggerPitchCurveAbsDiff = zeros(1, nUnits);

    pitchTuningIdx = zeros(1, nUnits);
    pitchTuned = false(1, nUnits);

    for i = 1:nUnits
        unitResp = zfPitch(b).allUnitRespMatrix(i,:);
        pitchToInclude = zfPitch(b).allPitchFlag;
        goodPitchRes = unitResp(pitchToInclude)*1000/25;

        pitchIdx = find(pitchToInclude);

        idx1 = pitchIdx(1:2:length(pitchIdx));
        idx2 = pitchIdx(2:2:length(pitchIdx));
                
        [meanPitchResp, sdPitchResp, sePitchResp, r2, ~, ~, pitchCurveRespSd(i)] = calMeanRespAlongX(zfPitch(b).allPitch(pitchToInclude), goodPitchRes, pitchCurveMidPoint, pitchCurveWin, includeThreshN);

        pitchTuningCurve(i,:) = meanPitchResp;
        pitchTuningCurveSd(i,:) = sdPitchResp;
        pitchTuningCurveSe(i,:) = sePitchResp;
        pitchRespSd(i) = std(goodPitchRes);
        pitchRespMean(i) = mean(goodPitchRes);
        pitchRespRange(i) = range(goodPitchRes);
        pitchRsquare(i) = r2;

        [~, minPos] = min(meanPitchResp);

        [pitchMod(i), pitchBest(i), pitchFWHM(i), pitchFWHMNorm(i), pitchNBumps(i), pitchBumpLength{i}, pitchMod2(i), pitchCurveRange(i), pitchCurveSd(i), pitch2ndDer(i), pitchRoughness(i)] = characterizeTuningCurve(meanPitchResp, pitchCurveMidPoint);

        biggerMeanPitchResp = calMeanRespAlongX(zfPitch(b).allPitch(pitchToInclude), goodPitchRes, biggerPitchMidPoint, biggerGap, includeThreshN);
        [biggerPitchMod(i), ~, ~, ~, ~, ~, ~, biggerPitchCurveRange(i), biggerPitchCurveSd(i), ~, ~] = characterizeTuningCurve(biggerMeanPitchResp, biggerPitchMidPoint);
        biggerPitchTuningCurve(i,:) = biggerMeanPitchResp;
        biggerPitchCurveAbsDiff(i) = sum(abs(biggerMeanPitchResp(2:end)-biggerMeanPitchResp(1:end-1)));
        
        pitchTuningIdx(i) = biggerPitchCurveRange(i) / sqrt(pitchRespMean(i));
        if pitchTuningIdx(i) >= tuningThresh
            pitchTuned(i) = true;
        end

    end
    
    zfPitchTuning(b).bId = b*ones([1, nUnits]);
    zfPitchTuning(b).uId = 1:nUnits;

    zfPitchTuning(b).pitchCurveMidPoint = pitchCurveMidPoint;

    zfPitchTuning(b).pitchTuningCurve = pitchTuningCurve;
    zfPitchTuning(b).pitchTuningCurveSd = pitchTuningCurveSd;
    zfPitchTuning(b).pitchTuningCurveSe = pitchTuningCurveSe;
    zfPitchTuning(b).pitchRespSd = pitchRespSd;
    zfPitchTuning(b).pitchRespMean = pitchRespMean;
    zfPitchTuning(b).pitchRespRange = pitchRespRange;
    zfPitchTuning(b).pitchMidPoint = pitchMidPoint;
    zfPitchTuning(b).pitchEdges = pitchEdges;
    zfPitchTuning(b).pitchRsquare = pitchRsquare;
    zfPitchTuning(b).pitchCurveRespSd = pitchCurveRespSd;

    zfPitchTuning(b).pitchTuningIdx = pitchTuningIdx;
    zfPitchTuning(b).pitchTuned = pitchTuned;

    zfPitchTuning(b).pitchRoughness = pitchRoughness;
    zfPitchTuning(b).pitchReliability = pitchReliability;
    zfPitchTuning(b).pitchBest = pitchBest;
    zfPitchTuning(b).pitchFWHM = pitchFWHM;
    zfPitchTuning(b).pitchFWHMNorm = pitchFWHMNorm;
    zfPitchTuning(b).pitchMod = pitchMod;
    zfPitchTuning(b).pitchMod2 = pitchMod2;

    zfPitchTuning(b).pitchNBumps = pitchNBumps;
    zfPitchTuning(b).pitchBumpLength = pitchBumpLength;

    zfPitchTuning(b).pitchCurveRange = pitchCurveRange;
    zfPitchTuning(b).pitchCurveSd = pitchCurveSd;
    zfPitchTuning(b).pitch2ndDer = pitch2ndDer;

    zfPitchTuning(b).biggerPitchMidPoint = biggerPitchMidPoint;
    zfPitchTuning(b).biggerPitchTuningCurve = biggerPitchTuningCurve;
    zfPitchTuning(b).biggerPitchMod = biggerPitchMod;
    zfPitchTuning(b).biggerPitchCurveRange = biggerPitchCurveRange;
    zfPitchTuning(b).biggerPitchCurveSd = biggerPitchCurveSd;
    zfPitchTuning(b).biggerPitchCurveAbsDiff = biggerPitchCurveAbsDiff; 
end



%%% plot zebra finch single unit tuning
binLim = [0, 0.02];
for b = 1:length(zfPitch)
    for i = 1:size(zfPitch(b).allUnitRespMatrix, 1)
        gap = zfPitchTuning(b).pitchEdges(2)-zfPitchTuning(b).pitchEdges(1);
        unitResp = zfPitch(b).allUnitRespMatrix(i,:);

        pitchToInclude = zfPitch(b).allPitchFlag;

        goodPitchRes = unitResp(pitchToInclude);

        spikeEdges = 0:1:max(unitResp(zfPitch(b).allPitchFlag))+1;
        N = histcounts2(goodPitchRes, zfPitch(b).allPitch(pitchToInclude), spikeEdges, zfPitchTuning(b).pitchEdges);
        Nnormed = N/sum(N(:));

        figure;
        imagesc([zfPitchTuning(b).pitchEdges(1)+gap/2, zfPitchTuning(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
        set(gca,'ydir','normal');
        colorbar;
        colormap(flipud(gray));
        yticks([0:2:spikeEdges(end)]*1000/25)
        box off;
        clim(binLim)
        hold on;
        errorbar(zfPitchTuning(b).pitchCurveMidPoint, zfPitchTuning(b).pitchTuningCurve(i,:), zfPitchTuning(b).pitchTuningCurveSe(i,:), '.-','markersize', 10, 'CapSize', 2, 'MarkerFaceColor', 'r')
        
        title(['U' num2str(i), ' Tuning Idx:', num2str(zfPitchTuning(b).pitchTuningIdx(i))]);        
        close all
    end
end

save('zfPitch.mat', 'zfPitch', 'zfPitchTuning');