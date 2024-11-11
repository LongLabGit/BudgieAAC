function [spec, specNorm, specThresh, specMean, specNormMean, specThreshMean] = processSpec(audio, timeWin, sampleRate)
% timeWin in integer ms


syllableLength = zeros(size(timeWin, 1));
padding = 10;    %10ms padding
spec = cell(size(timeWin, 1),1);
specConcat = [];
for i = 1:size(timeWin, 1)
    if sampleRate ==8000  % human data
        audSig = audio(((timeWin(i,1)-4*padding)*sampleRate/1000):((timeWin(i,2)+4*padding)*sampleRate/1000));
        [S,F,T,P]=spectrogram(audSig,256,256-0.001*sampleRate, 300:5:4e3,sampleRate);  %32ms window, stepSize 1ms. For human data
    else
        audSig = audio(((timeWin(i,1)-padding)*sampleRate/1000):((timeWin(i,2)+padding)*sampleRate/1000));
        [S,F,T,P]=spectrogram(audSig,256,256-0.001*sampleRate, 300:5:7e3,sampleRate);  %8ms window, stepSize 1ms. for bird data
    end
    %logP = 10*log10(P);
    logP = 10*log10(P);
    start = find(T>=padding/1000,1,'first');
    trunctedP = logP(:,start:(start+timeWin(i,2)-timeWin(i,1)));
    spec{i} = trunctedP;
    specConcat = [specConcat, trunctedP];
    syllableLength(i) = size(trunctedP,2);
end

if nargout>1
    specNorm = cell(size(timeWin, 1),1);
    meanSpecVec = mean(specConcat,2);
    %stdSpecVec = std(specConcat, [], 2);
    for i = 1:length(spec)
        %meanPower = mean(spec{i}, 1);
        %spec{i} = spec{i} - meanPower - meanSpecVec;
        specNorm{i} = spec{i} - meanSpecVec;
        %specNorm{i} = (spec{i} - repmat(meanSpecVec, [1, size(spec{i}, 2)])) ./ repmat(stdSpecVec, [1, size(spec{i},2)]);
    end
end

if nargout>2
    specThresh = spec;
    threshold = min(specConcat(:)) + range(specConcat(:))*0.6;
    for i = 1:length(spec)
        mask = spec{i} <= threshold;
        specThresh{i}(mask) = 0;
        specThresh{i}(~mask) = spec{i}(~mask) - threshold;
    end
end

if nargout > 3
    specMean = cell(size(timeWin, 1),1);
    specNormMean = cell(size(timeWin, 1), 1);
    specThreshMean = cell(size(timeWin, 1), 1);
    for i = 1:length(spec)
        specMean{i} = mean(spec{i}, 2);
        specNormMean{i} = mean(specNorm{i}, 2);
        specThreshMean{i} = mean(specThresh{i}, 2);
    end
end
