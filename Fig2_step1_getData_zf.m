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
    dataDir = 'ZF\Zebra Finch RA from Margot\ZF_data\';
    audioFile = ['ZF\Zebra Finch RA from Margot\ZF_data\audioFull\audioFull_', birdId, '.wav'];
    outputDir = ['ZF\' birdId '\'];
    featureFile = ['ZF\' birdId '\alignedSyllables.mat'];
    [audio, sampRate] = audioread(audioFile);
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





