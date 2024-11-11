function plotRasterWithHarmLow2behavFullSpec(sua, audio, timeWin, sampleRate, saveFig, figName, padding, segment, neuralDelay, behav, behavOverlay)
% timeWin, segment in s
% padding, neuralDelay in ms

if nargin < 4
    sampleRate = 30000;
    saveFig = 0;
    figName = '';
    %padding = 0;
    padding = 80;   %default 80 ms padding
    segment = 3;    % defautl segment length 3s
    neuralDelay = 0;
end

timeWinPadded = [timeWin(1)-padding/1000, timeWin(2)+padding/1000];

figUnitWidth = 2489/segment;

%figUnitWidth = 3200/segment;

%sampleWin = round(timeWinPadded*sampleRate);
pubFig([21, 2.5, 4, 3]);
axes('Unit', 'Inches', 'Position', [0.5, 2.4, 3.1, 0.35])
%axes('position', [0.1 0.800 0.7750 0.13]);
% if ifclip
%     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:8000, 0.6, 256, 226, [], 0, timeWinPadded(1));
% else
%     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:8000, 0, 256, 226, [], 0, timeWinPadded(1));
% end
%[power, T] = mySpec(audio, timeWinPadded, sampleRate, 0, []);
[power, T] = mySpecFullFull(audio, timeWinPadded, sampleRate, 0, []);
imagesc(T, 0:5:15e3, power);
xlim(timeWinPadded)
xticks(timeWinPadded(1):0.02:timeWinPadded(2));
set(gca,'ydir','normal');
xticklabels([]);
%yticks([]);
%yticks(0:500:13000);
ylim([0, 15e3])
yticks([0:1000:15e3])
yticklabels([0:1000:15e3]/1000)
ylabel('Freq. (kHz)')
colormap('turbo')
set(gca, 'TickDir', 'out');
box off
%clim([-100, -50])
%clim([-120, -60])
clim([-90, -50]);
ax1 = gca;
ax1.XAxis.Visible = 'off';
ax1.TickLength = [0.01, 0.01];
if nargin >10
    hold on;
    plot(behavOverlay{1}, behavOverlay{2}, 'w-', 'lineWidth', 1);
end


axes('Unit', 'Inches', 'Position', [0.5, 1.3, 3.1, 1])
% axes('position', [0.1 0.385 0.7750 0.4]);
hold on;
axis ij
unitsRange = [1, length(sua)];
yLevel = unitsRange(1);
for i = unitsRange(1):unitsRange(2)%length(sua)
    spikeTimes = sua(i).spikeTimes + neuralDelay/1000;
    goodSpikeTimes = spikeTimes((spikeTimes>timeWinPadded(1)) & (spikeTimes<timeWinPadded(2)));
    for j = 1:length(goodSpikeTimes)
        time = goodSpikeTimes(j);
        plot([time, time], [yLevel-0.4, yLevel+0.4], 'k-', 'LineWidth', 0.3);
    end
    yLevel = yLevel+1;
end
set(gca, 'TickDir', 'out');
xticks([timeWinPadded(1):0.02:timeWinPadded(2)]);
xticklabels([timeWinPadded(1):0.02:timeWinPadded(2)]-timeWin(1));
xlabel('Time (s)')
if rem(unitsRange(2), 5)
    yticks([unitsRange(1), 5:5:unitsRange(2), unitsRange(2)])
else
    yticks([unitsRange(1), 5:5:unitsRange(2)])
end
ylabel('Neuron #')
xlim(timeWinPadded)
ylim([unitsRange(1)-0.5,unitsRange(2)+0.5])
ax2 = gca;
ax2.XAxis.Visible = 'off';
ax2.TickLength = [0.01, 0.01];


axes('Unit', 'Inches', 'Position', [0.5, 0.85, 3.1, 0.35])
%axes('position', [0.1 0.25 0.7750 0.13])
plot(behav{1}, behav{3}, 'k-');
ax = gca;
ylabel('Low freq. ratio')
ylim([-4, 4])
xlim(timeWinPadded)
xticks([timeWinPadded(1):0.2:timeWinPadded(2)]);
xticklabels([timeWinPadded(1):0.2:timeWinPadded(2)]-timeWin(1));
box off
ax.TickLength = [0.01, 0.01];

axes('Unit', 'Inches', 'Position', [0.5, 0.3, 3.1, 0.35])
%axes('position', [0.1 0.25 0.7750 0.13])
plot(behav{1}, behav{2}, 'k-');
ylabel('Harm. index')
ylim([0, 1])
xlim(timeWinPadded)
xticks([timeWinPadded(1):0.2:timeWinPadded(2)]);
xticklabels([timeWinPadded(1):0.2:timeWinPadded(2)]-timeWin(1));
box off
ax = gca;
ax.TickLength = [0.01, 0.01];
xlabel('Time (s)')




if saveFig
    exportgraphics(gcf, [figName '.jpg']);
    %exportgraphics(gcf, [figName '.pdf'], 'ContentType','vector');
    %savefig([figName '.fig']);
    close all
end

