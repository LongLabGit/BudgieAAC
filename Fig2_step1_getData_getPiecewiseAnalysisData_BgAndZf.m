clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);
set(0, 'DefaultAxesTickDir','out');
set(0, 'DefaultAxesTickDirMode', 'manual');

load('bgI.mat', 'bgI');
load('zfI.mat', 'zfI');
load('bgFrSpec.mat', 'bgcorr', 'vocalDelay');
load('zfFrSpec.mat', 'zfcorr', 'vocalDelay');

winSize = 20;
step = 10;


zfSegNeuralSpecCorr = struct();
for i = 1:length(zfcorr)
    specs = zfcorr(i).corrSpec1;

    frs = zfcorr(i).corrFRZscored1;

    nSy = zfI(i).nSy;


    scorr = [];
    ncorr = [];
    scorrDemean = [];
    sxcorr = [];
    firstSyId = [];
    lastSyId = [];
    firstSyWinStart = [];
    lastSyWinStart = [];
    firstSyWinIdx = [];
    lastSyWinIdx = [];
    
    for m = 1:nSy-1
        for n = m+1:nSy
            m
            n
            spec1 = specs{m};
            spec2 = specs{n};
            spec1Demean = specs{m}-mean(specs{m}, 2);
            spec2Demean = specs{n}-mean(specs{n}, 2);
            fr1 = frs{m};
            fr2 = frs{n};

            winStart1 = 1:step:size(spec1,2)-(winSize-1);
            winStart2 = 1:step:size(spec2,2)-(winSize-1);

            for p = 1:length(winStart1)
                for q = 1:length(winStart2)
                    win1 = [winStart1(p), winStart1(p)+winSize-1];
                    win2 = [winStart2(q), winStart2(q)+winSize-1];

                    sp1 = spec1(:, win1(1):win1(2));
                    sp2 = spec2(:, win2(1):win2(2));
                    sp1Demean = spec1Demean(:, win1(1):win1(2));
                    sp2Demean = spec2Demean(:, win2(1):win2(2));
                    fp1 = fr1(:, win1(1):win1(2));
                    fp2 = fr2(:, win2(1):win2(2));
                    
                    scorr = [scorr, corr(sp1(:), sp2(:))];
                    scorrDemean = [scorrDemean, corr(sp1Demean(:), sp2Demean(:))];
                    sxcorr = [sxcorr, spcc(sp1, sp2)]; 
                    ncorr = [ncorr, corr(fp1(:), fp2(:))];
                    firstSyId = [firstSyId, m];
                    lastSyId = [lastSyId, n];
                    firstSyWinStart = [firstSyWinStart, win1(1)];
                    lastSyWinStart = [lastSyWinStart, win2(1)];
                    firstSyWinIdx = [firstSyWinIdx, p];
                    lastSyWinIdx = [lastSyWinIdx, q];

                end
            end
        end
    end
    zfSegNeuralSpecCorr(i).scorr = scorr;
    zfSegNeuralSpecCorr(i).scorrDemean = scorrDemean;
    zfSegNeuralSpecCorr(i).sxcorr = sxcorr;
    zfSegNeuralSpecCorr(i).ncorr = ncorr;
    zfSegNeuralSpecCorr(i).firstSyId = firstSyId;
    zfSegNeuralSpecCorr(i).lastSyId = lastSyId;
    zfSegNeuralSpecCorr(i).firstSyWinStart = firstSyWinStart;
    zfSegNeuralSpecCorr(i).lastSyWinStart = lastSyWinStart;
    zfSegNeuralSpecCorr(i).firstSyWinIdx = firstSyWinIdx;
    zfSegNeuralSpecCorr(i).lastSyWinIdx = lastSyWinIdx;
    zfSegNeuralSpecCorr(i).birdId = i*ones(1, length(scorr));
end



%%% budgie
bgSegNeuralSpecCorr = struct();
tic
for i = 1:length(bgcorr)
    sys = find(bgcorr(i).syllablesToKeep);

    specs = bgcorr(i).corrSpec(sys);
   
    frs = bgcorr(i).corrFRZscored(sys);

    nSy = length(specs);

    scorr = [];
    scorrDemean = [];
    sxcorr = [];
    ncorr = [];
    firstSyId = [];
    lastSyId = [];
    firstSyWinStart = [];
    lastSyWinStart = [];
    firstSyWinIdx = [];
    lastSyWinIdx = [];

    for m = 1:nSy-1
        for n = m+1:nSy
            m
            n
            spec1 = specs{m};
            spec2 = specs{n};
            spec1Demean = specs{m}-mean(specs{m}, 2);
            spec2Demean = specs{n}-mean(specs{n}, 2);
            fr1 = frs{m};
            fr2 = frs{n};

            winStart1 = 1:step:size(spec1,2)-(winSize-1);
            winStart2 = 1:step:size(spec2,2)-(winSize-1);

            for p = 1:length(winStart1)
                for q = 1:length(winStart2)
                    win1 = [winStart1(p), winStart1(p)+winSize-1];
                    win2 = [winStart2(q), winStart2(q)+winSize-1];

                    sp1 = spec1(:, win1(1):win1(2));
                    sp2 = spec2(:, win2(1):win2(2));
                    sp1Demean = spec1Demean(:, win1(1):win1(2));
                    sp2Demean = spec2Demean(:, win2(1):win2(2));
                    fp1 = fr1(:, win1(1):win1(2));
                    fp2 = fr2(:, win2(1):win2(2));

                    scorr = [scorr, corr(sp1(:), sp2(:))];
                    scorrDemean = [scorrDemean, corr(sp1Demean(:), sp2Demean(:))];
                    sxcorr = [sxcorr, spcc(sp1, sp2)];
                    ncorr = [ncorr, corr(fp1(:), fp2(:))];
                    firstSyId = [firstSyId, sys(m)];
                    lastSyId = [lastSyId, sys(n)];
                    firstSyWinStart = [firstSyWinStart, win1(1)];
                    lastSyWinStart = [lastSyWinStart, win2(1)];
                    firstSyWinIdx = [firstSyWinIdx, p];
                    lastSyWinIdx = [lastSyWinIdx, q];
                end
            end
        end
    end
    bgSegNeuralSpecCorr(i).scorr = scorr;
    bgSegNeuralSpecCorr(i).scorrDemean = scorrDemean;
    bgSegNeuralSpecCorr(i).sxcorr = sxcorr;
    bgSegNeuralSpecCorr(i).ncorr = ncorr;
    bgSegNeuralSpecCorr(i).firstSyId = firstSyId;
    bgSegNeuralSpecCorr(i).lastSyId = lastSyId;
    bgSegNeuralSpecCorr(i).firstSyWinStart = firstSyWinStart;
    bgSegNeuralSpecCorr(i).lastSyWinStart = lastSyWinStart;
    bgSegNeuralSpecCorr(i).firstSyWinIdx = firstSyWinIdx;
    bgSegNeuralSpecCorr(i).lastSyWinIdx = lastSyWinIdx;
    bgSegNeuralSpecCorr(i).birdId = i*ones(1, length(scorr));
end
toc


save('bgzfpiecewisecorr_bgAllSy.mat', 'bgSegNeuralSpecCorr', 'zfSegNeuralSpecCorr');
