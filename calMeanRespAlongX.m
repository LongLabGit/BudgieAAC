function [meanResp, sdResp, seResp, rsquare, nPoints, indices, pointSd, pct10, pct90] = calMeanRespAlongX(x, y, xvector, win, minNPoints)

if nargin < 5
    minNPoints = 1;
end

assert(length(x) == length(y));

meanResp = zeros(1, length(xvector));
sdResp = zeros(1, length(xvector));
seResp = zeros(1, length(xvector));
indices = cell(length(xvector), 1);
nPoints = zeros(length(xvector), 1);
pct10 = zeros(1, length(xvector));
pct90 = zeros(1, length(xvector));

ssres = 0;
sstotal = 0;
pointsToInclude = [];
for p = 1:length(xvector)
    thisP = xvector(p);
    if p == length(xvector)
        idx = find((x>=thisP-win/2) & (x<=thisP+win/2));
    else
        idx = find((x>=thisP-win/2) & (x<thisP+win/2));
    end
    nPoints(p) = length(idx);
    if length(idx) <= minNPoints
        meanResp(p) = nan;
        varResp(p) = nan;
        seResp(p) = nan;
    else
        meanResp(p) = mean(y(idx), "omitnan");
        sdResp(p) = std(y(idx), [], "omitnan");
        seResp(p) = sdResp(p)/sqrt(nPoints(p));
        indices{p} = idx;
        ssres = ssres + sum((y(idx)-meanResp(p)).^2);
        pointsToInclude = [pointsToInclude, y(idx)];
        if nargout > 7
            pct10(p) = prctile(y(idx), 10);
            pct90(p) = prctile(y(idx), 90);
        end
    end
end
sstotal = sum((pointsToInclude - mean(pointsToInclude)).^2);
rsquare = 1-ssres/sstotal;
pointSd = std(pointsToInclude);
end