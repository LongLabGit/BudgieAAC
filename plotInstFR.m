function plotInstFR(sua, audio, timeWin, sampleRate, instFR, saveFig, figName, padding, segment, neuralDelay)
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

if timeWinPadded(2)-timeWinPadded(1)<=segment
    %sampleWin = round(timeWinPadded*sampleRate);
    figure('position', [1949        -252        figUnitWidth*(timeWinPadded(2)-timeWinPadded(1))        1200]);
    axes('position', [0.1800 0.800 0.7750 0.195]);
    % if ifclip
    %     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:8000, 0.6, 256, 226, [], 0, timeWinPadded(1));
    % else
    %     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:8000, 0, 256, 226, [], 0, timeWinPadded(1));
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
    %clim([-100, -50])
    %clim([-120, -60])
    clim([-90, -50]);
    ax2 = axes('position', [0.1800 0.100 0.7750 0.695]);
    hold on;
    axis ij
    imagesc(T, 1:length(sua),  instFR);
    %colormap(ax2, flipud(gray));
    colormap(ax2, gray);
    %colormap(ax2, 'hot');
    %colormap(ax2, 'bone');
    xlim(timeWinPadded)
    xticks(timeWinPadded(1):0.02:timeWinPadded(2));
    ylim([0.5,length(sua)+0.5])
    axis off
    % set(gca, 'TickDir', 'out');
    % ylabel('# Units')
    % ylim([unitsRange(1)-0.5,unitsRange(2)+0.5])
    if saveFig
        exportgraphics(gcf, [figName '.jpg']);
        %exportgraphics(gcf, [figName '.pdf'], 'ContentType','vector');
        %savefig([figName '.fig']);
        close all
    end
    
else
    return;
end
