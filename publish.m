clear;

fs = 7;

set(0,'DefaultAxesTickLabelInterpreter','tex',...    % affecting title and tick labels
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', fs, ...
    'DefaultAxesFontSizeMode', 'manual',...              % keep matlab from auto resizeing fonts
    'DefaultAxesFontName', 'Arial', ...                 % In matlab 2020a or later, use exportgraphics, which will automatically embed fonts into pdf files.
    'DefaultAxesFontWeight', 'normal', ...
    'DefaultAxesTitleFontSizeMultiplier', 1,...
    'DefaultAxesTitleFontWeight', 'normal',...
    'DefaultAxesLabelFontSizeMultiplier', 1,...         % default is 1.1
    'DefaultAxesLineWidth', 0.5, ...                    % next time use 1pt, this is good for both publication and presentation purposes
    'DefaultAxesTickDir', 'Out', ...
    'DefaultAxesTickDirMode', 'manual',...                 % has to set the tickmode as manual to make the default tickdir in effect
    'defaultAxesTickLength', [0.04, 0.04],...
    'DefaultAxesBox', 'Off', ...
    'DefaultLegendFontSize', fs,...
    'DefaultLegendFontSizeMode', 'manual',...
    'DefaultLegendInterpreter', 'tex',...
    'DefaultColorbarFontSize', fs,...
    'DefaultColorbarFontSizeMode', 'manual',...
    'DefaultLineColor', 'Black', ...
    'DefaultLineLineWidth', 0.5, ...
    'DefaultTextInterpreter', 'tex',...
    'DefaultTextFontUnits', 'Points', ...
    'DefaultTextFontSize', fs, ...
    'DefaultTextUnits', 'normalized',...
    'DefaultTextFontName', 'Arial', ...
    'DefaultFigureColor', 'w', ...
    'DefaultFigurePaperPositionMode','auto',...         % this will update the printed size as the ondisplay figure size
    'DefaultFigurePaperUnits', 'inches');

load('bgI.mat');
load('zfI.mat', 'zfI');
load('bgResp.mat');
load('zfResp.mat');
load('bgFrSpec.mat', 'bgcorr');
load('zfFrSpec.mat', 'zfcorr');
load('bgzfpiecewisecorr_bgAllSy.mat');
load('bgPitch.mat', 'bgPitch', 'bgPitchTuning', 'tuningThresh', 'bgPitchControl');


sampRate = bgI(1).sampRate;

%%%%% piezo supplimentary figure
audio1 = audioread('piezoSuppFigData\calls_ambient1.flac');
audio2 = audioread('piezoSuppFigData\calls_piezo1.flac');
audio3 = audioread('piezoSuppFigData\calls_piezo2.flac');

pubFig([21, 2.5, 2, 1]);
vigiSpec(audio1, 30000, 300:5:7e3, .54, 256, 180, [], 0);
yticks([])
xticks([0,0.1])
set(gca, 'tickDir', 'out')
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_callsAmbient.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 2, 1]);
vigiSpec(audio2, 30000, 300:5:7e3, .54, 256, 180, [], 0);
xticks([0,0.1])
yticks([]);
set(gca, 'tickDir', 'out')
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_callsPiezo1.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 2, 1]);
vigiSpec(audio3, 30000, 300:5:7e3, .54, 256, 180, [], 0);
xticks([0,0.1])
yticks([]);
set(gca, 'tickDir', 'out')
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_callsPiezo2.pdf', 'ContentType', 'vector');



audio1 = audioread('piezoSuppFigData\warble_ambient1.flac');
audio2 = audioread('piezoSuppFigData\warble_piezo1.flac');
audio3 = audioread('piezoSuppFigData\warble_piezo2.flac');

pubFig([21, 2.5, 6, 1]);
vigiSpec(audio1(1:124000), 30000, 300:5:7e3, .54, 256, 180, [], 0);
yticks([])
xticks([0,0.5])
set(gca, 'tickDir', 'out')
set(gca, 'TickLength', [0.015, 0.015])
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_warbleAmbient.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 6, 1]);
vigiSpec(audio2(1:124000), 30000, 300:5:7e3, .54, 256, 180, [], 0);
xticks([0,0.5])
yticks([]);
set(gca, 'tickDir', 'out')
set(gca, 'TickLength', [0.015, 0.015])
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_warblePiezo1.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 6, 1]);
vigiSpec(audio3(1:124000), 30000, 300:5:7e3, .54, 256, 180, [], 0);
xticks([0,0.5])
yticks([]);
set(gca, 'tickDir', 'out')
set(gca, 'TickLength', [0.015, 0.015])
box off
colormap('turbo')
exportgraphics(gcf(), 'Paper\SupFig_warblePiezo2.pdf', 'ContentType', 'vector');


%%%%%% Fig1 example sonograms for zf and bg
% human switchboard
hmAudioFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\HumanSpeechFromSwitchboard\sw02012B.wav';
hmWordFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\HumanSpeechFromSwitchboard\sw2012B-ms98-a-word.text';


[hmAudio, hmSampRate] = audioread(hmAudioFile);
exampleHmWordWins = [234.810, 234.810+0.4; 235.9017, 235.9017+0.4;  262.8375,  262.8375+0.4];
 
wordLength = 420;
unitLength = 0.0015;
height = 0.5;

pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*wordLength, height])
mySpecHm(hmAudio, exampleHmWordWins(1,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
hold on;
plot([0, 100], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*wordLength, height])
mySpecHm(hmAudio, exampleHmWordWins(2,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*wordLength, height])
mySpecHm(hmAudio, exampleHmWordWins(3,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
box off
axis off
exportgraphics(gcf, ['paper\Fig1_hmWord1.pdf'], 'ContentType','vector')


exampleHmSentenceWins = [56.465, 56.465+1.45; 57.969, 57.969+1.45; 243.033, 243.033+1.45];
sentenceLength = 1450;
pubFig([21, 2.5, 10, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*sentenceLength, height])
mySpecHm(hmAudio, exampleHmSentenceWins(1,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
hold on;
plot([0, 200], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*sentenceLength, height])
mySpecHm(hmAudio, exampleHmSentenceWins(2,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*sentenceLength, height])
mySpecHm(hmAudio, exampleHmSentenceWins(3,:), hmSampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 4000]);
box off
axis off
exportgraphics(gcf, ['paper\Fig1_hmSentences.pdf'], 'ContentType','vector')



% zf piezo
zfaudio = audioread('F:\Data Center\Intan\Neural\Zebra Finch Piezo\zf1\audioCh1_HP.flac');

exampleZfCall1Wins = [5.202975, 5.202975+0.037; 9.777, 9.777+0.037; 109.583, 109.583+0.037];
exampleZfCall2Wins = [1029.082, 1029.082+0.095; 1142.253, 1142.253+0.095; 2085.890, 2085.890+0.095];

unitLength = 0.005;
height = 0.8;

call1Length = 37;
call2Length = 95;

pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*call1Length, height])
mySpecFull(zfaudio, exampleZfCall1Wins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([0, 20], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*call1Length, height])
mySpecFull(zfaudio, exampleZfCall1Wins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*call1Length, height])
mySpecFull(zfaudio, exampleZfCall1Wins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
exportgraphics(gcf, ['paper\Fig1_zfcall1.pdf'], 'ContentType','vector')

pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*call2Length, height])
mySpecFull(zfaudio, exampleZfCall2Wins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([0, 20], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*call2Length, height])
mySpecFull(zfaudio, exampleZfCall2Wins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*call2Length, height])
mySpecFull(zfaudio, exampleZfCall2Wins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
exportgraphics(gcf, ['paper\Fig1_zfcall2.pdf'], 'ContentType','vector')



exampleZfSongWins = [8866.579, 8867.083; 8867.250, 8867.754; 8868.461, 8868.965];
songLength = 504;

pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*songLength, height])
mySpecFull(zfaudio, exampleZfSongWins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([0, 100], [1000,1000], 'k-', 'linewidth', 1)
plot([0, 20], [1000,1000], 'r-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*songLength, height])
mySpecFull(zfaudio, exampleZfSongWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*songLength, height])
mySpecFull(zfaudio, exampleZfSongWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
exportgraphics(gcf, ['paper\Fig1_zfsongs.pdf'], 'ContentType','vector')


% budgie
bgCallAudioFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Bl122_ChronicLeftAAC\Bl122_230626_092509_audioCh3.flac';
bgCallAudio = audioread(bgCallAudioFile);

exampleCall1TimeWins = [4478.707034,4478.707034+0.250; 1535.873356,1535.873356+0.250;   24216.17577, 24216.17577+0.250];
exampleCall2TimeWins = [302.785115, 302.785115+0.209; 1404.831818, 1404.831818+0.209; 13794.810736, 13794.810736+0.209];  % call example 1, 9, 34
exampleCall3TimeWins = [8958.089179, 8958.089179+0.15; 8958.408572, 8958.408572+0.15; 8964.132483, 8964.132483+0.15];   % call example 26, 27, 28

call1Length = 250;
call2Length = 209;
call3Length = 150;

unitLength = 0.003;
height = 0.6;

pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*call1Length, height])
mySpecFull(bgCallAudio, exampleCall1TimeWins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*call1Length, height])
mySpecFull(bgCallAudio, exampleCall1TimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*call1Length, height])
mySpecFull(bgCallAudio, exampleCall1TimeWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([1, 101], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off

axes('Unit', 'Inches', 'Position', [2, 5, unitLength*call2Length, height])
mySpecFull(bgCallAudio, exampleCall2TimeWins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [2, 4, unitLength*call2Length, height])
mySpecFull(bgCallAudio, exampleCall2TimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [2, 3, unitLength*call2Length, height])
mySpecFull(bgCallAudio, exampleCall2TimeWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([1, 101], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off

axes('Unit', 'Inches', 'Position', [3.5, 5, unitLength*call3Length, height])
mySpecFull(bgCallAudio, exampleCall3TimeWins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [3.5, 4, unitLength*call3Length, height])
mySpecFull(bgCallAudio, exampleCall3TimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [3.5, 3, unitLength*call3Length, height])
mySpecFull(bgCallAudio, exampleCall3TimeWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([1, 101], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
exportgraphics(gcf, ['Paper\Fig1_bgcalls.pdf'], 'ContentType','vector')


bgWarbleAudio = audioread(bgI(3).audioFile);
exampleWarbleTimeWins = [1766.860, 1766.860+.99; 1793.545, 1793.545+.99; 2096.54,  2096.54+.99];


songLength = 990;


pubFig([21, 2.5, 6, 6]);
axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*songLength, height])
mySpecFull(bgWarbleAudio, exampleWarbleTimeWins(1,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*songLength, height])
mySpecFull(bgWarbleAudio, exampleWarbleTimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*songLength, height])
mySpecFull(bgWarbleAudio, exampleWarbleTimeWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
hold on;
plot([1, 101], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
exportgraphics(gcf, ['Paper\Fig1_bgwarbles.pdf'], 'ContentType','vector')


%%%%%%% Fig 1 Tsne analyses for zf and bg and human
% human 

hmAudioFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\HumanSpeechFromSwitchboard\sw02012B.wav';
hmWordFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\HumanSpeechFromSwitchboard\sw2012B-ms98-a-word.text';



[hmAudio, hmSampRate] = audioread(hmAudioFile);
f = fopen(hmWordFile, 'r');
wordLabel = textscan(f, '%s %f %f %s','Delimiter',' ');
fclose(f);
wordIdx = [];
for i = 1:length(wordLabel{4})
    if startsWith(wordLabel{4}{i}, lettersPattern(1))
        wordIdx = [wordIdx, i];
    end
end
wordIdx = wordIdx(1:end-1); % we remove the last word because it might be very close to the end of recording and causes trouble in padding
hmVocalTimeWin = [wordLabel{2}(wordIdx), wordLabel{3}(wordIdx)];
wordList = wordLabel{4}(wordIdx);  


[hmSpec, hmSpecNormed, hmSpecThreshed] = processSpec(hmAudio, round(hmVocalTimeWin*1000), hmSampRate);
[sHmSpec, sHmSpecMat] = standardizeSpec(hmSpecThreshed, 300);
[~, hmScore, latent, tsquared, explained, mu] = pca(sHmSpecMat);
hmTsneCoords = tsne(hmScore(:,1:25),"Perplexity",30,'Verbose',1);
figure; 
scatter(hmTsneCoords(:,1), hmTsneCoords(:,2), '.')
axis equal
xlim([-50, 40])
ylim([-50, 40])
hold on
plot([-40, -20], [-35, -35], 'k-')
plot([-40, -40], [-35, -15], 'k-')



% zebra finch
zfAudioFile = 'F:\Data Center\Intan\Neural\Zebra Finch Piezo\zf1\audioCh1_HP.flac';
zfSyFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\zebraFinchPiezoSyllablesWithCalls.txt';

zfAudio = audioread(zfAudioFile);

f = fopen(zfSyFile, 'r');
vocalLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
zfVocalTimeWin = vocalLabel(:,1:2);
zfSyId = vocalLabel(:,3);

zfSyLength = zeros(size(zfVocalTimeWin, 1), 1);
for i = 1:size(zfVocalTimeWin, 1)
    zfSyLength(i) = zfVocalTimeWin(i,2) - zfVocalTimeWin(i,1);
end

% t-SNE plot
[zfSpec, zfSpecNormed, zfSpecThreshed] = processSpec(zfAudio, round(zfVocalTimeWin*1000), sampRate);
[sZfSpec, sZfSpecMat] = standardizeSpec(zfSpecThreshed, 300);
[~, zfScore, latent, tsquared, explained, mu] = pca(sZfSpecMat);
zfTsneCoords = tsne(zfScore(:,1:25),"Perplexity",30,'Verbose',1);
figure; scatter(zfTsneCoords(:,1), zfTsneCoords(:,2), '.')

% budgie
b = 3;

bgCallLabelFile = 'E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Bl122_Day2_calls.txt';
bgCallAudioFile = 'F:\Data Center\Intan\Neural\Budgie\Bl122_ChronicLeftAAC\Bl122_230626_092509\audioCh3.flac';
f = fopen(bgCallLabelFile, 'r');
bgCallLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
bgCallTimeWin = bgCallLabel(:, 1:2);
bgCallId = bgCallLabel(:,3);
bgCallLength = bgCallTimeWin(:,2)-bgCallTimeWin(:,1);

bgCallAudio = audioread(bgCallAudioFile);
[bgCallSpec, bgCallSpecNormed, bgCallSpecThreshed] = processSpec(bgCallAudio, round(bgCallTimeWin*1000), sampRate);
call1Spec = bgCallSpec(bgCallId==1);
call2Spec = bgCallSpec(bgCallId==2);
call3Spec = bgCallSpec(bgCallId==3);
bgWarbleAudio = audioread(bgI(3).audioFile);
[bgSpec, bgSpecNormed, bgSpecThreshed] = processSpec(bgWarbleAudio, round(bgI(3).syTimeWin*1000), sampRate);

% tsne
bgWarbleSpecThreshed = bgSpecThreshed(bgI(3).warbleSyFlag);   % only look at warbles 
[sBgSpec, sBgSpecMat] = standardizeSpec([bgWarbleSpecThreshed; bgCallSpecThreshed], 300);
[~, bgScore, latent, tsquared, explained, mu] = pca(sBgSpecMat);
bgTsneCoords = tsne(bgScore(:,1:25),"Perplexity",30,'Verbose',1);
bgWarbleTsneCoords = [bgTsneCoords(1:length(bgWarbleSpecThreshed), 1), bgTsneCoords(1:length(bgWarbleSpecThreshed), 2)];
bgCallTsneCoords = [bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 1), bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 2)];

figure;
scatter(bgTsneCoords(1:length(bgWarbleSpecThreshed), 1), bgTsneCoords(1:length(bgWarbleSpecThreshed), 2), '.');
hold on
scatter(bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 1), bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 2), '.');
axis equal
xlim([-50, 40])
ylim([-40, 50])

hold on;
figure
scatter(bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 1), bgTsneCoords(length(bgWarbleSpecThreshed)+1:end, 2), '.');
xlim([-50, 50])
ylim([-40, 50])
axis equal

