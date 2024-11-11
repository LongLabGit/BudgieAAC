function [modIdx, bestCoord, fwhm, fwhmNormed, nBumps, bumpLength, modIdx2, curveRange, curveSd, der2nd, roughness] = characterizeTuningCurve(curve, coordinates)
    [maxResp, maxRespIdx] = max(curve);
    bestCoord = coordinates(maxRespIdx);

    [minResp, minRespIdx] = min(curve);

    curveRange = maxResp - minResp;
    curveSd = std(curve, "omitnan");

    modIdx = (maxResp-minResp)/(maxResp+minResp);

    modIdx2 = (maxResp-minResp)/maxResp;

    leftBoundary = find(~isnan(curve), 1, 'first');
    rightBoundary = find(~isnan(curve), 1, 'last');

    targetHeight = (maxResp+minResp)/2;

    leftSide = nan;
    for i = maxRespIdx-1:-1:leftBoundary
        if curve(i) <= targetHeight
            leftSide = i;
            leftIntersectPoint = (targetHeight-curve(i))/(curve(i+1)-curve(i))*(coordinates(i+1)-coordinates(i))+coordinates(i);
            %leftWidth = coordinates(maxRespIdx) - coordinates(leftSide);
            leftWidth = round(coordinates(maxRespIdx) - leftIntersectPoint);
            break;
        end
    end

    rightSide = nan;
    for i = maxRespIdx+1:rightBoundary
        if curve(i) <= targetHeight
            rightSide = i;
            rightIntersectPoint = (targetHeight-curve(i))/(curve(i-1)-curve(i))*(coordinates(i-1)-coordinates(i))+coordinates(i);
            %rightWidth = coordinates(rightSide) - coordinates(maxRespIdx);
            rightWidth = round(rightIntersectPoint - coordinates(maxRespIdx));
            break
        end
    end

    if isnan(leftSide)
        leftWidth = rightWidth;
    end

    if isnan(rightSide)
        rightWidth = leftWidth;
    end

    fwhm = leftWidth+rightWidth;
    fwhmNormed = fwhm/(coordinates(rightBoundary)-coordinates(leftBoundary));

    [~, intervalDur, ~] = calContinuousInterval(curve>=targetHeight);
    nBumps = size(intervalDur, 1);
    bumpLength = intervalDur;

    curve1d = curve(2:end)-curve(1:end-1);
    curve2d = curve1d(2:end)-curve1d(1:end-1);
    der2nd = mean(abs(curve2d), 'omitnan');
    roughness = der2nd/curveRange;