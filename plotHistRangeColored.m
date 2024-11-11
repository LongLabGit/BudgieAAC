function plotHistRangeColored(h, threshLow, threshHigh, color)
%h is the histogram handle

hold on;
edges = h.BinEdges;

if ~isempty(threshLow) && ~isempty(threshHigh)
    pos1 = find(edges>=threshLow, 1, 'first');
    pos2 = find(edges<=threshHigh, 1, 'last');
    patch([threshLow, edges(pos1), edges(pos1), threshLow], [0, 0, h.Values(pos1-1), h.Values(pos1-1)], color, 'edgeColor', 'none')
    for i = pos1:pos2-1
        patch([edges(i), edges(i+1), edges(i+1), edges(i)], [0, 0, h.Values(i), h.Values(i)], color, 'edgeColor', 'none')
    end
    patch([edges(pos2), threshHigh, threshHigh, edges(pos2)], [0, 0, h.Values(pos2), h.Values(pos2)], color, 'edgeColor', 'none')
else

    if ~isempty(threshLow)
        pos = find(edges<=threshLow, 1, 'last');
        for i = 1:pos-1
            patch([edges(i), edges(i+1), edges(i+1), edges(i)], [0, 0, h.Values(i), h.Values(i)], color, 'edgeColor', 'none')
        end
        patch([edges(pos), threshLow, threshLow, edges(pos)], [0, 0, h.Values(pos), h.Values(pos)], color, 'edgeColor', 'none')
    end

    if ~isempty(threshHigh)
        pos = find(edges>=threshHigh, 1, 'first');
        patch([threshHigh, edges(pos), edges(pos), threshHigh], [0, 0, h.Values(pos-1), h.Values(pos-1)], color, 'edgeColor', 'none')
        for i = pos:length(edges)-1
            patch([edges(i), edges(i+1), edges(i+1), edges(i)], [0, 0, h.Values(i), h.Values(i)], color, 'edgeColor', 'none')
        end
    end
end