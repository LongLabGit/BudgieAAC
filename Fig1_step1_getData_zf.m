clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultAxesTickDir','out');
set(0, 'DefaultAxesTickDirMode', 'manual');

load('zfI.mat', 'zfI');

zfResp = struct();

for b = 1:length(zfI)
    b
    sua = getZfSua(zfI(b).dataFile);

    lenIntro = size(zfI(b).oldSyTimeWinCell{end}, 1);

    meanFrVocal = calAveFR(sua, zfI(b).oldSyTimeWin(1:end-lenIntro, :));  % here we calcuate the mean firing rate without the intronote
    meanFrBaseline = calAveFR(sua, zfI(b).baselineTimeWin);

    [frVocalAll, frVocal, ~] = calInstFR(sua, round(zfI(b).oldSyTimeWin(1:end-lenIntro, :)*1000));
    [frBaselineAll, frBaseline, ~] = calInstFR(sua, round(zfI(b).baselineTimeWin*1000));

    nSua = size(frVocal, 1);

    burstThreshold = 100;
    percentSyllableBurst = zeros(nSua, 1);
    percentBaselineBurst = zeros(nSua, 1);

    allSyllableLength = size(frVocal,2);
    allBaselineLength = size(frBaseline, 2);

    for i = 1:nSua
        percentSyllableBurst(i) = sum(frVocal(i,:) > burstThreshold)/allSyllableLength;
        percentBaselineBurst(i) = sum(frBaseline(i,:) > burstThreshold)/allBaselineLength;
    end
    
    zfResp(b).birdId = zfI(b).birdId;
    zfResp(b).meanFrVocal = meanFrVocal';
    zfResp(b).meanFrBaseline = meanFrBaseline';
    zfResp(b).frVocalAll = frVocalAll;
    zfResp(b).frVocal = frVocal;
    zfResp(b).frBaselineAll = frBaselineAll;
    zfResp(b).frBaseline = frBaseline;

    zfResp(b).percentSyllableBurst = percentSyllableBurst';
    zfResp(b).percentBaselineBurst = percentBaselineBurst';
end

save('zfResp.mat', 'zfResp', 'burstThreshold');


