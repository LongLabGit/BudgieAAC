clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultAxesTickDir', 'Out');
set(0, 'DefaultAxesTickDirMode', 'manual');


load('bgI.mat');

bgPitch = struct();


for b = 1:4
    load(bgI(b).suaFile, 'sua');
    load(bgI(b).featureFile, 'features');

    vocalTimeWin = bgI(b).syTimeWin;
    neuralWinShift = [-30, -5]/1000;
    allUnitResp = cell(length(sua), 1);
    allUnitRespMatrix = zeros(length(sua), length([features(:).pitch]));
    for i = 1:length(sua)
        %i
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

    bgPitch(b).allUnitRespMatrix = allUnitRespMatrix;
    bgPitch(b).neuralWinShift = neuralWinShift;
    bgPitch(b).features = features;
    bgPitch(b).allPitch = [features(:).pitch];

    bgPitch(b).allAperiodicity = [features(:).aperiodicity];
    bgPitch(b).allFundRatioLog = [features(:).fundamentalRatioLog];

    bgPitch(b).allLowHighFreqEnergyRatioLog = [features(:).lowHighFreqEnergyRatioLog];
    bgPitch(b).allLowHighFreqEnergyRatioLogFiltered = [features(:).lowHighFreqEnergyRatioLogFiltered];
    bgPitch(b).allWeightedHarmRatio = [features(:).weightedHarmRatio];
    bgPitch(b).allWeightedHarmRatioFiltered = [features(:).weightedHarmRatioFiltered];
    bgPitch(b).allValidFlag = [features(:).validFlag];
end


%Control analysis
bgPitchControl = struct();
controlTimeWins = [-125, -100; 100, 125];

for b = 2  % use bird 2
    load(bgI(b).suaFile, 'sua');
    load(bgI(b).featureFile, 'features');

    vocalTimeWin = bgI(b).syTimeWin;

    for k = 1:size(controlTimeWins, 1)
        neuralWinShift = controlTimeWins(k,:)/1000
        allUnitResp = cell(length(sua), 1);
        allUnitRespMatrix = zeros(length(sua), length([features(:).pitch]));
        for i = 1:length(sua)
            %i
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

        bgPitchControl(k).allUnitRespMatrix = allUnitRespMatrix;
        bgPitchControl(k).neuralWinShift = neuralWinShift;
    end
end


%%% get Pitch flag
for i = 1:4
    lowFreqThresh = 1;
    normalFreqThresh = 1;

    lowFreqFlag = bgPitch(i).allLowHighFreqEnergyRatioLog > lowFreqThresh;
    lowFreqFlagFiltered = removeSpikes(lowFreqFlag, 4);

    normalFreqFlag = bgPitch(i).allLowHighFreqEnergyRatioLog < normalFreqThresh;
    normalFreqFlagFiltered = removeSpikes(normalFreqFlag, 4);

    validWeightedHarmRatio = bgPitch(i).allWeightedHarmRatio(normalFreqFlagFiltered & bgPitch(i).allValidFlag);

    bgPitch(i).harmPitchThresh = median(validWeightedHarmRatio, 'omitnan');
    bgPitch(i).allLowFreqFlagUnfiltered = lowFreqFlag;
    bgPitch(i).allLowFreqFlagFiltered = lowFreqFlagFiltered;
    bgPitch(i).allNormFreqFlagUnfiltered = normalFreqFlag;
    bgPitch(i).allNormFreqFlagFiltered = normalFreqFlagFiltered;
    bgPitch(i).allPitchFlagUnfiltered = bgPitch(i).allWeightedHarmRatio >= bgPitch(i).harmPitchThresh & normalFreqFlagFiltered;
    bgPitch(i).allPitchFlagFiltered = removeSpikes(bgPitch(i).allPitchFlagUnfiltered, 4);

    curIdx = 1;
    for j = 1:length(bgPitch(i).features)
        curLength = length(bgPitch(i).features(j).pitch);
        bgPitch(i).features(j).pitchFlagUnfiltered = bgPitch(i).allPitchFlagUnfiltered(curIdx:curIdx+curLength-1);
        bgPitch(i).features(j).pitchFlagFiltered = bgPitch(i).allPitchFlagFiltered(curIdx:curIdx+curLength-1);
        bgPitch(i).features(j).normFreqFlagUnfiltered = bgPitch(i).allNormFreqFlagUnfiltered(curIdx:curIdx+curLength-1);
        bgPitch(i).features(j).normFreqFlagFiltered = bgPitch(i).allNormFreqFlagFiltered(curIdx:curIdx+curLength-1);
        bgPitch(i).features(j).lowFreqFlagUnfiltered = bgPitch(i).allLowFreqFlagUnfiltered(curIdx:curIdx+curLength-1);
        bgPitch(i).features(j).lowFreqFlagFiltered = bgPitch(i).allLowFreqFlagFiltered(curIdx:curIdx+curLength-1);
        curIdx = curIdx+curLength;
    end