%%% tsne plots
save('vocalTsne.mat', 'wordList', 'sortedUniqueWords', 'hmTsneCoords', 'zfTsneCoords', 'zfSyId', 'bgTsneCoords', 'bgCallTsneCoords', 'bgCallId', 'bgWarbleTsneCoords')
load('vocalTsne.mat', 'wordList', 'sortedUniqueWords', 'hmTsneCoords', 'zfTsneCoords', 'zfSyId', 'bgTsneCoords', 'bgCallTsneCoords', 'bgCallId', 'bgWarbleTsneCoords')

pubFig([21, 2.5, 2.5, 2.5]);
hold on;
plot(hmTsneCoords(:, 1), hmTsneCoords(:, 2), '.', 'color', [0.4,0.4,0.4], 'MarkerSize',5);
specWordIndicies = matches(wordList, 'invaded');
plot(hmTsneCoords(specWordIndicies,1), hmTsneCoords(specWordIndicies,2), '.', 'color', "#00FFFF", 'MarkerSize', 5);
axis equal
xlim([-50, 40])
ylim([-50, 40])
plot([-40, -20], [-35, -35], 'k-')
plot([-40, -40], [-35, -15], 'k-')
exportgraphics(gcf, ['Paper\Fig1_tsneHmWord.pdf'], 'ContentType','vector');

pubFig([21, 2.5, 2, 2]);
colorzf = slanCM("Dark2", 8);
hold on;
plot(zfTsneCoords(zfSyId==1, 1), zfTsneCoords(zfSyId==1, 2), '.', 'color', colorzf(1,:), 'markersize', 4)
plot(zfTsneCoords(zfSyId==2, 1), zfTsneCoords(zfSyId==2, 2), '.', 'color', colorzf(2,:), 'markersize', 4)
plot(zfTsneCoords(zfSyId==3, 1), zfTsneCoords(zfSyId==3, 2), '.', 'color', colorzf(3,:), 'markersize', 4)
plot(zfTsneCoords(zfSyId==4, 1), zfTsneCoords(zfSyId==4, 2), '.', 'color', colorzf(4,:), 'markersize', 4)
plot(zfTsneCoords(zfSyId==5, 1), zfTsneCoords(zfSyId==5, 2), '.', 'color', colorzf(5,:), 'markersize', 4)
plot(zfTsneCoords(zfSyId==6, 1), zfTsneCoords(zfSyId==6, 2), '.', 'color', colorzf(6,:), 'markersize', 4)
axis equal
xlim([-50, 40])
ylim([-50, 40])
plot([-40, -20], [-35, -35], 'k-')
plot([-40, -40], [-35, -15], 'k-')
exportgraphics(gcf, ['Paper\Fig1_tsneZFsyllable.pdf'], 'ContentType','vector');

pubFig([21, 2.5, 2, 2]);
plot(bgWarbleTsneCoords(:, 1), bgWarbleTsneCoords(:, 2), '.', 'color', [0.4,0.4,0.4], 'MarkerSize', 4);
hold on;
plot(bgCallTsneCoords(bgCallId==1, 1), bgCallTsneCoords(bgCallId==1, 2), '.', 'color', "#77AC30", 'markersize', 4);
plot(bgCallTsneCoords(bgCallId==2, 1), bgCallTsneCoords(bgCallId==2, 2), '.', 'color', "#4DBEEE", 'markersize', 4);
plot(bgCallTsneCoords(bgCallId==3, 1), bgCallTsneCoords(bgCallId==3, 2), '.', 'color', "#A2142F", 'markersize', 4);
axis equal
xlim([-50, 40])
ylim([-50, 40])
plot([-40, -20], [-35, -35], 'k-')
plot([-40, -40], [-35, -15], 'k-')
box off
exportgraphics(gcf, ['Paper\Fig1_tsneBgWarbleAndCall.pdf'], 'ContentType','vector');


%%%%%%%%% Fig1 neural
% zf example song and baseline response
z = 1;
zfaudio = audioread(zfI(z).audioFile);
zfsua = getZfSua(zfI(z).dataFile);


% example song
timeWin = [4479.954255, 4479.954255+0.42];
plotRaster(zfsua, zfaudio, timeWin, 30000, 0,  [], 10, 3, 0);  
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\Fig1_zfneuralsong.pdf'], 'contentType', 'vector')

% example call
exampleCallWin = [3872.701478 3872.816202];
timeWin = [4479.954255, 4479.954255+0.42];
plotRaster(zfsua, zfaudio, exampleCallWin, 30000, 0,  [], 10, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\Fig1_zfneuralcall.pdf'], 'contentType', 'vector')


% example baseline
timeWin = [zfI(z).baselineTimeWin(1)+0.45, zfI(z).baselineTimeWin(1)+0.6];
plotRaster(zfsua, zfaudio, timeWin, 30000, 0, [], 0, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\Fig1_zfbaseline.pdf'], 'contentType', 'vector')


% plot zebra finch response fr
% example fr 
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,150], [0, 150], 'k-');
plot(zfResp(z).meanFrBaseline, zfResp(z).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.15)
axis image
title('ZF1');
xticks([0, 75, 150])
yticks([0, 75, 150])
xlabel('Baseline');
ylabel('Vocal');
exportgraphics(gcf, 'Paper\Fig1_zfExampFR.pdf', 'contentType', 'vector')


% other birds
for sz = 2:7
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,150], [0, 150], 'k-');
    plot(zfResp(sz).meanFrBaseline, zfResp(sz).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.15)
    axis image
    title(['ZF' num2str(sz)]);
    xticks([0, 75, 150])
    yticks([0, 75, 150])
    xlabel('Baseline');
    ylabel('Vocal');
    exportgraphics(gcf, ['Paper\Fig1_zfExampFR' num2str(sz) '.pdf'], 'contentType', 'vector')
end

% all birds mean fr
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,150], [0, 150], 'k-');
plot([zfResp.meanFrBaseline], [zfResp.meanFrVocal], 'ko', 'markersize', 2, 'LineWidth', 0.15)
axis image
set(gca,'TickDir','out');
title('Pop. (N=7)');
xticks([0, 75, 150])
yticks([0, 75, 150])
xlabel('Baseline');
ylabel('Vocal');
exportgraphics(gcf, 'Paper\Fig1_zfAllFR.pdf', 'contentType', 'vector')


