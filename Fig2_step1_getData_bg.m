clear;

set(0, 'DefaultFigureColor', 'w');
set(0, 'defaultAxesFontSize', 10);


%%%%%%%% bird1
dataDir = 'Ti81_ChronicLeftAAC\';
audioFile = 'Ti81_ChronicLeftAAC\audioCh3_HP.flac';
vocalFile = 'Ti81_ChronicLeftAAC\vocals_onlyFirst7Hours_AdjustedToCutAudio_new.txt';
syllableFile = 'Ti81_ChronicLeftAAC\syllableManualChecked_cutAt107thVocal.txt';
auditoryFile = 'Ti81_ChronicLeftAAC\auditory.txt';
outputDir = 'Ti81_ChronicLeftAAC\';
featureFile = 'Ti81_ChronicLeftAAC\syllableFeatures.mat';
birdName = 'Ti81';


%%%%%%%% bird2
dataDir = 'Li145_ChronicLeftAAC\';
audioFile = 'Li145_ChronicLeftAAC\audioCh3_HP.flac';
vocalFile = 'Li145_ChronicLeftAAC\vocals_RecordingStable.txt';
syllableFile = 'Li145_ChronicLeftAAC\syllableManualChecked.txt';
auditoryFile = 'Li145_ChronicLeftAAC\auditory.txt';
outputDir = 'Li145_ChronicLeftAAC\';
featureFile = 'Li145_ChronicLeftAAC\syllableFeatures.mat';
birdName = 'Li145';


%%%%%%%% bird3
dataDir = 'Bl122_ChronicLeftAAC\';
audioFile = 'Bl122_ChronicLeftAAC\audioCh3_HP.flac';
vocalFile = 'Bl122_ChronicLeftAAC\vocals.txt';
syllableFile = 'Bl122_ChronicLeftAAC\syllableManualChecked.txt';
auditoryFile = 'Bl122_ChronicLeftAAC\auditory.txt';
outputDir = 'Bl122_ChronicLeftAAC\';
featureFile = 'Bl122_ChronicLeftAAC\syllableFeatures.mat';
birdName = 'Bl122';


%%%%%%% bird4
dataDir = 'Or61_ChronicLeftAAC\';
audioFile = 'Or61_ChronicLeftAAC\audioCh3_HP.flac';
vocalFile = 'Or61_ChronicLeftAAC\vocals.txt';
syllableFile = 'Or61_ChronicLeftAAC\syllableManualChecked.txt';
auditoryFile = 'Or61_ChronicLeftAAC\auditory.txt';
outputDir = 'Or61_ChronicLeftAAC\';
featureFile = 'Or61_ChronicLeftAAC\syllableFeatures.mat';
birdName = 'Or61';




f = fopen(fullfile(syllableFile), 'r');
syllableLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
syllableTimeWin = syllableLabel(:, 1:2);


[audio, sampRate] = audioread(audioFile);

suaFile = [dataDir, 'sua.mat'];
load(suaFile, 'sua');
vocalDelay = 12; 



%%%%%% similarity analysis

[warbleSyllabeFlag, warble] = getWarble(syllableTimeWin);

warbleSyllables = syllableTimeWin(warbleSyllabeFlag,:);
syllableLength = warbleSyllables(:,2)-warbleSyllables(:,1);
syllableToSelect = warbleSyllables(syllableLength>0.1, :);

% % if rerun the randomization process
% nRand = 50;
% thisRand = randperm(size(syllableToSelect, 1), nRand);
% randSyllable = syllableToSelect(thisRand, :);


load('Rand50Syllables_Ti81.mat', 'randSyllable', 'nRand');
callPair = [1,3];


load('Rand50Syllables_Li145.mat', 'randSyllable', 'nRand');
callPair = [287,288];

load('Rand50Syllables_Bl122.mat', 'randSyllable',  'nRand');
callPair = [4,6];

load('Rand50Syllables_Or61.mat', 'randSyllable', 'nRand');
callPair = [14,15];




