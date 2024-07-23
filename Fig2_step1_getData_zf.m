clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultAxesTickDir','out');
set(0, 'DefaultAxesTickDirMode', 'manual');



%%% extrac data structure
birdIds = {'A413', 'B1', 'B3', 'B5', 'C29', 'C44', 'C47'};

song1Syllables = {[4479.955 4480.166; 4480.205, 4480.280; 4480.310, 4480.370];...
    [33318.418 33318.697; 33318.741 33318.795; 33318.847 33319.023; 33319.083 33319.165];...
    [40285.477, 40285.853; 40285.921, 40286.052; 40286.062, 40286.128; 40286.181, 40286.232];...
    [42614.204 42614.334; 42614.375, 42614.429; 42614.468, 42614.587; 42614.594 42614.815];...
    [52722.5 52722.597; 52722.635 52722.76; 52722.788 52722.921; 52722.964 52723.083];...
    [336.91 337.072; 337.107 337.201; 337.221 337.383];...
    [3096.321 3096.400; 3096.437 3096.693; 3096.743 3096.827; 3096.855 3097.008; 3097.055 3097.138; 3097.189 3097.387]};

song2Syllables = {[4480.473 4480.684; 4480.724 4480.800; 4480.829 4480.890];...
    [33319.201 33319.480; 33319.527 33319.581; 33319.637 33319.814; 33319.878 33319.960];...
    [40929.405, 40929.774; 40929.836, 40929.965; 40929.975, 40930.039; 40930.089, 40930.141];...
    [41227.168, 41227.299; 41227.338 41227.393; 41227.428 41227.549; 41227.555 41227.773];...
    [52472.746 52472.844; 52472.883 52473.006; 52473.034 52473.169; 52473.211 52473.334];...
    [339.793 339.961; 339.998 340.088; 340.114 340.285];...
    [3094.351 3094.425; 3094.469 3094.727; 3094.774 3094.864; 3094.887 3095.039; 3095.087 3095.169; 3095.219 3095.418]};

vocalDelay = 12;