% example zf burst ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot(zfResp(z).percentBaselineBurst, zfResp(z).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
set(gca,'TickDir','out');
title('ZF1')
xticks([0 0.25 0.5])
yticks([0 0.25 0.5])
xlabel('Baseline');
ylabel('Vocal');
exportgraphics(gcf, 'Paper\Fig1_zfExampBurst.pdf', 'contentType', 'vector')

for sz = 2:7
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,1], [0, 1], 'k-');
    plot(zfResp(sz).percentBaselineBurst, zfResp(sz).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
    axis image
    xlim([0, 0.5]);
    ylim([0, 0.5]);
    set(gca,'TickDir','out');
    title(['ZF' num2str(sz)])
    xticks([0 0.25 0.5])
    yticks([0 0.25 0.5])
    xlabel('Baseline');
    ylabel('Vocal');
    exportgraphics(gcf, ['Paper\Fig1_zfExampBurst' num2str(sz) '.pdf'], 'contentType', 'vector')
end


% all bird burst time ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot([zfResp.percentBaselineBurst], [zfResp.percentSyllableBurst], 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
set(gca,'TickDir','out');
title('Pop. (N=7)');
xticks([0 0.25 0.5])
yticks([0 0.25 0.5])
xlabel('Baseline');
ylabel('Vocal');
exportgraphics(gcf, 'Paper\Fig1_zfAllBurst.pdf', 'contentType', 'vector')



%%% budgie bird 3
b = 3;

audio = audioread(bgI(3).audioFile);
load(bgI(3).suaFile, 'sua');

% example warble
timeWin = [2077.228 2078.089];
plotRaster(sua, audio, timeWin, 30000, 0, [], 20, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-95, -50]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\', 'Fig1_bgWarble.pdf'], 'contentType', 'vector');

% example call
timeWin = [91.548895 91.781406];
plotRaster(sua, audio, timeWin, 30000, 0, [], 20, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-95, -50]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\', 'Fig1_bgCall.pdf'], 'contentType', 'vector');


% example quite
timeWin = [7758.03 7758.27]

plotRaster(sua, audio, timeWin, 30000, 0, [], 0, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-95, -50]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\', 'Fig1_bgBaseline.pdf'], 'contentType', 'vector');

% example auditory
ambientAudio = audioread('C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\audioCh2_HP.flac');

timeWin = [7802.477 7802.768];
plotRaster(sua, ambientAudio, timeWin, 30000, 0, [], 20, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-105, -60]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, ['Paper\', 'Fig1_bgCallPlayback.pdf'], 'contentType', 'vector');



%%% plot budgie response fr
% use bird3 Bl122 as example bird
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot(bgResp(3).meanFrBaseline, bgResp(3).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Baseline');
ylabel('Vocal');
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgExampFR.pdf', 'contentType', 'vector')

% all other bird
for sb = [1,2,4]
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,300], [0, 300], 'k-');
    plot(bgResp(sb).meanFrBaseline, bgResp(sb).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.25)
    axis image
    xticks([0, 150, 300])
    yticks([0, 150, 300])
    xlabel('Baseline');
    ylabel('Vocal');
    title(['BG' num2str(sb)]);
    exportgraphics(gcf, ['Paper\Fig1_bgExampFROtherBird', num2str(sb), '.pdf'], 'contentType', 'vector')
end


% all birds mean fr
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot([bgResp.meanFrBaseline], [bgResp.meanFrVocal], 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Baseline');
ylabel('Vocal');
title('Pop. (N=4)');
exportgraphics(gcf, 'Paper\Fig1_bgAllFR.pdf', 'contentType', 'vector')


% bird 3 and 4 fr to playback
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot(bgResp(3).meanFrBaseline, bgResp(3).meanFrPlayback, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Baseline');
ylabel('Playback');
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgPlaybackFR3.pdf', 'contentType', 'vector')
p = ranksum(bgResp(3).meanFrBaseline, bgResp(3).meanFrPlayback)

pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot(bgResp(4).meanFrBaseline, bgResp(4).meanFrPlayback, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Baseline');
ylabel('Playback');
title('BG4');
exportgraphics(gcf, 'Paper\Fig1_bgPlaybackFR4.pdf', 'contentType', 'vector')
p = ranksum(bgResp(4).meanFrBaseline, bgResp(4).meanFrPlayback)


% bird 3 and 4 fr to playback and vocal
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot(bgResp(3).meanFrPlayback, bgResp(3).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Playback');
ylabel('Vocal');
%fontsize(gcf, 30, "points")
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgVocalPlaybackFR3.pdf', 'contentType', 'vector')
p = ranksum(bgResp(3).meanFrVocal, bgResp(3).meanFrPlayback)

pubFig([21, 2.5, 1 1]);
hold on;
plot([0,300], [0, 300], 'k-');
plot(bgResp(4).meanFrPlayback, bgResp(4).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xticks([0, 150, 300])
yticks([0, 150, 300])
xlabel('Playback');
ylabel('Vocal');
title('BG4');
exportgraphics(gcf, 'Paper\Fig1_bgVocalPlaybackFR4.pdf', 'contentType', 'vector')
p = ranksum(bgResp(4).meanFrVocal, bgResp(4).meanFrPlayback)



% bird 3 burst time ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot(bgResp(3).percentBaselineBurst, bgResp(3).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
xticks([0, 0.25, 0.5])
yticks([0, 0.25, 0.5])
xlabel('Baseline');
ylabel('Vocal');
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgExampBurst.pdf', 'contentType', 'vector')


for sb = [1,2,4]
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,1], [0, 1], 'k-');
    plot(bgResp(sb).percentBaselineBurst, bgResp(sb).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
    axis image
    xlim([0, 0.5]);
    ylim([0, 0.5]);
    xticks([0, 0.25, 0.5])
    yticks([0, 0.25, 0.5])
    xlabel('Baseline');
    ylabel('Vocal');
    title(['BG', num2str(sb)]);
    exportgraphics(gcf, ['Paper\Fig1_bgExampBurstOtherBird' num2str(sb) '.pdf'], 'contentType', 'vector')
end


% all bird burst time ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot([bgResp.percentBaselineBurst], [bgResp.percentSyllableBurst], 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
xticks([0, 0.25, 0.5])
yticks([0, 0.25, 0.5])
xlabel('Baseline');
ylabel('Vocal');
title('Pop. (N=4)');
exportgraphics(gcf, 'Paper\Fig1_bgAllBurst.pdf', 'contentType', 'vector')


% fig1 quantification for zebra finches and budgies
mean([zfResp(:).meanFrVocal])
std([zfResp(:).meanFrVocal])
mean([zfResp(:).meanFrBaseline])
std([zfResp(:).meanFrBaseline])
p = ranksum([zfResp(:).meanFrVocal], [zfResp(:).meanFrBaseline])



mean([zfResp(:).percentSyllableBurst])
std([zfResp(:).percentSyllableBurst])
mean([zfResp(:).percentBaselineBurst])
std([zfResp(:).percentBaselineBurst])
p = ranksum([zfResp(:).percentSyllableBurst], [zfResp(:).percentBaselineBurst])


mean([bgResp(:).meanFrVocal])
std([bgResp(:).meanFrVocal])
mean([bgResp(:).meanFrBaseline])
std([bgResp(:).meanFrBaseline])
p = ranksum([bgResp(:).meanFrVocal], [bgResp(:).meanFrBaseline])


mean([bgResp(:).percentSyllableBurst])
std([bgResp(:).percentSyllableBurst])
mean([bgResp(:).percentBaselineBurst])
std([bgResp(:).percentBaselineBurst])
p = ranksum([bgResp(:).percentSyllableBurst], [bgResp(:).percentBaselineBurst])


%%%%%% budgie ISI
isiPooled = [];
for i = 1:length(bgResp)
    pubFig([21,0, 3, 1.4])
    edges = [0:1:50];
    y = histcounts(cell2mat(bgResp(i).ISI)*1000, edges);
    isiPooled = [isiPooled; y/sum(y)];
    plot(edges(1:end-1)+1/2, y, 'k-');
    box off;
    xticks(0:5:50);
    title(['BG', num2str(i)])
    xlabel('Inter spike interval (ms)')
    ylabel('Count')
    exportgraphics(gcf, ['Paper\Fig1_ISIBG' num2str(i) '.pdf'], 'contentType', 'vector');
end

pubFig([21,0, 3, 1.4]);
plot(edges(1:end-1)+1/2, mean(isiPooled, 1), 'k-');
box off;
xticks(0:5:50);
xlabel('Inter spike interval (ms)')
ylabel('Freq.')
exportgraphics(gcf, ['Paper\Fig1_ISIBGAll.pdf'], 'contentType', 'vector');



%%%%%%%%%%%%%%%%%% Fig 2 

%%%%% same syllables
%%%%%%  zf same syllable 
z = 1;   %zfBirdIds(cIdx);

zfAudio = audioread(zfI(z).audioFile);
zfSua = getZfSua(zfI(z).dataFile);

%%% zf same syllables
% zfNewOrder = randperm(length(zfSua));
% save('Fig1And2_zfbgNewOrder.mat', 'zfNewOrder');
% zfNewOrder = 1:length(zfSua); % or we can load zfNewOrder form file
load('Fig1And2_zfbgNewOrder.mat', 'zfNewOrder');

i = 1;
instFr = zfcorr(z).corrFRZscored1{i};
plotInstFR(zfSua, zfAudio, zfI(z).song1Syllables(i,:), sampRate, instFr(zfNewOrder,:), 0, 0, 0, 3, 12)
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
hold on;
plot([zfI(z).song1Syllables(i,1), zfI(z).song1Syllables(i,1)+0.1], [1000, 1000])
axis off
axes(ax(1));
xlabel([]);
colormap(ax(1), 'gray')
clim([-1, 4]);
ax(1).XAxis.Visible = 'off';
drawnow();
exportgraphics(gcf, ['paper\Fig2_zfSameSyInstFR1', '.pdf'], 'ContentType', 'vector')


instFr = zfcorr(z).corrFRZscored2{i};
plotInstFR(zfSua, zfAudio, zfI(z).song2Syllables(i,:), sampRate, instFr(zfNewOrder,:), 0, 0, 0, 3, 12)
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
hold on;
plot([zfI(z).song2Syllables(i,1), zfI(z).song2Syllables(i,1)+0.1], [1000, 1000])
axis off
axes(ax(1));
xlabel([]);
colormap(ax(1), 'gray')
clim([-1, 4]);
ax(1).XAxis.Visible = 'off';
drawnow();
exportgraphics(gcf, ['paper\Fig2_zfSameSyInstFR2', '.pdf'], 'ContentType', 'vector')


%%% example zf multiple trials
shankIds = [zfSua.shank];
leftUnits = ismember(shankIds, zfI(z).leftShank);
rightUnits = ismember(shankIds, zfI(z).rightShank);

zfTrialExample = zfI(z).oldSyTimeWinCell{1};
zfTrialExample = zfTrialExample([3,1,2,4:7], :);

unitsToPlot = [5,11,15,19,27,31,32];  % good example units in original order
unitsToPlotIDNewOrder = arrayfun(@(x) find(zfNewOrder==x), unitsToPlot);
[unitsToPlotIDNewOrderSorted, sortOrder] = sort(unitsToPlotIDNewOrder);

f = plotRasterMultipleTrials(zfSua(zfNewOrder), unitsToPlotIDNewOrderSorted, zfAudio, zfTrialExample, 1, zfTrialExample, 30000, 0, 0, [], 10, 3, 12);
ax = findall(f, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
axes(ax(1))
axis off
exportgraphics(f, ['Paper\Fig2_zfSameSyRasterMultiTrial.pdf'], 'contentType', 'vector')


%%%% budgie same syllable
b = 3;

audio = audioread(bgI(b).audioFile);
load(bgI(b).suaFile, 'sua');

load('Fig1And2_zfbgNewOrder.mat', 'bgNewOrder');

%%% budgie same syllable
f = fopen(fullfile('C:\WorkAtLongLab\Bl122_ChronicLeftAAC\Bl122_230625_092844_cut0-16200\exampleResp.txt'), 'r');
exampleLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
exampleRespWin = exampleLabel(exampleLabel(:,3)==1,1:2);   % example call resp
scaleWin1 = exampleLabel(exampleLabel(:,3)==2,1:2);
lengthExampleWin = exampleRespWin(:,2)-exampleRespWin(:,1);
[~, sortOrder] = sort(lengthExampleWin);

instWin = round(exampleRespWin*1000);
[~, ~, ~, ~, ~, ~, instFRZ, ~] = calInstFR(sua, instWin-12);

i = 1;
instFr = instFRZ{i};
plotInstFR(sua, audio, exampleRespWin(i,:), sampRate, instFr(bgNewOrder,:), 0, 0, 0, 3, 12)
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-105, -50]);
axes(ax(2));
hold on
plot([exampleRespWin(i,1), exampleRespWin(i,1)+0.1], [1000 1000])
axis off
axes(ax(1));
yticks([1, length(sua)])
xlabel([]);
clim([-1, 4]);
ax(1).XAxis.Visible = 'off';
drawnow();
exportgraphics(gcf, ['paper\Fig2_bgSameSyInstFR1' '.pdf'], 'ContentType', 'vector')

i = 2;
instFr = instFRZ{i};
plotInstFR(sua, audio, exampleRespWin(i,:), sampRate, instFr(bgNewOrder,:), 0, 0, 0, 3, 12)
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-105, -50]);
axes(ax(2));
hold on
plot([exampleRespWin(i,1), exampleRespWin(i,1)+0.1], [1000 1000])
axis off
axes(ax(1));
yticks([1, length(sua)])
xlabel([]);
clim([-1, 4]);
ax(1).XAxis.Visible = 'off';
drawnow();
exportgraphics(gcf, ['paper\Fig2_bgSameSyInstFR2' '.pdf'], 'ContentType', 'vector')

% plot multiple trials
unitsToPlot = [10, 12, 36, 33, 11, 37, 3];
unitsToPlotIDNewOrder = arrayfun(@(x) find(bgNewOrder==x), unitsToPlot);
[unitsToPlotIDNewOrderSorted, uSortOrder] = sort(unitsToPlotIDNewOrder);

f = plotRasterMultipleTrials(sua(bgNewOrder), unitsToPlotIDNewOrderSorted, audio, exampleRespWin(sortOrder,:), 1, scaleWin1(sortOrder,:), 30000, 0, 0, [], 20, 3, 12);

ax = findall(f, 'type', 'axes');
clim(ax(2), [-95, -50]);
axes(ax(2));
axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 1)
%axis off
exportgraphics(gcf, ['Paper\Fig2_bgSameSyRasterMultiTrial.pdf'], 'contentType', 'vector')



%%%%% Zebra finch different syllables
zfIdx = find([zfSegNeuralSpecCorr(:).scorr]>=0.6);
zfBirdIds = [zfSegNeuralSpecCorr(:).birdId];
zfScorrs = [zfSegNeuralSpecCorr(:).scorr];
zfNcorrs = [zfSegNeuralSpecCorr(:).ncorr];
zfFirstSyIds = [zfSegNeuralSpecCorr(:).firstSyId];
zfLastSyIds = [zfSegNeuralSpecCorr(:).lastSyId];
zfFirstSyWinStarts = [zfSegNeuralSpecCorr(:).firstSyWinStart];
zfLastSyWinStarts = [zfSegNeuralSpecCorr(:).lastSyWinStart];
zfFirstSyWinIdx = [zfSegNeuralSpecCorr(:).firstSyWinIdx];
zfLastSyWinIdx = [zfSegNeuralSpecCorr(:).lastSyWinIdx];

goodExamples = [62];
examPair = 62;   % the high spec corr example pair
cIdx = zfIdx(examPair);

z = 7;   %zfBirdIds(cIdx);

zfAudio = audioread(zfI(z).audioFile);
zfSua = getZfSua(zfI(z).dataFile);

zfFirstSy = 5; %zfFirstSyIds(cIdx);  
zfLastSy = 6;  %zfLastSyIds(cIdx);
zfSeg1 = 6; %zfFirstSyWinIdx(cIdx);
zfSeg2 = 17; %zfLastSyWinIdx(cIdx);
zfSeg3 = 4; % from the second syllable
zfSegs = [zfSeg1, zfSeg2, zfSeg3];
zfSys = [zfFirstSy, zfLastSy, zfLastSy];


for i = [zfFirstSy, zfLastSy]
    instFr = zfcorr(z).corrFRZscored1{i};
    plotInstFR(zfSua, zfAudio, zfI(z).song1Syllables(i,:), sampRate, instFr, 0, 0, 0, 3, 12)
    ax = findall(gcf, 'type', 'axes');
    clim(ax(2), [-110, -50]);
    axes(ax(2));
    hold on;
    plot([zfI(z).song1Syllables(i,1), zfI(z).song1Syllables(i,1)+0.05], [1000, 1000])
    
    segIdx = find(zfSys == i);
    for k = 1:length(segIdx)
        seg = zfSegs(segIdx(k));
        segStart = zfI(z).song1Syllables(i,1)+(seg-1)*10/1000;
        plot([segStart, segStart+0.02], [2000, 2000]);
    end
   
    axis off
    axes(ax(1));
    xlabel([]);
    colormap(ax(1), 'gray')
    clim([-1, 4]);
    ax(1).XAxis.Visible = 'off';
    drawnow();
    exportgraphics(gcf, ['paper\Fig2_zfSyllableInstFR', num2str(i), '.pdf'], 'ContentType', 'vector')
end

zfSegNeuralSpecCorr(7).scorr(find(zfSegNeuralSpecCorr(7).firstSyId==5 & zfSegNeuralSpecCorr(7).lastSyId==6  & zfSegNeuralSpecCorr(7).firstSyWinIdx==6 & zfSegNeuralSpecCorr(7).lastSyWinIdx==17))
zfSegNeuralSpecCorr(7).ncorr(find(zfSegNeuralSpecCorr(7).firstSyId==5 & zfSegNeuralSpecCorr(7).lastSyId==6  & zfSegNeuralSpecCorr(7).firstSyWinIdx==6 & zfSegNeuralSpecCorr(7).lastSyWinIdx==17))

zfSegNeuralSpecCorr(7).scorr(find(zfSegNeuralSpecCorr(7).firstSyId==5 & zfSegNeuralSpecCorr(7).lastSyId==6  & zfSegNeuralSpecCorr(7).firstSyWinIdx==6 & zfSegNeuralSpecCorr(7).lastSyWinIdx==4))
zfSegNeuralSpecCorr(7).ncorr(find(zfSegNeuralSpecCorr(7).firstSyId==5 & zfSegNeuralSpecCorr(7).lastSyId==6  & zfSegNeuralSpecCorr(7).firstSyWinIdx==6 & zfSegNeuralSpecCorr(7).lastSyWinIdx==4))



for i = 1:3
    segStart = zfI(z).song1Syllables(zfSys(i),1)+(zfSegs(i)-1)*10/1000;

    instFr = zfcorr(z).corrFRZscored1{zfSys(i)}(:, (zfSegs(i)-1)*10+1 : (zfSegs(i)-1)*10+20);
    plotInstFR(zfSua, zfAudio, [segStart, segStart+0.02], sampRate, instFr, 0, 0, 0, 3, 12)
    ax = findall(gcf, 'type', 'axes');
    clim(ax(2), [-110, -50]);
    axes(ax(2));
    axis off
    axes(ax(1));
    xlabel([]);
    clim([-1, 4]);
    ax(1).XAxis.Visible = 'off';
    drawnow();
    exportgraphics(gcf, ['paper\Fig2_zfExampleInstFR_Seg', num2str(i), '.pdf'], 'ContentType', 'vector')
end

% plot similarity matrices
syPairIdx = find((zfSegNeuralSpecCorr(z).firstSyId==zfFirstSy) & (zfSegNeuralSpecCorr(z).lastSyId==zfLastSy));
zfP = zfSegNeuralSpecCorr(z).firstSyWinIdx(syPairIdx);
zfQ = zfSegNeuralSpecCorr(z).lastSyWinIdx(syPairIdx);
zfPairScorrs = flipud(reshape(zfSegNeuralSpecCorr(z).scorr(syPairIdx), [zfQ(end), zfP(end)]));
zfPairNcorrs = flipud(reshape(zfSegNeuralSpecCorr(z).ncorr(syPairIdx), [zfQ(end), zfP(end)]));

cax = plotCorrMatrixWithSpec(fliplr(rot90(zfPairScorrs)), zfcorr(z).corrSpec1([zfLastSy, zfFirstSy]), [-110, -50]);
clim(cax, [-.1, .8]);
exportgraphics(gcf, ['paper\Fig2_zfScorr', '.pdf'], 'ContentType', 'vector')

cax = plotCorrMatrixWithSpec(fliplr(rot90(zfPairNcorrs)), zfcorr(z).corrFRZscored1([zfLastSy, zfFirstSy]), [-1, 4], 0);
clim(cax, [-.2, .6]);
exportgraphics(gcf, ['paper\Fig2_zfNcorr', '.pdf'], 'ContentType', 'vector')


%%%%%% budgies
bgIdx = find([bgSegNeuralSpecCorr(:).scorr]>=0.6 & [bgSegNeuralSpecCorr(:).ncorr]>=0.4);
bgBirdIds = [bgSegNeuralSpecCorr(:).birdId];
bgScorrs = [bgSegNeuralSpecCorr(:).scorr];
bgNcorrs = [bgSegNeuralSpecCorr(:).ncorr];
bgFirstSyIds = [bgSegNeuralSpecCorr(:).firstSyId];
bgLastSyIds = [bgSegNeuralSpecCorr(:).lastSyId];
bgFirstSyWinStarts = [bgSegNeuralSpecCorr(:).firstSyWinStart];
bgLastSyWinStarts = [bgSegNeuralSpecCorr(:).lastSyWinStart];
bgFirstSyWinIdx = [bgSegNeuralSpecCorr(:).firstSyWinIdx];
bgLastSyWinIdx = [bgSegNeuralSpecCorr(:).lastSyWinIdx];

examPair = 25;
cIdx = bgIdx(examPair);
b = 1; %bgBirdIds(cIdx);

audio = audioread(bgI(b).audioFile);
load(bgI(b).suaFile, 'sua');

firstSy = 2; %bgFirstSyIds(cIdx);
lastSy = 23;  %bgLastSyIds(cIdx);
bgSeg1 = 21; %bgFirstSyWinIdx(cIdx)
bgSeg2 = 4; %bgLastSyWinIdx(cIdx)
bgSeg3 = 10; % from the second syllable
bgSegs = [bgSeg1, bgSeg2, bgSeg3];
bgSys = [firstSy, lastSy, firstSy];


for i = [firstSy, lastSy]
    instFr = bgcorr(b).corrFRZscored{i};
    plotInstFR(sua, audio, bgcorr(b).randSyllable(i,:), sampRate, instFr, 0, 0, 0, 3, 12)
    ax = findall(gcf, 'type', 'axes');
    clim(ax(2), [-105, -50]);
    axes(ax(2));
    hold on
    plot([bgcorr(b).randSyllable(i,1), bgcorr(b).randSyllable(i,1)+0.05], [1000 1000])

    segIdx = find(bgSys == i);
    for k = 1:length(segIdx)
        seg = bgSegs(segIdx(k));
        segStart = bgcorr(b).randSyllable(i,1)+(seg-1)*10/1000;
        plot([segStart, segStart+0.02], [2000, 2000]);
    end

    axis off
    axes(ax(1));
    yticks([1, length(sua)])
    xlabel([]);
    %clim
    clim([-1, 4]);
    ax(1).XAxis.Visible = 'off';
    drawnow();
    exportgraphics(gcf, ['paper\Fig2_bgExampleInstFR', num2str(i), '.pdf'], 'ContentType', 'vector')
end


for i = 1:3
    segStart = bgcorr(b).randSyllable(bgSys(i),1)+(bgSegs(i)-1)*10/1000;
    instFr = bgcorr(b).corrFRZscored{bgSys(i)}(:, (bgSegs(i)-1)*10+1 : (bgSegs(i)-1)*10+20);
    plotInstFR(sua, audio, [segStart, segStart+0.02], sampRate, instFr, 0, 0, 0, 3, 12)
    ax = findall(gcf, 'type', 'axes');
    clim(ax(2), [-105, -50]);
    axes(ax(2));
    axis off
    axes(ax(1));
    yticks([1, length(sua)])
    xlabel([]);
    clim([-1, 4]);
    ax(1).XAxis.Visible = 'off';
    drawnow();
    exportgraphics(gcf, ['paper\Fig2_bgExampleInstFR_Seg', num2str(i), '.pdf'], 'ContentType', 'vector')
end

bgSegNeuralSpecCorr(1).scorr(find(bgSegNeuralSpecCorr(1).firstSyId==2 & bgSegNeuralSpecCorr(1).lastSyId==23  & bgSegNeuralSpecCorr(1).firstSyWinIdx==21 & bgSegNeuralSpecCorr(1).lastSyWinIdx==4))
bgSegNeuralSpecCorr(1).ncorr(find(bgSegNeuralSpecCorr(1).firstSyId==2 & bgSegNeuralSpecCorr(1).lastSyId==23  & bgSegNeuralSpecCorr(1).firstSyWinIdx==21 & bgSegNeuralSpecCorr(1).lastSyWinIdx==4))

bgSegNeuralSpecCorr(1).scorr(find(bgSegNeuralSpecCorr(1).firstSyId==2 & bgSegNeuralSpecCorr(1).lastSyId==23  & bgSegNeuralSpecCorr(1).firstSyWinIdx==10 & bgSegNeuralSpecCorr(1).lastSyWinIdx==4))
bgSegNeuralSpecCorr(1).ncorr(find(bgSegNeuralSpecCorr(1).firstSyId==2 & bgSegNeuralSpecCorr(1).lastSyId==23  & bgSegNeuralSpecCorr(1).firstSyWinIdx==10 & bgSegNeuralSpecCorr(1).lastSyWinIdx==4))



% plot similarity matrices
syPairIdx = find((bgSegNeuralSpecCorr(b).firstSyId==firstSy) & (bgSegNeuralSpecCorr(b).lastSyId==lastSy));
bgP = bgSegNeuralSpecCorr(b).firstSyWinIdx(syPairIdx);
bgQ = bgSegNeuralSpecCorr(b).lastSyWinIdx(syPairIdx);
bgPairScorrs = flipud(reshape(bgSegNeuralSpecCorr(b).scorr(syPairIdx), [bgQ(end), bgP(end)]));
bgPairNcorrs = flipud(reshape(bgSegNeuralSpecCorr(b).ncorr(syPairIdx), [bgQ(end), bgP(end)]));

cax = plotCorrMatrixWithSpec(bgPairScorrs, bgcorr(b).corrSpec([firstSy, lastSy]), [-105, -50]);
clim(cax, [-.1, .8]);
exportgraphics(gcf, ['paper\Fig2_bgScorr', '.pdf'], 'ContentType', 'vector')

cax = plotCorrMatrixWithSpec(bgPairNcorrs, bgcorr(b).corrFRZscored([firstSy, lastSy]), [-1, 4], 0);
clim(cax, [-.2, .6]);
exportgraphics(gcf, ['paper\Fig2_bgNcorr', '.pdf'], 'ContentType', 'vector')


%%%% correlation plots for zebra finch and budgies
figure;
plot(zfSegNeuralSpecCorr(z).scorr, zfSegNeuralSpecCorr(z).ncorr, '.');
title(['ZF', num2str(z), ' , corr:', num2str(corr(zfSegNeuralSpecCorr(z).scorr', zfSegNeuralSpecCorr(z).ncorr'))])

 

corrEdges = -1:0.01:1;
pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap(zfSegNeuralSpecCorr(z).scorr, zfSegNeuralSpecCorr(z).ncorr, corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural Corr')
xlabel('Spec Corr')
title(['ZF', num2str(z), ' , \rho:', num2str(corr(zfSegNeuralSpecCorr(z).scorr', zfSegNeuralSpecCorr(z).ncorr','type', 'spearman'))])
[r, p] = corr(zfSegNeuralSpecCorr(z).scorr', zfSegNeuralSpecCorr(z).ncorr','type', 'spearman')
xlim([-0.4, 0.8])
ylim([-0.2 0.35])
daspect([1.8,1,1])
box off
xticks([-0.4:0.4:0.8])
xtickangle(0)
yticks([-0.2:0.1:0.3])
exportgraphics(gcf, ['Paper\Fig2_zfCorrZF' num2str(z) '.pdf'], 'ContentType', 'vector');

% other birds
for sz = 1:6
    pubFig([21, 2.5, 1.5, 1.5]);
    N = plotHeatmap(zfSegNeuralSpecCorr(sz).scorr, zfSegNeuralSpecCorr(sz).ncorr, corrEdges, corrEdges, 0, 0);
    imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
    colormap('turbo')
    set(gca,'ydir','normal');
    cb = colorbar;
    cb.Ticks = clim;
    ylabel('Neural Corr')
    xlabel('Spec Corr')
    title(['ZF', num2str(sz), ' , \rho:', num2str(corr(zfSegNeuralSpecCorr(sz).scorr', zfSegNeuralSpecCorr(sz).ncorr','type', 'spearman'))])
    [r, p] = corr(zfSegNeuralSpecCorr(sz).scorr', zfSegNeuralSpecCorr(sz).ncorr','type', 'spearman')
    xlim([-0.4, 0.8])
    ylim([-0.2 0.35])
    daspect([1.8,1,1])
    box off
    xticks([-0.4:0.4:0.8])
    xtickangle(0)
    yticks([-0.2:0.1:0.3])
    exportgraphics(gcf, ['Paper\Fig2_zfCorrZF' num2str(sz) '.pdf'], 'ContentType', 'vector');
end


pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap([zfSegNeuralSpecCorr(:).scorr], [zfSegNeuralSpecCorr(:).ncorr], corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural Corr')
xlabel('Spec Corr')
title(['ZF All, \rho::', num2str(corr([zfSegNeuralSpecCorr(:).scorr]', [zfSegNeuralSpecCorr(:).ncorr]','type', 'spearman'))])
[r, p] = corr([zfSegNeuralSpecCorr(:).scorr]', [zfSegNeuralSpecCorr(:).ncorr]','type', 'spearman')
xlim([-0.4, 0.8])
ylim([-0.2 0.35])
daspect([1.8,1,1])
box off
xticks([-0.4:0.4:0.8])
xtickangle(0)
yticks([-0.2:0.1:0.3])
exportgraphics(gcf, 'Paper\Fig2_zfCorrAll.pdf', 'ContentType', 'vector');



figure;
plot(bgSegNeuralSpecCorr(b).scorr, bgSegNeuralSpecCorr(b).ncorr, '.');
title(['bg', num2str(b), ' , corr:', num2str(corr(bgSegNeuralSpecCorr(b).scorr', bgSegNeuralSpecCorr(b).ncorr'))])

figure;
plot([bgSegNeuralSpecCorr(:).scorr], [bgSegNeuralSpecCorr(:).ncorr], '.');
title(['Bg All, corr:', num2str(corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]'))])

[r, p] = corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]', 'type', 'spearman')


corrEdges = -1:0.01:1;
pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap(bgSegNeuralSpecCorr(b).scorr, bgSegNeuralSpecCorr(b).ncorr, corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural Corr')
xlabel('Spec Corr')
title(['BG', num2str(b), ' , \rho:', num2str(corr(bgSegNeuralSpecCorr(b).scorr', bgSegNeuralSpecCorr(b).ncorr','type', 'spearman'))])
[r, p] = corr(bgSegNeuralSpecCorr(b).scorr', bgSegNeuralSpecCorr(b).ncorr','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, ['Paper\Fig2_bgCorrBG', num2str(b), '.pdf'], 'ContentType', 'vector');

for sb = 2:4
    corrEdges = -1:0.01:1;
    pubFig([21, 2.5, 1.5, 1.5]);
    N = plotHeatmap(bgSegNeuralSpecCorr(sb).scorr, bgSegNeuralSpecCorr(sb).ncorr, corrEdges, corrEdges, 0, 0);
    imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
    colormap('turbo')
    set(gca,'ydir','normal');
    cb = colorbar;
    cb.Ticks = clim;
    ylabel('Neural Corr')
    xlabel('Spec Corr')
    title(['BG', num2str(sb), ' , \rho:', num2str(corr(bgSegNeuralSpecCorr(sb).scorr', bgSegNeuralSpecCorr(sb).ncorr','type', 'spearman'))])
    [r, p] = corr(bgSegNeuralSpecCorr(sb).scorr', bgSegNeuralSpecCorr(sb).ncorr','type', 'spearman')
    xlim([-0.69, 0.88])
    ylim([-0.38 0.8])
    daspect([1.4,1,1])
    box off
    xticks([-0.6:0.3:1])
    xtickangle(0)
    yticks([-0.3:0.3:0.9])
    exportgraphics(gcf, ['Paper\Fig2_bgCorrBG', num2str(sb), '.pdf'], 'ContentType', 'vector');
end


pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap([bgSegNeuralSpecCorr(:).scorr], [bgSegNeuralSpecCorr(:).ncorr], corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural Corr')
xlabel('Spec Corr')
title(['Bg All, \rho:', num2str(corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]','type', 'spearman'))])
[r, p] = corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, 'Paper\Fig2_bgCorrBGAll.pdf', 'ContentType', 'vector');


%%%%%%%%%%%%%%%%%% Fig 3
%%% plot example songs segment with measurements
b = 3;
sys = 306:312;
timeWin = [1956.85, 1957.85];

sysToLook = [308, 309, 312];  % plot plotting example pca state
timePoints = [60, 80, 80];


audio = audioread(bgI(b).audioFile);
load(bgI(b).suaFile, 'sua');

x = [];
h = [];
l = [];
hNoLowFreq = [];
xHarm = [];
harm = [];
for i = 1:length(sys)
    sy = sys(i);
    x = [x, bgI(b).syTimeWin(sy,1):0.001:bgI(b).syTimeWin(sy,1)+(bgI(b).syFeatureLength(sy)-1)/1000];
    h = [h, bgPitch(b).features(sy).weightedHarmRatio];
    
    tmp2 = bgPitch(b).features(sy).weightedHarmRatio;
    tmp2(~bgPitch(b).features(sy).normFreqFlagFiltered) = nan;
    hNoLowFreq = [hNoLowFreq, tmp2];
    
    tmp = bgPitch(b).features(sy).lowHighFreqEnergyRatioLog;
    tmp(isnan(bgPitch(b).features(sy).weightedHarmRatio)) = nan;
    l = [l, tmp];


    tmp = bgPitch(b).features(sy).pitch;
    tmp(~bgPitch(b).features(sy).pitchFlagFiltered) = nan;
    harm = [harm, tmp];
end


%%% show the figure.
plotRasterWithHarmLow2behav(sua, audio, timeWin, 30000, 0, [], 0, 3, 0, {x, hNoLowFreq, l}, {x, harm});
ax = findall(gcf, 'type', 'axes');
clim(ax(4), [-102, -60]);
axes(ax(4));
ylim([300, 8000])
% plot the indicators of timewin for PCA construction examples
axes(ax(3));
hold on;
for i = 1:length(sysToLook) 
    time = bgI(b).syTimeWin(sysToLook(i),1)+(timePoints(i)-1)/1000;
    xline(time, 'k--')
    xline([time-30/1000, time-5/1000], 'color', [0.5, 0.5, 0.5])
end

axes(ax(2));
xrange = xlim;
yrange = ylim;
hold on;
lowThresh = 1;
patch([xrange(1), xrange(2), xrange(2), xrange(1)], [lowThresh, lowThresh, yrange(2), yrange(2)], 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'none')

axes(ax(1));
hold on;
box off
xrange = xlim;
yrange = ylim;
noisyHarmThresh = [0.2684, 0.7063];
patch([xrange(1), xrange(2), xrange(2), xrange(1)], [noisyHarmThresh(2), noisyHarmThresh(2), yrange(2), yrange(2)], 'r', 'FaceAlpha', 0.7, 'EdgeColor', 'none')
patch([xrange(1), xrange(2), xrange(2), xrange(1)], [noisyHarmThresh(1), noisyHarmThresh(1), yrange(1), yrange(1)], 'b', 'FaceAlpha', 0.7, 'EdgeColor', 'none')
patch([xrange(1), xrange(2), xrange(2), xrange(1)], [bgPitch(b).harmPitchThresh, bgPitch(b).harmPitchThresh, yrange(2), yrange(2)], [0.5,0.5,0.5], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
fontsize(5, 'points')
exportgraphics(gcf, 'Paper\Fig3_songExampleRasterWithBehavMeasurementsNew.pdf', 'contentType', 'Vector')


%%% get the catergories
bgCat = struct();
nPC = 3;

ptThresh = [20, 70];
ptThreshMid = [30, 50];

% get thresh
for i = 1:4
    bgCat(i).lowFreqThresh = 1;
    bgCat(i).normalFreqThresh = 1;

    bgCat(i).lowFreqFlag = bgPitch(i).allLowHighFreqEnergyRatioLog > bgCat(i).lowFreqThresh;  
    bgCat(i).lowFreqFlagFiltered = removeSpikes(bgCat(i).lowFreqFlag, 4);

    bgCat(i).normalFreqFlag = bgPitch(i).allLowHighFreqEnergyRatioLog < bgCat(i).normalFreqThresh;
    bgCat(i).normalFreqFlagFiltered = removeSpikes(bgCat(i).normalFreqFlag, 4);
    
    bgCat(i).validWeightedHarmRatio = bgPitch(i).allWeightedHarmRatio(bgCat(i).normalFreqFlagFiltered & bgPitch(i).allValidFlag);
end

allValidWeightedHarmRatio = [bgCat(:).validWeightedHarmRatio];
allLowFreqRatio = [bgPitch(:).allLowHighFreqEnergyRatioLog];

threshBottomHigh = prctile(allValidWeightedHarmRatio, ptThresh);
threshMid = prctile(allValidWeightedHarmRatio, ptThreshMid);

% get coords
for i = 1:4    
    bgCat(i).tonalFlag = bgPitch(i).allWeightedHarmRatio>threshBottomHigh(2) & bgPitch(i).allValidFlag & bgCat(i).normalFreqFlagFiltered;
    bgCat(i).noiseFlag = bgPitch(i).allWeightedHarmRatio<threshBottomHigh(1) & bgPitch(i).allValidFlag & bgCat(i).normalFreqFlagFiltered;
    bgCat(i).mixedFlag = bgPitch(i).allWeightedHarmRatio >= threshMid(1) & bgPitch(i).allWeightedHarmRatio <= threshMid(2) & bgPitch(i).allValidFlag & bgCat(i).normalFreqFlagFiltered;

    bgCat(i).tonalFlagFiltered = removeSpikes(bgCat(i).tonalFlag, 4);
    bgCat(i).noiseFlagFiltered = removeSpikes(bgCat(i).noiseFlag, 4);
    bgCat(i).mixedFlagFiltered = removeSpikes(bgCat(i).mixedFlag, 4);
    
    bgCat(i).lowCoord = bgPitch(i).score(bgCat(i).lowFreqFlagFiltered, 1:nPC);
    bgCat(i).tonalCoord = bgPitch(i).score(bgCat(i).tonalFlagFiltered, 1:nPC);
    bgCat(i).noiseCoord = bgPitch(i).score(bgCat(i).noiseFlagFiltered, 1:nPC);
    bgCat(i).mixedCoord = bgPitch(i).score(bgCat(i).mixedFlagFiltered, 1:nPC);
end

% get dist
for i = 1:4
    bgCat(i).distTonal = pdist(bgCat(i).tonalCoord);
    bgCat(i).distNoise = pdist(bgCat(i).noiseCoord);
    bgCat(i).distLowCoord = pdist(bgCat(i).lowCoord);
    bgCat(i).distMixed = pdist(bgCat(i).mixedCoord);

    bgCat(i).distBetween = [reshape(pdist2(bgCat(i).tonalCoord, bgCat(i).noiseCoord), 1, []), ...
        reshape(pdist2(bgCat(i).tonalCoord, bgCat(i).lowCoord), 1, []),...
        reshape(pdist2(bgCat(i).tonalCoord, bgCat(i).mixedCoord), 1, []),...
        reshape(pdist2(bgCat(i).noiseCoord,bgCat(i).lowCoord), 1, []),...
        reshape(pdist2(bgCat(i).noiseCoord,bgCat(i).mixedCoord), 1, []),...
        reshape(pdist2(bgCat(i).mixedCoord,bgCat(i).lowCoord), 1, [])];

    bgCat(i).rankSumTonalP = ranksum(bgCat(i).distBetween, bgCat(i).distTonal);
    bgCat(i).rankSumNoiseP = ranksum(bgCat(i).distBetween, bgCat(i).distNoise);
    bgCat(i).rankSumLowP = ranksum(bgCat(i).distBetween, bgCat(i).distLowCoord);
    bgCat(i).rankSumMixedP = ranksum(bgCat(i).distBetween, bgCat(i).distMixed);
end


% plot hist for measures pooled across birds
pubFig([21, 2.5, 1.1, 1.1]);
h = histogram(allLowFreqRatio, [-4.7:0.1:3], 'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], 1, 'g')
xlim([-4.7, 3]);
ylim([0, 3e4]);
xticks([-5:1:3]);
xtickangle(0)
box off
xlabel('Low freq. ratio')
ylabel('Count')
exportgraphics(gcf, ['Paper\Fig3_HistLowHighFreq.pdf'], 'ContentType', 'vector');

pubFig([21, 2.5, 1.1, 1.1]);
h = histogram(allValidWeightedHarmRatio, 0:0.02:1,'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, threshBottomHigh(1), [], 'b')
xlim([0, 1]);
ylim([0, 18000]);
ax = gca;
ax.YAxis.Exponent = 3;
box off
xlabel('Harm. index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_HistHarmIndexNoise.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 1.1, 1.1]);
h = histogram(allValidWeightedHarmRatio, 0:0.02:1,'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], threshBottomHigh(2), 'r')
xlim([0, 1]);
ylim([0, 18000]);
ax = gca;
ax.YAxis.Exponent = 3;
box off
xlabel('Harm. index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_HistHarmIndexTonal.pdf', 'ContentType', 'vector');

pubFig([21, 2.5, 1.1, 1.1]);
h = histogram(allValidWeightedHarmRatio, 0:0.02:1,'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, threshMid(1), threshMid(2), [0.5, 0, 0.5]);
xlim([0, 1]);
ylim([0, 18000]);
ax = gca;
ax.YAxis.Exponent = 3;
box off
xlabel('Harm. index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_HistHarmIndexMixture.pdf', 'ContentType', 'vector');


% plot gray with each of the class
for b = 1:4
    pubFig([21, 2.5, 3, 3]);
    scatter3(bgPitch(b).score(:,1), bgPitch(b).score(:,2), bgPitch(b).score(:,3), 2, [0.5, 0.5, 0.5], 'filled', 'MarkerFaceAlpha', 0.25);
    hold on;
    scatter3(bgCat(b).lowCoord(:,1), bgCat(b).lowCoord(:,2), bgCat(b).lowCoord(:,3), 2, 'g', 'filled', 'MarkerFaceAlpha', 1);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(-30.1, 34);
    axis tight
    grid off
    xlabel('Neural PC1');
    ylabel('Neural PC2');
    zlabel('Neural PC3');
    set(gca, 'tickLength', [0.06, 0.06])
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_lowFreq.tiff'], 'ContentType', 'image', 'Resolution', 600);
    xlabel([]);
    ylabel([]);
    zlabel([]);
    xticklabels([]);
    yticklabels([]);
    zticklabels([]);
    set(gca, 'LineWidth', 1.5)
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_lowFreq_nolabel.tiff'], 'ContentType', 'image', 'Resolution', 600);

    pubFig([21, 2.5, 3, 3]);
    scatter3(bgPitch(b).score(:,1), bgPitch(b).score(:,2), bgPitch(b).score(:,3), 2, [0.5, 0.5, 0.5], 'filled', 'MarkerFaceAlpha', 0.25);
    hold on;
    scatter3(bgCat(b).noiseCoord(:,1), bgCat(b).noiseCoord(:,2), bgCat(b).noiseCoord(:,3), 2, 'b', 'filled', 'MarkerFaceAlpha', 1);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(-30.1, 34);
    axis tight
    grid off
    xlabel('Neural PC1');
    ylabel('Neural PC2');
    zlabel('Neural PC3');
    set(gca, 'tickLength', [0.06, 0.06])
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_noisy.tiff'], 'ContentType', 'image', 'Resolution', 600);
    xlabel([]);
    ylabel([]);
    zlabel([]);
    xticklabels([]);
    yticklabels([]);
    zticklabels([]);
    set(gca, 'LineWidth', 1.5)
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_noisy_nolabel.tiff'], 'ContentType', 'image', 'Resolution', 600);

    pubFig([21, 2.5, 3, 3]);
    scatter3(bgPitch(b).score(:,1), bgPitch(b).score(:,2), bgPitch(b).score(:,3), 2, [0.5, 0.5, 0.5], 'filled', 'MarkerFaceAlpha', 0.25);
    hold on;
    scatter3(bgCat(b).tonalCoord(:,1), bgCat(b).tonalCoord(:,2),  bgCat(b).tonalCoord(:,3), 2, 'r', 'filled', 'MarkerFaceAlpha', 1);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(-30.1, 34);
    axis tight
    grid off
    xlabel('Neural PC1');
    ylabel('Neural PC2');
    zlabel('Neural PC3');
    set(gca, 'tickLength', [0.06, 0.06])
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_tonal.tiff'], 'ContentType', 'image', 'Resolution', 600);
    xlabel([]);
    ylabel([]);
    zlabel([]);
    xticklabels([]);
    yticklabels([]);
    zticklabels([]);
    set(gca, 'LineWidth', 1.5)
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_tonal_nolabel.tiff'], 'ContentType', 'image', 'Resolution', 600);

    pubFig([21, 2.5, 3, 3]);
    scatter3(bgPitch(b).score(:,1), bgPitch(b).score(:,2), bgPitch(b).score(:,3), 2, [0.5, 0.5, 0.5], 'filled', 'MarkerFaceAlpha', 0.25);
    hold on;
    scatter3(bgCat(b).mixedCoord(:,1), bgCat(b).mixedCoord(:,2),  bgCat(b).mixedCoord(:,3), 2, [0.5, 0, 0.5], 'filled', 'MarkerFaceAlpha', 1);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(-30.1, 34);
    axis tight
    grid off
    xlabel('Neural PC1');
    ylabel('Neural PC2');
    zlabel('Neural PC3');
    set(gca, 'tickLength', [0.06, 0.06])
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_mixture.tiff'], 'ContentType', 'image', 'Resolution', 600);
    xlabel([]);
    ylabel([]);
    zlabel([]);
    xticklabels([]);
    yticklabels([]);
    zticklabels([]);
    set(gca, 'LineWidth', 1.5)
    exportgraphics(gcf, ['Paper\Fig3_PCscatter_Bg', num2str(b) '_mixture_nolabel.tiff'], 'ContentType', 'image', 'Resolution', 600);
end

% plot distance cdf
for i = 1:4
    [cdfTonal, posTonal] = myCdf(bgCat(i).distTonal);
    [cdfNoise, posNoise] = myCdf(bgCat(i).distNoise);
    [cdfLowCoord, posLowCoord] = myCdf(bgCat(i).distLowCoord);
    [cdfMixed, posMixed] = myCdf(bgCat(i).distMixed);
    [cdfBetween, posBetween] = myCdf(bgCat(i).distBetween);
    pubFig([21, 2.5, 1.1, 1.1]);
    hold on;
    plot(posTonal, cdfTonal, 'r-');
    plot(posNoise, cdfNoise, 'b-');
    plot(posLowCoord, cdfLowCoord, 'g-');
    plot(posMixed, cdfMixed, '-', 'color', [0.5, 0, 0.5]);
    plot(posBetween, cdfBetween, 'k-');
    box off;
    xlim([0, inf])
    xlabel('Dist. (a.u.)')
    ylabel('Cumul. freq.')
    xticks(0:10:60)
    xtickangle(0)
    exportgraphics(gcf, ['Paper\Fig3_PCDistCDF_', 'Bg', num2str(i), '.pdf'], 'ContentType', 'vector');
end


for i = 1:4
    i
    distWithin = [bgCat(i).distTonal, bgCat(i).distNoise, bgCat(i).distLowCoord, bgCat(i).distMixed];
    [cdfWithin, posWithin] = myCdf(distWithin);
    [cdfBetween, posBetween] = myCdf(bgCat(i).distBetween);

    bgCat(i).rankSumBewteenWithin = ranksum(bgCat(i).distBetween, distWithin);

    pubFig([21, 2.5, 1.1, 1.1]);
    hold on;
    plot(posWithin, cdfWithin, 'k-');
    plot(posBetween, cdfBetween, 'k--');
    box off;
    xlim([0, inf])
    xlabel('Dist. (a.u.)')
    ylabel('Cumul. freq.')
    xticks(0:10:60)
    xtickangle(0)
    exportgraphics(gcf, ['Paper\Fig3_PCDistCDF2Cats_', 'Bg', num2str(i), '.pdf'], 'ContentType', 'vector');
end


%%% plot trajectory
b = 3;
good = [70, 306, 307, 428, 488,  530, 540, 1248];

goodLow = [178, 210, 347,828];

examples = [70, 828, 530];

clims = [[-45, -6]; [-65, -27]; [-45, -6]];

unitLength = 0.004;
height = 0.35;

for i = 1:length(examples)
    exam = examples(i);

    pubFig([21, 2.5, 3, 3]);

    xrange = [find(~isnan(bgPitch(b).features(exam).weightedHarmRatio), 1, 'first'),...
    find(~isnan(bgPitch(b).features(exam).weightedHarmRatio), 1, 'last')];

    syLength = range(xrange)+1;
    % color bar
    axes('Unit', 'Inches', 'Position', [0.5, 0.95, unitLength*(syLength+1), height/1.3]);
    cb = colorbar(gca, 'northoutside');
    colormap('turbo');
    axis off
    cb.Ticks = [];
    cb.EdgeColor = 'none';
    % spec
    axes('Unit', 'Inches', 'Position', [0.5, 1.8, unitLength*(syLength+1), height])
    imagesc(1:range(xrange)+1, bgPitch(b).features(exam).F(1:256)/1000, 10*log10(bgPitch(b).features(exam).sonogram(:, xrange(1):xrange(2))));
    hold on;
    set(gca, 'ydir', 'normal');
    ylim([0, 7]);
    box off
    a = gca;
    a.XAxis.Visible = 'off';
    yticks([0:1:7])
    ylabel('Freq. (kHz)')
    colormap(gca, 'gray');
    clim(clims(i,:))
    axis off
    % behav measurements
    axes('Unit', 'Inches', 'Position', [0.5, 1.5, unitLength*(syLength+1), height/1.5])
    plot(1:range(xrange)+1, bgPitch(b).features(exam).weightedHarmRatio(xrange(1):xrange(2)), 'k-');
    ylim([0, 1])
    yticks([0:0.5:1]);
    ylabel('Harm. index')
    yyaxis right
    a = gca;
    a.YAxis(2).Color = "#EDB120";
    plot(1:range(xrange)+1, bgPitch(b).features(exam).lowHighFreqEnergyRatioLog(xrange(1):xrange(2)), '-', 'Color',"#EDB120");
    ylabel('Low freq. ratio')
    xlim([0.5, range(xrange)+1.5])
    ylim([-4,4])
    yticks([-4, 0, 4])
    xticks(1:20:range(xrange)+1);
    xticklabels([1:20:range(xrange)+1]-1); 
    xtickangle(0)
    xlabel('Time (ms)')
    box off
    exportgraphics(gcf, ['Paper\Fig3_PCtraj_', num2str(i), '_spec.pdf'], 'contentType', 'vector');
    

    pubFig([21, 2.5, 2, 2]);
    scatter3(bgCat(b).noiseCoord(:,1), bgCat(b).noiseCoord(:,2), bgCat(b).noiseCoord(:,3), 2, [0.4, 0.4, 0.4], 'filled', 'MarkerFaceAlpha', 0.2);
    hold on;
    scatter3(bgCat(b).lowCoord(:,1), bgCat(b).lowCoord(:,2), bgCat(b).lowCoord(:,3), 2, [0.1, 0.1, 0.1], 'filled', 'MarkerFaceAlpha', 0.2);
    scatter3(bgCat(b).tonalCoord(:,1), bgCat(b).tonalCoord(:,2),  bgCat(b).tonalCoord(:,3), 2, [0.7,0.7,0.7], 'filled', 'MarkerFaceAlpha', 0.2);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(26.8, 56.9);
    axis tight
    grid off
    set(gca, 'tickLength', [0.05, 0.05])
    set(gca, 'LineWidth', 1)
    ax1 = gca;

    axes;
    scatter3(bgCat(b).noiseCoord(:,1), bgCat(b).noiseCoord(:,2), bgCat(b).noiseCoord(:,3), 2, [0.4, 0.4, 0.4], 'filled', 'MarkerFaceAlpha', 0);
    hold on;
    scatter3(bgCat(b).lowCoord(:,1), bgCat(b).lowCoord(:,2), bgCat(b).lowCoord(:,3), 2, [0.1, 0.1, 0.1], 'filled', 'MarkerFaceAlpha', 0);
    scatter3(bgCat(b).tonalCoord(:,1), bgCat(b).tonalCoord(:,2),  bgCat(b).tonalCoord(:,3), 2, [0.7,0.7,0.7], 'filled', 'MarkerFaceAlpha', 0);
    set(gca, 'zdir', 'reverse');
    daspect([1,1,1]);
    view(26.8, 56.9);
    axis tight
    grid off
    set(gca, 'tickLength', [0.05, 0.05])
    set(gca, 'LineWidth', 1)
    axis off;
    
    eidx = find(bgI(b).syFeatureId==exam);
    eidx = eidx(xrange(1):xrange(2));
    x = bgPitch(b).score(eidx,1);
    y = bgPitch(b).score(eidx,2);
    z = bgPitch(b).score(eidx,3);
    patch([x;nan], [y;nan], [z;nan], [1:length(eidx) nan], 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth',2);
    colormap('turbo');
    length(eidx)
    ax2 = gca;

    exportgraphics(gcf, ['Paper\Fig3_PCtraj_', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);

    axes(ax1);
    xticklabels([]);
    yticklabels([]);
    zticklabels([]);

    axes(ax2)
    xlabel([]);
    ylabel([]);
    zlabel([]);
    exportgraphics(gcf, ['Paper\Fig3_PCtraj_', num2str(i), 'noLabel.tiff'], 'ContentType', 'image', 'Resolution', 600);

end




% plot method of constructing the neural space
xLimRange = [-26.3969, 21.3321];
yLimRange = [-16.8797, 27.9132];
zLimRange = [-20.5907, 16.1960];

b = 3;
for i = length(sysToLook)%1:length(sysToLook)
    pubFig([21, 2.5, 3, 3]);
    hold on;
    for j = 1:i
        pos = find(bgI(b).syFeatureId == sysToLook(j));
        posToPlot = pos(timePoints(j));
        scatter3(bgPitch(b).score(posToPlot, 1), bgPitch(b).score(posToPlot,2), bgPitch(b).score(posToPlot, 3), 20, [0.5, 0.5, 0.5], 'filled');
        set(gca, 'zdir', 'reverse');
        daspect([1,1,1]);
        view(-30.1, 34);
        axis tight
        grid off
        set(gca, 'LineWidth', 1.5)
        xlim(xLimRange);
        ylim(yLimRange);
        zlim(zLimRange);
        xticklabels([]);
        yticklabels([]);
        zticklabels([]);
    end
    exportgraphics(gcf, ['paper\SupFig_PCscatter_Bg', num2str(b) '_examplePoints', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);
end


pubFig([21, 2.5, 3, 3]);
scatter3(bgPitch(b).score(:, 1), bgPitch(b).score(:,2), bgPitch(b).score(:, 3), 2, [0.5, 0.5, 0.5], 'filled', 'MarkerFaceAlpha', 0.25);
set(gca, 'zdir', 'reverse');
daspect([1,1,1]);
view(-30.1, 34);
axis tight
grid off
set(gca, 'LineWidth', 1.5)
xlim(xLimRange);
ylim(yLimRange);
zlim(zLimRange);
xticklabels([]);
yticklabels([]);
zticklabels([]);
exportgraphics(gcf, ['paper\SupFig_PCscatter_Bg', num2str(b) 'AllPoints.tiff'], 'ContentType', 'image', 'Resolution', 600);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fig 4

b = 2;
pubFig([21, 2.5, 1.2, 1.2]);
h = histogram(bgPitch(b).allWeightedHarmRatio(bgPitch(b).allNormFreqFlagFiltered & bgPitch(b).allValidFlag), 'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], bgPitch(b).harmPitchThresh, [0.3, 0.3, 0.3])
xlabel('Harm. index');
ax = gca;
ax.YAxis.Exponent = 3;
ylabel('Count')
box off;
exportgraphics(gcf, 'Paper\Fig4_HistHarmIdxBg2.pdf', 'contentType', 'vector');


% histogram of pitch distribution
pubFig([21, 1, 1.2, 1.2]);
histogram(bgPitch(2).allPitch(bgPitch(2).allPitchFlagFiltered), 20, 'facecolor', [0.3, 0.3, 0.3], 'facealpha', 1, 'edgecolor', 'none');
xlim([500, 5500])
xticks([1000:1000:5500])
xticklabels(1:5)
a = gca;
a.YAxis.Exponent = 3;
xlabel('Freq (kHz)')
ylabel('Count')
box off
exportgraphics(gcf, 'Paper\Fig4_histFreqBg2.pdf', 'contentType', 'vector')


% for all other birds
for i = [1,3,4]
    pubFig([21, 1, 1.5, 1.5]);
    histogram(bgPitch(i).allPitch(bgPitch(i).allPitchFlagFiltered), 20, 'facecolor', [0.3, 0.3, 0.3], 'facealpha', 1, 'edgecolor', 'none');
    xticks([1000:1000:6000])
    xticklabels(1:6)
    a = gca;
    a.YAxis.Exponent = 3;
    xlabel('Freq (kHz)')
    ylabel('Count')
    box off
    exportgraphics(gcf, ['Paper\Fig4_histFreqBg', num2str(i) '.pdf'], 'contentType', 'vector')
end


%%% population analyses

% find axis and projection
bgPitchGradientVector = cell(1, length(bgPitch));
bgPitchGradientLoading = cell(1, length(bgPitch));


bgProj = struct();

pct = 50;

clims = [[1000,5000]; [1000, 5000]; [1000, 6000]; [1000, 4200]];
for i = 1:length(bgPitch)
    pitchIdx = bgPitch(i).allPitchFlagFiltered;
    pitchScores = bgPitch(i).score(pitchIdx, :);
    pitch = bgPitch(i).allPitch(pitchIdx);
    
    oddPitchScores = pitchScores(1:2:end,:);
    evenPitchScores = pitchScores(2:2:end,:);
    oddPitch = pitch(1:2:end);
    evenPitch = pitch(2:2:end);

    % now we use half split
    pitchPct = prctile(oddPitch, [pct, 100-pct]);
    bgPitchGradientStart = mean(oddPitchScores(oddPitch<pitchPct(1),:), 1);
    bgPitchGradientEnd = mean(oddPitchScores(oddPitch>pitchPct(2),:), 1);
    pvector = bgPitchGradientEnd-bgPitchGradientStart;
    bgPitchGradientVector{i} = pvector/norm(pvector);

    pitchGradientProj = zeros(1, length(evenPitch));
    for k = 1:length(evenPitch)
        pitchGradientProj(k) = dot(evenPitchScores(k,:), bgPitchGradientVector{i});
    end

    bgProj(i).pitchGradientProj = pitchGradientProj;
    bgProj(i).pitch = pitch;
    bgProj(i).oddPitch = oddPitch;
    bgProj(i).evenPitch = evenPitch;

    % plot the method
    if i == 2
        pubFig([21, 2.5, 5, 5]);
        scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
        hold on;
        scatter(oddPitchScores(:,1), oddPitchScores(:,2),  2, oddPitch, 'filled', 'MarkerFaceAlpha', 1);
        colormap(turbo);
        clim(clims(i,:))
        axis image;
        xLimRange = xlim();
        yLimRange = ylim();
        plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
        plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
        axis off
        exportgraphics(gcf, ['Paper\SupFig_PCRainbowOdd_bg', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);

        pubFig([21, 2.5, 5, 5]);
        scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
        hold on;
        scatter(evenPitchScores(:,1), evenPitchScores(:,2),  2, evenPitch, 'filled', 'MarkerFaceAlpha', 1);
        colormap(turbo);
        clim(clims(i,:))
        axis image;
        xLimRange = xlim();
        yLimRange = ylim();
        plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
        plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
        axis off
        exportgraphics(gcf, ['Paper\SupFig_PCRainbowEven_bg', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);

        pubFig([21, 2.5, 5, 5]);
        scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
        hold on;
        scatter(oddPitchScores(oddPitch<pitchPct(1),1), oddPitchScores(oddPitch<pitchPct(1),2),  2, 'b', 'filled', 'MarkerFaceAlpha', 1);
        scatter(oddPitchScores(oddPitch>pitchPct(1),1), oddPitchScores(oddPitch>pitchPct(1),2),  2, 'r', 'filled', 'MarkerFaceAlpha', 1);
        plot([bgPitchGradientStart(1), bgPitchGradientEnd(1)], [bgPitchGradientStart(2), bgPitchGradientEnd(2)], 'ko', 'markersize', 8, 'lineWidth', 3);
        axis image;
        xLimRange = xlim();
        yLimRange = ylim();
        plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
        plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
        axis off
        exportgraphics(gcf, ['Paper\SupFig_PCRainbowOddLowHighPitch_bg', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);
    end
end


% rainbow plots using all cells
clims = [[1000,5000]; [1000, 5000]; [1000, 6000]; [1000, 4200]];
pos = [[-2, -16]; [0, -18]; [6, -20]; [8, -14]];
for i = 1:length(bgPitch)
    pubFig([21, 2.5, 5, 5]);
    scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
    hold on;
    scatter(bgPitch(i).score(bgPitch(i).allPitchFlagFiltered, 1), bgPitch(i).score(bgPitch(i).allPitchFlagFiltered, 2),  2, bgPitch(i).allPitch(bgPitch(i).allPitchFlagFiltered), 'filled', 'MarkerFaceAlpha', 1);
    colormap(turbo);
    clim(clims(i,:))
    
    axis image
    hold on

    xStartPos = pos(i,1);
    yStartPos = pos(i,2);
    xEndPos = xStartPos + 20*bgPitchGradientVector{i}(1);%range(xlim)/3;
    yEndPos = yStartPos + 20*bgPitchGradientVector{i}(2); %(xEndPos-xStartPos)*(bgPitchFullGradientVector{i}(2)/bgPitchFullGradientVector{i}(1));

    arrow('Start', [xStartPos, yStartPos], 'Stop', [xEndPos, yEndPos], 'Length', 12, 'Width', 1.5);


    xLimRange = xlim();
    yLimRange = ylim();
    plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
    plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
    axis off

    exportgraphics(gcf, ['Paper\Fig4_PCRainbow_bg', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);
end



%%%% rainbow plot for control
climControl = [1000, 5000];
for i = 1:length(bgPitchControl)
    pubFig([21, 2.5, 5, 5]);
    scatter(bgPitchControl(i).score(:, 1), bgPitchControl(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
    hold on;
    scatter(bgPitchControl(i).score(bgPitch(2).allPitchFlagFiltered, 1), bgPitchControl(i).score(bgPitch(2).allPitchFlagFiltered, 2),  2, bgPitch(2).allPitch(bgPitch(2).allPitchFlagFiltered), 'filled', 'MarkerFaceAlpha', 1);
    colormap(turbo);
    clim(climControl)
    
    axis image
    hold on

    set(gca, 'XDir','normal')
    set(gca, 'YDir','reverse')

    xLimRange = xlim();
    yLimRange = ylim();
    plot([xLimRange(1), xLimRange(1)+5], [yLimRange(2), yLimRange(2)], 'k-', 'lineWidth', 1.5)
    plot([xLimRange(1), xLimRange(1)], [yLimRange(2), yLimRange(2)-5], 'k-', 'lineWidth', 1.5)
    axis off

    exportgraphics(gcf, ['Paper\Fig4_PCRainbow_bg2Control', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);
end


% calculate proj curves
projY = {};
projX = {};
projSe = {};
projRsquare = [];
projXRanges = {};
for i = 1:length(bgPitch)
    minProj = min(bgProj(i).pitchGradientProj);
    maxProj = max(bgProj(i).pitchGradientProj);
    projGap = 3;
    xPoints = floor(minProj)+projGap/2:projGap:ceil(maxProj)-projGap/2;
    projXRanges{i} = xPoints;
    [projY{i}, ~, projSe{i}, projRsquare(i)] = calMeanRespAlongX(bgProj(i).pitchGradientProj, bgProj(i).evenPitch, xPoints, projGap, 20);
    projX{i} = xPoints;
end

% shuffle the data and calculate projection
nShuffle = 5000;
shuffledPitch = cell(4, nShuffle);
shuffledProj = cell(4, nShuffle);
shuffledCurve = cell(4);
meanShuffledCurve = cell(4);
seShuffledCurve = cell(4);
pct = 50;
tic
for i = 1:4
    pitchIdx = bgPitch(i).allPitchFlagFiltered;
    pitchScores = bgPitch(i).score(pitchIdx, :);
    pitch = bgPitch(i).allPitch(pitchIdx);
    
    oddPitchScores = pitchScores(1:2:end,:);
    evenPitchScores = pitchScores(2:2:end,:);

    curves = zeros(nShuffle, length(projXRanges{i}));

    parfor j = 1:nShuffle
        %j
        sPitch = pitch(randperm(length(pitch)));

        oddPitch = sPitch(1:2:end);
        evenPitch = sPitch(2:2:end);

        pitchPct = prctile(oddPitch, [pct, 100-pct]);

        gradStart = mean(oddPitchScores(oddPitch<pitchPct(1),:), 1);
        gradEnd = mean(oddPitchScores(oddPitch>pitchPct(2),:), 1);
        pvector = gradEnd-gradStart;
        bgPitchGradientVector = pvector/norm(pvector);

        pitchGradientProj = zeros(1, length(evenPitch));
        for k = 1:length(evenPitch)
            pitchGradientProj(k) = dot(evenPitchScores(k,:), bgPitchGradientVector);
        end

        curves(j,:) = calMeanRespAlongX(pitchGradientProj, evenPitch, projXRanges{i}, projGap, 20);

        shuffledPitch{i,j} = sPitch;
        shuffledProj{i,j} = pitchGradientProj;
    end
    shuffledCurve{i} = curves;
    meanShuffledCurve{i} = mean(curves, 1, 'omitnan');
    seShuffledCurve{i} = std(curves, [], 1, 'omitnan')./sqrt(sum(~isnan(curves), 1));
end
toc

% plot proj curve together with shuffled data
for i = 1:4
    pubFig([21, 2.5, 1, 1.25]);
    hold on;
    errorbar(projXRanges{i}, meanShuffledCurve{i}, seShuffledCurve{i}, '.-', 'color', [0.5,0.5,0.5], 'markersize', 8, 'capsize', 0.2);
    errorbar(projXRanges{i}, projY{i}, projSe{i}, 'k.-', 'markersize', 8, 'CapSize', 0.2)
    box off;
    xlabel('Proj. freq axis')
    ylabel('Freq. (kHz)')
    title(['BG', num2str(i), ' R^2:', num2str(projRsquare(i))])
    xlim([-20, 22])
    ylim([1000, 4300])
    yticklabels(yticks()/1000)
    exportgraphics(gcf, ['Paper\Fig4_PCProj_bg', num2str(i), '.pdf'], 'contentType', 'vector')
end


%%%%%% single unit tuning
% example tuning
b = 2;
audio = audioread(bgI(b).audioFile);
load(bgI(b).suaFile, 'sua');

exampVocalId = 34;
exampSyId = 110;

exampleRespWin = bgI(b).vocalTimeWin(34,:);

% sort using rastermap
rasterMapSortWin = round([exampleRespWin(1,1)-0.12, exampleRespWin(1,2)+0.12]*1000);
[~, frSort, ~] = calInstFR(sua, rasterMapSortWin);
ops.nCall = [17, 55];

[isort1, isort2, Sm] = mapTmap(frSort, ops);

plotRaster(sua(isort1), audio, exampleRespWin(1,:), 30000, 0, [], 100, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-110, -65]);
axes(ax(2));
ylabel('Freq. (kHz)')
yticks(1000:1000:7000)
yticklabels(1:7);
ax(2).XAxis.Visible = 'off';
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 2)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, 'Paper\Fig4_bgFreqExampRaster.pdf','ContentType', 'vector');

save('Fig4_exampleSortOrder.mat', 'isort1');


%%% single unit tuning
% plot all units with tuing 
binLim = [0, 0.02];
outputDir = ['Bg_pitch\']; 
for b = 1:length(bgPitch)
    for i = 1:size(bgPitch(b).allUnitRespMatrix, 1)
        gap = bgPitchTuning(b).pitchEdges(2)-bgPitchTuning(b).pitchEdges(1);
        unitResp = bgPitch(b).allUnitRespMatrix(i,:);

        pitchToInclude = bgPitch(b).allPitchFlagFiltered;

        goodPitchRes = unitResp(pitchToInclude);

        spikeEdges = 0:1:max(unitResp(bgPitch(b).allPitchFlagFiltered))+1;
        N = histcounts2(goodPitchRes, bgPitch(b).allPitch(pitchToInclude), spikeEdges, bgPitchTuning(b).pitchEdges);
        Nnormed = N/sum(N(:));

        figure;
        imagesc([bgPitchTuning(b).pitchEdges(1)+gap/2, bgPitchTuning(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
        set(gca,'ydir','normal');
        colorbar;
        colormap(flipud(gray));
        yticks([0:2:spikeEdges(end)]*1000/25)
        box off;
        clim(binLim)
        hold on;
        errorbar(bgPitchTuning(b).pitchCurveMidPoint, bgPitchTuning(b).pitchTuningCurve(i,:), bgPitchTuning(b).pitchTuningCurveSe(i,:), '.-','markersize', 10, 'CapSize', 2, 'MarkerFaceColor', 'r')
        
        plot(bgPitchTuning(b).biggerPitchMidPoint, bgPitchTuning(b).biggerPitchTuningCurve(i,:), '.-', 'markersize', 10);
        title(['U' num2str(i), ' Tuning Idx:', num2str(bgPitchTuning(b).pitchTuningIdx(i))]);
        exportgraphics(gcf, [outputDir, 'b' num2str(b), '_U', num2str(i), '_heatmap0.jpg']);
        
        close all
    end
end


% plot example units from bird 2
bgU = [27,69,65, 79]; 

% find unit id in tuning curve matrix heatamp plot
arrayfun(@(x) find(bgPitchTuning(2).pitchTunedSortId==x), bgU(1:3))

oldU = 1:81;
sortedU = oldU(isort1);
newUId = zeros(length(bgU), 1);
for i = 1:length(bgU)
    idx = find(sortedU == bgU(i));
    newUId(i) = idx;
end

b = 2;
binLim = [0, 0.02];
for j = 1:length(bgU)
    gap = bgPitchTuning(b).pitchEdges(2)-bgPitchTuning(b).pitchEdges(1);
    i = bgU(j);
    
    unitResp = bgPitch(b).allUnitRespMatrix(i,:);

    pitchToInclude = bgPitch(b).allPitchFlagFiltered;

    goodPitchRes = unitResp(pitchToInclude);

    spikeEdges = 0:1:max(unitResp(bgPitch(b).allPitchFlagFiltered))+1;
    N = histcounts2(goodPitchRes, bgPitch(b).allPitch(pitchToInclude), spikeEdges, bgPitchTuning(b).pitchEdges);
    Nnormed = N/sum(N(:));

    pubFig([21, 2.5, 1.5, 1.5]);
    imagesc([bgPitchTuning(b).pitchEdges(1)+gap/2, bgPitchTuning(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
    set(gca,'ydir','normal');
    colormap(flipud(gray));
    xlim([1000, 5700])
    yticks([0:2:spikeEdges(end)]*1000/25)
    box off;
    clim(binLim)
    hold on;
    errorbar(bgPitchTuning(b).pitchCurveMidPoint, bgPitchTuning(b).pitchTuningCurve(i,:), bgPitchTuning(b).pitchTuningCurveSe(i,:), '.-','markersize', 6, 'lineWidth', 0.5, 'CapSize', 0.3, 'color', [45,211,120]/255);
    title(['U' num2str(newUId(j)), ', TI:' num2str(bgPitchTuning(b).pitchTuningIdx(i))]);
    xticks(0:1000:5000);
    xticklabels(0:1:5);
    xtickangle(0);
    xlabel('Freq. (kHz)');
    yticks(0:80:1000);
    ylabel('Spikes/s')
    ylim([0 spikeEdges(end)*1000/25]);
    xlim([900, 5500])
    exportgraphics(gcf, ['Paper\Fig4_UnitTuning_', 'b' num2str(b), '_U', num2str(i), '.pdf'], 'contentType', 'vector');
    close(gcf)
end

% for colorbar
figure; 
colormap(flipud(gray));
cb = colorbar;
cb.Ticks = [];
axis off
exportgraphics(gcf, ['Paper\Fig4_UnitTuningColorbar.pdf'], 'contentType', 'vector');


% histogram of tuning idx
sum([bgPitchTuning(:).pitchTuned])/length([bgPitchTuning(:).pitchTuned])

pubFig([21, 2.5, 2, 1.2])
h = histogram([bgPitchTuning(:).pitchTuningIdx], 0:1:35,'facecolor', [0.5, 0.5, 0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], tuningThresh, 'k')
axis tight
xlim([0, 37]);
xlabel('Tuning index')
ylabel('Count')
box off
exportgraphics(gcf, 'Paper\Fig4_HistTuningIndex.pdf', 'ContentType', 'vector');


% tuning heatmap for each bird
allCurveNorm = [];
allFirstFreq = [];
allXRange = [];
for b = 1:4
    allCurveNorm = [allCurveNorm; bgPitchTuning(b).curveNorm];
    allFirstFreq = [allFirstFreq, bgPitchTuning(b).firstFreq];
    allXRange = [allXRange; bgPitchTuning(b).pitchCurveXRange];

    xrange = bgPitchTuning(b).pitchCurveXRange;
    curveNormSorted = bgPitchTuning(b).pitchCurveNormSorted;
    
    pubFig([21, 2, 3, 5]);
    axes('Units', 'Inches', 'Position', [0.6, 0.6, 0.6, 0.04*size(curveNormSorted,1)])
    imagesc(bgPitchTuning(b).pitchCurveMidPoint(xrange(1):xrange(2)), 1:size(curveNormSorted,1), curveNormSorted(:,xrange(1):xrange(2)));
    clim([0, 1]);
    colormap('turbo')

    box off
    xticks(1000:1000:7000);
    xticklabels(1:7);
    yticks([1,size(curveNormSorted,1)])
    xlabel('Freq. (kHz)')
    xtickangle(0)
    ylabel('Neuron #')
    exportgraphics(gcf, ['Paper\Fig4_PopTuningMap_Bg', num2str(b), '.pdf'], 'contentType', 'Vector');
end


% plot unit location in the probe and freq preferences
clims = [[1000,5000]; [1000, 5000]; [1000, 6000]; [1000, 4200]];
for b = 1:4
    tunedCell = find(bgPitchTuning(b).pitchTuningIdx>=tuningThresh);  
    load(bgI(b).suaFile, 'sua');
    coords = [];
    for i = 1:length(tunedCell)
        coords = [coords; sua(tunedCell(i)).coordinates];
    end
    pubFig([21, 2, 3,5]);

    load('E:\WorkAtLongLab\YangCodeBase\BudgieEphys\Li145_ChronicLeftAAC\128_5_integrated_corrected.mat');
    hold on
    plot(xcoords, ycoords, 'ko');

    scatter(coords(:,1), coords(:,2), 20, bgPitchTuning(b).pitchBest(tunedCell), 'filled', 'markerfacealpha', 0.8);
    colormap('turbo');
    clim(clims(b,:));
    axis off
    exportgraphics(gcf, ['Paper\Fig4_UnitTuningLocationInProbe', num2str(b), '.pdf'], 'contentType', 'Vector');
end


%%%%% frequency decoding
% use all syllables
syGroupIdxAllBg = {};
syGroupIdAllBg = {};
for i = 1:4
    syGroupIdx = {};
    syGroupId = [];
    for j = 1:length(bgPitch(i).features)
        pointIds = find(bgI(i).syFeatureId == j);
        if any(bgPitch(i).features(j).pitchFlagFiltered)
            syGroupIdx{end+1} = pointIds(bgPitch(i).features(j).pitchFlagFiltered)';
            syGroupId(end+1) = j;
        end
    end
    syGroupIdxAllBg{i} = syGroupIdx;
    syGroupIdAllBg{i} = syGroupId;
end


delete(gcp('nocreate'));
parpool(4)
bgFreqDecode = struct();

for b = 1:4
    tic
    syPoint = syGroupIdxAllBg{b};
    syId = syGroupIdAllBg{b};
    predicted = cell(1, length(syPoint));
    predictedFull = cell(1, length(syPoint));

    syFeatureId = bgI(b).syFeatureId;
    allUnitRespMatrix = bgPitch(b).allUnitRespMatrix;
    allPitch = bgPitch(b).allPitch;

    parfor i = 1:length(syPoint)
        i
        testSy = syId(i);
        testPoint = syPoint{i};
        testPointFull = find(syFeatureId == testSy);
        
        tmp = syPoint;
        tmp{i} = [];
        trainPoint = [tmp{:}];
        md = fitlm(allUnitRespMatrix(:, trainPoint)', allPitch(trainPoint)');
        predicted{i} = predict(md, allUnitRespMatrix(:, testPoint)')';
        predictedFull{i} = predict(md, allUnitRespMatrix(:, testPointFull)')';
    end
    toc

    bgFreqDecode(b).predicted = predicted;
    bgFreqDecode(b).predictedFull = predictedFull;
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [predicted{:}];
    bgFreqDecode(b).rsquare = 1-sum((allFreq-allPredicted).^2)/sum((allFreq - mean(allFreq)).^2);
end

%decode using different number of cells
unitsNum = [5, 10, 15, 20];
for b = 1:4
    tic
    syPoint = syGroupIdxAllBg{b};
    syId = syGroupIdAllBg{b};

    [~, unitRank] = sort(bgPitchTuning(b).pitchTuningIdx);
    goodUnits = arrayfun(@(x) unitRank(end-x+1:end), unitsNum, 'UniformOutput', false);
    badUnits = arrayfun(@(x) unitRank(1:x), unitsNum, 'UniformOutput', false);

    predictedGood = cell(length(unitsNum), length(syPoint));
    predictedGoodFull = cell(length(unitsNum), length(syPoint));
    predictedBad = cell(length(unitsNum), length(syPoint));
    predictedBadFull = cell(length(unitsNum), length(syPoint));

    rsquareGood = zeros(1, length(unitsNum));
    rsquareBad = zeros(1, length(unitsNum));

    syFeatureId = bgI(b).syFeatureId;
    allUnitRespMatrix = bgPitch(b).allUnitRespMatrix;
    allPitch = bgPitch(b).allPitch;
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);

    for j = 1:length(unitsNum)
        parfor i = 1:length(syPoint)
            i
            testSy = syId(i);
            testPoint = syPoint{i};
            testPointFull = find(syFeatureId == testSy);

            tmp = syPoint;
            tmp{i} = [];
            trainPoint = [tmp{:}];

            md = fitlm(allUnitRespMatrix(goodUnits{j}, trainPoint)', allPitch(trainPoint)');
            predictedGood{j, i} = predict(md, allUnitRespMatrix(goodUnits{j}, testPoint)')';
            predictedGoodFull{j, i} = predict(md, allUnitRespMatrix(goodUnits{j}, testPointFull)')';
            md = fitlm(allUnitRespMatrix(badUnits{j}, trainPoint)', allPitch(trainPoint)');
            predictedBad{j, i} = predict(md, allUnitRespMatrix(badUnits{j}, testPoint)')';
            predictedBadFull{j, i} = predict(md, allUnitRespMatrix(badUnits{j}, testPointFull)')';
        end
        allPredictedGood = [predictedGood{j, :}];
        rsquareGood(j) = 1-sum((allFreq-allPredictedGood).^2)/sum((allFreq - mean(allFreq)).^2);
        allPredictedBad = [predictedBad{j, :}];
        rsquareBad(j) = 1-sum((allFreq-allPredictedBad).^2)/sum((allFreq - mean(allFreq)).^2);
    end
    toc

    bgFreqDecode(b).predictedGood = predictedGood;
    bgFreqDecode(b).predictedGoodFull = predictedGoodFull;
    bgFreqDecode(b).predictedBad = predictedBad;
    bgFreqDecode(b).predictedBadFull = predictedBadFull;
    bgFreqDecode(b).rsquareGood = rsquareGood;
    bgFreqDecode(b).rsquareBad = rsquareBad;
end

save('bgFreqDecode.mat', 'bgFreqDecode', 'unitsNum')

load('bgFreqDecode.mat', 'bgFreqDecode', 'unitsNum')



% plot decoding Rsquare summary
pubFig([21, 0, 1.0, 1.78])
hold on
allDecodeGood = [];
allDecodeBad = [];
markers = {'square', 'diamond', '^', 'v'};
for i = 1:4
    allDecodeGood = [allDecodeGood; bgFreqDecode(i).rsquareGood];
    allDecodeBad = [allDecodeBad; bgFreqDecode(i).rsquareBad];
    plot(1:length(unitsNum), bgFreqDecode(i).rsquareGood, ['r', markers{i}, '-'], 'markerSize', 4);
    plot(length(unitsNum)+1, bgFreqDecode(i).rsquare, ['k', markers{i}], 'markerSize', 4);
    plot(1:length(unitsNum), bgFreqDecode(i).rsquareBad, ['b', markers{i}, '-'], 'markerSize', 4);
end
ylim([-0.05, 0.8]);
yticks(0:0.2:0.8);
xlim([0.5, 5])
xticks(1:length(unitsNum)+1);
xticklabels([arrayfun(@num2str, unitsNum, 'UniformOutput', false), {'All'}])
xlabel('No. of neurons')
ylabel('Decoding accuracy (R^2)')
exportgraphics(gcf, 'Paper\Fig4_decodingRsquareSummary.pdf', 'contentType', 'vector')

for i = 1:length(unitsNum)
    good = arrayfun(@(x) bgFreqDecode(x).rsquareGood(i), 1:4);
    bad = arrayfun(@(x) bgFreqDecode(x).rsquareBad(i), 1:4);
    p = ranksum(good, bad)
end


% plot all bird decoded freq for each syllable
unitsToUse = 1;
for b = 1:4
    folderName = 'Bg_decode_lm';
    syId = syGroupIdAllBg{b};
    for i = 1:length(syId)
        sy = syId(i);
        figure('Position', [985   277   633   174]);
        xcoord = 1:size(bgPitch(b).features(sy).sonogram, 2);
        validFlag = bgPitch(b).features(sy).validFlag;
        subplot(1,2,1)
        imagesc(xcoord, bgPitch(b).features(sy).F(1:256), 10*log10(bgPitch(b).features(sy).sonogram))
        set(gca, 'ydir', 'normal')
        colormap('gray')
        clim([-70, -25])
        ylim([0, 7000])
        hold on;
        plot(xcoord(validFlag), bgPitch(b).features(sy).pitch(validFlag), 'g-')
        box off
        subplot(1,2,2)
        hold on;

        dummy = nan(1, length(xcoord));
        dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgPitch(b).features(sy).pitch(bgPitch(b).features(sy).pitchFlagFiltered);
        plot(xcoord, dummy, 'g-', 'lineWidth', 1)

        dummy = nan(1, length(xcoord));
        dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predicted{i};
        plot(xcoord, dummy, 'k-', 'lineWidth', 1);

        dummy = nan(1, length(xcoord));
        dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predictedGood{unitsToUse, i};
        plot(xcoord, dummy, 'r-', 'lineWidth', 1);

        dummy = nan(1, length(xcoord));
        dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predictedBad{unitsToUse, i};
        plot(xcoord, dummy, 'b-', 'lineWidth', 1);

        xlim([0.5,size(bgPitch(b).features(sy).sonogram, 2)+0.5]);
        ylim([0, 7000]);
        exportgraphics(gcf, [folderName, '\bg', num2str(b), '_sy', num2str(sy), '_idx', num2str(i), '.jpg']);
        close gcf
    end
end



%%% plot example
unitsToUse = 1;
b= 2;
syIdx = [12, 127, 131];
timeLim1 = [58, 1, 1];
timeLim2 = [150, 155, 79];
freqLim = [[1500, 4500]; [1500, 4500]; [1500, 4500]];
colorLim = [[-58, -30]; [-58, -30]; [-62, -30]];
syId = syGroupIdAllBg{b};
for j = 1:length(syIdx)
    i = syIdx(j);
    sy = syId(i);
    pubFig([21, 0, 1.5, 4]);
    xcoord = 1:size(bgPitch(b).features(sy).sonogram, 2);
    validFlag = bgPitch(b).features(sy).validFlag;
    subplot(4,1,1)
    imagesc(xcoord, bgPitch(b).features(sy).F(1:256), 10*log10(bgPitch(b).features(sy).sonogram))
    set(gca, 'ydir', 'normal')
    colormap('gray')
    clim([-70, -25])
    ylim([300, 7000])
    yticks([1000:1000:7000]);
    yticklabels(1:7)
    ylabel('Freq. (kHz)')
    clim(colorLim(j,:));
    hold on;
    
    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgPitch(b).features(sy).pitch(bgPitch(b).features(sy).pitchFlagFiltered);
    plot(xcoord, dummy, '-', 'color', [0.9290 0.6940 0.1250], 'lineWidth', 0.5)
    
    plot([timeLim1(j), timeLim1(j)+50], [1000, 1000], 'k-', 'lineWidth', 1)
    box off
    ax = gca;
    ax.XAxis.Visible = 'off';
    xlim([timeLim1(j)-0.5, timeLim2(j)+0.5])

    subplot(4,1,2)
    hold on;
    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgPitch(b).features(sy).pitch(bgPitch(b).features(sy).pitchFlagFiltered);
    plot(xcoord, dummy, '-', 'color', [0.6 0.6 0.6], 'lineWidth', 0.5)

    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predictedBad{unitsToUse, i};
    plot(xcoord, dummy, 'b-', 'lineWidth', 0.5);
    ylim(freqLim(j,:));
    xlim([timeLim1(j)-0.5, timeLim2(j)+0.5])
    plot([timeLim1(j), timeLim1(j)], [1600, 2600], 'k-', 'lineWidth', 1)
    axis off

    subplot(4,1,3)
    hold on;
    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgPitch(b).features(sy).pitch(bgPitch(b).features(sy).pitchFlagFiltered);
    plot(xcoord, dummy, '-', 'color', [0.6 0.6 0.6], 'lineWidth', 0.5)

    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predictedGood{unitsToUse, i};
    plot(xcoord, dummy, 'r-', 'lineWidth', 0.5);
    ylim(freqLim(j,:));
    xlim([timeLim1(j)-0.5, timeLim2(j)+0.5])
    plot([timeLim1(j), timeLim1(j)], [1600, 2600], 'k-', 'lineWidth', 1)
    axis off

    subplot(4,1,4)
    hold on;
    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgPitch(b).features(sy).pitch(bgPitch(b).features(sy).pitchFlagFiltered);
    plot(xcoord, dummy, '-', 'color', [0.6 0.6 0.6], 'lineWidth', 0.5)

    dummy = nan(1, length(xcoord));
    dummy(bgPitch(b).features(sy).pitchFlagFiltered) = bgFreqDecode(b).predicted{i};
    plot(xcoord, dummy, 'k-', 'lineWidth', 0.5);
    ylim(freqLim(j,:));
    xlim([timeLim1(j)-0.5, timeLim2(j)+0.5])
    plot([timeLim1(j), timeLim1(j)], [1600, 2600], 'k-', 'lineWidth', 1)
    axis off

    exportgraphics(gcf, ['Paper\Fig4_', 'bg', num2str(b), '_sy', num2str(sy), '_idx', num2str(i), '.pdf'], 'contentType', 'Vector');
end


% plot decoded frequency with original frequency, using heatmap
unitsToUse = 1;
flim = [[650, 5050]; [900, 5700]; [250, 6800]; [900, 4500]];
colorLim = [0, 60];
for b = 2
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [bgFreqDecode(b).predicted{:}];
    allPredictedGood = [bgFreqDecode(b).predictedGood{unitsToUse, :}];
    allPredictedBad = [bgFreqDecode(b).predictedBad{unitsToUse, :}];
    
    gap = 80;
    fRange = [flim(b,1):gap:flim(b,2)];
    
    pubFig([21, 0, 1.2, 1.2]);
    N = histcounts2(allPredicted, allFreq, fRange, fRange);
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, N, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap(flipud(cmap('black', 256, 0, 10)));
    daspect([1, 1, 1])
    box off
    xlabel('True freq (kHz)');
    ylabel('Decoded freq (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:5);
    xtickangle(0);
    yticklabels(1:5);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    exportgraphics(gcf, ['Paper\Fig4_decodingScatterAllUnits_bg', num2str(b), '.pdf'], 'contentType', 'vector');

    pubFig([21, 0, 1.2, 1.2]);
    N = histcounts2(allPredictedGood, allFreq, fRange, fRange);
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, N, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap(flipud(cmap('red', 256, 10)));
    daspect([1, 1, 1])
    box off
    xlabel('True freq (kHz)');
    ylabel('Decoded freq (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:5);
    xtickangle(0);
    yticklabels(1:5);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    exportgraphics(gcf, ['Paper\Fig4_decodingScatterGoodUnits_bg', num2str(b), '.pdf'], 'contentType', 'vector');

    pubFig([21, 0, 1.2, 1.2]);
    N = histcounts2(allPredictedBad, allFreq, fRange, fRange);
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, N, 'alphaData', N>0);
    colormap(flipud(cmap('blue', 256, 10)));
    set(gca, 'ydir', 'normal')
    daspect([1, 1, 1])
    box off
    xlabel('True freq (kHz)');
    ylabel('Decoded freq (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:5);
    xtickangle(0);
    yticklabels(1:5);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    exportgraphics(gcf, ['Paper\Fig4_decodingScatterBadUnits_bg', num2str(b), '.pdf'], 'contentType', 'vector');
end



% plot decoded frequency with original frequency, using heatmap and all units
figure;
for b = 1:4
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [bgFreqDecode(b).predicted{:}];
   
    gap = 50;
    fRange = [flim(b,1):gap:flim(b,2)];
    
    subplot(1,4,b)
    N = histcounts2(allPredicted, allFreq, fRange, fRange);
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, N, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap('turbo');
    daspect([1, 1, 1])
    box off
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
end


% plot bird 2
unitsToUse = 1;
flim = [250, 6800];
gap = 50;
fRange = [flim(1):gap:flim(2)];

NnormAll = zeros(length(fRange)-1, length(fRange)-1, 4);
NnormGood = zeros(length(fRange)-1, length(fRange)-1, 4);
NnormBad = zeros(length(fRange)-1, length(fRange)-1, 4);

for b = 1:4
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [bgFreqDecode(b).predicted{:}];
    allPredictedGood = [bgFreqDecode(b).predictedGood{unitsToUse, :}];
    allPredictedBad = [bgFreqDecode(b).predictedBad{unitsToUse, :}];

    Nall = histcounts2(allPredicted, allFreq, fRange, fRange);
    Ngood = histcounts2(allPredictedGood, allFreq, fRange, fRange);
    Nbad = histcounts2(allPredictedBad, allFreq, fRange, fRange);

    NnormAll(:,:,b) = Nall./sum(Nall, 'all');
    NnormGood(:,:,b) = Ngood./sum(Ngood, 'all');
    NnormBad(:,:,b) = Nbad./sum(Nbad, 'all');
end

NnormAllMean = mean(NnormAll, 3);
NnormGoodMean = mean(NnormGood, 3);
NnormBadMean = mean(NnormBad, 3);

%plot b2
pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormAll(:,:,2), 'alphaData', NnormAll(:,:,2)>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterAllUnit_bg2.pdf', 'contentType', 'vector');

pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormGood(:,:,2), 'alphaData', NnormGood(:,:,2)>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterGoodUnit_bg2.pdf', 'contentType', 'vector');


pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormBad(:,:,2), 'alphaData', NnormBad(:,:,2)>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterBadUnit_bg2.pdf', 'contentType', 'vector');

% plot all bird
pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormAllMean, 'alphaData', NnormAllMean>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterAllUnit_allBird.pdf', 'contentType', 'vector');

pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormGoodMean, 'alphaData', NnormGoodMean>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterGoodUnit_allBird.pdf', 'contentType', 'vector');


pubFig([21, 0, 1.2, 1.2]);
imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, NnormBadMean, 'alphaData', NnormBadMean>0);
set(gca, 'ydir', 'normal');
colormap('turbo');
daspect([1, 1, 1])
box off
xticks([1000:1000:flim(2)]);
yticks([1000:1000:flim(2)]);
exportgraphics(gcf, 'Paper\Fig4_DecodeScatterBadUnit_allBird.pdf', 'contentType', 'vector');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end 
