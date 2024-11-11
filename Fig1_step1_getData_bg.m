clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultAxesTickDir','out');
set(0, 'DefaultAxesTickDirMode', 'manual');

load('bgI.mat', 'bgI');

bgResp = struct();

for b = 1:length(bgI)
    load(bgI(b).suaFile, 'sua');

    ISI = calISI(sua, bgI(b).ISIWindow);


    meanFrVocal = calAveFR(sua, bgI(b).syTimeWin);
    meanFrBaseline = calAveFR(sua, bgI(b).baselineTimeWin);
    meanFrPlayback = calAveFR(sua, bgI(b).playbackTimeWin);

    [frVocalAll, frVocal, ~] = calInstFR(sua, round(bgI(b).syTimeWin*1000));
    [frBaselineAll, frBaseline, ~] = calInstFR(sua, round(bgI(b).baselineTimeWin*1000));
    [frPlaybackAll, frPlayback, ~] = calInstFR(sua, round(bgI(b).playbackTimeWin*1000));

    nSua = size(frVocal, 1);

    burstThreshold = 200;
    percentSyllableBurst = zeros(nSua, 1);
    percentBaselineBurst = zeros(nSua, 1);
    percentPlaybackBurst = zeros(nSua, 1);

    allSyllableLength = size(frVocal,2);
    allBaselineLength = size(frBaseline, 2);
    allPlaybackLength = size(frPlayback, 2);

    for i = 1:nSua
        percentSyllableBurst(i) = sum(frVocal(i,:) > burstThreshold)/allSyllableLength;
        percentBaselineBurst(i) = sum(frBaseline(i,:) > burstThreshold)/allBaselineLength;
        percentPlaybackBurst(i) = sum(frPlayback(i,:) > burstThreshold)/allPlaybackLength;
    end

    bgResp(b).birdId = bgI(b).birdId;
    bgResp(b).meanFrVocal = meanFrVocal';
    bgResp(b).meanFrBaseline = meanFrBaseline';
    bgResp(b).meanFrPlayback = meanFrPlayback';
    bgResp(b).frVocalAll = frVocalAll;
    bgResp(b).frVocal = frVocal;
    bgResp(b).frBaselineAll = frBaselineAll;
    bgResp(b).frBaseline = frBaseline;
    bgResp(b).frPlaybackAll = frPlaybackAll;
    bgResp(b).frPlayback = frPlayback;

    bgResp(b).percentSyllableBurst = percentSyllableBurst';
    bgResp(b).percentBaselineBurst = percentBaselineBurst';
    bgResp(b).percentPlaybackBurst = percentPlaybackBurst';

    bgResp(b).ISI = ISI;
end

save('bgResp.mat', 'bgResp', 'burstThreshold');