zfcorr = struct();
for i = 1:length(birdIds)
    birdId = birdIds{i};
    dataDir = 'F:\Data Center\Intan\Neural\Zebra Finch RA from Margot\ZF_data\';
    audioFile = ['F:\Data Center\Intan\Neural\Zebra Finch RA from Margot\ZF_data\audioFull\audioFull_', birdId, '.wav'];
    outputDir = ['E:\WorkAtLongLab\YangCodeBase\BudgieEphys\ZF\' birdId '\'];
    featureFile = ['E:\WorkAtLongLab\YangCodeBase\BudgieEphys\ZF\' birdId '\alignedSyllables.mat'];
    [audio, sampRate] = audioread(audioFile);
    % load([dataDir, birdId, 'data.mat']);
    % sua = data.clusters;
    sua = getZfSua([dataDir, birdId, 'data.mat']);

    zfcorr(i).song1Syllables = song1Syllables{i};
    zfcorr(i).song2Syllables = song2Syllables{i};
    zfcorr(i).nSy = size(song1Syllables{i},1);
    zfcorr(i).song1 = [zfcorr(i).song1Syllables(1,1), zfcorr(i).song1Syllables(end,2)];
    zfcorr(i).song2 = [zfcorr(i).song2Syllables(1,1), zfcorr(i).song2Syllables(end,2)];

    [~, ~, ~, corrFR, corrFRNormed, corrFRDivNormed, corrFRZscored, winFR] = calInstFR(sua, round([zfcorr(i).song1Syllables; zfcorr(i).song2Syllables]*1000)-vocalDelay);
    [~, corrBurst] = calBurst(sua, round([zfcorr(i).song1Syllables; zfcorr(i).song2Syllables]*1000)-vocalDelay, 100);
    [corrSpec, corrSpecNormed, specThresh, specMean, specNormMean, specThreshMean] = processSpec(audio, round([zfcorr(i).song1Syllables; zfcorr(i).song2Syllables]*1000), sampRate);
    zfcorr(i).corrFR1 = corrFR(1:zfcorr(i).nSy);
    zfcorr(i).corrFRNormed1 = corrFRNormed(1:zfcorr(i).nSy);
    zfcorr(i).corrFRDivNormed1 = corrFRDivNormed(1:zfcorr(i).nSy);
    zfcorr(i).corrFRZscored1 = corrFRZscored(1:zfcorr(i).nSy);
    zfcorr(i).corrWinFR1 = winFR(1:zfcorr(i).nSy);
    zfcorr(i).corrBurst1 = corrBurst(1:zfcorr(i).nSy);

    zfcorr(i).corrSpec1 = corrSpec(1:zfcorr(i).nSy);
    zfcorr(i).corrSpecNormed1 = corrSpecNormed(1:zfcorr(i).nSy);
    zfcorr(i).corrSpecThresh1 = specThresh(1:zfcorr(i).nSy);
    zfcorr(i).corrSpecMean1 = specMean(1:zfcorr(i).nSy);
    zfcorr(i).corrSpecNormMean1 = specNormMean(1:zfcorr(i).nSy);
    zfcorr(i).corrSpecThreshMean1 = specThreshMean(1:zfcorr(i).nSy);

    
    zfcorr(i).corrFR2 = corrFR(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrFRNormed2 = corrFRNormed(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrFRDivNormed2 = corrFRDivNormed(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrFRZscored2 = corrFRZscored(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrWinFR2 = winFR(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrBurst2 = corrBurst(zfcorr(i).nSy+1:2*zfcorr(i).nSy);

    zfcorr(i).corrSpec2 = corrSpec(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrSpecNormed2 = corrSpecNormed(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrSpecThresh2 = specThresh(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrSpecMean2 = specMean(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrSpecNormMean2 = specNormMean(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
    zfcorr(i).corrSpecThreshMean2 = specThreshMean(zfcorr(i).nSy+1:2*zfcorr(i).nSy);
end

save('zfFrSpec.mat', 'zfcorr', 'vocalDelay');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END

load('zfFrSpec.mat', 'zfcorr', 'vocalDelay');


frSpecCorr = struct();
frSpecCorrSame = struct();

frSpecNormedCorr = struct();
frSpecNormedCorrSame = struct();

frNormedSpecNormedCorr = struct();
frNormedSpecNormedCorrSame = struct();

frDivNormedSpecNormedCorr = struct();
frDivNormedSpecNormedCorrSame = struct();

frZscoredSpecNormedCorr = struct();
frZscoredSpecNormedCorrSame = struct();

burstSpecNormedCorr = struct();
burstSpecNormedCorrSame = struct();

ifPlot = 0;
for i = 1:length(zfcorr)
    % % across different syllables, unnormed fr and spec
    % [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrFR1, zfcorr(i).corrSpec1, ifPlot);
    % frSpecCorr(i).ncorrs = ncorrs;
    % frSpecCorr(i).scorrs = scorrs;
    % frSpecCorr(i).selectPair = selectPair;
    % frSpecCorr(i).nscorr = nscorr;
    % 
    % % between same syllables, unnormed fr and spec
    % ncorrs = {};
    % scorrs = {};
    % nscorr = zeros(zfcorr(i).nSy,1);
    % for j = 1:zfcorr(i).nSy
    %     [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrFR1(j), zfcorr(i).corrFR2(j)], [zfcorr(i).corrSpec1(j), zfcorr(i).corrSpec2(j)], ifPlot);
    % end
    % frSpecCorrSame(i).ncorrs = ncorrs;
    % frSpecCorrSame(i).scorrs = scorrs;
    % frSpecCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    % frSpecCorrSame(i).nscorr = nscorr;


    % across different syllables, unnormed fr and normed spec
    [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrFR1, zfcorr(i).corrSpecNormed1, ifPlot);
    frSpecNormedCorr(i).ncorrs = ncorrs;
    frSpecNormedCorr(i).scorrs = scorrs;
    frSpecNormedCorr(i).selectPair = selectPair;
    frSpecNormedCorr(i).nscorr = nscorr;
    frSpecNormedCorr(i).scorrsDiagMean = cellfun(@(x) mean(diag(x)), scorrs);
    
    % between same syllables, unnormed fr and normed spec
    ncorrs = {};
    scorrs = {};
    nscorr = zeros(zfcorr(i).nSy,1);
    for j = 1:zfcorr(i).nSy
        [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrFR1(j), zfcorr(i).corrFR2(j)], [zfcorr(i).corrSpecNormed1(j), zfcorr(i).corrSpecNormed2(j)], ifPlot);
    end
    frSpecNormedCorrSame(i).ncorrs = ncorrs;
    frSpecNormedCorrSame(i).scorrs = scorrs;
    frSpecNormedCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    frSpecNormedCorrSame(i).nscorr = nscorr;
    frSpecNormedCorrSame(i).scorrsDiagMean = cellfun(@(x) mean(diag(x)), scorrs);




    % across different syllables, normed fr and normed spec
    [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrFRNormed1, zfcorr(i).corrSpecNormed1, ifPlot);
    frNormedSpecNormedCorr(i).ncorrs = ncorrs;
    frNormedSpecNormedCorr(i).scorrs = scorrs;
    frNormedSpecNormedCorr(i).selectPair = selectPair;
    frNormedSpecNormedCorr(i).nscorr = nscorr;

    % between same syllables, normed fr and normed spec
    ncorrs = {};
    scorrs = {};
    nscorr = zeros(zfcorr(i).nSy,1);
    for j = 1:zfcorr(i).nSy
        [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrFRNormed1(j), zfcorr(i).corrFRNormed2(j)], [zfcorr(i).corrSpecNormed1(j), zfcorr(i).corrSpecNormed2(j)], ifPlot);
    end
    frNormedSpecNormedCorrSame(i).ncorrs = ncorrs;
    frNormedSpecNormedCorrSame(i).scorrs = scorrs;
    frNormedSpecNormedCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    frNormedSpecNormedCorrSame(i).nscorr = nscorr;



    % across different syllables, Div Normed fr and normed spec
    [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrFRDivNormed1, zfcorr(i).corrSpecNormed1, ifPlot);
    frDivNormedSpecNormedCorr(i).ncorrs = ncorrs;
    frDivNormedSpecNormedCorr(i).scorrs = scorrs;
    frDivNormedSpecNormedCorr(i).selectPair = selectPair;
    frDivNormedSpecNormedCorr(i).nscorr = nscorr;

    % between same syllables, zscored fr and normed spec
    ncorrs = {};
    scorrs = {};
    nscorr = zeros(zfcorr(i).nSy,1);
    for j = 1:zfcorr(i).nSy
        [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrFRDivNormed1(j), zfcorr(i).corrFRDivNormed2(j)], [zfcorr(i).corrSpecNormed1(j), zfcorr(i).corrSpecNormed2(j)], ifPlot);
    end
    frDivNormedSpecNormedCorrSame(i).ncorrs = ncorrs;
    frDivNormedSpecNormedCorrSame(i).scorrs = scorrs;
    frDivNormedSpecNormedCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    frDivNormedSpecNormedCorrSame(i).nscorr = nscorr;



    % across different syllables, Zscored normed fr and normed spec
    [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrFRZscored1, zfcorr(i).corrSpecNormed1, ifPlot);
    frZscoredSpecNormedCorr(i).ncorrs = ncorrs;
    frZscoredSpecNormedCorr(i).scorrs = scorrs;
    frZscoredSpecNormedCorr(i).selectPair = selectPair;
    frZscoredSpecNormedCorr(i).nscorr = nscorr;

    % between same syllables, Div normed fr and normed spec
    ncorrs = {};
    scorrs = {};
    nscorr = zeros(zfcorr(i).nSy,1);
    for j = 1:zfcorr(i).nSy
        [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrFRZscored1(j), zfcorr(i).corrFRZscored2(j)], [zfcorr(i).corrSpecNormed1(j), zfcorr(i).corrSpecNormed2(j)], ifPlot);
    end
    frZscoredSpecNormedCorrSame(i).ncorrs = ncorrs;
    frZscoredSpecNormedCorrSame(i).scorrs = scorrs;
    frZscoredSpecNormedCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    frZscoredSpecNormedCorrSame(i).nscorr = nscorr;

    %  % across different syllables, unnormed fr and normed spec
    % [ncorrs, scorrs, selectPair, nscorr] = crossSyllableNeuralSpecCore(zfcorr(i).corrBurst1, zfcorr(i).corrSpecNormed1, ifPlot);
    % burstSpecNormedCorr(i).ncorrs = ncorrs;
    % burstSpecNormedCorr(i).scorrs = scorrs;
    % burstSpecNormedCorr(i).selectPair = selectPair;
    % burstSpecNormedCorr(i).nscorr = nscorr;
    % burstSpecNormedCorr(i).scorrsDiagMean = cellfun(@(x) mean(diag(x)), scorrs);
    % 
    % % between same syllables, unnormed fr and normed spec
    % ncorrs = {};
    % scorrs = {};
    % nscorr = zeros(zfcorr(i).nSy,1);
    % for j = 1:zfcorr(i).nSy
    %     [ncorrs(j), scorrs(j), ~, nscorr(j)] = crossSyllableNeuralSpecCore([zfcorr(i).corrBurst1(j), zfcorr(i).corrBurst2(j)], [zfcorr(i).corrSpecNormed1(j), zfcorr(i).corrSpecNormed2(j)], ifPlot);
    % end
    % burstSpecNormedCorrSame(i).ncorrs = ncorrs;
    % burstSpecNormedCorrSame(i).scorrs = scorrs;
    % burstSpecNormedCorrSame(i).selectPair = [(1:zfcorr(i).nSy)', (1:zfcorr(i).nSy)'];
    % burstSpecNormedCorrSame(i).nscorr = nscorr;
    % burstSpecNormedCorrSame(i).scorrsDiagMean = cellfun(@(x) mean(diag(x)), scorrs);
end


% across syllables
allNcorrs = [frSpecNormedCorr(:).ncorrs];
allScorrs = [frSpecNormedCorr(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);

% between same syllables
allNcorrs = [frSpecNormedCorrSame(:).ncorrs];
allScorrs = [frSpecNormedCorrSame(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);


% fr normed across syllables
allNcorrs = [frNormedSpecNormedCorr(:).ncorrs];
allScorrs = [frNormedSpecNormedCorr(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);

% fr normed between same syllables
allNcorrs = [frNormedSpecNormedCorrSame(:).ncorrs];
allScorrs = [frNormedSpecNormedCorrSame(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);


% fr Div normed across syllables
allNcorrs = [frDivNormedSpecNormedCorr(:).ncorrs];
allScorrs = [frDivNormedSpecNormedCorr(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);

% fr Div normed between same syllables
allNcorrs = [frDivNormedSpecNormedCorrSame(:).ncorrs];
allScorrs = [frDivNormedSpecNormedCorrSame(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);


% fr zscored normed across syllables
allNcorrs = [frZscoredSpecNormedCorr(:).ncorrs];
allScorrs = [frZscoredSpecNormedCorr(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);

% fr zscored normed between same syllables
allNcorrs = [frZscoredSpecNormedCorrSame(:).ncorrs];
allScorrs = [frZscoredSpecNormedCorrSame(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);




% burst across syllables
allNcorrs = [burstSpecNormedCorr(:).ncorrs];
allScorrs = [burstSpecNormedCorr(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);

% burst between same syllables
allNcorrs = [burstSpecNormedCorrSame(:).ncorrs];
allScorrs = [burstSpecNormedCorrSame(:).scorrs];
plotHighLowCorrComp(allNcorrs, allScorrs, 0);




figure; 
hold on
histogram([frSpecNormedCorr(:).scorrsDiagMean])
histogram([frSpecNormedCorrSame(:).scorrsDiagMean])
legend({'Different Syllables', 'Same Syllables'});
xlabel('Mean Diagonal Spec Corr')
title('Zebra Finch')






