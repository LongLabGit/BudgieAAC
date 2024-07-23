clear;
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesFontSize', 10);


%%% budgies
birdIds = {'Ti81', 'Li145', 'Bl122', 'Or61'};

dataDirs = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\'};

myKsDirs = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\kilosort2.5';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\kilosort2.5_ops.th10_4';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\kilosort2.5';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\kilosort2.5'};

channelMaps = {'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Ti81_ChronicLeftAAC\128_5_integrated_corrected_firstChDisconnected.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Li145_ChronicLeftAAC\128_5_integrated_corrected.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Bl122_ChronicLeftAAC\128_5_integrated_corrected.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Or61_ChronicLeftAAC\128_5_integrated_corrected.mat'};

audioFiles = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\audioCh3_HP.flac';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\audioCh3_HP.flac';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\audioCh3_HP.flac';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\audioCh3_HP.flac'};

ambientFiles = {'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\audioCh2.flac';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\audioCh1.flac';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\audioCh2_HP.flac';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\audioCh2_HP.flac'};

vocalFiles = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\syllableManualChecked_cutAt107thVocal.txt';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\syllableManualChecked.txt';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\syllableManualChecked.txt';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\syllableManualChecked.txt'};

fullVocalFiles = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\vocals_onlyFirst7Hours_AdjustedToCutAudio_new.txt';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\vocals_RecordingStable.txt';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\vocals.txt';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\vocals.txt'};

auditoryFiles = {'C:\WorkAtLongLab\Ti81_ChronicLeftAAC\Ti81_230309_111154\auditory.txt';...
    'C:\WorkAtLongLab\Li145_ChronicLeftAAC\Li145_230319_175518\auditory.txt';...
    'C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\auditory.txt';...
    'C:\WorkAtLongLab\Or61_ChronicLeftAAC\Or61_230705_172553_cut3880-5583_7610-7888\auditory.txt'};

