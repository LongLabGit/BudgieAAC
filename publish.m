clear;

fs = 7;

set(0,'DefaultAxesTickLabelInterpreter','tex',...    % affecting title and tick labels
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', fs, ...
    'DefaultAxesFontSizeMode', 'manual',...              % keep matlab from auto resizeing fonts
    'DefaultAxesFontName', 'Arial', ...                 % In matlab 2020a or later, use exportgraphics, which will automatically embed fonts into pdf files. Stupid Matlab will always replace font to Helvetica when printed as eps or pdf. In windows, helvetica will be replaced by Arial in AI
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
load('bgPitch.mat', 'bgPitch', 'bgPitchTuning', 'tuningThresh', 'bgPitchControl', 'bgPitchTuningCall', 'bgPitchTuningWarble');
load('zfPitch.mat', 'zfPitch', 'zfPitchTuning');

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
%%%% the human switchboard data could be accessed from the Linguistic Data Consortium
% % human switchboard
% hmAudioFile = 'HumanSpeechFromSwitchboard\sw02012B.wav';
% hmWordFile = 'HumanSpeechFromSwitchboard\sw2012B-ms98-a-word.text';
% 
% 
% [hmAudio, hmSampRate] = audioread(hmAudioFile);
% exampleHmWordWins = [234.810, 234.810+0.4; 235.9017, 235.9017+0.4;  262.8375,  262.8375+0.4];
% 
% wordLength = 420;
% unitLength = 0.0015;
% height = 0.5;
% 
% pubFig([21, 2.5, 6, 6]);
% axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*wordLength, height])
% mySpecHm(hmAudio, exampleHmWordWins(1,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 1)
% box off
% axis off
% axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*wordLength, height])
% mySpecHm(hmAudio, exampleHmWordWins(2,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% %hold on;
% %plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
% box off
% axis off
% axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*wordLength, height])
% mySpecHm(hmAudio, exampleHmWordWins(3,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% % hold on;
% % plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
% box off
% axis off
% exportgraphics(gcf, ['paper\Fig1_hmWord1.pdf'], 'ContentType','vector')
% 
% 
% exampleHmSentenceWins = [56.465, 56.465+1.45; 57.969, 57.969+1.45; 243.033, 243.033+1.45];
% sentenceLength = 1450;
% pubFig([21, 2.5, 10, 6]);
% axes('Unit', 'Inches', 'Position', [0.5, 5, unitLength*sentenceLength, height])
% mySpecHm(hmAudio, exampleHmSentenceWins(1,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% hold on;
% plot([0, 200], [1000,1000], 'k-', 'linewidth', 1)
% box off
% axis off
% axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*sentenceLength, height])
% mySpecHm(hmAudio, exampleHmSentenceWins(2,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% %hold on;
% %plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
% box off
% axis off
% axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*sentenceLength, height])
% mySpecHm(hmAudio, exampleHmSentenceWins(3,:), hmSampRate, 1, 0.6);
% clim([-100, -55]);
% ylim([300, 4000]);
% % hold on;
% % plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
% box off
% axis off
% exportgraphics(gcf, ['paper\Fig1_hmSentences.pdf'], 'ContentType','vector')



% zf piezo
zfaudio = audioread('ZF\Zebra Finch Piezo\zf1\audioCh1_HP.flac');

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
%hold on;
%plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*call1Length, height])
mySpecFull(zfaudio, exampleZfCall1Wins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
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
%hold on;
%plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*call2Length, height])
mySpecFull(zfaudio, exampleZfCall2Wins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
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
%hold on;
%plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 3, unitLength*songLength, height])
mySpecFull(zfaudio, exampleZfSongWins(3,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
exportgraphics(gcf, ['paper\Fig1_zfsongs.pdf'], 'ContentType','vector')


% budgie
bgCallAudioFile = 'Bl122_ChronicLeftAAC\Bl122_230626_092509_audioCh3.flac';
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
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*call1Length, height])
mySpecFull(bgCallAudio, exampleCall1TimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
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
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
box off
axis off
axes('Unit', 'Inches', 'Position', [2, 4, unitLength*call2Length, height])
mySpecFull(bgCallAudio, exampleCall2TimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 100], [1000,1000], 'k-', 'linewidth', 2)
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
% hold on;
% plot([0, 200], [1000,1000], 'k-', 'linewidth', 1)
box off
axis off
axes('Unit', 'Inches', 'Position', [0.5, 4, unitLength*songLength, height])
mySpecFull(bgWarbleAudio, exampleWarbleTimeWins(2,:), sampRate, 1, 0.6);
clim([-100, -55]);
ylim([300, 7000]);
% hold on;
% plot([0, 200], [1000,1000], 'k-', 'linewidth', 1)
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



%%%%%%%%% acoustic analysis for three species
load('acousticRepresentation.mat', 'bg3Duration', 'bg3EntropyVar', 'bg3MeanPitch', ...
    'bg3CallDuration', 'bgCallId', 'bg3CallEntropyVar', 'bg3CallMeanPitch',...
    'zfDuration', 'zfSyId', 'zfEntropyVar', 'zfMeanPitch',...
    'hmDuration', 'hmEntropyVar', 'hmMeanPitch', 'wordList');

% plot human separately
pubFig([25, 2, 3.8, 2.8]);
hold on;
plot3(hmDuration, hmEntropyVar, hmMeanPitch, 'r.', 'MarkerSize', 4);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('Duration (ms)')
ylabel('Entropy variance')
zlabel('Mean pitch (Hz)')
grid off
view(27.1, 55.1);
%view(30, 42.5);
axis tight;
zticks(0:1000:4000);
exportgraphics(gcf, 'paper\Fig1_acousticFeatureHm.pdf', 'contentType', 'vector');

% plot zebra finch
pubFig([25, 2, 3.8, 2.8]);
hold on;
plot3(zfDuration, zfEntropyVar, zfMeanPitch, 'b.', 'MarkerSize', 4);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('Duration (ms)')
ylabel('Entropy variance')
zlabel('Mean pitch (hz)')
grid off
view(27.1, 55.1);
%view(25.5, 18);
axis tight;
zticks(0:1000:4000);
exportgraphics(gcf, 'paper\Fig1_acousticFeatureZf.pdf', 'contentType', 'vector');

% plot budgie acoustic
pubFig([25, 2, 3.8, 2.8]);
hold on;
plot3(bg3Duration(bgI(3).warbleSyFlag), bg3EntropyVar(bgI(3).warbleSyFlag), bg3MeanPitch(bgI(3).warbleSyFlag), 'g.', 'MarkerSize', 4);
plot3(bg3CallDuration, bg3CallEntropyVar, bg3CallMeanPitch, 'g.', 'MarkerSize', 4);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('Duration (ms)')
ylabel('Entropy variance')
zlabel('Mean pitch (Hz)')
grid off
view(27.1, 55.1);
%view(30, 42.5);
axis tight;
zticks(0:1000:4000);
exportgraphics(gcf, 'paper\Fig1_acousticFeatureBg.pdf', 'contentType', 'vector');

% plot human, budgie, and zebra finch together
pubFig([25, 2, 3.8, 2.8]);
hold on;
plot3(hmDuration, hmEntropyVar, hmMeanPitch, 'r.',  'MarkerSize', 4);
plot3(zfDuration, zfEntropyVar, zfMeanPitch, 'b.', 'MarkerSize', 4);
plot3(bg3Duration(bgI(3).warbleSyFlag), bg3EntropyVar(bgI(3).warbleSyFlag), bg3MeanPitch(bgI(3).warbleSyFlag), 'g.','MarkerSize', 4);
plot3(bg3CallDuration, bg3CallEntropyVar, bg3CallMeanPitch, 'g.','MarkerSize', 4);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('Duration (ms)')
ylabel('Entropy variance')
zlabel('Mean pitch (Hz)')
grid off
view(27.1, 55.1);
%view(30, 42.5);
axis tight;
zticks(0:1000:4000);
%legend({'Human', 'Zebra finch', 'Budgerigar'})
exportgraphics(gcf, 'paper\Fig1_acousticFeatureHmZfBg.pdf', 'contentType', 'vector');



%%%%%%%%% Fig 1 neural unit quality
% spike amplitude and number of refractory period violations
spikeAmp = {};
spikeViolation = {};
for b = 1:4
    load(bgI(b).suaFile, 'sua', 'suaWav');
    thisSpikeAmp = [];
    thisSpikeViolation = [];
    for i = 1:length(suaWav)
        meanWaveform = suaWav(i).meanWaveforms(8:48)*0.195;
        thisSpikeAmp(i) = max(meanWaveform) - min(meanWaveform);
        
        spikeTimes = sua(i).spikeTimes;
        thisSpikeViolation(i) = sum(abs(spikeTimes(2:end)-spikeTimes(1:end-1))<0.001)/length(spikeTimes);
    end
    spikeAmp{b} = thisSpikeAmp;
    spikeViolation{b} = thisSpikeViolation;
end

pubFig([21, 0,  2, 1.5])
histogram([spikeAmp{:}], 20, 'facecolor', [0.3, 0.3, 0.3], 'edgecolor', 'none')
xlabel('Peak-to-peak amp. (uV)')
ylabel('Count')
xticks(50:50:600)
xtickangle(0)
box off
exportgraphics(gcf, ['paper\Fig1_spikeAmpDist.pdf'], 'contentType', 'vector');

pubFig([21, 0, 2, 1.5])
histogram([spikeViolation{:}]*100, [0:.025:2], 'facecolor', [0.3, 0.3, 0.3], 'edgecolor', 'none');
xlabel('ISI violation (%)')
ylabel('Count')
box off
exportgraphics(gcf, ['paper\Fig1_ISIViolation.pdf'], 'contentType', 'vector');




%%%%%%%%% Fig1 neural
% zf example song and baseline response
z = 1;
zfaudio = audioread(zfI(z).audioFile);
zfsua = getZfSua(zfI(z).dataFile);


% example song

%timeWin = zfI(z).song1;
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

% % FR
% for b = 1:length(zfResp)
%     figure;
%     hold on;
%     plot([0,150], [0, 150], 'k-');
%     plot(zfResp(b).meanFrBaseline, zfResp(b).meanFrVocal, 'ro', 'markersize', 5)
%     axis image
%     xlabel('Mean Firing Rate During Baseline (spikes/s)');
%     ylabel('Mean Firing Rate During Vocalization (spikes/s)');
%     set(gca,'TickDir','out');
%     title(zfResp(b).birdId);
% end

% example fr 
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,150], [0, 150], 'k-');
plot(zfResp(z).meanFrBaseline, zfResp(z).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.15)
axis image
%title(zfResp(z).birdId);
title('ZF1');
xticks([0, 75, 150])
yticks([0, 75, 150])
xlabel('Baseline');
ylabel('Vocal');
%fontsize(gcf, 30, "points")
exportgraphics(gcf, 'Paper\Fig1_zfExampFR.pdf', 'contentType', 'vector')
p = ranksum(zfResp(z).meanFrBaseline, zfResp(z).meanFrVocal)

% other birds
for sz = 2:7
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,150], [0, 150], 'k-');
    plot(zfResp(sz).meanFrBaseline, zfResp(sz).meanFrVocal, 'ko', 'markersize', 2, 'LineWidth', 0.15)
    axis image
    %title(zfResp(z).birdId);
    title(['ZF' num2str(sz)]);
    xticks([0, 75, 150])
    yticks([0, 75, 150])
    xlabel('Baseline');
    ylabel('Vocal');
    %fontsize(gcf, 30, "points")
    exportgraphics(gcf, ['Paper\Fig1_zfExampFR' num2str(sz) '.pdf'], 'contentType', 'vector')
end

% all birds mean fr
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,150], [0, 150], 'k-');
plot([zfResp(:).meanFrBaseline], [zfResp(:).meanFrVocal], 'ko', 'markersize', 2, 'LineWidth', 0.15)
axis image
set(gca,'TickDir','out');
title('Pop. (N=7)');
xticks([0, 75, 150])
yticks([0, 75, 150])
xlabel('Baseline');
ylabel('Vocal');
%fontsize(gcf, 30, "points")
exportgraphics(gcf, 'Paper\Fig1_zfAllFR.pdf', 'contentType', 'vector')
p = ranksum([zfResp(:).meanFrBaseline], [zfResp(:).meanFrVocal])