end


%%% PCA
for b = 1:4
    [coeff, score, latent, tsquared, explained] = pca(bgPitch(b).allUnitRespMatrix');

    bgPitch(b).coeff = coeff;
    bgPitch(b).score = score;
    bgPitch(b).latent = latent;
    bgPitch(b).explained = explained;
end



%%% PCA for control
for k = 1:length(bgPitchControl)
    [coeff, score, latent, tsquared, explained] = pca(bgPitchControl(k).allUnitRespMatrix');

    bgPitchControl(k).coeff = coeff;
    bgPitchControl(k).score = score;
    bgPitchControl(k).latent = latent;
    bgPitchControl(k).explained = explained;
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

lowPitchGap = 50;
lowPitchEdges = 0:lowPitchGap:800;
lowPitchMidPoint = lowPitchEdges(1:end-1)+lowPitchGap/2;


includeThresh = 0.005;
includeThreshN = 20;

bgPitchTuning = struct();
for b = 1:length(bgPitch)
    nUnits = size(bgPitch(b).allUnitRespMatrix, 1);
    pitchTuningCurve = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSd = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSe = zeros(nUnits, length(pitchCurveMidPoint));
    pitchRespSd = zeros(1, nUnits);
    pitchRespMean = zeros(1, nUnits);
    pitchRespRange = zeros(1, nUnits);
    

    biggerPitchTuningCurve = zeros(nUnits, length(biggerPitchMidPoint));
    
    lowPitchTuningCurve = zeros(nUnits, length(lowPitchMidPoint));
    lowPitchResp = zeros(1, nUnits);

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

    lowPitchBest = zeros(1, nUnits);

    for i = 1:nUnits
        unitResp = bgPitch(b).allUnitRespMatrix(i,:);
        pitchToInclude = bgPitch(b).allPitchFlagFiltered;
        goodPitchRes = unitResp(pitchToInclude)*1000/25;

        lowPitchToInclude = bgPitch(b).allLowFreqFlagFiltered;
        lowPitchUnitResp = unitResp(lowPitchToInclude)*1000/25;
        
        lowPitchResp(i) = mean(lowPitchUnitResp);
        
        pitchIdx = find(pitchToInclude);

        idx1 = pitchIdx(1:2:length(pitchIdx));
        idx2 = pitchIdx(2:2:length(pitchIdx));

        [meanPitchResp, sdPitchResp, sePitchResp, r2, ~, ~, pitchCurveRespSd(i)] = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, pitchCurveMidPoint, pitchCurveWin, includeThreshN);

        pitchTuningCurve(i,:) = meanPitchResp;
        pitchTuningCurveSd(i,:) = sdPitchResp;
        pitchTuningCurveSe(i,:) = sePitchResp;
        pitchRespSd(i) = std(goodPitchRes);
        pitchRespMean(i) = mean(goodPitchRes);
        pitchRespRange(i) = range(goodPitchRes);
        pitchRsquare(i) = r2;

        [~, minPos] = min(meanPitchResp);




        [pitchMod(i), pitchBest(i), pitchFWHM(i), pitchFWHMNorm(i), pitchNBumps(i), pitchBumpLength{i}, pitchMod2(i), pitchCurveRange(i), pitchCurveSd(i), pitch2ndDer(i), pitchRoughness(i)] = characterizeTuningCurve(meanPitchResp, pitchCurveMidPoint);

        [lowPitchRespC, ~, ~, ~] = calMeanRespAlongX(bgPitch(b).allPitch(lowPitchToInclude), lowPitchUnitResp, lowPitchMidPoint, lowPitchGap, includeThreshN);
        lowPitchTuningCurve(i,:) = lowPitchRespC;

        [~, lowPitchBest(i),~, ~]= characterizeTuningCurve(lowPitchRespC, lowPitchMidPoint);


        biggerMeanPitchResp = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, biggerPitchMidPoint, biggerGap, includeThreshN);
        [biggerPitchMod(i), ~, ~, ~, ~, ~, ~, biggerPitchCurveRange(i), biggerPitchCurveSd(i), ~, ~] = characterizeTuningCurve(biggerMeanPitchResp, biggerPitchMidPoint);
        biggerPitchTuningCurve(i,:) = biggerMeanPitchResp;
        biggerPitchCurveAbsDiff(i) = sum(abs(biggerMeanPitchResp(2:end)-biggerMeanPitchResp(1:end-1)));
        
        pitchTuningIdx(i) = biggerPitchCurveRange(i) / sqrt(pitchRespMean(i));
        if pitchTuningIdx(i) >= tuningThresh
            pitchTuned(i) = true;
        end
    end
    
    bgPitchTuning(b).bId = b*ones([1, nUnits]);
    bgPitchTuning(b).uId = 1:nUnits;

    bgPitchTuning(b).pitchCurveMidPoint = pitchCurveMidPoint;

    bgPitchTuning(b).pitchTuningCurve = pitchTuningCurve;
    bgPitchTuning(b).pitchTuningCurveSd = pitchTuningCurveSd;
    bgPitchTuning(b).pitchTuningCurveSe = pitchTuningCurveSe;
    bgPitchTuning(b).pitchRespSd = pitchRespSd;
    bgPitchTuning(b).pitchRespMean = pitchRespMean;
    bgPitchTuning(b).pitchRespRange = pitchRespRange;
    % bgPitchTuning(b).pitchTI = pitchTI;
    bgPitchTuning(b).pitchMidPoint = pitchMidPoint;
    bgPitchTuning(b).pitchEdges = pitchEdges;
    bgPitchTuning(b).pitchRsquare = pitchRsquare;
    bgPitchTuning(b).pitchCurveRespSd = pitchCurveRespSd;

    bgPitchTuning(b).pitchTuningIdx = pitchTuningIdx;
    bgPitchTuning(b).pitchTuned = pitchTuned;

    bgPitchTuning(b).pitchRoughness = pitchRoughness;
    bgPitchTuning(b).pitchReliability = pitchReliability;
    bgPitchTuning(b).pitchBest = pitchBest;
    bgPitchTuning(b).pitchFWHM = pitchFWHM;
    bgPitchTuning(b).pitchFWHMNorm = pitchFWHMNorm;
    bgPitchTuning(b).pitchMod = pitchMod;
    bgPitchTuning(b).pitchMod2 = pitchMod2;

    bgPitchTuning(b).pitchNBumps = pitchNBumps;
    bgPitchTuning(b).pitchBumpLength = pitchBumpLength;

    bgPitchTuning(b).lowPitchResp = lowPitchResp;
    bgPitchTuning(b).lowPitchTuningCurve = lowPitchTuningCurve;
    bgPitchTuning(b).lowPitchMidPoint = lowPitchMidPoint;
    bgPitchTuning(b).lowPitchEdges = lowPitchEdges;
    bgPitchTuning(b).lowPitchBest = lowPitchBest;

    bgPitchTuning(b).pitchCurveRange = pitchCurveRange;
    bgPitchTuning(b).pitchCurveSd = pitchCurveSd;
    bgPitchTuning(b).pitch2ndDer = pitch2ndDer;

    bgPitchTuning(b).biggerPitchMidPoint = biggerPitchMidPoint;
    bgPitchTuning(b).biggerPitchTuningCurve = biggerPitchTuningCurve;
    bgPitchTuning(b).biggerPitchMod = biggerPitchMod;
    bgPitchTuning(b).biggerPitchCurveRange = biggerPitchCurveRange;
    bgPitchTuning(b).biggerPitchCurveSd = biggerPitchCurveSd;
    bgPitchTuning(b).biggerPitchCurveAbsDiff = biggerPitchCurveAbsDiff; 