corrTimeWins = round(randSyllable*1000);
[corrSpec, corrSpecNormed, corrSpecThresh, corrSpecMean, corrSpecNormMean, corrSpecThreshMean] = processSpec(audio, corrTimeWins, sampRate);
[~, ~, ~, corrFR, corrFRNormed, corrFRDivNormed, corrFRZscored, corrWinFR] = calInstFR(sua, corrTimeWins-vocalDelay);
[~, corrBurst] = calBurst(sua, corrTimeWins-vocalDelay, 200);


instWin = round(syllableTimeWin(callPair,:)*1000);  % we used the first 20 syllables for calcualting mean and std for normalization
[~, ~, ~, ~, ~, ~, instFRZ] = calInstFR(sua, instWin-vocalDelay);
[~, callBurst] = calBurst(sua, instWin-vocalDelay, 200);
callInstFr = instFRZ;


%%% Ti81
syllablesToKeep = true(nRand, 1);
syllablesToKeep([15,17,26,28,41,11,46,47,7, 22, 40, 33]) = 0;
save('Rand50Syllables_Ti81.mat', 'randSyllable', 'corrFR', 'corrFRNormed', 'corrSpecNormed',  'corrSpec', 'syllablesToKeep', 'nRand', 'corrFRDivNormed', 'corrFRZscored', 'corrBurst', 'corrWinFR', 'corrSpecThresh', 'corrSpecMean', 'corrSpecNormMean', 'corrSpecThreshMean', 'callPair', 'callInstFr', 'callBurst');


%%% Li145 
syllablesToKeep = true(nRand, 1);
save('Rand50Syllables_Li145.mat', 'randSyllable', 'corrFR', 'corrFRNormed', 'corrSpecNormed',  'corrSpec', 'syllablesToKeep', 'nRand', 'corrFRDivNormed', 'corrFRZscored', 'corrBurst', 'corrWinFR', 'corrSpecThresh', 'corrSpecMean', 'corrSpecNormMean', 'corrSpecThreshMean', 'callPair', 'callInstFr', 'callBurst');


%%% Bl122 
syllablesToKeep = true(nRand, 1);
syllablesToKeep([20,24,33,15,32,50,45]) = 0;
save('Rand50Syllables_Bl122.mat', 'randSyllable', 'corrFR', 'corrFRNormed', 'corrSpecNormed',  'corrSpec', 'syllablesToKeep', 'nRand', 'corrFRDivNormed', 'corrFRZscored', 'corrBurst', 'corrWinFR', 'corrSpecThresh', 'corrSpecMean', 'corrSpecNormMean', 'corrSpecThreshMean', 'callPair', 'callInstFr', 'callBurst');


%%% Or61 
syllablesToKeep = true(nRand, 1);
syllablesToKeep([1,26,28,36,44]) = 0;
save('Rand50Syllables_Or61.mat', 'randSyllable', 'corrFR', 'corrFRNormed', 'corrSpecNormed',  'corrSpec', 'syllablesToKeep', 'nRand', 'corrFRDivNormed', 'corrFRZscored', 'corrBurst', 'corrWinFR', 'corrSpecThresh', 'corrSpecMean', 'corrSpecNormMean', 'corrSpecThreshMean', 'callPair', 'callInstFr', 'callBurst');



figure();
for i=1:nRand
    subplot(6,9,i);
    imagesc(1:size(corrSpec{i},2), 300:5:7000, corrSpec{i});
    set(gca, 'ydir', 'normal');
    colormap(turbo);
    clim([-105, -60]);
    title(i);
end

corrSpecToKeep = corrSpec(syllablesToKeep);
figure();
for i=1:length(corrSpecToKeep)
    subplot(6,9,i);
    imagesc(1:size(corrSpecToKeep{i},2), 300:5:7000, corrSpecToKeep{i});
    set(gca, 'ydir', 'normal');
    colormap(turbo);
    clim([-105, -60]);
    title(i);
end


%%%%%%%%%%%%%%%%%% after all birds have been run
bgcorr = load('Rand50Syllables_Ti81.mat');
bgcorr(2) = load('Rand50Syllables_Li145.mat');
bgcorr(3) = load('Rand50Syllables_Bl122.mat');
bgcorr(4) = load('Rand50Syllables_Or61.mat');

save('bgFrSpec.mat', 'bgcorr', 'vocalDelay');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END