outputDirs = {'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Ti81_ChronicLeftAAC\';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Li145_ChronicLeftAAC\';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Bl122_ChronicLeftAAC\';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Or61_ChronicLeftAAC\'};

featureFiles = {'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Ti81_ChronicLeftAAC\syllableFeatures.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Li145_ChronicLeftAAC\syllableFeatures.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Bl122_ChronicLeftAAC\syllableFeatures.mat';...
    'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Or61_ChronicLeftAAC\syllableFeatures.mat'};


%%% Set parameters for SAT
cd SAT_YinCompiled_YZTModified
load SAT_params.mat
SAT_params.FFT_size = 256;     %256 samples = 8.53ms (FFT window size)
SAT_params.FFT_step = 30;      % 30 samples = 1ms (FFT window step size)
SAT_params.pitch_method = 1;   % Use Yin for pitch estimation
save('SAT_params.mat', 'SAT_params');
cd ..
%%%
clear SAT_params

global SAT_params


for b = 1:4
    audioFile = audioFiles{b};
    vocalFile = vocalFiles{b};

    [audio, sampRate] = audioread(audioFile);

    f = fopen(fullfile(vocalFile), 'r');
    vocalLabel = fscanf(f, "%f %f %d", [3 Inf])';
    fclose(f);

    vocalTimeWin = vocalLabel(:,1:2);

    features = struct([]);
    for i = 1:length(vocalLabel)

        sampWin = round(vocalTimeWin(i,:)*sampRate);
        obj = SAT_sound(audio(sampWin(1):sampWin(2)), sampRate, 0);
        tmp = obj.features;
        tmp.sonogram = obj.sonogram;


        to_Hz=obj.sound.fs/SAT_params.FFT;
        freq_range=floor(SAT_params.FFT*SAT_params.Frequency_range/2); % with 1024 frequency range and 0.5 in SAT_params, range is 256
        F=1:to_Hz:obj.sound.fs/2;
        n_samps = length(obj.sound.wave);
        wave_smp = round(SAT_params.FFT_step/2)+1:SAT_params.FFT_step:n_samps;
        T = (wave_smp/obj.sound.fs); % sonogram pixel centers (sec)
        tmp.F = F;
        tmp.T = T;

        sonoFreqValue = F(1:256);
        lowFreqIdx = find(sonoFreqValue <= 700);                                % ratio of energy below 700hz with engery between 700-7000hz
        highFreqIdx = find((sonoFreqValue > 700) & (sonoFreqValue <7000));
        allFreqIdx = find(sonoFreqValue>300 & sonoFreqValue<7000);

        timeWin = vocalTimeWin(i,:);
        hr = harmonicRatio(audio(round(timeWin(1)*sampRate)-0.004*30000:round(timeWin(2)*sampRate)+0.004*30000), sampRate, Window=hamming(256, 'periodic'), OverlapLength=256-0.001*sampRate);
        tmp.harmRatio = hr';
        tmp.lowHighFreqEnergyRatioLog = log10(mean(tmp.sonogram(lowFreqIdx, :), 1)./mean(tmp.sonogram(highFreqIdx,:),1));
        tmp.lowHighFreqEnergyRatioLogFiltered = medfilt1(tmp.lowHighFreqEnergyRatioLog, 8, 'omitnan');

        pitch = tmp.pitch;
        tmp.validFlag = tmp.pitch>0;
        fundamentalRatioLog = nan(1, length(pitch));
        halfBW = 200;
        for k = 1:length(pitch)
            if pitch(k) > 0 && pitch(k)<7000-halfBW
                fundamentalBand = find(sonoFreqValue>pitch(k)-halfBW & sonoFreqValue<pitch(k)+halfBW & sonoFreqValue>300);
                if pitch(k) <= 4500
                    otherBand = find(sonoFreqValue>pitch(k)*1.5-halfBW & sonoFreqValue<pitch(k)*1.5+halfBW);
                else
                    otherBand = find(sonoFreqValue>pitch(k)/1.5-halfBW & sonoFreqValue<pitch(k)/1.5+halfBW);
                end
                fundamentalRatioLog(k) = log10(mean(tmp.sonogram(fundamentalBand,k)) / mean(tmp.sonogram(otherBand, k)));
            end
        end
        tmp.fundamentalRatioLog = fundamentalRatioLog;

        tmp.timeWithinSy = 1:length(tmp.pitch);
        tmp.time = round(vocalTimeWin(i,1)*1000) + tmp.timeWithinSy - 1;  % absolute time in ms

        features = [features; tmp];
    end

    x = [features(:).fundamentalRatioLog];
    minX = min(x);
    rangeX = range(x);
    xnorm = (x-minX)/rangeX;
    allWeightedHarmRatio = xnorm.*[features(:).harmRatio];

    curIdx = 1;
    for i = 1:length(features)
        curLength = length(features(i).pitch);
        features(i).weightedHarmRatio = allWeightedHarmRatio(curIdx:curIdx+curLength-1);
        features(i).weightedHarmRatioFiltered = medfilt1(features(i).weightedHarmRatio, 8, 'omitnan');
        curIdx = curIdx+curLength;

        features(i).meanWeightedHarmRatio = mean(features(i).weightedHarmRatio(features(i).validFlag));
        features(i).meanLowHighFreqEnergyRatioLog =  mean(features(i).lowHighFreqEnergyRatioLog(features(i).validFlag));
    end
    save([dataDirs{b} 'syllableFeatures.mat'], 'features');
    save([outputDirs{b} 'syllableFeatures.mat'], 'features');
end



%%% plot features with sonogram
for b = 1:4
    features = bgPitch(b).features;
    for i = 1:length(features)
        curLength = length(features(i).pitch);

        f = figure('Position', [889    49   529   936]);
        subplot(4, 1, 1)
        imagesc(1:size(features(i).sonogram, 2), sonoFreqValue, 10*log10(features(i).sonogram));
        set(gca,'ydir', 'normal');
        colormap("turbo");
        hold on;
        plot(1:curLength, features(i).pitch, 'w-', 'linewidth', 2);
        yticks(0:500:8000)

        subplot(4, 1, 2)
        imagesc(1:size(features(i).sonogram, 2), sonoFreqValue, 10*log10(features(i).sonogram));
        set(gca,'ydir', 'normal');
        colormap("turbo");
        yticks(0:500:8000)
        hold on;
        plot(1:curLength, features(i).pitch, 'w-', 'linewidth', 2);
        yyaxis right
        plot(1:curLength, features(i).weightedHarmRatio, 'b-', 'linewidth', 2);
        ylim([0,1]);
        ylabel('Weighed Harm Ratio')

        subplot(4,1,3)
        plot(1:curLength, features(i).harmRatio, 'k-');
        ylabel('Harm Ratio')
        yyaxis right
        hold on
        plot(1:curLength, features(i).lowHighFreqEnergyRatioLog, 'r-');
        plot(1:curLength, features(i).fundamentalRatioLog, 'b-');
        ylabel('Low Freq Ratio(R) & Fund Ratio(B)')
        xlim([1, curLength])

        subplot(4,1,4)
        plot(1:curLength, features(i).aperiodicity);
        ylabel('Aperiodicity')
        yyaxis right
        plot(1:curLength, features(i).entropy);
        ylabel('Entropy')
        xlim([1, curLength])

        exportgraphics(f, ['Bg_syllables\b', num2str(b), '_sy', num2str(i), '.jpg'])
        close(f);
    end
end