end


%%% find sorting order for tuned cell
for b = 1:4
    tunedCell = bgPitchTuning(b).pitchTuned;
    tunedCellCurve = bgPitchTuning(b).pitchTuningCurve(tunedCell, :);
    curveNorm = tunedCellCurve ./ max(tunedCellCurve, [], 2);

    bgPitchTuning(b).curveNorm = curveNorm;

    firstFreq = zeros(1, size(curveNorm, 1));
    for i = 1:size(curveNorm, 1)
        firstFreq(i) = find(curveNorm(i,:)>=0.7, 1, 'first');
    end
    bgPitchTuning(b).firstFreq = firstFreq;

    pitchCurveXRange = [find(~isnan(curveNorm(1,:)), 1, 'first'),...
        find(~isnan(curveNorm(1,:)), 1, 'last')];

    bgPitchTuning(b).pitchCurveXRange = pitchCurveXRange;

    [~, idx] = sort(firstFreq);

    bgPitchTuning(b).pitchTunedSortIdx = idx;
    tmp = find(tunedCell);
    bgPitchTuning(b).pitchTunedSortId = tmp(idx);

    bgPitchTuning(b).pitchCurveNormSorted = curveNorm(idx,:);
end

%%% PCA for cells that are tuned
for b = 1:4
    [coeff, score, latent, tsquared, explained] = pca(bgPitch(b).allUnitRespMatrix(bgPitchTuning(b).pitchTuned,:)');
    bgPitchTuning(b).coeff = coeff;
    bgPitchTuning(b).score = score;
    bgPitchTuning(b).latent = latent;
    bgPitchTuning(b).explained = explained;

    [coeff, score, latent, tsquared, explained] = pca(bgPitch(b).allUnitRespMatrix(bgPitchTuning(b).pitchTuned, bgPitch(b).allPitchFlagFiltered)');
    bgPitchTuning(b).coeffSub = coeff;
    bgPitchTuning(b).scoreSub = score;
    bgPitchTuning(b).latentSub = latent;
    bgPitchTuning(b).explainedSub = explained;
end


%%%%% pitch tuning for only calls
bgPitchTuningCall = struct();
for b = 1:length(bgPitch)
    nUnits = size(bgPitch(b).allUnitRespMatrix, 1);
    pitchTuningCurve = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSd = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSe = zeros(nUnits, length(pitchCurveMidPoint));
    pitchRespSd = zeros(1, nUnits);
    pitchRespMean = zeros(1, nUnits);
    pitchRespRange = zeros(1, nUnits);
    

    biggerPitchTuningCurve = zeros(nUnits, length(biggerPitchMidPoint));
    
    lowPitchTuningCurve = zeros(nUnits, length(lowPitchMidPoint));
    lowPitchResp = zeros(1, nUnits);

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

    lowPitchBest = zeros(1, nUnits);
    
    
    warbleFlag = false(size(bgPitch(b).allPitchFlagFiltered));
    warbleSys = find(bgI(b).warbleSyFlag);
    for s = 1:length(warbleSys)
        warbleFlag(bgI(b).syFeatureId==warbleSys(s)) = true;
    end
    
    for i = 1:nUnits
        unitResp = bgPitch(b).allUnitRespMatrix(i,:);
        pitchToInclude = bgPitch(b).allPitchFlagFiltered & ~warbleFlag;
        goodPitchRes = unitResp(pitchToInclude)*1000/25;

        lowPitchToInclude = bgPitch(b).allLowFreqFlagFiltered;
        lowPitchUnitResp = unitResp(lowPitchToInclude)*1000/25;
        
        lowPitchResp(i) = mean(lowPitchUnitResp);
        
        pitchIdx = find(pitchToInclude);

        idx1 = pitchIdx(1:2:length(pitchIdx));
        idx2 = pitchIdx(2:2:length(pitchIdx));
        
        [meanPitchResp, sdPitchResp, sePitchResp, r2, ~, ~, pitchCurveRespSd(i)] = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, pitchCurveMidPoint, pitchCurveWin, includeThreshN);

        pitchTuningCurve(i,:) = meanPitchResp;
        pitchTuningCurveSd(i,:) = sdPitchResp;
        pitchTuningCurveSe(i,:) = sePitchResp;
        pitchRespSd(i) = std(goodPitchRes);
        pitchRespMean(i) = mean(goodPitchRes);
        pitchRespRange(i) = range(goodPitchRes);
        pitchRsquare(i) = r2;

        [~, minPos] = min(meanPitchResp);

        [pitchMod(i), pitchBest(i), pitchFWHM(i), pitchFWHMNorm(i), pitchNBumps(i), pitchBumpLength{i}, pitchMod2(i), pitchCurveRange(i), pitchCurveSd(i), pitch2ndDer(i), pitchRoughness(i)] = characterizeTuningCurve(meanPitchResp, pitchCurveMidPoint);

        [lowPitchRespC, ~, ~, ~] = calMeanRespAlongX(bgPitch(b).allPitch(lowPitchToInclude), lowPitchUnitResp, lowPitchMidPoint, lowPitchGap, includeThreshN);
        lowPitchTuningCurve(i,:) = lowPitchRespC;

        [~, lowPitchBest(i),~, ~]= characterizeTuningCurve(lowPitchRespC, lowPitchMidPoint);


        biggerMeanPitchResp = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, biggerPitchMidPoint, biggerGap, includeThreshN);
        [biggerPitchMod(i), ~, ~, ~, ~, ~, ~, biggerPitchCurveRange(i), biggerPitchCurveSd(i), ~, ~] = characterizeTuningCurve(biggerMeanPitchResp, biggerPitchMidPoint);
        biggerPitchTuningCurve(i,:) = biggerMeanPitchResp;
        biggerPitchCurveAbsDiff(i) = sum(abs(biggerMeanPitchResp(2:end)-biggerMeanPitchResp(1:end-1)));
        
        pitchTuningIdx(i) = biggerPitchCurveRange(i) / sqrt(pitchRespMean(i));
        if pitchTuningIdx(i) >= tuningThresh
            pitchTuned(i) = true;
        end
    end
    
    bgPitchTuningCall(b).bId = b*ones([1, nUnits]);
    bgPitchTuningCall(b).uId = 1:nUnits;

    bgPitchTuningCall(b).pitchCurveMidPoint = pitchCurveMidPoint;

    bgPitchTuningCall(b).pitchTuningCurve = pitchTuningCurve;
    bgPitchTuningCall(b).pitchTuningCurveSd = pitchTuningCurveSd;
    bgPitchTuningCall(b).pitchTuningCurveSe = pitchTuningCurveSe;
    bgPitchTuningCall(b).pitchRespSd = pitchRespSd;
    bgPitchTuningCall(b).pitchRespMean = pitchRespMean;
    bgPitchTuningCall(b).pitchRespRange = pitchRespRange;
    bgPitchTuningCall(b).pitchMidPoint = pitchMidPoint;
    bgPitchTuningCall(b).pitchEdges = pitchEdges;
    bgPitchTuningCall(b).pitchRsquare = pitchRsquare;
    bgPitchTuningCall(b).pitchCurveRespSd = pitchCurveRespSd;

    bgPitchTuningCall(b).pitchTuningIdx = pitchTuningIdx;
    bgPitchTuningCall(b).pitchTuned = pitchTuned;

    bgPitchTuningCall(b).pitchRoughness = pitchRoughness;
    bgPitchTuningCall(b).pitchReliability = pitchReliability;
    bgPitchTuningCall(b).pitchBest = pitchBest;
    bgPitchTuningCall(b).pitchFWHM = pitchFWHM;
    bgPitchTuningCall(b).pitchFWHMNorm = pitchFWHMNorm;
    bgPitchTuningCall(b).pitchMod = pitchMod;
    bgPitchTuningCall(b).pitchMod2 = pitchMod2;

    bgPitchTuningCall(b).pitchNBumps = pitchNBumps;
    bgPitchTuningCall(b).pitchBumpLength = pitchBumpLength;

    bgPitchTuningCall(b).lowPitchResp = lowPitchResp;
    bgPitchTuningCall(b).lowPitchTuningCurve = lowPitchTuningCurve;
    bgPitchTuningCall(b).lowPitchMidPoint = lowPitchMidPoint;
    bgPitchTuningCall(b).lowPitchEdges = lowPitchEdges;
    bgPitchTuningCall(b).lowPitchBest = lowPitchBest;

    bgPitchTuningCall(b).pitchCurveRange = pitchCurveRange;
    bgPitchTuningCall(b).pitchCurveSd = pitchCurveSd;
    bgPitchTuningCall(b).pitch2ndDer = pitch2ndDer;

    bgPitchTuningCall(b).biggerPitchMidPoint = biggerPitchMidPoint;
    bgPitchTuningCall(b).biggerPitchTuningCurve = biggerPitchTuningCurve;
    bgPitchTuningCall(b).biggerPitchMod = biggerPitchMod;
    bgPitchTuningCall(b).biggerPitchCurveRange = biggerPitchCurveRange;
    bgPitchTuningCall(b).biggerPitchCurveSd = biggerPitchCurveSd;
    bgPitchTuningCall(b).biggerPitchCurveAbsDiff = biggerPitchCurveAbsDiff; 
