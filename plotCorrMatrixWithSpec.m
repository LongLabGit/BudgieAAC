function corrax = plotCorrMatrixWithSpec(tcorr, specs, specClim, setYdirNormal)
% corr matrix horizontal is the first syllable

if nargin < 4
    setYdirNormal = 1;
end


syLength(1) = size(tcorr, 2)*10+10;
syLength(2) = size(tcorr, 1)*10+10;


inchesPerMs = 0.006;
gap = 0.05;
initialGap = 1.2;
%specHeight = 0.7;
specHeight = 0.3;
%specHeight = 0.5; % for talk
figSize = 5;

cmap = "turbo";
%specMap = 'bone';
specMap = 'gray';


% spec corr
figure('Units', 'inches', 'Position', [21, .2, figSize, figSize]);
corrax = axes('Units', 'inches', 'Position', [initialGap, initialGap, size(tcorr,2)*10*inchesPerMs, size(tcorr,1)*10*inchesPerMs]);
imagesc(tcorr);  
colormap(cmap);
hold on;
plot([0.5, 2.5], [5,5], 'k-', 'lineWidth', 1);
axis off

% plot spectrogram
axes('Units', 'inches', 'Position', [initialGap-5*inchesPerMs, initialGap+size(tcorr,1)*10*inchesPerMs+gap, syLength(1)*inchesPerMs, specHeight]);
imagesc(specs{1}(:, 1:syLength(1)));
if setYdirNormal
    set(gca, 'ydir', 'normal');
end
axis off
colormap(gca, specMap);
clim(specClim);
hold on
plot([0.5, 20.5], [500, 500], 'w-', 'LineWidth', 1);

% vertical
axes('Units', 'inches', 'Position', [initialGap-gap-specHeight, initialGap-5*inchesPerMs, specHeight, syLength(2)*inchesPerMs]);
imagesc(specs{2}(:, 1:syLength(2))');
set(gca, 'xdir', 'reverse');
if setYdirNormal
    set(gca, 'ydir', 'normal');
end
axis off
colormap(gca, specMap);
clim(specClim);
hold on;
plot([500, 500], [0.5, 20.5], 'w-', 'LineWidth', 1);



% % neural corr
% figure('Units', 'inches', 'Position', [21, .2, figSize, figSize]);
% axes('Units', 'inches', 'Position', [initialGap, initialGap, size(tcorr,2)*10*inchesPerMs, size(tcorr,1)*10*inchesPerMs])
% imagesc(ncorr);  
% colormap(cmap);
% hold on;
% plot([0.5, 5.5], [5,5], 'k-', 'lineWidth', 1);
% axis off
% 
% % plot vertical spectrogrogram
% axes('Units', 'inches', 'Position', [initialGap-gap-specHeight, initialGap-5*inchesPerMs, specHeight, syLength(2)*inchesPerMs]);
% imagesc(specs{2}(:, 1:syLength(2))');
% set(gca, 'xdir', 'reverse');
% set(gca, 'ydir', 'normal');
% axis off
% colormap(gca, specMap);
% clim(specClim);




% % neural corr
% figure('Units', 'inches', 'Position', [21, .2, figSize, figSize]);
% 
% for i = 1:size(selectPair,1)
%     x = selectPair(i,1);
%     y = selectPair(i,2);
%     if x == 1
%         if y == 2
%             axes('Units', 'inches', 'Position', [initialGap, initialGap, syLength(x)*inchesPerMs, syLength(y)*inchesPerMs])
%         else
%             axes('Units', 'inches', 'Position', [initialGap, initialGap+sum(syLength(2:y-1))*inchesPerMs+(y-2)*gap, syLength(x)*inchesPerMs, syLength(y)*inchesPerMs]);
%         end
%     else
%         axes('Units', 'inches', 'Position', [initialGap+sum(syLength(1:x-1))*inchesPerMs+(x-1)*gap, initialGap+sum(syLength(2:y-1))*inchesPerMs+(y-2)*gap, syLength(x)*inchesPerMs, syLength(y)*inchesPerMs]);
%     end
%     imagesc(ncorrs{i}');
%     set(gca, 'ydir', 'normal');
%     axis off
%     clim([minNcorr, maxNcorr]);
%     colormap(cmap)
% 
%     % hold on;
%     % plot([0, 100], [10,10], 'w-', 'lineWidth', 2);
% 
%     nAxes{end+1} = gca;
% end
% 
% % colorbar
% %axes('Units', 'inches', 'Position', [initialGap + sum(syLength(1:end-2))*inchesPerMs+gap, initialGap, syLength(1)*inchesPerMs, colorbarHeight]);
% lastAxesPos = nAxes{end}.Position;
% axes('Units', 'inches', 'Position', [lastAxesPos(1)+lastAxesPos(3)+gap, lastAxesPos(2), colorbarHeight, colorbarHeight]);
% clim([minNcorr, maxNcorr]);
% colormap(cmap);
% nCb = colorbar;
% axis off;
% 
% nAxes{end+1} = gca;





