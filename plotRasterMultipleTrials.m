function f = plotRasterMultipleTrials(sua, unitIds, audio, timeWin, ifScaleNeural, scaleWin, sampleRate, ifclip, saveFig, figName, padding, segment, neuralDelay)

% Plot multiple trials raster for each unit in unitIds.
% if unitIds is [], then all units in sua are included

% timeWin is the full window to plot
% scaleWin is the time segment used to scale 
% padding in ms


if isempty(unitIds)
    unitIds = 1:length(sua);
end

if nargin < 5
    ifScaleNeural = 0;
    scaleWin = [];
    sampleRate = 30000;
    ifclip = 0;
    saveFig = 0;
    figName = '';
    %padding = 0;
    padding = 80;   %default 80 ms padding
    segment = 3;    % defautl segment length 3s
    neuralDelay = 0;
end

padding = padding/1000;

scaleTimeRef = 0/1000;  % scale from 0 before vocal onset.


sua = sua(unitIds);

matlabColors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840] ];

%matlabColors = [[0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840]; [0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840] ];


timeWinPadded = [timeWin(1,1)-padding, timeWin(1,2)+padding];

figUnitWidth = 2489/segment;

%figUnitWidth = 3200/segment;

%sampleWin = round(timeWinPadded*sampleRate);
f = figure('position', [1949        -252        figUnitWidth*(timeWinPadded(2)-timeWinPadded(1))        1200]);
axes('position', [0.1800 0.92 0.7750 0.078]);
% if ifclip
%     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:13000, 0.55, 256, 226, [], 0, timeWinPadded(1));
% else
%     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:13000, 0, 256, 226, [], 0, timeWinPadded(1));
% end
[power, T] = mySpec(audio, timeWinPadded, sampleRate, 0, []);
imagesc(T, 300:5:7e3, power);
xlim(timeWinPadded)
xticks(timeWinPadded(1):0.02:timeWinPadded(2));
set(gca,'ydir','normal');
xticklabels([]);
%yticks([]);
%yticks(0:500:13000);
ylabel('Hz')
colormap('turbo')
set(gca, 'TickDir', 'out');
box off
clim([-100, -50])
axes('position', [0.1800 0.0700 0.7750 0.84]);
hold on;
axis ij
unitsRange = [1, length(sua)];
yLevel = unitsRange(1);
for i = unitsRange(1):unitsRange(2)%length(sua)
    spikeTimes = sua(i).spikeTimes + neuralDelay/1000;
    goodSpikeTimes = spikeTimes((spikeTimes>timeWinPadded(1)) & (spikeTimes<timeWinPadded(2)));
    thisColor = mod(i,size(matlabColors,1));
    if thisColor == 0
        thisColor = 7;
    end
    
    for j = 1:length(goodSpikeTimes)
        time = goodSpikeTimes(j);
        plot([time, time], [yLevel-0.4, yLevel+0.4], '-', 'LineWidth', 1,'Color', matlabColors(thisColor, :));
    end
    yLevel = yLevel+1;
    for k = 2:size(timeWin, 1)
        thisTimeWinPadded = [timeWin(k,1)-padding, timeWin(k,2)+padding];
        goodSpikeTimes = spikeTimes((spikeTimes>thisTimeWinPadded(1)) & (spikeTimes<thisTimeWinPadded(2)));
        for j = 1:length(goodSpikeTimes)
            if ifScaleNeural && goodSpikeTimes(j) >= timeWin(k,1)+scaleTimeRef
                time = (goodSpikeTimes(j) - (timeWin(k,1)+scaleTimeRef)) / ((scaleWin(k,2)-scaleWin(k,1))/(scaleWin(1,2)-scaleWin(1,1))) + (timeWin(1,1)+scaleTimeRef);
            else
                time = goodSpikeTimes(j)-timeWin(k,1)+timeWin(1,1);
            end
            plot([time, time], [yLevel-0.4, yLevel+0.4], '-', 'LineWidth', 1, 'Color', matlabColors(thisColor, :));
        
        end
        yLevel = yLevel+1;
    end
    yLevel = yLevel+1;
end
set(gca, 'TickDir', 'out');
xticks([timeWinPadded(1):0.02:timeWinPadded(2)]);
xticklabels([timeWinPadded(1):0.02:timeWinPadded(2)]-timeWin(1));
xlabel('Time (s)')


% if rem(unitsRange(2), 5)
%     yticks([unitsRange(1), 5:5:unitsRange(2), unitsRange(2)])
% else
%     yticks([unitsRange(1), 5:5:unitsRange(2)])
% end
ylabel('# Units')
xlim(timeWinPadded)
ylim([1-0.5,yLevel-0.5])
yticks(1:size(timeWin,1)+1:yLevel);
yticklabels(unitIds);
if saveFig
    exportgraphics(gcf, [figName '.jpg']);
    %exportgraphics(gcf, [figName '.pdf'], 'ContentType','vector');
    %savefig([figName '.fig']);
    close all
end


maxSyllableLength = max(timeWin(:,2)-timeWin(:,1));
figure;
nTrials = size(timeWin, 1);
for i = 1:nTrials
    subplot(nTrials, 1, i);
    timeWinPadded = [timeWin(i,1)-padding, timeWin(i,2)+padding];
    % sampleWin = round(timeWinPadded*sampleRate);
    % vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:13000, 0, 256, 226, [], 0, -padding);
    % xlim([-padding, maxSyllableLength+padding]);

    [power, T] = mySpec(audio, timeWinPadded, sampleRate, 0, []);
    imagesc(T-timeWin(i,1), 300:5:7e3, power);
    xlim(timeWinPadded-timeWin(i,1));
    xticks(timeWinPadded(1):0.02:timeWinPadded(2));
    set(gca,'ydir','normal');
    xticklabels([]);
    clim([-100, -50])
    colormap('turbo')
    set(gca, 'TickDir', 'out');
    box off
end