end


%%%%% pitch tuning for only warbles
bgPitchTuningWarble = struct();
for b = 1:length(bgPitch)
    nUnits = size(bgPitch(b).allUnitRespMatrix, 1);
    pitchTuningCurve = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSd = zeros(nUnits, length(pitchCurveMidPoint));
    pitchTuningCurveSe = zeros(nUnits, length(pitchCurveMidPoint));
    pitchRespSd = zeros(1, nUnits);
    pitchRespMean = zeros(1, nUnits);
    pitchRespRange = zeros(1, nUnits);
    

    biggerPitchTuningCurve = zeros(nUnits, length(biggerPitchMidPoint));
    
    lowPitchTuningCurve = zeros(nUnits, length(lowPitchMidPoint));
    lowPitchResp = zeros(1, nUnits);

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

    lowPitchBest = zeros(1, nUnits);
    
    warbleFlag = false(size(bgPitch(b).allPitchFlagFiltered));
    warbleSys = find(bgI(b).warbleSyFlag);
    for s = 1:length(warbleSys)
        warbleFlag(bgI(b).syFeatureId==warbleSys(s)) = true;
    end
    
    for i = 1:nUnits
        unitResp = bgPitch(b).allUnitRespMatrix(i,:);
        pitchToInclude = bgPitch(b).allPitchFlagFiltered & warbleFlag;
        goodPitchRes = unitResp(pitchToInclude)*1000/25;

        lowPitchToInclude = bgPitch(b).allLowFreqFlagFiltered;
        lowPitchUnitResp = unitResp(lowPitchToInclude)*1000/25;
        
        lowPitchResp(i) = mean(lowPitchUnitResp);
        
        pitchIdx = find(pitchToInclude);

        idx1 = pitchIdx(1:2:length(pitchIdx));
        idx2 = pitchIdx(2:2:length(pitchIdx));
        
        [meanPitchResp, sdPitchResp, sePitchResp, r2, ~, ~, pitchCurveRespSd(i)] = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, pitchCurveMidPoint, pitchCurveWin, includeThreshN);

        pitchTuningCurve(i,:) = meanPitchResp;
        pitchTuningCurveSd(i,:) = sdPitchResp;
        pitchTuningCurveSe(i,:) = sePitchResp;
        pitchRespSd(i) = std(goodPitchRes);
        pitchRespMean(i) = mean(goodPitchRes);
        pitchRespRange(i) = range(goodPitchRes);
        pitchRsquare(i) = r2;

        [~, minPos] = min(meanPitchResp);

        [pitchMod(i), pitchBest(i), pitchFWHM(i), pitchFWHMNorm(i), pitchNBumps(i), pitchBumpLength{i}, pitchMod2(i), pitchCurveRange(i), pitchCurveSd(i), pitch2ndDer(i), pitchRoughness(i)] = characterizeTuningCurve(meanPitchResp, pitchCurveMidPoint);

        [lowPitchRespC, ~, ~, ~] = calMeanRespAlongX(bgPitch(b).allPitch(lowPitchToInclude), lowPitchUnitResp, lowPitchMidPoint, lowPitchGap, includeThreshN);
        lowPitchTuningCurve(i,:) = lowPitchRespC;

        [~, lowPitchBest(i),~, ~]= characterizeTuningCurve(lowPitchRespC, lowPitchMidPoint);


        biggerMeanPitchResp = calMeanRespAlongX(bgPitch(b).allPitch(pitchToInclude), goodPitchRes, biggerPitchMidPoint, biggerGap, includeThreshN);
        [biggerPitchMod(i), ~, ~, ~, ~, ~, ~, biggerPitchCurveRange(i), biggerPitchCurveSd(i), ~, ~] = characterizeTuningCurve(biggerMeanPitchResp, biggerPitchMidPoint);
        biggerPitchTuningCurve(i,:) = biggerMeanPitchResp;
        biggerPitchCurveAbsDiff(i) = sum(abs(biggerMeanPitchResp(2:end)-biggerMeanPitchResp(1:end-1)));
        
        pitchTuningIdx(i) = biggerPitchCurveRange(i) / sqrt(pitchRespMean(i));
        if pitchTuningIdx(i) >= tuningThresh
            pitchTuned(i) = true;
        end
    end
    
    bgPitchTuningWarble(b).bId = b*ones([1, nUnits]);
    bgPitchTuningWarble(b).uId = 1:nUnits;

    bgPitchTuningWarble(b).pitchCurveMidPoint = pitchCurveMidPoint;

    bgPitchTuningWarble(b).pitchTuningCurve = pitchTuningCurve;
    bgPitchTuningWarble(b).pitchTuningCurveSd = pitchTuningCurveSd;
    bgPitchTuningWarble(b).pitchTuningCurveSe = pitchTuningCurveSe;
    bgPitchTuningWarble(b).pitchRespSd = pitchRespSd;
    bgPitchTuningWarble(b).pitchRespMean = pitchRespMean;
    bgPitchTuningWarble(b).pitchRespRange = pitchRespRange;
    bgPitchTuningWarble(b).pitchMidPoint = pitchMidPoint;
    bgPitchTuningWarble(b).pitchEdges = pitchEdges;
    bgPitchTuningWarble(b).pitchRsquare = pitchRsquare;
    bgPitchTuningWarble(b).pitchCurveRespSd = pitchCurveRespSd;

    bgPitchTuningWarble(b).pitchTuningIdx = pitchTuningIdx;
    bgPitchTuningWarble(b).pitchTuned = pitchTuned;

    bgPitchTuningWarble(b).pitchRoughness = pitchRoughness;
    bgPitchTuningWarble(b).pitchReliability = pitchReliability;
    bgPitchTuningWarble(b).pitchBest = pitchBest;
    bgPitchTuningWarble(b).pitchFWHM = pitchFWHM;
    bgPitchTuningWarble(b).pitchFWHMNorm = pitchFWHMNorm;
    bgPitchTuningWarble(b).pitchMod = pitchMod;
    bgPitchTuningWarble(b).pitchMod2 = pitchMod2;

    bgPitchTuningWarble(b).pitchNBumps = pitchNBumps;
    bgPitchTuningWarble(b).pitchBumpLength = pitchBumpLength;

    bgPitchTuningWarble(b).lowPitchResp = lowPitchResp;
    bgPitchTuningWarble(b).lowPitchTuningCurve = lowPitchTuningCurve;
    bgPitchTuningWarble(b).lowPitchMidPoint = lowPitchMidPoint;
    bgPitchTuningWarble(b).lowPitchEdges = lowPitchEdges;
    bgPitchTuningWarble(b).lowPitchBest = lowPitchBest;

    bgPitchTuningWarble(b).pitchCurveRange = pitchCurveRange;
    bgPitchTuningWarble(b).pitchCurveSd = pitchCurveSd;
    bgPitchTuningWarble(b).pitch2ndDer = pitch2ndDer;

    bgPitchTuningWarble(b).biggerPitchMidPoint = biggerPitchMidPoint;
    bgPitchTuningWarble(b).biggerPitchTuningCurve = biggerPitchTuningCurve;
    bgPitchTuningWarble(b).biggerPitchMod = biggerPitchMod;
    bgPitchTuningWarble(b).biggerPitchCurveRange = biggerPitchCurveRange;
    bgPitchTuningWarble(b).biggerPitchCurveSd = biggerPitchCurveSd;
    bgPitchTuningWarble(b).biggerPitchCurveAbsDiff = biggerPitchCurveAbsDiff; 
end


save('bgPitch.mat', 'bgPitch', 'bgPitchTuning', 'tuningThresh', 'bgPitchControl', 'bgPitchTuningCall', 'bgPitchTuningWarble');