% example zf burst ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot(zfResp(z).percentBaselineBurst, zfResp(z).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
set(gca,'TickDir','out');
%title(zfResp(z).birdId);
title('ZF1')
xticks([0 0.25 0.5])
yticks([0 0.25 0.5])
xlabel('Baseline');
ylabel('Vocal');
% fontsize(gcf, 30, "points")
exportgraphics(gcf, 'Paper\Fig1_zfExampBurst.pdf', 'contentType', 'vector')
p = ranksum(zfResp(z).percentBaselineBurst, zfResp(z).percentSyllableBurst)



for sz = 2:7
    pubFig([21, 2.5, 1 1]);
    hold on;
    plot([0,1], [0, 1], 'k-');
    plot(zfResp(sz).percentBaselineBurst, zfResp(sz).percentSyllableBurst, 'ko', 'markersize', 2, 'LineWidth', 0.25)
    axis image
    xlim([0, 0.5]);
    ylim([0, 0.5]);
    set(gca,'TickDir','out');
    %title(zfResp(z).birdId);
    title(['ZF' num2str(sz)])
    xticks([0 0.25 0.5])
    yticks([0 0.25 0.5])
    xlabel('Baseline');
    ylabel('Vocal');
    % fontsize(gcf, 30, "points")
    exportgraphics(gcf, ['Paper\Fig1_zfExampBurst' num2str(sz) '.pdf'], 'contentType', 'vector')
end


% all bird burst time ratio
pubFig([21, 2.5, 1 1]);
hold on;
plot([0,1], [0, 1], 'k-');
plot([zfResp(:).percentBaselineBurst], [zfResp(:).percentSyllableBurst], 'ko', 'markersize', 2, 'LineWidth', 0.25)
axis image
xlim([0, 0.5]);
ylim([0, 0.5]);
set(gca,'TickDir','out');
title('Pop. (N=7)');
xticks([0 0.25 0.5])
yticks([0 0.25 0.5])
xlabel('Baseline');
ylabel('Vocal');
%fontsize(gcf, 30, "points")
exportgraphics(gcf, 'Paper\Fig1_zfAllBurst.pdf', 'contentType', 'vector')
p = ranksum([zfResp(:).percentBaselineBurst], [zfResp(:).percentSyllableBurst])




%%% budgie bird 3
b = 3;

audio = audioread(bgI(3).audioFile);
load(bgI(3).suaFile, 'sua');

% example warble
%timeWin = [2064.153 2065.056];
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
timeWin = [7758.03 7758.27];
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
ambientAudio = audioread('Bl122_ChronicLeftAAC\audioCh2_HP.flac');

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
%fontsize(gcf, 30, "points")
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgExampFR.pdf', 'contentType', 'vector')
p = ranksum(bgResp(3).meanFrBaseline, bgResp(3).meanFrVocal)


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
    %fontsize(gcf, 30, "points")
    title(['BG' num2str(sb)]);
    exportgraphics(gcf, ['Paper\Fig1_bgExampFROtherBird', num2str(sb), '.pdf'], 'contentType', 'vector')
    p = ranksum(bgResp(sb).meanFrBaseline, bgResp(sb).meanFrVocal)
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
%fontsize(gcf, 30, "points")
title('Pop. (N=4)');
exportgraphics(gcf, 'Paper\Fig1_bgAllFR.pdf', 'contentType', 'vector')
p = ranksum([bgResp.meanFrBaseline], [bgResp.meanFrVocal])



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
%fontsize(gcf, 30, "points")
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
%fontsize(gcf, 30, "points")
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
%fontsize(gcf, 30, "points")
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
%fontsize(gcf, 30, "points")
title('BG3');
exportgraphics(gcf, 'Paper\Fig1_bgExampBurst.pdf', 'contentType', 'vector')
p = ranksum(bgResp(3).percentBaselineBurst, bgResp(3).percentSyllableBurst)



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
    %fontsize(gcf, 30, "points")
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
%fontsize(gcf, 30, "points")
title('Pop. (N=4)');
exportgraphics(gcf, 'Paper\Fig1_bgAllBurst.pdf', 'contentType', 'vector')
p = ranksum([bgResp.percentBaselineBurst], [bgResp.percentSyllableBurst])



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
    edges = [0:1:50];
    y = histcounts(cell2mat(bgResp(i).ISI)*1000, edges);
    isiPooled = [isiPooled; y/sum(y)];
end

pubFig([21,0, 3, 1.2]);
plot(edges(1:end-1)+1/2, mean(isiPooled, 1), 'k-');
box off;
xticks(0:5:50);
%xlim([0,40]);
%title(bgResp(i).birdId)
%title()
xlabel('Inter spike interval (ms)')
ylabel('Ratio')
exportgraphics(gcf, ['Paper\Fig1_ISIBGAll.pdf'], 'contentType', 'vector');



%%%%%% alignment to beginning of vocalization
respWinSize = 120;  % [-100, 100]


goodGap = 0.1;

startAlignedResp = cell(1,4);
for i = 1:4
    % find good syllable start
    dist = bgI(i).syTimeWin(2:end,1) - bgI(i).syTimeWin(1:end-1,2);
    fineSyllableStart = bgI(i).syTimeWin(find(dist>goodGap)+1, 1);
    load(bgI(i).suaFile, 'sua');

    alignedResp = zeros(length(sua), 2*respWinSize+1);
    for u = 1:length(sua)
        u
        spikeAcrossTrials = cell(1,length(fineSyllableStart));
        for x = 1:length(fineSyllableStart)
            spikeAcrossTrials{x} = sua(u).spikeTimes(sua(u).spikeTimes>=(fineSyllableStart(x)-respWinSize/1000) &...
                sua(u).spikeTimes<=(fineSyllableStart(x)+respWinSize/1000))*1000;
        end
        thisAlignedResp = zeros(1, 2*respWinSize+1);
        for x = 1:length(fineSyllableStart)
            winStart = floor(fineSyllableStart(x)*1000)-respWinSize;
            for y = 1:length(thisAlignedResp)
                thisAlignedResp(y) = thisAlignedResp(y) + sum(((spikeAcrossTrials{x}>=winStart) & (spikeAcrossTrials{x}<(winStart+1))));
                winStart = winStart+1;
            end
        end
        alignedResp(u,:) = thisAlignedResp./length(fineSyllableStart)*1000;
    end
    startAlignedResp{i} = alignedResp;
end

endAlignedResp = cell(1,4);
for i = 1:4
    % find good syllable start
    dist = bgI(i).syTimeWin(2:end,1) - bgI(i).syTimeWin(1:end-1,2);
    fineSyllableEnd = bgI(i).syTimeWin(find(dist>goodGap), 2);
    load(bgI(i).suaFile, 'sua');

    alignedResp = zeros(length(sua), 2*respWinSize+1);
    for u = 1:length(sua)
        u
        spikeAcrossTrials = cell(1,length(fineSyllableEnd));
        for x = 1:length(fineSyllableEnd)
            spikeAcrossTrials{x} = sua(u).spikeTimes(sua(u).spikeTimes>=(fineSyllableEnd(x)-respWinSize/1000) &...
                sua(u).spikeTimes<=(fineSyllableEnd(x)+respWinSize/1000))*1000;
        end
        thisAlignedResp = zeros(1, 2*respWinSize+1);
        for x = 1:length(fineSyllableEnd)
            winStart = floor(fineSyllableEnd(x)*1000)-respWinSize;
            for y = 1:length(thisAlignedResp)
                thisAlignedResp(y) = thisAlignedResp(y) + sum(((spikeAcrossTrials{x}>=winStart) & (spikeAcrossTrials{x}<(winStart+1))));
                winStart = winStart+1;
            end
        end
        alignedResp(u,:) = thisAlignedResp./length(fineSyllableEnd)*1000;
    end
    endAlignedResp{i} = alignedResp;
end

    
% plot time aligned start resp
for i = 1:4
    pubFig([21, 0, 1.5,0.85]);
    plot(-respWinSize:respWinSize, mean(startAlignedResp{i},1), 'k-');
    xlim([-100, 100]);
    box off
    xticks([-100:10:100])
    xtickangle(0)
    xline(0, '--')
    %xline([-30, -5], 'r')
    xlabel('Time to onset (ms)')
    ylabel('Spikes/s')
    % title(['BG', num2str(i)])
    exportgraphics(gcf, ['Paper\Fig1_timeAlignedAnalysisOnsegB', num2str(i), '_mean.pdf'], 'contentType', 'vector')
end


% plot time aligned end resp
for i = 1:4
    pubFig([21, 0, 1.5,0.85]);
    plot(-respWinSize:respWinSize, mean(endAlignedResp{i},1), 'k-');
    xlim([-100, 100]);
    box off
    xticks([-100:10:100])
    xtickangle(0)
    xline(0, '--')
    xlabel('Time to offset (ms)')
    ylabel('Spikes/s')
    % title(['BG', num2str(i)])
    exportgraphics(gcf, ['Paper\Fig1_timeAlignedAnalysisOffsetB', num2str(i), '_meanEnd.pdf'], 'contentType', 'vector')
end


%%%%%%%% sparseness of neural response
zfSparseness = cell(length(zfI),1);
for i = 1:length(zfI)
    tmp = zfResp(i).frVocal;
    zfSparseness{i} = (mean(tmp, 2)).^2 ./ mean(tmp.^2,2);
end

bgSparseness = cell(length(bgI),1);
for i = 1:length(bgI)
    tmp = bgResp(i).frVocal;
    bgSparseness{i} = (mean(tmp, 2)).^2 ./ mean(tmp.^2,2);
end

mean(cell2mat(zfSparseness))
std(cell2mat(zfSparseness))

mean(cell2mat(bgSparseness))
std(cell2mat(bgSparseness))

ranksum(cell2mat(zfSparseness), cell2mat(bgSparseness))

data = {};
pubFig([21, 2.5, 1.3, 1])
data{1} = cell2mat(bgSparseness);
data{2} = cell2mat(zfSparseness);
h = daviolinplot(data, 'color', [0.4660 0.6740 0.1880;0.8500 0.3250 0.0980], 'outliers',0,...
    'box',3,'boxcolor','w','scatter',1,'jitter',1,'scattercolor','same',...
    'scattersize',6,'scatteralpha',0.7, 'xtlabels', {'BG', 'ZF'});
ylabel('Sparseness')
xlim([0.5, 2.5])
ylim([0, 0.8])
exportgraphics(gcf, 'Paper\Fig1_sparseness.pdf', 'contentType', 'vector');


%%%%%%%%%%%%%%%%%% Fig 2 

%%%%% same syllables
%%%%%%  zf same syllable 
z = 1;   %zfBirdIds(cIdx);

zfAudio = audioread(zfI(z).audioFile);
zfSua = getZfSua(zfI(z).dataFile);

load('Fig1And2_zfbgNewOrder.mat', 'zfNewOrder');


i= 1; 

instWin = round(zfI(z).song1Syllables(i,:)*1000);
instWin = [instWin(:,1)-10, instWin(:,2)+10];
[instFR, ~, ~, ~, ~, ~, instFRZ, ~] = calInstFR(zfSua, instWin-12);

instFRGroup = cell2mat(zfcorr(z).corrFR1');
meanFR = mean(instFRGroup, 2);
stdFR = std(instFRGroup, [], 2);

instFRZ2 = cell(size(instFR,2),1);
for i = 1:length(instFRZ2)
    tmp = cell2mat(instFR(:,i));
    instFRZ2{i} = (tmp-repmat(meanFR, [1, size(tmp,2)])) ./ repmat(stdFR, [1, size(tmp,2)]);
end


instFr = instFRZ2{1};
plotInstFR(zfSua, zfAudio, [zfI(z).song1Syllables(i,1)-0.01, zfI(z).song1Syllables(i,2)+0.01], sampRate, instFr(zfNewOrder,:), 0, 0, 0, 3, 12)
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
f = fopen(fullfile('Bl122_ChronicLeftAAC\exampleResp.txt'), 'r');
exampleLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
exampleRespWin = exampleLabel(exampleLabel(:,3)==1,1:2);   % example call resp
scaleWin1 = exampleLabel(exampleLabel(:,3)==2,1:2);
lengthExampleWin = exampleRespWin(:,2)-exampleRespWin(:,1);
[~, sortOrder] = sort(lengthExampleWin);

instWin = round(exampleRespWin*1000);
instWin = [instWin(:,1)-20, instWin(:,2)+20];
[instFR, ~, ~, ~, ~, ~, instFRZ, ~] = calInstFR(sua, instWin-12);

instFRGroup = cell2mat(bgcorr(b).corrFR');
meanFR = mean(instFRGroup, 2);
stdFR = std(instFRGroup, [], 2);

instFRZ2 = cell(size(instFR,2),1);
for i = 1:length(instFRZ2)
    tmp = cell2mat(instFR(:,i));
    instFRZ2{i} = (tmp-repmat(meanFR, [1, size(tmp,2)])) ./ repmat(stdFR, [1, size(tmp,2)]);
end

i = 1;
instFr = instFRZ2{i};
plotInstFR(sua, audio, [exampleRespWin(i,1)-0.02, exampleRespWin(i,2)+0.02], sampRate, instFr(bgNewOrder,:), 0, 0, 0, 3, 12)
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-105, -50]);
axes(ax(2));
hold on
plot([exampleRespWin(i,1), exampleRespWin(i,1)+0.1], [1000 1000])
axis off
axes(ax(1));
yticks([1, length(sua)])
xlabel([]);
%clim
clim([-1, 4]);
ax(1).XAxis.Visible = 'off';
drawnow();
exportgraphics(gcf, ['paper\Fig2_bgSameSyInstFR1' '.pdf'], 'ContentType', 'vector')

% plot multiple trials
unitsToPlot = [10, 12, 36, 33, 11, 37, 3];
unitsToPlotIDNewOrder = arrayfun(@(x) find(bgNewOrder==x), unitsToPlot);
[unitsToPlotIDNewOrderSorted, uSortOrder] = sort(unitsToPlotIDNewOrder);

f = plotRasterMultipleTrials(sua(bgNewOrder), unitsToPlotIDNewOrderSorted, audio, exampleRespWin(sortOrder(1:7),:), 1, scaleWin1(sortOrder(1:7),:), 30000, 0, 0, [], 20, 3, 12);
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
        plot([segStart, segStart+0.02-0.001], [2000, 2000]);
    end
   
    axis off
    axes(ax(1));
    %yticks([1, length(zfSua)])
    xlabel([]);
    %clim
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
    %yticks([1, length(zfSua)])
    xlabel([]);
    %clim
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
        plot([segStart, segStart+0.02-0.001], [2000, 2000]);
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
    %clim
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
corrEdges = -1:0.01:1;
pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap(zfSegNeuralSpecCorr(z).scorr, zfSegNeuralSpecCorr(z).ncorr, corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['ZF', num2str(z), ' \rho = ', num2str(corr(zfSegNeuralSpecCorr(z).scorr', zfSegNeuralSpecCorr(z).ncorr','type', 'spearman'))])
[r, p] = corr(zfSegNeuralSpecCorr(z).scorr', zfSegNeuralSpecCorr(z).ncorr','type', 'spearman')
xlim([-0.4, 0.8])
ylim([-0.2 0.35])
daspect([1.8,1,1])
box off
xticks([-0.4:0.4:0.8])
xtickangle(0)
yticks([-0.2:0.1:0.3])
exportgraphics(gcf, ['Paper\Fig2_zfCorrZF' num2str(z) '.pdf'], 'ContentType', 'vector');

pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap([zfSegNeuralSpecCorr(:).scorr], [zfSegNeuralSpecCorr(:).ncorr], corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['ZF All \rho = ', num2str(corr([zfSegNeuralSpecCorr(:).scorr]', [zfSegNeuralSpecCorr(:).ncorr]','type', 'spearman'))])
[r, p] = corr([zfSegNeuralSpecCorr(:).scorr]', [zfSegNeuralSpecCorr(:).ncorr]','type', 'spearman')
xlim([-0.4, 0.8])
ylim([-0.2 0.35])
daspect([1.8,1,1])
box off
xticks([-0.4:0.4:0.8])
xtickangle(0)
yticks([-0.2:0.1:0.3])
exportgraphics(gcf, 'Paper\Fig2_zfCorrAll.pdf', 'ContentType', 'vector');



corrEdges = -1:0.01:1;
pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap(bgSegNeuralSpecCorr(b).scorr, bgSegNeuralSpecCorr(b).ncorr, corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['BG', num2str(b), ' \rho = ', num2str(corr(bgSegNeuralSpecCorr(b).scorr', bgSegNeuralSpecCorr(b).ncorr','type', 'spearman'))])
[r, p] = corr(bgSegNeuralSpecCorr(b).scorr', bgSegNeuralSpecCorr(b).ncorr','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, ['Paper\Fig2_bgCorrBG', num2str(b), '.pdf'], 'ContentType', 'vector');


% exclude spec corr larger than 0.6
corrEdges = -1:0.01:1;
pubFig([21, 2.5, 2, 2]);
N = plotHeatmap(bgSegNeuralSpecCorr(b).scorr(bgSegNeuralSpecCorr(b).scorr<0.6), bgSegNeuralSpecCorr(b).ncorr(bgSegNeuralSpecCorr(b).scorr<0.6), corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['BG', num2str(b), ' \rho=', num2str(corr(bgSegNeuralSpecCorr(b).scorr(bgSegNeuralSpecCorr(b).scorr<0.6)', bgSegNeuralSpecCorr(b).ncorr(bgSegNeuralSpecCorr(b).scorr<0.6)','type', 'spearman'))])
[r, p] = corr(bgSegNeuralSpecCorr(b).scorr(bgSegNeuralSpecCorr(b).scorr<0.6)', bgSegNeuralSpecCorr(b).ncorr(bgSegNeuralSpecCorr(b).scorr<0.6)','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, ['Paper\Fig2_bgCorrExcludeDiffRendBG', num2str(b), '.pdf'], 'ContentType', 'vector');


pubFig([21, 2.5, 1.5, 1.5]);
N = plotHeatmap([bgSegNeuralSpecCorr(:).scorr], [bgSegNeuralSpecCorr(:).ncorr], corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['Bg All \rho = ', num2str(corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]','type', 'spearman'))])
[r, p] = corr([bgSegNeuralSpecCorr(:).scorr]', [bgSegNeuralSpecCorr(:).ncorr]','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, 'Paper\Fig2_bgCorrBGAll.pdf', 'ContentType', 'vector');


% exclude spec corr larger than 0.6
pubFig([21, 2.5, 2, 2]);
tmpScorr = [bgSegNeuralSpecCorr(:).scorr];
tmpNcorr = [bgSegNeuralSpecCorr(:).ncorr];
N = plotHeatmap(tmpScorr(tmpScorr<0.6), tmpNcorr(tmpScorr<0.6), corrEdges, corrEdges, 0, 0);
imagesc(corrEdges, corrEdges, N, 'AlphaData', N>0);
colormap('turbo')
set(gca,'ydir','normal');
cb = colorbar;
cb.Ticks = clim;
ylabel('Neural corr')
xlabel('Spec corr')
title(['Bg All \rho = ', num2str(corr(tmpScorr(tmpScorr<0.6)', tmpNcorr(tmpScorr<0.6)','type', 'spearman'))])
[r, p] = corr(tmpScorr(tmpScorr<0.6)', tmpNcorr(tmpScorr<0.6)','type', 'spearman')
xlim([-0.69, 0.88])
ylim([-0.38 0.8])
daspect([1.4,1,1])
box off
xticks([-0.6:0.3:1])
xtickangle(0)
yticks([-0.3:0.3:0.9])
exportgraphics(gcf, 'Paper\Fig2_bgCorrExcludeDiffRendBGAll.pdf', 'ContentType', 'vector');



% plot distribution of neural corr for zebra finch and budgerigars
pubFig([21, 2.5, 1.75,1.75])
hold on;
histogram([zfSegNeuralSpecCorr(:).ncorr], -0.5:0.05:0.9, 'normalization', 'probability');
histogram([bgSegNeuralSpecCorr(:).ncorr], -0.5:0.05:0.9, 'normalization', 'probability');
xlim([-0.5, 0.9]);
xticks([-0.5:0.25:1]);
ylabel('Ratio')
xlabel('Neural corr')
legend({'Zebra finch', 'Budgerigar'})
p = ranksum([zfSegNeuralSpecCorr(:).ncorr], [bgSegNeuralSpecCorr(:).ncorr])
exportgraphics(gcf, 'Paper\Fig2_ZFandBGNeuralCorrDist.pdf', 'contentType', 'vector');


%%% control analysis for different renditions of the same components
zfaudio = audioread('ZF\Zebra Finch Piezo\zf1\audioCh1_HP.flac');

zfSyFile = 'zebraFinchPiezoSyllablesWithCalls.txt';
f = fopen(zfSyFile, 'r');
zfVocalLabel = fscanf(f, "%f %f %d", [3 Inf])';
fclose(f);
zfVocalTimeWin = zfVocalLabel(:,1:2);
zfSyId = zfVocalLabel(:,3);


% calcualte corr between renditions and between different pieces
syToChoose = {[19,39,40,42,46,55,60,70,71,82],...
    [5,12,17,50,56,62,65,69,77,102],...
    [8,10,11,20,26,41,45,51,56,83],...
    [15,16,17,37,46,50,52,88,89,11]};

allSysSpecSeg = {};
for i = 1:4
    tmp = round(zfVocalTimeWin(zfSyId==i,:)*1000);
    sysSpec = processSpec(zfaudio, tmp(syToChoose{i},:), sampRate);
    
    sysSpecSeg = {};
    for j = 1:length(sysSpec)
        t = sysSpec{j};
        p = 1;
        pIdx = 1;
        while p+19<=size(t,2)
            sysSpecSeg{j, pIdx} = t(:, p:p+19);
            p = p+10;
            pIdx = pIdx+1;
        end
    end
    allSysSpecSeg{i} = sysSpecSeg;

    thisSysSpec = sysSpec;
    unitLength = 0.008;
    gap = 0.05;
    height = 0.5;
    pubFig([21, 0, 7, 6])
    curX = 0.5;
    curY = 5.8;
    for j=1:length(thisSysSpec)
        if curX+unitLength*size(thisSysSpec{j},2)>0.5
            curY = curY - gap - height;
            curX = 0.5;
        end
        axes('Unit', 'Inches', 'Position', [curX, curY, unitLength*size(thisSysSpec{j},2), height]);
        imagesc(1:size(thisSysSpec{j},2), 300:5:7000, thisSysSpec{j});
        set(gca, 'ydir', 'normal');
        colormap(turbo);
        clim([-105, -60]);
        axis off;
        curX = curX + gap + unitLength*size(thisSysSpec{j},2);
    end
    hold on;
    plot([1, 101], [1000, 1000], 'k-');
    plot([1, 21], [500, 500], 'r-')
    exportgraphics(gcf, ['Paper\Fig2_zfpiezoSy', num2str(i), '.pdf'], 'ContentType', 'vector');
end

rendCorr = []; %correlation between different renditions of the same piece
crossCorr = []; %correlation between different pieces
for i = 1:4
    sysSpecSeg = allSysSpecSeg{i};
    for m = 1:length(sysSpec)
        for n = (m+1):length(sysSpec)
            for k = 1:size(sysSpecSeg,2)
                rendCorr = [rendCorr, corr(sysSpecSeg{m, k}(:), sysSpecSeg{n,k}(:))];
            end
        end
    end

    for k = (i+1):4
        segs1 = sysSpecSeg(:);
        segs2 = allSysSpecSeg{k}(:);
        for m = 1:length(segs1)
            for n = 1:length(segs2)
                crossCorr = [crossCorr, corr(segs1{m}(:), segs2{n}(:))];
            end
        end
    end
end


mean(rendCorr)
std(rendCorr)

mean(crossCorr)
std(crossCorr)

pubFig([21,0,2.5,2.5]);
hold on;
histogram(rendCorr,20, 'normalization', 'probability');
histogram(crossCorr, 40, 'normalization', 'probability');
legend({'Vocal reuse', 'Vocal similarity'})
xticks([-0.6:0.2:1])
xline(0.6)
xlabel('Spec corr')
ylabel('Ratio')
exportgraphics(gcf, 'paper\Fig2_zfpiezo_histScorr.pdf', 'contentType', 'vector')


pubFig([21,0,2, 2])
hold on
histogram(zfSegNeuralSpecCorr(7).scorr, 30, 'normalization', 'probability');
histogram(crossCorr, 40, 'normalization', 'probability');
xlabel('Spec corr')
ylabel('Ratio')
legend({'ZF7', 'ZF piezo'})
exportgraphics(gcf, 'paper\Fig2_zfscorrHistAmbientPiezo.pdf', 'contentType', 'vector')


for i = 1:length(bgcorr)
    pubFig([21,0, 1.75,1.75]);
    h = histogram(bgSegNeuralSpecCorr(i).scorr, 40, 'normalization', 'probability', 'facecolor', [0.5,0.5,0.5]);
    plotHistRangeColored(h, [], 0.6, 'k')
    sum(bgSegNeuralSpecCorr(i).scorr>=0.6)/length(bgSegNeuralSpecCorr(i).scorr)
    xticks([-1:0.2:1])
    xlabel('Spec corr')
    ylabel('Ratio')
    box off
    xline(0.6)
    exportgraphics(gcf, ['paper\Fig2_bg', num2str(i), '_histScorr.pdf'], 'contentType', 'vector')
end



%%%%%%%%%%%%%%%%%% Fig 3   
%%% the calculation of distance between and within categories takes a lot
%%% of memory, clear all unused variables before running this figure
clear all;
load('bgI.mat');
load('zfI.mat', 'zfI');
load('bgResp.mat');
load('zfResp.mat');
load('bgFrSpec.mat', 'bgcorr');
load('zfFrSpec.mat', 'zfcorr');
load('bgzfpiecewisecorr_bgAllSy.mat');
load('bgPitch.mat', 'bgPitch', 'bgPitchTuning', 'tuningThresh', 'bgPitchControl', 'bgPitchTuningCall', 'bgPitchTuningWarble');
load('zfPitch.mat', 'zfPitch', 'zfPitchTuning');
sampRate = bgI(1).sampRate;

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


%%% full spec plot
plotRasterWithHarmLow2behavFullSpec(sua, audio, timeWin, 30000, 0, [], 0, 3, 0, {x, hNoLowFreq, l}, {x, harm});
ax = findall(gcf, 'type', 'axes');
clim(ax(4), [-102, -60]);
axes(ax(4));
ylim([0, 15000])
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
xEnd = xlim();
plot([xEnd(2)-0.1, xEnd(2)], [0.3, 0.3], 'k-', 'lineWidth', 1)
exportgraphics(gcf, 'Paper\Fig3_songExampleRasterWithBehavMeasurementsNewFullSpec.pdf', 'contentType', 'Vector')


%%% scree plot 
pubFig([21, 2, 1.5, 1.5]); 
hold on;
for i = 1:4
    plot(1:10, bgPitch(i).latent(1:10), '.-');
    box off
    xticks(1:10);
end
xlabel('PC')
ylabel('Eigenvalue')
ylim([0, 82])
legend({'BG1', 'BG2', 'BG3', 'BG4'});
legend('boxoff')
xtickangle(0)
exportgraphics(gcf, 'Paper\Fig3_screeEigenvalue.pdf', 'contentType', 'vector');

pubFig([21, 2, 1.5, 1.5]); 
hold on;
for i = 1:4
    plot(1:10, bgPitch(i).explained(1:10), '.-');
    box off
    xticks(1:10);
end
xlabel('PC')
ylabel('Explained Variance (%)')
legend({'BG1', 'BG2', 'BG3', 'BG4'});
legend('boxoff')
xtickangle(0)
exportgraphics(gcf, 'Paper\Fig3_screeExplainedVariance.pdf', 'contentType', 'vector');



%%% get the catergories
bgCat = struct();
bgCatSubSamp = struct();
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

    subSampMask = zeros(1, length(bgPitch(i).allPitch));
    subSampMask(1:25:end) = true;
    bgCatSubSamp(i).subSampMask = subSampMask;

    bgCatSubSamp(i).lowCoord = bgPitch(i).score(bgCat(i).lowFreqFlagFiltered & subSampMask, 1:nPC);
    bgCatSubSamp(i).tonalCoord = bgPitch(i).score(bgCat(i).tonalFlagFiltered & subSampMask, 1:nPC);
    bgCatSubSamp(i).noiseCoord = bgPitch(i).score(bgCat(i).noiseFlagFiltered & subSampMask, 1:nPC);
    bgCatSubSamp(i).mixedCoord = bgPitch(i).score(bgCat(i).mixedFlagFiltered & subSampMask, 1:nPC);
end

% if wanted to run the spike times shifting analyses
%save('bgCat.mat', 'bgCat');

% get dist
% takes 50 min to run
tic
for i = 1:4
    i
    bgCat(i).distTonal = pdist(bgCat(i).tonalCoord);
    bgCat(i).distNoise = pdist(bgCat(i).noiseCoord);
    bgCat(i).distLowCoord = pdist(bgCat(i).lowCoord);
    bgCat(i).distMixed = pdist(bgCat(i).mixedCoord);
    bgCat(i).distWithin = [bgCat(i).distTonal, bgCat(i).distNoise, bgCat(i).distLowCoord, bgCat(i).distMixed];

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
toc


% get dist for subsample
for i = 1:4
    i
    bgCatSubSamp(i).distTonal = pdist(bgCatSubSamp(i).tonalCoord);
    bgCatSubSamp(i).distNoise = pdist(bgCatSubSamp(i).noiseCoord);
    bgCatSubSamp(i).distLowCoord = pdist(bgCatSubSamp(i).lowCoord);
    bgCatSubSamp(i).distMixed = pdist(bgCatSubSamp(i).mixedCoord);

    bgCatSubSamp(i).distBetween = [reshape(pdist2(bgCatSubSamp(i).tonalCoord, bgCatSubSamp(i).noiseCoord), 1, []), ...
        reshape(pdist2(bgCatSubSamp(i).tonalCoord, bgCatSubSamp(i).lowCoord), 1, []),...
        reshape(pdist2(bgCatSubSamp(i).tonalCoord, bgCatSubSamp(i).mixedCoord), 1, []),...
        reshape(pdist2(bgCatSubSamp(i).noiseCoord, bgCatSubSamp(i).lowCoord), 1, []),...
        reshape(pdist2(bgCatSubSamp(i).noiseCoord, bgCatSubSamp(i).mixedCoord), 1, []),...
        reshape(pdist2(bgCatSubSamp(i).mixedCoord, bgCatSubSamp(i).lowCoord), 1, [])];

    bgCatSubSamp(i).rankSumTonalP = ranksum(bgCatSubSamp(i).distBetween, bgCatSubSamp(i).distTonal);
    bgCatSubSamp(i).rankSumNoiseP = ranksum(bgCatSubSamp(i).distBetween, bgCatSubSamp(i).distNoise);
    bgCatSubSamp(i).rankSumLowP = ranksum(bgCatSubSamp(i).distBetween, bgCatSubSamp(i).distLowCoord);
    bgCatSubSamp(i).rankSumMixedP = ranksum(bgCatSubSamp(i).distBetween, bgCatSubSamp(i).distMixed);
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
xticks([0:0.25:1])
xtickangle(0)
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
xticks([0:0.25:1])
xtickangle(0)
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
xticks([0:0.25:1])
xtickangle(0)
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


% create a movie to rotate the whole thing
pubFig([21, -3, 13,13])
for b = 1:4
    subplot(4, 4, (b-1)*4+1)
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
    
    subplot(4, 4, (b-1)*4+2)
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
    
    subplot(4, 4, (b-1)*4+3)
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

    subplot(4, 4, (b-1)*4+4)
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
end

stateSpaceVideo = VideoWriter('Paper\SupplementaryVideo1.mp4', 'MPEG-4');
stateSpaceVideo.FrameRate = 5;
open(stateSpaceVideo);
initialView = [-30.1, 34];
for k = 0:5:359
    for s = 1:16
        subplot(4,4,s);
        view(initialView(1)+k, initialView(2));
    end
    frame = getframe(gcf);
    writeVideo(stateSpaceVideo, frame);
end
close(stateSpaceVideo);
close all

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
    [bgCat(i).rankSumLowP, bgCat(i).rankSumMixedP, bgCat(i).rankSumNoiseP, bgCat(i).rankSumTonalP]
end


% takes about 40 mins to run
for i = 1:4
    i
    [cdfWithin, posWithin] = myCdf(bgCat(i).distWithin);
    [cdfBetween, posBetween] = myCdf(bgCat(i).distBetween);

    bgCat(i).rankSumBewteenWithin = ranksum(bgCat(i).distBetween, bgCat(i).distWithin);

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
[bgCat.rankSumBewteenWithin]


% compare dist between true and shuffled data
for i = 1:4
    dDist = mean(bgCat(i).distBetween) - mean(bgCat(i).distWithin)
    load(['Fig3_shuffledSpikesAcousticCatDistStatBg', num2str(i), '.mat']);
    pubFig([21, 5, 1.5, 1.5]);
    nullDdist = [distStat(:).distBetweenMean] - [distStat(:).distWithinMean];
    histogram(nullDdist, 10, 'faceColor', [0.5, 0.5, 0.5], 'edgeColor', 'none');
    max(nullDdist)
    xline(dDist);
    box off;
    xlim([-1, 10]);
    xticks(0:2:10);
    xlabel('Betw. Dist. - Within Dist.')
    ylabel('Count')
    exportgraphics(gcf, ['paper\Fig3_BetweenWithinCatDistNull', num2str(i), '.pdf']);
end

% plot distance cdf for subsamp
for i = 1:4
    [cdfTonal, posTonal] = myCdf(bgCatSubSamp(i).distTonal);
    [cdfNoise, posNoise] = myCdf(bgCatSubSamp(i).distNoise);
    [cdfLowCoord, posLowCoord] = myCdf(bgCatSubSamp(i).distLowCoord);
    [cdfMixed, posMixed] = myCdf(bgCatSubSamp(i).distMixed);
    [cdfBetween, posBetween] = myCdf(bgCatSubSamp(i).distBetween);
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
    exportgraphics(gcf, ['Paper\Fig3_PCDistCDFSubSamp_', 'Bg', num2str(i), '.pdf'], 'ContentType', 'vector');
end

for i = 1:4
    [bgCatSubSamp(i).rankSumLowP, bgCat(i).rankSumMixedP, bgCat(i).rankSumNoiseP, bgCat(i).rankSumTonalP]
end

for i = 1:4
    i
    distWithin = [bgCatSubSamp(i).distTonal, bgCatSubSamp(i).distNoise, bgCatSubSamp(i).distLowCoord, bgCatSubSamp(i).distMixed];
    [cdfWithin, posWithin] = myCdf(distWithin);
    [cdfBetween, posBetween] = myCdf(bgCatSubSamp(i).distBetween);

    bgCatSubSamp(i).rankSumBewteenWithin = ranksum(bgCatSubSamp(i).distBetween, distWithin);

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
    exportgraphics(gcf, ['Paper\Fig3_PCDistCDF2CatsSubSamp_', 'Bg', num2str(i), '.pdf'], 'ContentType', 'vector');
end
[bgCatSubSamp.rankSumBewteenWithin]



%%% plot representation of harmonic index
clims = [[0, 0.97]; [0, 0.97]; [0, 0.97]; [0, 0.97]];
for i = 1:length(bgPitch)
    pubFig([21, 2.5, 5, 5]);
    scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
    hold on;
    scatter(bgPitch(i).score(bgCat(i).normalFreqFlagFiltered & bgPitch(i).allValidFlag, 1), bgPitch(i).score(bgCat(i).normalFreqFlagFiltered & bgPitch(i).allValidFlag, 2),...
        2, bgPitch(i).allWeightedHarmRatio(bgCat(i).normalFreqFlagFiltered & bgPitch(i).allValidFlag), 'filled', 'MarkerFaceAlpha', 1);
    colormap(turbo);
    clim(clims(i,:))
    
    axis image

    xLimRange = xlim();
    yLimRange = ylim();
    plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
    plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
    axis off

    exportgraphics(gcf, ['Paper\Fig3_PCHarmIdx_bg', num2str(i), '.tiff'], 'ContentType', 'image', 'Resolution', 600);
end


% fit linear regression to harmonic index representation using population data
rsqHarmLM = zeros(1,4);
rHarmLM = zeros(1,4);
for i = 1:length(bgPitch)
    idx = bgCat(i).normalFreqFlagFiltered & bgPitch(i).allValidFlag;
    harmScore = bgPitch(i).score(idx, :);
    harmIdx = bgCat(i).validWeightedHarmRatio';
    
    % now we use half split
    oddHarmScores = harmScore(1:2:end,:);
    evenHarmScores = harmScore(2:2:end,:);
    oddHarmIdx = harmIdx(1:2:end);
    evenHarmIdx = harmIdx(2:2:end);

    
    %%% use linear regression 
    mdl = fitlm(oddHarmScores, oddHarmIdx);
    evenPred = predict(mdl, evenHarmScores);
    notNan = ~isnan(evenHarmIdx);
    rsqHarmLM(i) = 1 - sum((evenPred(notNan) - evenHarmIdx(notNan)).^2)/sum((evenHarmIdx(notNan) - mean(evenHarmIdx(notNan))).^2);
    rHarmLM(i) = corr(evenPred(notNan), evenHarmIdx(notNan));
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


%%%% plot freq range from 0 to 1000 
allLowPitchAcrossBird = [];
for i = 1:length(bgPitch)
    allLowPitchAcrossBird = [allLowPitchAcrossBird, bgPitch(i).allPitch(bgPitch(i).allPitch>0 & bgPitch(i).allPitch<=1000)];
end

pubFig([21, -3, 2.1, 1.6]);
histogram(allLowPitchAcrossBird, 20, 'FaceColor', 'k', 'EdgeColor', 'none');
xlim([0, 1000]);
xticks([0:100:1000])
box off;
xlabel('Freq. (Hz)')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_DistPitchBelow1KHz.pdf', 'contentType', 'vector')


%%% plot single unit tuning to low freq and to harm, and to noisy
lowFreqBaseSel = cell(1,4);
harmBaseSel = cell(1,4);
noiseBaseSel = cell(1,4);
for i = 1:length(bgPitchTuning)
    resp = bgPitch(i).allUnitRespMatrix;
    lowFreqResp = mean(resp(:,bgCat(i).lowFreqFlagFiltered),2)'*1000/25;
    harmResp = mean(resp(:,bgCat(i).tonalFlagFiltered),2)'*1000/25;
    noiseResp = mean(resp(:,bgCat(i).noiseFlagFiltered),2)'*1000/25;
    baseResp = bgResp(i).meanFrBaseline;
    
    lowFreqBaseSel{i} = (lowFreqResp-baseResp) ./ (lowFreqResp+baseResp);
    harmBaseSel{i} = (harmResp-baseResp) ./ (harmResp+baseResp);
    noiseBaseSel{i} = (noiseResp-baseResp) ./ (noiseResp+baseResp);
end


pubFig([21,5,2,1.5]);
h = histogram([lowFreqBaseSel{:}], 20, 'facecolor', [0.5,0.5,0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], 0.5, 'g')
box off;
xlabel('Low freq. selectivity index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_LowFreqBaseSel.pdf', 'contentType', 'vector');

pubFig([21,5,2,1.5]);
h = histogram([harmBaseSel{:}], 20, 'facecolor', [0.5,0.5,0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], 0.5, 'r')
box off;
xlabel('Harmonic selectivity index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_HarmBaseSel.pdf', 'contentType', 'vector');

pubFig([21,5,2,1.5]);
h = histogram([noiseBaseSel{:}], 20, 'facecolor', [0.5,0.5,0.5], 'edgecolor', 'none');
plotHistRangeColored(h, [], 0.5, 'b')
box off;
xlabel('Noise selectivity index')
ylabel('Count')
exportgraphics(gcf, 'Paper\Fig3_NoiseBaseSel.pdf', 'contentType', 'vector');

lowf = [lowFreqBaseSel{:}] > 0.5;
harm = [harmBaseSel{:}] > 0.5;
noise = [noiseBaseSel{:}] > 0.5;

z1=sum(lowf)
z2=sum(harm)
z3=sum(noise)
z12=sum(lowf & harm)
z13=sum(lowf & noise)
z23=sum(harm & noise)
z123=sum(lowf & harm & noise)
zu12 = z12-z123
zu13 = z13-z123
zu23 = z23-z123
zu1 = z1-zu12-zu13-z123
zu2 = z2-zu12-zu23-z123
zu3 = z3-zu13-zu23-z123


pubFig([21,5,2,2]);
venn([z1,z2,z3,z12,z13,z23,z123], 'FaceColor', {'g', 'r', 'b'}, 'EdgeColor', 'none');
daspect([1,1,1])
axis off
exportgraphics(gcf, 'Paper\Fig3_vennThreeCats.pdf', 'contentType', 'vector');


%%%%%% VAE for budgies 125ms with 5ms step
load('bgVocalVAE125msStep5ms.mat', 'bgLatent', 'bgLatentUmap', 'bgLatentPCA', 'bgLatentIdx', 'birdNames');
bgColor = slanCM('tab10', 10);

% all birds in one figure
h = [];
pubFig([21,0,5,5])
hold on;
for i = 1:length(birdNames)
    h(i) = plot(bgLatentUmap(bgLatentIdx(i,1):bgLatentIdx(i,2),1), bgLatentUmap(bgLatentIdx(i,1):bgLatentIdx(i,2),2), '.', 'markersize', 1, 'color', bgColor(i,:));
end
axis equal
xlim([-8, 14])
ylim([-2.5, 12])
legend(h, birdNames)
xlabel('UMAP 1');
ylabel('UMAP 2');
exportgraphics(gcf, 'Paper\Fig1_VAEBgAll.pdf', 'contentType', 'vector');

% each bird a figure
for i = 1:length(birdNames)
    pubFig([21,0,5,5])
    plot(bgLatentUmap(bgLatentIdx(i,1):bgLatentIdx(i,2),1), bgLatentUmap(bgLatentIdx(i,1):bgLatentIdx(i,2),2), '.', 'markersize', 1, 'color', bgColor(i,:));
    title(birdNames{i});
    axis equal
    xlim([-8, 14])
    ylim([-2.5, 12])
    box off;
    xlabel('UMAP 1');
    ylabel('UMAP 2');
    exportgraphics(gcf, ['Paper\Fig3_VAEBg', num2str(i), '.pdf'], 'contentType', 'vector');
end


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
xticks([0:0.25:1])
xtickangle(0)
exportgraphics(gcf, 'Paper\Fig4_HistHarmIdxBg2.pdf', 'contentType', 'vector');


% histogram of pitch distribution
pubFig([21, 1, 1.2, 1.2]);
histogram(bgPitch(2).allPitch(bgPitch(2).allPitchFlagFiltered), 20, 'facecolor', [0.3, 0.3, 0.3], 'facealpha', 1, 'edgecolor', 'none');
xlim([500, 5500])
xticks([1000:1000:5500])
xticklabels(1:5)
a = gca;
a.YAxis.Exponent = 3;
xlabel('Pitch (kHz)')
ylabel('Count')
box off
exportgraphics(gcf, 'Paper\Fig4_histFreqBg2.pdf', 'contentType', 'vector')


% for all other birds
for i = [1,3,4]
    pubFig([21, 1, 1.2, 1.2]);
    histogram(bgPitch(i).allPitch(bgPitch(i).allPitchFlagFiltered), 20, 'facecolor', [0.3, 0.3, 0.3], 'facealpha', 1, 'edgecolor', 'none');
    % xlim([500, 5500])
    xticks([1000:1000:6000])
    xticklabels(1:6)
    a = gca;
    a.YAxis.Exponent = 3;
    xlabel('Pitch (kHz)')
    ylabel('Count')
    box off
    exportgraphics(gcf, ['Paper\Fig4_histFreqBg', num2str(i) '.pdf'], 'contentType', 'vector')
end


%%% population analyses

% find axis and projection
bgPitchGradientVector = cell(1, length(bgPitch));

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

    %%% use top and bottom 50% pitch responses to find the neural freq. axis
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
        
        pitchPct
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


% rainbow plots using all cells, plotted separately for calls and warbles
clims = [[1000,5000]; [1000, 5000]; [1000, 6000]; [1000, 4200]];
pos = [[-2, -16]; [0, -18]; [6, -20]; [8, -14]];
for i = 1:length(bgPitch)

    callIds = find(~bgI(i).warbleSyFlag);
    callPointFlag = false(1, length(bgI(i).syFeatureId));
    for j = 1:length(callIds)
        callPointFlag(bgI(i).syFeatureId==callIds(j)) = true;
    end
    syPointFlag = ~callPointFlag;

    % for call
    pubFig([21, 2.5, 5, 5]);
    scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
    hold on;
    scatter(bgPitch(i).score(bgPitch(i).allPitchFlagFiltered&callPointFlag, 1), bgPitch(i).score(bgPitch(i).allPitchFlagFiltered&callPointFlag, 2),  2,...
        bgPitch(i).allPitch(bgPitch(i).allPitchFlagFiltered&callPointFlag), 'filled', 'MarkerFaceAlpha', 1);
    colormap(turbo);
    clim(clims(i,:))
    
    axis image
    hold on

    xLimRange = xlim();
    yLimRange = ylim();
    plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
    plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
    axis off

    exportgraphics(gcf, ['Paper\Fig4_PCRainbow_bg', num2str(i), '_onlyCall.tiff'], 'ContentType', 'image', 'Resolution', 600);

    % for syllable
    pubFig([21, 2.5, 5, 5]);
    scatter(bgPitch(i).score(:, 1), bgPitch(i).score(:, 2),  2, [0.7, 0.7, 0.7], 'filled', 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
    hold on;
    scatter(bgPitch(i).score(bgPitch(i).allPitchFlagFiltered&syPointFlag, 1), bgPitch(i).score(bgPitch(i).allPitchFlagFiltered&syPointFlag, 2),  2,...
        bgPitch(i).allPitch(bgPitch(i).allPitchFlagFiltered&syPointFlag), 'filled', 'MarkerFaceAlpha', 1);
    colormap(turbo);
    clim(clims(i,:))
    
    axis image
    hold on

    xLimRange = xlim();
    yLimRange = ylim();
    plot([xLimRange(1), xLimRange(1)+5], [yLimRange(1), yLimRange(1)], 'k-', 'lineWidth', 1.5)
    plot([xLimRange(1), xLimRange(1)], [yLimRange(1), yLimRange(1)+5], 'k-', 'lineWidth', 1.5)
    axis off

    exportgraphics(gcf, ['Paper\Fig4_PCRainbow_bg', num2str(i), '_onlySyllable.tiff'], 'ContentType', 'image', 'Resolution', 600);
end


% calculate proj curves
projY = {};
projX = {};
projSe = {};
projPct10 = {};
projPct90 = {};
projRsquare = [];
projXRanges = {};
projSlope = [];
for i = 1:length(bgPitch)
    minProj = min(bgProj(i).pitchGradientProj);
    maxProj = max(bgProj(i).pitchGradientProj);
    projGap = 3;
    xPoints = floor(minProj)+projGap/2:projGap:ceil(maxProj)-projGap/2;
    projXRanges{i} = xPoints;
    [projY{i}, ~, projSe{i}, projRsquare(i), ~, ~, ~, projPct10{i}, projPct90{i}] = calMeanRespAlongX(bgProj(i).pitchGradientProj, bgProj(i).evenPitch, xPoints, projGap, 20);
    projX{i} = xPoints;

    X = [ones(length(projXRanges{i}),1), projXRanges{i}'];
    tmpCurve = projY{i};
    notNan = ~isnan(tmpCurve);
    thisTmp = X(notNan, :)\tmpCurve(notNan)';
    projSlope(i) = thisTmp(2);
end


% % shuffle the data and calculate projection
% nShuffle = 5000;
% shuffledCurve = cell(4);
% meanShuffledCurve = cell(4);
% seShuffledCurve = cell(4);
% pct10ShuffledCurve = cell(4);
% pct90ShuffledCurve = cell(4);
% slopeShuffledCurve = zeros(4, nShuffle);
% pct = 50;
% tic  % takes about 80 secs to run
% for i = 1:4
%     pitchIdx = bgPitch(i).allPitchFlagFiltered;
%     pitchScores = bgPitch(i).score(pitchIdx, :);
%     pitch = bgPitch(i).allPitch(pitchIdx);
% 
%     oddPitchScores = pitchScores(1:2:end,:);
%     evenPitchScores = pitchScores(2:2:end,:);
% 
%     curves = zeros(nShuffle, length(projXRanges{i}));
% 
%     parfor j = 1:nShuffle
%         j
%         sPitch = pitch(randperm(length(pitch))); 
% 
%         oddPitch = sPitch(1:2:end);
%         evenPitch = sPitch(2:2:end);
% 
%         pitchPct = prctile(oddPitch, [pct, 100-pct]);
% 
%         gradStart = mean(oddPitchScores(oddPitch<pitchPct(1),:), 1);
%         gradEnd = mean(oddPitchScores(oddPitch>pitchPct(2),:), 1);
%         pvector = gradEnd-gradStart;
%         bgPitchGradientVector = pvector/norm(pvector);
% 
%         pitchGradientProj = zeros(1, length(evenPitch));
%         for k = 1:length(evenPitch)
%             pitchGradientProj(k) = dot(evenPitchScores(k,:), bgPitchGradientVector);
%         end
% 
%         curves(j,:) = calMeanRespAlongX(pitchGradientProj, evenPitch, projXRanges{i}, projGap, 20);
%         X = [ones(length(projXRanges{i}),1) projXRanges{i}'];
%         tmpCurve = curves(j,:);
%         notNan = ~isnan(tmpCurve);
%         thisTmp = X(notNan, :)\tmpCurve(notNan)';
%         slopeShuffledCurve(i,j) = thisTmp(2);
% 
%     end
%     shuffledCurve{i} = curves;
%     meanShuffledCurve{i} = mean(curves, 1, 'omitnan');
%     seShuffledCurve{i} = std(curves, [], 1, 'omitnan')./sqrt(sum(~isnan(curves), 1));
%     pct10ShuffledCurve{i} = prctile(curves, 10, 1);
%     pct90ShuffledCurve{i} = prctile(curves, 90, 1);
% end
% toc
% save('Fig4_shuffleProj.mat', 'meanShuffledCurve', 'seShuffledCurve', 'pct10ShuffledCurve', 'pct90ShuffledCurve', 'slopeShuffledCurve');

load('Fig4_shuffleProj.mat', 'meanShuffledCurve', 'seShuffledCurve', 'pct10ShuffledCurve', 'pct90ShuffledCurve', 'slopeShuffledCurve');

% plot proj curve together with shuffled data
ylimValues = [4000, 4520, 4400, 4000];
for i = 1:4
    pubFig([21, 2.5, 1, 1.25]);
    hold on;
    
    lineProps.width = .5;
    lineProps.style = '.-';
    lineProps.col = {[0.5,0.5,0.5]; [0,0,0]};
    lineProps.edgeWidth = 0;
    pctArray = zeros(1, length(projXRanges{i}), 2);
    pctArray(1,:,:) = [meanShuffledCurve{i}-pct10ShuffledCurve{i}; pct90ShuffledCurve{i}-meanShuffledCurve{i}]';
    pctArray(2,:,:) = [projY{i}-projPct10{i}; projPct90{i}-projY{i}]';
    lh = mseb(repmat(projXRanges{i}, 2,1), [meanShuffledCurve{i}; projY{i}], pctArray,lineProps);
    for k = 1:length(lh)
        lh(k).mainLine.MarkerSize = 8;
    end

    box off;
    xlabel('Proj. freq axis')
    ylabel('Pitch (kHz)')
    xlim([-20, 22])
    ylim([1000, ylimValues(i)]);
    yticklabels(yticks()/1000)
    exportgraphics(gcf, ['Paper\Fig4_PCProj_bg', num2str(i), '.pdf'], 'contentType', 'vector')
end


%%% plot distribution of slopes for shuffled and true data
% plot proj curve together with shuffled data
for i = 1:4
    pubFig([21, 2.5, 1.75, 1.5]);
    histogram(slopeShuffledCurve(i,:), 30, 'EdgeColor', 'none', 'FaceColor', [0.5, 0.5, 0.5]);
    xline(projSlope(i), 'k');
    box off;
    xlabel('Slope');
    ylabel('Count');
    
    exportgraphics(gcf, ['Paper\Fig4_PCProj_bg', num2str(i), '_stat.pdf'], 'contentType', 'vector')
end


%%%%%%%%% rainbow plot for two control
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


% calcualte loss from linear predition using PC1 and PC2
pitchIdx = bgPitch(2).allPitchFlagFiltered;
pitchScores = bgPitch(2).score(pitchIdx, 1:2);
pitch = bgPitch(2).allPitch(pitchIdx);

loss = zeros(1, length(pitch));
parfor i = 1:length(pitch)
    trainingPitch = pitch;
    trainingPitch(i) = [];
    trainingScores = pitchScores;
    trainingScores(i,:) = [];
    md = fitlm(trainingScores, trainingPitch);
    testPred = predict(md, pitchScores(i,:));
    loss(i) = (testPred - pitch(i))^2;
end

pitchScoresControl1 = bgPitchControl(1).score(pitchIdx, 1:2);
lossControl1 = zeros(1, length(pitch));
parfor i = 1:length(pitch)
    trainingPitch = pitch;
    trainingPitch(i) = [];
    trainingScores = pitchScoresControl1;
    trainingScores(i,:) = [];
    md = fitlm(trainingScores, trainingPitch);
    testPred = predict(md, pitchScoresControl1(i,:));
    lossControl1(i) = (testPred - pitch(i))^2;
end

pitchScoresControl2 = bgPitchControl(2).score(pitchIdx, 1:2);
lossControl2 = zeros(1, length(pitch));
parfor i = 1:length(pitch)
    trainingPitch = pitch;
    trainingPitch(i) = [];
    trainingScores = pitchScoresControl2;
    trainingScores(i,:) = [];
    md = fitlm(trainingScores, trainingPitch);
    testPred = predict(md, pitchScoresControl2(i,:));
    lossControl2(i) = (testPred - pitch(i))^2;
end

pubFig([21, 2.5, 1.5,1.5])
data{1} = loss';
data{2} = lossControl1';
data{3} = lossControl2';
h = daboxplot(data, 'outliers', 0);
ylabel('Squared error')
xlim([0.5, 3.5])
ax = gca;
ax.XAxis.Visible = 'off';
exportgraphics(gcf, 'Paper\Fig4_pitchMapLossOrignalAndControl.pdf', 'contentType', 'vector');

ranksum(loss, lossControl1)*2
ranksum(loss, lossControl2)*2


%%%%%% single unit tuning

% example tuning
b = 2;
audio = audioread(bgI(b).audioFile);
load(bgI(b).suaFile, 'sua');

exampVocalId = 34;
exampSyId = 110;

exampleRespWin = bgI(b).vocalTimeWin(34,:);

load('Fig4_exampleSortOrder.mat', 'isort1');


plotRaster(sua(isort1), audio, exampleRespWin(1,:), 30000, 0, [], 100, 3, 0);
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-110, -65]);
axes(ax(2));
ylabel('Freq. (kHz)')
yticks(1000:1000:7000)
hold on
x = bgI(b).syTimeWin(exampSyId, 1):0.001:...
    (bgI(b).syTimeWin(exampSyId, 1)+0.001*(length(bgPitch(b).features(exampSyId).pitch)-1));
y = bgPitch(b).features(exampSyId).pitch;
y(y==0) = nan;
plot(x,y, '-', 'color', '#EDB120');
yticklabels(1:7);
ax(2).XAxis.Visible = 'off';
%axis off
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [2, 2], 'k-', 'LineWidth', 2)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
exportgraphics(gcf, 'Paper\Fig4_bgFreqExampRaster.pdf','ContentType', 'vector');


% plot example units from bird 2
bgU = [27,69,65, 79]; %%% used in paper

% find unit id in tuning curve matrix heatamp plot
arrayfun(@(x) find(bgPitchTuning(2).pitchTunedSortId==x), bgU(1:3))

% newUId shows the position of the example units on the sorted example raster plot
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
    %colorbar;
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
    xlabel('Pitch (kHz)');
    yticks(0:80:1000);
    ylabel('Spikes/s')
    ylim([0 spikeEdges(end)*1000/25]);
    xlim([900, 5500])
    plot(900, bgResp(b).meanFrBaseline(i), 'o', 'markeredgecolor', "#4DBEEE", 'markersize',4);
    exportgraphics(gcf, ['Paper\Fig4_UnitTuning_', 'b' num2str(b), '_U', num2str(i), '.pdf'], 'contentType', 'vector');
    %close(gcf)
end

% for colorbar
figure; 
colormap(flipud(gray));
cb = colorbar;
cb.Ticks = [];
axis off
exportgraphics(gcf, ['Paper\Fig4_UnitTuningColorbar.pdf'], 'contentType', 'vector');


% only call
warbleFlag = false(size(bgPitch(b).allPitchFlagFiltered));
warbleSys = find(bgI(b).warbleSyFlag);
for s = 1:length(warbleSys)
    warbleFlag(bgI(b).syFeatureId==warbleSys(s)) = true;
end

for j = 1:length(bgU)
    gap = bgPitchTuningCall(b).pitchEdges(2)-bgPitchTuningCall(b).pitchEdges(1);
    i = bgU(j);

    unitResp = bgPitch(b).allUnitRespMatrix(i,:);

    pitchToInclude = bgPitch(b).allPitchFlagFiltered & ~warbleFlag;

    goodPitchRes = unitResp(pitchToInclude);

    spikeEdges = 0:1:max(unitResp(bgPitch(b).allPitchFlagFiltered))+1;
    N = histcounts2(goodPitchRes, bgPitch(b).allPitch(pitchToInclude), spikeEdges, bgPitchTuningCall(b).pitchEdges);
    Nnormed = N/sum(N(:));

    pubFig([21, 2.5, 1.5, 1.5]);
    imagesc([bgPitchTuningCall(b).pitchEdges(1)+gap/2, bgPitchTuningCall(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
    set(gca,'ydir','normal');
    %colorbar;
    colormap(flipud(gray));
    xlim([1000, 5700])
    yticks([0:2:spikeEdges(end)]*1000/25)
    box off;
    clim(binLim)
    hold on;
    errorbar(bgPitchTuningCall(b).pitchCurveMidPoint, bgPitchTuningCall(b).pitchTuningCurve(i,:), bgPitchTuningCall(b).pitchTuningCurveSe(i,:), '.-','markersize', 6, 'lineWidth', 0.5, 'CapSize', 0.3, 'color', [45,211,120]/255);
    title(['U' num2str(newUId(j)), ', TI:' num2str(bgPitchTuningCall(b).pitchTuningIdx(i))]);
    xticks(0:1000:5000);
    xticklabels(0:1:5);
    xtickangle(0);
    xlabel('Pitch (kHz)');
    yticks(0:80:1000);
    ylabel('Spikes/s')
    ylim([0 spikeEdges(end)*1000/25]);
    xlim([900, 5500])
    plot(900, bgResp(b).meanFrBaseline(i), 'o', 'markeredgecolor', "#4DBEEE", 'markersize',4);
    exportgraphics(gcf, ['Paper\Fig4_UnitTuningOnlyCall_', 'b' num2str(b), '_U', num2str(i), '.pdf'], 'contentType', 'vector');
    %close(gcf)
end

% only warble
for j = 1:length(bgU)
    gap = bgPitchTuningWarble(b).pitchEdges(2)-bgPitchTuningWarble(b).pitchEdges(1);
    i = bgU(j);

    unitResp = bgPitch(b).allUnitRespMatrix(i,:);

    pitchToInclude = bgPitch(b).allPitchFlagFiltered & warbleFlag;

    goodPitchRes = unitResp(pitchToInclude);

    spikeEdges = 0:1:max(unitResp(bgPitch(b).allPitchFlagFiltered))+1;
    N = histcounts2(goodPitchRes, bgPitch(b).allPitch(pitchToInclude), spikeEdges, bgPitchTuningWarble(b).pitchEdges);
    Nnormed = N/sum(N(:));

    pubFig([21, 2.5, 1.5, 1.5]);
    imagesc([bgPitchTuningWarble(b).pitchEdges(1)+gap/2, bgPitchTuningWarble(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
    set(gca,'ydir','normal');
    %colorbar;
    colormap(flipud(gray));
    xlim([1000, 5700])
    yticks([0:2:spikeEdges(end)]*1000/25)
    box off;
    clim(binLim)
    hold on;
    errorbar(bgPitchTuningWarble(b).pitchCurveMidPoint, bgPitchTuningWarble(b).pitchTuningCurve(i,:), bgPitchTuningWarble(b).pitchTuningCurveSe(i,:), '.-','markersize', 6, 'lineWidth', 0.5, 'CapSize', 0.3, 'color', [45,211,120]/255);
    title(['U' num2str(newUId(j)), ', TI:' num2str(bgPitchTuningWarble(b).pitchTuningIdx(i))]);
    xticks(0:1000:5000);
    xticklabels(0:1:5);
    xtickangle(0);
    xlabel('Pitch (kHz)');
    yticks(0:80:1000);
    ylabel('Spikes/s')
    ylim([0 spikeEdges(end)*1000/25]);
    xlim([900, 5500])
    plot(900, bgResp(b).meanFrBaseline(i), 'o', 'markeredgecolor', "#4DBEEE", 'markersize',4);
    exportgraphics(gcf, ['Paper\Fig4_UnitTuningOnlyWarble_', 'b' num2str(b), '_U', num2str(i), '.pdf'], 'contentType', 'vector');
    %close(gcf)
end


% plot schematics for tuning index
b = 2;
examU = 27;
bandRespExamU = [364.08503543143,191.350855745721,103.333333333333,55.9013867488444];
meanExamU = 183.531511739668;
examTuningIdx = range(bandRespExamU)/sqrt(meanExamU);
pubFig([21, 5, 1.5,1.5])
bar(1:4, bandRespExamU, 'facecolor', 'k', 'edgecolor', 'none')
box off
ylabel('Firing rate (Hz)')
xticklabels({'1-2', '2-3', '3-4', '4-5'});
xlabel('Pitcht band (kHz)')
exportgraphics(gcf, ['Paper\Fig4_UnitTuningIdxSchematic.pdf'], 'contentType', 'vector');


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
    xlabel('Pitch (kHz)')
    xtickangle(0)
    ylabel('Neuron #')
    exportgraphics(gcf, ['Paper\Fig4_PopTuningMap_Bg', num2str(b), '.pdf'], 'contentType', 'Vector');
end



% % GLM
% rsq = cell(1,4);
% llratio = cell(1,4);
% contribEachFactor = cell(1,4);
% llratioEachFactor = cell(1,4);
% 
% tic  % takes about 1 min to run
% for b = 1:4
%     sidx = find(bgPitch(b).allPitchFlagFiltered);
%     allResp = bgPitch(b).allUnitRespMatrix;
%     allPitch = bgPitch(b).allPitch;
%     features = bgPitch(b).features;
%     allEntropy = [features(:).entropy];
%     allAmp = [features(:).amplitude];
%     allFM = [features(:).FM];
% 
%     thisRsq = zeros(1,size(allResp,1));
%     thisLlratio = zeros(1,size(allResp,1));
%     thisContribEachFactor = zeros(4,size(allResp,1));
%     thisLlratioEachFactor = zeros(4,size(allResp,1));
% 
%     for u = 1:size(allResp, 1)
%         u
%         X = [allPitch(sidx)', allEntropy(sidx)', allAmp(sidx)', allFM(sidx)'];
%         Y = allResp(u,sidx)';
%         md = fitglm(X, Y, 'linear', 'Distribution', 'Poisson', 'Link', 'log');
%         thisRsq(u) = md.Rsquared.LLR;
%         thisLlhood = calPoissionLogLikelihood(Y, md.predict());     
% 
%         mdNull = fitglm(X, Y, 'constant', 'Distribution', 'Poisson', 'Link', 'log');
%         thisNllhood = calPoissionLogLikelihood(Y, mdNull.predict());
%         thisLlratio(u) = -2*(thisNllhood - thisLlhood);
% 
%         for k = 1:4
%             vector = 1:4;
%             vector(k) = [];
%             mdRed = fitglm(X(:,vector), Y, 'linear', 'Distribution', 'Poisson', 'Link', 'log');
%             thisContribEachFactor(k, u) = 1 - (mdRed.Rsquared.LLR/md.Rsquared.LLR);
%             thisLlratioEachFactor(k, u) = -2*(calPoissionLogLikelihood(Y, mdRed.predict()) - thisLlhood);
%         end
%         thisContribEachFactor(:,u) = thisContribEachFactor(:,u) ./ sum(thisContribEachFactor(:,u));
%     end
% 
%     rsq{b} = thisRsq;
%     llratio{b} = thisLlratio;
%     contribEachFactor{b} = thisContribEachFactor;
%     llratioEachFactor{b} = thisLlratioEachFactor;
% end
% toc
% 
% tic  % takes about 6 hours to run
% llratioShuffle = cell(1,4);
% llratioEachFactorShuffle = cell(1,4);
% nShuffle = 1000;
% for b = 1:4
%     b
%     sidx = find(bgPitch(b).allPitchFlagFiltered);
%     allResp = bgPitch(b).allUnitRespMatrix;
%     allPitch = bgPitch(b).allPitch;
%     features = bgPitch(b).features;
%     allEntropy = [features(:).entropy];
%     allAmp = [features(:).amplitude];
%     allFM = [features(:).FM];
% 
%     thisLlratio = zeros(size(allResp,1), nShuffle);
%     thisContribEachFactor = zeros(4,size(allResp,1), nShuffle);
%     thisLlratioEachFactor = zeros(4,size(allResp,1), nShuffle);
% 
%     for u = 1:size(allResp, 1)
%         u
%         X = [allPitch(sidx)', allEntropy(sidx)', allAmp(sidx)', allFM(sidx)'];
%         Y = allResp(u,sidx)';
%         tic
%         parfor m = 1:nShuffle
%             m
%             Yrand = Y(randperm(length(Y)));
%             md = fitglm(X, Yrand, 'linear', 'Distribution', 'Poisson', 'Link', 'log');
%             thisLlhood = calPoissionLogLikelihood(Yrand, md.predict());
% 
%             mdNull = fitglm(X, Yrand, 'constant', 'Distribution', 'Poisson', 'Link', 'log');
%             thisNllhood = calPoissionLogLikelihood(Yrand, mdNull.predict());
%             thisLlratio(u, m) = -2*(thisNllhood - thisLlhood);
% 
%             for k = 1:4
%                 vector = 1:4;
%                 vector(k) = [];
%                 mdRed = fitglm(X(:,vector), Yrand, 'linear', 'Distribution', 'Poisson', 'Link', 'log');
%                 %thisContribEachFactor(k, u, m) = 1 - (mdRed.Rsquared.LLR/md.Rsquared.LLR);
%                 thisLlratioEachFactor(k, u, m) = -2*(calPoissionLogLikelihood(Yrand, mdRed.predict()) - thisLlhood);
%             end
%             %thisContribEachFactor(:,u, m) = thisContribEachFactor(:,u, m) ./ sum(thisContribEachFactor(:,u, m));
%         end
%         toc
%     end
% 
%     llratioShuffle{b} = thisLlratio;
%     llratioEachFactorShuffle{b} = thisLlratioEachFactor;
% end
% toc
% save('bgGLM.mat', 'rsq', 'llratio', 'contribEachFactor', 'llratioEachFactor', 'llratioShuffle', 'llratioEachFactorShuffle');


load('bgGLM.mat', 'rsq', 'llratio', 'contribEachFactor', 'llratioEachFactor', 'llratioShuffle', 'llratioEachFactorShuffle');

llratioSig = cell(1, 4);
for b = 1:4
    nUnits = size(bgPitch(b).allUnitRespMatrix, 1); 
    thisLlratioSig = false(1, nUnits);
    for i = 1:size(thisLlratioSig, 2)
        if llratio{b}(i) > prctile(llratioShuffle{b}(i,:), 99)  % here we use one-sided test, but it really doesn't matter
            thisLlratioSig(i) = true;
        end
    end
    llratioSig{b} = thisLlratioSig;
end


dataTuned = [];
dataNotTuned = [];
allData = [];
for b = 1:4
    dataTuned = [dataTuned; contribEachFactor{b}(:, bgPitchTuning(b).pitchTuned)'*100];
    dataNotTuned = [dataNotTuned; contribEachFactor{b}(:, ~bgPitchTuning(b).pitchTuned)'*100];
    allData = [allData; contribEachFactor{b}'*100];
end


pubFig([21, 5, 2, 2]);
h = daboxplot(allData, 'outliers', 0);
ylabel('Relative contribution (%)');
xlim([0.5, 4.5]);
xticklabels({'Pitch', 'Entropy', 'Amplitude', 'Freq. mod.'})
ax = gca; 
exportgraphics(gcf, 'Paper\Fig4_GLMPitchAllNeurons.pdf', 'contentType', 'vector');
ranksum(allData(:,1), allData(:,2))*6
ranksum(allData(:,1), allData(:,3))*6
ranksum(allData(:,1), allData(:,4))*6
ranksum(allData(:,2), allData(:,3))*6
ranksum(allData(:,2), allData(:,4))*6
ranksum(allData(:,3), allData(:,4))*6


pubFig([21, 5, 2, 2]);
h = daboxplot(dataTuned, 'outliers', 0);
ylabel('Relative contribution (%)');
xlim([0.5, 4.5]);
xticklabels({'Pitch', 'Entropy', 'Amplitude', 'Freq. mod.'})
ax = gca; 
exportgraphics(gcf, 'Paper\Fig4_GLMPitchTunedNeurons.pdf', 'contentType', 'vector');
ranksum(dataTuned(:,1), dataTuned(:,2))*6
ranksum(dataTuned(:,1), dataTuned(:,3))*6
ranksum(dataTuned(:,1), dataTuned(:,4))*6
ranksum(dataTuned(:,2), dataTuned(:,3))*6
ranksum(dataTuned(:,2), dataTuned(:,4))*6
ranksum(dataTuned(:,3), dataTuned(:,4))*6


pubFig([21, 5, 2, 2]);
h = daboxplot(dataNotTuned, 'outliers', 0);
ylabel('Relative contribution (%)');
xlim([0.5, 4.5]);
xticklabels({'Pitch', 'Entropy', 'Amplitude', 'Freq. mod.'})
exportgraphics(gcf, 'Paper\Fig4_GLMPitchNotTunedNeurons.pdf', 'contentType', 'vector');
ranksum(dataNotTuned(:,1), dataNotTuned(:,2))*6
ranksum(dataNotTuned(:,1), dataNotTuned(:,3))*6
ranksum(dataNotTuned(:,1), dataNotTuned(:,4))*6
ranksum(dataNotTuned(:,2), dataNotTuned(:,3))*6
ranksum(dataNotTuned(:,2), dataNotTuned(:,4))*6
ranksum(dataNotTuned(:,3), dataNotTuned(:,4))*6


%%%%% frequency decoding
% use all vocal elements
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

tic  % takes about 4 min to run
for b = 1:4
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

    bgFreqDecode(b).predicted = predicted;
    bgFreqDecode(b).predictedFull = predictedFull;
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [predicted{:}];
    bgFreqDecode(b).rsquare = 1-sum((allFreq-allPredicted).^2)/sum((allFreq - mean(allFreq)).^2);
    bgFreqDecode(b).normalR = corr(allPredicted',allFreq');
end
toc

%decode using different number of cells
unitsNum = [5, 10, 15, 20];
tic  % takes about 7 min to run
for b = 1:4
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

    bgFreqDecode(b).predictedGood = predictedGood;
    bgFreqDecode(b).predictedGoodFull = predictedGoodFull;
    bgFreqDecode(b).predictedBad = predictedBad;
    bgFreqDecode(b).predictedBadFull = predictedBadFull;
    bgFreqDecode(b).rsquareGood = rsquareGood;
    bgFreqDecode(b).rsquareBad = rsquareBad;
end
toc



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
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
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
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
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
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
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


% plot heatmap decoded pitch vs original pitch, for all birds, using all cells
flim = [[650, 5050]; [900, 5700]; [250, 6800]; [900, 4500]];
colorLim = [0, 0.007];
for b = 1:4
    allFreq = bgPitch(b).allPitch(bgPitch(b).allPitchFlagFiltered);
    allPredicted = [bgFreqDecode(b).predicted{:}];
        
    gap = 80;
    fRange = [flim(b,1):gap:flim(b,2)];
    
    pubFig([21, 0, 1.5, 1.5]);
    N = histcounts2(allPredicted, allFreq, fRange, fRange);
    Nnorm = N./sum(N, 'all');
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, Nnorm, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap(flipud(cmap('black', 256, 0, 10)));
    daspect([1, 1, 1])
    box off
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:7);
    xtickangle(0);
    yticklabels(1:7);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    title(['BG', num2str(b), ' R=', num2str(bgFreqDecode(b).normalR)])
    exportgraphics(gcf, ['Paper\Fig4_decodingScatterAllUnits_bg', num2str(b), '.pdf'], 'contentType', 'vector');
end


%%%%% train on warble syllables and test on calls
decodeCallRsquare = zeros(1,4);
decodedCallNormalR = zeros(1,4);
decodedCallPred = cell(1,4);
decodedCallTrue = cell(1,4);
for b = 1:4
    syPoint = syGroupIdxAllBg{b};
    syId = syGroupIdAllBg{b};
    syIdIsWarble = bgI(b).warbleSyFlag(syId);

    allUnitRespMatrix = bgPitch(b).allUnitRespMatrix;
    allPitch = bgPitch(b).allPitch;

    trainPoint = cell2mat(syPoint(syIdIsWarble));
    testPoint = cell2mat(syPoint(~syIdIsWarble));
    md = fitlm(allUnitRespMatrix(:, trainPoint)', allPitch(trainPoint)');
    predicted = predict(md, allUnitRespMatrix(:, testPoint)')';

    trueFreq = bgPitch(b).allPitch(testPoint);
    allPredicted = predicted;
    decodeCallRsquare(b) = 1-sum((trueFreq-allPredicted).^2)/sum((trueFreq - mean(trueFreq)).^2);
    decodedCallNormalR(b) = corr(trueFreq', allPredicted');

    decodedCallPred{b} = allPredicted;
    decodedCallTrue{b} = trueFreq;
end


% plot heatmap call decoded pitch vs original pitch, for all birds, using all cells
flim = [[650, 5050]; [900, 5700]; [250, 6800]; [900, 4500]];
colorLim = [0, 0.01];
%figure;
for b = 1:4
    allFreq = decodedCallTrue{b};
    allPredicted = decodedCallPred{b};
        
    gap = 80;
    fRange = [flim(b,1):gap:flim(b,2)];
    
    pubFig([21, 0, 1.5, 1.5]);
    N = histcounts2(allPredicted, allFreq, fRange, fRange);
    Nnorm = N./sum(N, 'all');
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, Nnorm, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap(flipud(cmap('black', 256, 0, 10)));
    daspect([1, 1, 1])
    box off
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:7);
    xtickangle(0);
    yticklabels(1:7);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    title(['BG', num2str(b), ' R=', num2str(decodedCallNormalR(b))])
    exportgraphics(gcf, ['Paper\Fig4_decodingCallScatterAllUnits_bg', num2str(b), '.pdf'], 'contentType', 'vector');
end


%%%%%%%%%%%%%%%%%% zebra finch pitch analysis

%%%%% decode zebra finch
syGroupIdxAllZf = {};
syGroupIdAllZf = {};
for i = 1:7
    syGroupIdx = {};
    syGroupId = [];
    syFeatureId = [];
    for j = 1:length(zfPitch(i).syFeatures)
        syFeatureId = [syFeatureId; j*ones(length(zfPitch(i).syFeatures(j).pitch), 1)];
    end
    zfI(i).syFeatureId = syFeatureId;

    for j = 1:length(zfPitch(i).syFeatures)
        if zfPitch(i).syFeatures(j).songId == 1   % we only select the first song
            pointIds = find(syFeatureId == j);
            if any(zfPitch(i).syFeatures(j).pitchFlag)
                syGroupIdx{end+1} = pointIds(zfPitch(i).syFeatures(j).pitchFlag)';
                syGroupId(end+1) = j;
            end
        end
    end
    syGroupIdxAllZf{i} = syGroupIdx;
    syGroupIdAllZf{i} = syGroupId;
end

for b = 1:7
    syPoint = syGroupIdxAllZf{b};
    syId = syGroupIdAllZf{b};
    predicted = cell(1, length(syPoint));

    syFeatureId = zfI(b).syFeatureId;
    allUnitRespMatrix = zfPitch(b).allUnitRespMatrix;
    allPitch = zfPitch(b).allPitch;

    for i = 1:length(syPoint)
        i
        testSy = syId(i);
        testPoint = syPoint{i};
        
        tmp = syPoint;
        tmp{i} = [];
        trainPoint = [tmp{:}];
        md = fitlm(allUnitRespMatrix(:, trainPoint)', allPitch(trainPoint)');
        predicted{i} = predict(md, allUnitRespMatrix(:, testPoint)')';
    end
    

    zfFreqDecode(b).predicted = predicted;
    allFreq = zfPitch(b).allPitch([syPoint{:}]);
    allPredicted = [predicted{:}];
    zfFreqDecode(b).rsquare = 1-sum((allFreq-allPredicted).^2)/sum((allFreq - mean(allFreq)).^2);
    zfFreqDecode(b).normalR = corr(allPredicted',allFreq');
end


% plot heatmap for decoded pitch for zebra finch, use all cells
flim = [[350, 5250]; [350, 4100]; [350, 4600]; [340, 4650]; [480, 4800]; [340, 4500]; [420, 5600]];
colorLim = [0, 0.02];
for b = 1:7
    syPoint = syGroupIdxAllZf{b};
    allFreq = zfPitch(b).allPitch([syPoint{:}]);
    allPredicted = [zfFreqDecode(b).predicted{:}];
    
    b
    min(allFreq)
    max(allFreq)

    gap = 80;
    fRange = [flim(b,1):gap:flim(b,2)];
    
    pubFig([21, 0, 1.5, 1.5]);
    N = histcounts2(allPredicted, allFreq, fRange, fRange);
    Nnorm = N./sum(N, 'all');
    imagesc(fRange(1:end-1)+gap/2, fRange(1:end-1)+gap/2, Nnorm, 'alphaData', N>0);
    set(gca, 'ydir', 'normal')
    colormap(flipud(cmap('black', 256, 0, 10)));
    daspect([1, 1, 1])
    box off
    xlabel('True pitch (kHz)');
    ylabel('Decoded pitch (kHz)');
    xticks([1000:1000:flim(b,2)]);
    yticks([1000:1000:flim(b,2)]);
    xticklabels(1:6);
    xtickangle(0);
    yticklabels(1:6);
    clim(colorLim);
    cb = colorbar;
    cb.Ticks = colorLim;
    title(['ZF', num2str(b), ' R=', num2str(zfFreqDecode(b).normalR)]);
    exportgraphics(gcf, ['Paper\Fig4_decodingScatterAllUnits_zf', num2str(b), '.pdf'], 'contentType', 'vector'); 
end


%%%% analyze zebra finch RA burst relationship with pitch
b = 3;

zfaudio = audioread(zfI(b).audioFile);
sua = getZfSua(zfI(b).dataFile);
birdIds = {'A413', 'B1', 'B3', 'B5', 'C29', 'C44', 'C47'};
birdId = birdIds{b};
featureFile = ['ZF\' birdId '\alignedSyllables.mat'];
load(featureFile, 'newSyllableTimeWins', 'syllablePitch', 'newFeatures');

nSy = [3,4,4,4,4,3,6];

song1SyTime = [];
song1SyPitch = cell(nSy(b),1);
for i = 1:nSy(b)
    song1SyTime = [song1SyTime; newSyllableTimeWins{i}(1,:)];
    song1SyPitch{i} = syllablePitch{i, 1};
end

bt = calBurstTiming(sua, [song1SyTime(:,1)-0.012, song1SyTime(:,2)], 100);

totalBurst = 0;
for i = 1:size(bt,1)
    for j = 1:size(bt,2)
        totalBurst = totalBurst + size(bt{i,j},1);
    end
end

pitchDelay = 12;
meanPitchPerBurst = cell(length(sua),1);
meanPitchPerBurstNoNan = {};
allPitchBurstTimePoint = {};
allPitchPoint = {};
for i = 1:length(sua)
    i
    thisUnitMeanPitch = [];
    thisPitchBurstTimePoint = {};
    thisPitchPoint = {};
    for j = 1:nSy(b)
        syStartTime = song1SyTime(j,1);
        thisBt = bt{i, j};
        for m = 1:size(thisBt,1)
            pitchStartTime = round((thisBt(m,1)-syStartTime)*1000) + 1 + pitchDelay;
            pitchEndTime = round((thisBt(m,2)-syStartTime)*1000) + 1 + pitchDelay;
            if pitchEndTime>length(song1SyPitch{j})
                if pitchStartTime>length(song1SyPitch{j})
                    continue
                else
                    pitchPoints = song1SyPitch{j}(pitchStartTime:end);
                end
            else
                pitchPoints = song1SyPitch{j}(pitchStartTime:pitchEndTime);
            end
            thisPitchBurstTimePoint{end+1} = (thisBt(m,1):0.001:(thisBt(m,1)+(length(pitchPoints)/1000)-0.001))+0.012;
            thisPitchPoint{end+1} = pitchPoints;

            if ~all(isnan(pitchPoints))
                thisUnitMeanPitch(end+1) = mean(pitchPoints, "omitnan");
            end
        end
    end
    allPitchBurstTimePoint{end+1} = thisPitchBurstTimePoint;
    allPitchPoint{end+1} = thisPitchPoint;
    meanPitchPerBurst{i} = thisUnitMeanPitch;
    if ~isempty(thisUnitMeanPitch)
        meanPitchPerBurstNoNan{end+1} = thisUnitMeanPitch;
    end
end

trueRange = zeros(length(meanPitchPerBurstNoNan), 1);
trueVar = zeros(length(meanPitchPerBurstNoNan), 1);
randRange = zeros(length(meanPitchPerBurstNoNan), 1);
randVar = zeros(length(meanPitchPerBurstNoNan), 1);
allNBurst = zeros(length(meanPitchPerBurstNoNan), 1);
randPermIdxes = {};
load('zfBurstPitch.mat', 'randPermIdxes')
for i = 1:length(meanPitchPerBurstNoNan)
    thisVec = meanPitchPerBurstNoNan{i};

    trueRange(i) = range(thisVec);
    trueVar(i) = var(thisVec);

    allNBurst(i) = length(meanPitchPerBurst{i});

    delMeanPitchPerBurst = meanPitchPerBurst';
    delMeanPitchPerBurst(i) = [];
    remainingDots = [delMeanPitchPerBurst{:}];

    thisRandPermIdx = randPermIdxes{i};
    randVec = remainingDots(thisRandPermIdx);
    randRange(i) = range(randVec);
    randVar(i) = var(randVec);
end


u = 84;
timeWin = [song1SyTime(1,1), song1SyTime(nSy(b),2)];
plotRaster(sua(u), zfaudio, timeWin, 30000, 0, [], 10, 3, 0);  
ax = findall(gcf, 'type', 'axes');
clim(ax(2), [-115, -65]);
axes(ax(2))
hold on
for i = 1:size(song1SyTime, 1)
    x = song1SyTime(i, 1):0.001:...
        (song1SyTime(i, 1)+0.001*(length(song1SyPitch{i})-1));
    y = song1SyPitch{i};
    y(y==0) = nan;
    plot(x,y, 'w-', 'lineWidth', 1);
end
thisBurstPitchTimePoint = allPitchBurstTimePoint{u};
thisPitchPoint = allPitchPoint{u};
for i = 1:length(thisPitchPoint)
    plot(thisBurstPitchTimePoint{i}, thisPitchPoint{i}, 'k-', 'lineWidth', 1);
    plot(thisBurstPitchTimePoint{i}, mean(thisPitchPoint{i}, 'omitnan')*ones(length(thisBurstPitchTimePoint{i}),1), 'k-', 'lineWidth', 1);
    plot(thisBurstPitchTimePoint{i}, 6500*ones(1, length(thisBurstPitchTimePoint{i})), 'k-', 'lineWidth', 1);
end
axes(ax(1))
hold on
xlims = xlim();
plot([xlims(1), xlims(1)+0.1], [1, 1], 'k-', 'LineWidth', 1)
ax(1).XAxis.Visible = 'off';
ylabel([]);
ylableticks = yticks();
yticks(ylableticks([1,end]))
for i = 1:nSy(b)
    thisBursts = bt{u, i};
    for j = 1:size(thisBursts, 1)
        thisBurst = thisBursts(j,:);
        plot([thisBurst(1), thisBurst(2)], [.6,.6], 'r-');
    end
end
meanPitchPerBurst{u}
exportgraphics(gcf, ['Paper\Fig4_zfExampleBurstPitch.pdf'], 'contentType', 'vector')


% three example tuning curves
b = 3;
binLim = [0, 0.02];
outputDir = ['Zf_pitch\']; 
examU = [19, 84, 90];
for i = examU
    gap = zfPitchTuning(b).pitchEdges(2)-zfPitchTuning(b).pitchEdges(1);
    unitResp = zfPitch(b).allUnitRespMatrix(i,:);
    pitchToInclude = zfPitch(b).allPitchFlag;
    goodPitchRes = unitResp(pitchToInclude);

    spikeEdges = 0:1:max(unitResp(zfPitch(b).allPitchFlag))+1;
    N = histcounts2(goodPitchRes, zfPitch(b).allPitch(pitchToInclude), spikeEdges, zfPitchTuning(b).pitchEdges);
    Nnormed = N/sum(N(:));
    pubFig([21, 2.5, 2.5, 2]);
    imagesc([zfPitchTuning(b).pitchEdges(1)+gap/2, zfPitchTuning(b).pitchEdges(end)-gap/2], [0.5, spikeEdges(end)-0.5]*1000/25, Nnormed, "AlphaData", Nnormed>0) %0.001); %N>0.001);
    set(gca,'ydir','normal');
    colorbar;
    colormap(flipud(gray));
    yticks([0:2:spikeEdges(end)]*1000/25)
    box off;
    clim(binLim)
    xlim([0, 5000]);
    xticks(0:1000:5000);
    xticklabels(0:1:5);
    xlabel('Pitch (kHz)');
    ylabel('Spikes/s');
    hold on;
    errorbar(zfPitchTuning(b).pitchCurveMidPoint, zfPitchTuning(b).pitchTuningCurve(i,:), zfPitchTuning(b).pitchTuningCurveSe(i,:), '.-','markersize', 10, 'CapSize', 2, 'MarkerFaceColor', 'r')
    title(['U' num2str(i), ' Tuning Idx:', num2str(zfPitchTuning(b).pitchTuningIdx(i))]);
    exportgraphics(gcf, ['Paper\Fig4_ZFUnitTuning_', 'ZF' num2str(b), '_U', num2str(i), '.pdf'], 'contentType', 'vector');
end

pubFig([21,0, 2,2]);
hold on;
histogram(trueRange, [0:500:4500],'normalization', 'probability');
histogram(randRange, [0:500:4500],'normalization', 'probability');
ranksum(trueRange, randRange)
title(['ZF', num2str(b),  ' P=', num2str(ranksum(trueRange, randRange))])
xlabel('Pitch range (Hz)');
legend({'Data', 'Randomly sampled'}, 'location', 'north')
exportgraphics(gcf, ['paper\Fig4_burstPitchRangeZF', num2str(b), '.pdf'], 'contentType', 'vector')

pubFig([21,0, 2,2]);
hold on;
histogram(trueVar, [0:0.5e6:5e6],'normalization', 'probability');
histogram(randVar, [0:0.5e6:5e6],'normalization', 'probability');
ranksum(trueVar, randVar)
title(['ZF', num2str(b),  ' P=', num2str(ranksum(trueVar, randVar))])
xlabel('Pitch var');
legend({'Data', 'Randomly sampled'}, 'location', 'northeast')
exportgraphics(gcf, ['paper\Fig4_burstPitchVarZF', num2str(b), '.pdf'], 'contentType', 'vector')

pubFig([21, 0, 6, 2.2]);
hold on
for i = 1:length(sua)
    plot(i*ones(length(meanPitchPerBurst{i}), 1), meanPitchPerBurst{i}, 'k.', 'markersize', 4);
end
xlim([0.5, length(sua)+0.5])
xticks([1, 10:10:length(sua), length(sua)])
xlabel('Neuron #')
ylabel('Pitch (Hz)')
title(['ZF', num2str(b)])
exportgraphics(gcf, ['paper\Fig4_burstPitchZF', num2str(b), '.pdf'], 'contentType', 'vector')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END
