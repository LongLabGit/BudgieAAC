function N = plotHeatmap(x, y, xEdges, yEdges, ifPlot, ifLog)

if nargin < 3 
    xEdges = [];
    yEdges = [];
    ifPlot = 1;
    ifLog = 0;
elseif nargin < 5
    ifPlot = 0;
    ifLog = 0;
elseif nargin < 6
    ifLog = 0;
end

if isempty(xEdges) || isempty(yEdges)
    xEdges = (min(x)-range(x)/100):range(x)/100:(max(x)+range(x)/100);
    yEdges = (min(y)-range(y)/100):range(y)/100:(max(y)+range(y)/100);
end

N = histcounts2(y, x, yEdges, xEdges);

Nnormed = N/sum(N(:));

if ifPlot
    figure;
    if ifLog
        imagesc(xEdges, yEdges, log10(N), "AlphaData", N>0);
    else
        %imagesc(xEdges, yEdges, N);
        imagesc(xEdges, yEdges, N, "AlphaData", N>0);
        % set(gca, 'color', 0*[1 1 1]);
    end
    set(gca,'ydir','normal');
    colorbar;
    colormap(flipud(gray));
    box off
    %clim([])
end
end