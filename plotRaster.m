function plotRaster(sua, audio, timeWin, sampleRate, saveFig, figName, padding, segment, neuralDelay)
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
    %[power, T] = mySpec(audio, timeWinPadded, sampleRate, 0, []);
    [power, T] = mySpec(audio, timeWinPadded, sampleRate, 0, []);
    imagesc(T, 300:5:7e3, power);
    xlim(timeWinPadded)
    xticks(timeWinPadded(1):0.02:timeWinPadded(2));
    set(gca,'ydir','normal');
    xticklabels([]);
    %yticks([]);
    %yticks(0:500:13000);
    ylim([300, 7000])
    ylabel('Hz')
    colormap('turbo')
    set(gca, 'TickDir', 'out');
    box off
    %clim([-100, -50])
    %clim([-120, -60])
    clim([-90, -50]);
    axes('position', [0.1800 0.100 0.7750 0.695]);
    hold on;
    axis ij
    unitsRange = [1, length(sua)];
    yLevel = unitsRange(1);
    for i = unitsRange(1):unitsRange(2)%length(sua)
        spikeTimes = sua(i).spikeTimes + neuralDelay/1000;
        goodSpikeTimes = spikeTimes((spikeTimes>timeWinPadded(1)) & (spikeTimes<timeWinPadded(2)));
        for j = 1:length(goodSpikeTimes)
            time = goodSpikeTimes(j);
            plot([time, time], [yLevel-0.4, yLevel+0.4], 'k-', 'LineWidth', 1);
        end
        yLevel = yLevel+1;
    end
    set(gca, 'TickDir', 'out');
    xticks([timeWinPadded(1):0.02:timeWinPadded(2)]);
    xticklabels([timeWinPadded(1):0.02:timeWinPadded(2)]-timeWin(1));
    xlabel('Time (s)')
    if unitsRange(2)>1
        if rem(unitsRange(2), 5)
            yticks([unitsRange(1), 5:5:unitsRange(2), unitsRange(2)])
        else
            yticks([unitsRange(1), 5:5:unitsRange(2)])
        end
    end
    ylabel('# Units')
    xlim(timeWinPadded)
    ylim([unitsRange(1)-0.5,unitsRange(2)+0.5])
    if saveFig
        exportgraphics(gcf, [figName '.jpg']);
        %exportgraphics(gcf, [figName '.pdf'], 'ContentType','vector');
        %savefig([figName '.fig']);
        close all
    end
    
else
    startPoint = timeWinPadded(1);
    endPoint = timeWinPadded(2);
    timeGap = segment;
    x = startPoint;
    seg = 0;
    while x < endPoint
        seg = seg+1;
        seg
        curTimeWin = [x, x+timeGap];
        %sampleWin = round(curTimeWin*sampleRate);
        x = x+timeGap;
        figure('position', [1949        -252        figUnitWidth*segment        1200]);
        axes('position', [0.1300 0.800 0.7750 0.195]);
        % if ifclip
        %     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:13000, 0.6, 256, 226, [], 0, curTimeWin(1));
        % else
        %     T = vigiSpec(audio(sampleWin(1):sampleWin(2)), 30000, 0:5:13000, 0, 256, 226, [], 0, curTimeWin(1));
        % end
        [power, T] = mySpec(audio, curTimeWin, sampleRate, 0, []);
        %[power, T] = mySpecFull(audio, curTimeWin, sampleRate, 0, []);
        imagesc(T, 300:5:7e3, power);
        xticks(timeWinPadded(1):0.02:timeWinPadded(2));
        set(gca,'ydir','normal');
        xlim(curTimeWin)
        xticks([curTimeWin(1):0.02:curTimeWin(2)]);
        xticklabels([]);
        %yticks(0:500:13000);
        %yticks([])
        ylim([300, 7000])
        colormap('turbo')
        set(gca, 'TickDir', 'out');
        box off
        clim([-90, -50])
        axes('position', [0.1300 0.100 0.7750 0.695]);
        hold on;
        axis ij
        unitsRange = [1, length(sua)];
        yLevel = unitsRange(1);
        for i = unitsRange(1):unitsRange(2)%length(sua)
            spikeTimes = sua(i).spikeTimes + neuralDelay/1000;
            goodSpikeTimes = spikeTimes((spikeTimes>curTimeWin(1)) & (spikeTimes<curTimeWin(2)));
            for j = 1:length(goodSpikeTimes)
                time = goodSpikeTimes(j);
                plot([time, time], [yLevel-0.4, yLevel+0.4], 'k-', 'LineWidth', 1);
            end
            yLevel = yLevel+1;
        end
        set(gca, 'TickDir', 'out');
        xticks([curTimeWin(1):0.02:curTimeWin(2)]);
        xticklabels([curTimeWin(1):0.02:curTimeWin(2)]-timeWin(1));
        xlabel('Time (s)')
        if unitsRange(2)>1
            if rem(unitsRange(2), 5)
                yticks([unitsRange(1), 5:5:unitsRange(2), unitsRange(2)])
            else
                yticks([unitsRange(1), 5:5:unitsRange(2)])
            end
        end
        ylabel('# Units')
        xlim(curTimeWin)
        ylim([unitsRange(1)-0.5,unitsRange(2)+0.5])
        if saveFig
            exportgraphics(gcf, [figName '_' num2str(seg) '.jpg']);
            %savefig([figName '_' num2str(seg) '.fig']);
            close all
        end
        
    end
end
end