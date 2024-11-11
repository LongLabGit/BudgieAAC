function [cdist, pos] = myCdf(data)
    [dist, edges]  = histcounts(data, 50);
    cdist = cumsum(dist)./length(data);
    pos = edges(2:end);
end