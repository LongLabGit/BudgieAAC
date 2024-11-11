function [power, timeLabel] = mySpecFull(signal, timeWin, sampleRate, ifplot, bgThresh)
%timeWin in Sec
% if timeWin has multiple rows, the spectrogram will be concatednated.

newTimeWin = round(timeWin*1000);
padding = 10;
audSig = signal(((newTimeWin(1)-padding)*sampleRate/1000):((newTimeWin(2)+padding)*sampleRate/1000));
[S,F,T,P]=spectrogram(audSig,256,256-0.001*sampleRate, 0:5:9e3,sampleRate);  %8ms window, stepSize 1ms
logP = 10*log10(P);
%logP = log10(P);
logP(isinf(logP)) = nan;
start = find(T>=padding/1000,1,'first');
trunctedP = logP(:,start:(start+newTimeWin(2)-newTimeWin(1)-1));
power = trunctedP;
timeLabel = (newTimeWin(1)-padding)/1000+T(start:(start+newTimeWin(2)-newTimeWin(1)-1));

if ifplot
    imagesc(1:size(power, 2), 0:5:9e3, power);
    set(gca,'ydir','normal');
    colormap('turbo');

    if nargin>4 && ~isempty(bgThresh)
        threshold = min(power(:)) + bgThresh * range(power(:));
        clim([threshold, max(power(:))]);
    else
        clim([-120, -50]);
    end
    
end

if nargin>4 && ~isempty(bgThresh)
    threshold = min(power(:)) + bgThresh * range(power(:));
    mask = power>=threshold;
    power(mask) = power(mask) - threshold;
    power(~mask) = 0;
end