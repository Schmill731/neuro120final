%% Load data
load('clusterData_2018-12-12_2013.mat')

%% Build figure
fontsz = 20;
figure();
subplot(2, 1, 1);
dendrogram(merges1, 31)
title('Fish 1', 'FontSize', 30);
ax = gca;
ax.FontSize = fontsz;
ylim([0.5 2]);
subplot(2, 1, 2);
dendrogram(merges2, 38)
title('Fish 2', 'FontSize', 30);
ylim([0.5 2])
ax = gca;
ax.FontSize = fontsz;
