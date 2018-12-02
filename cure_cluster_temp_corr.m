%% Hierarchical Clustering using CURE

%% Load data

load('Data4Class/Fish1.mat');
load('Data4Class/Fish2.mat');

%% Determine which ROIs are common to both fish and only use those
ROIinBoth = (Fish1.roi2map ~= 0) & (Fish2.roi2map ~= 0);
uniqueROIs = find(ROIinBoth);

%% Subsample data
subROIloc = randi(size(uniqueROIs, 1), 1, round(size(uniqueROIs, 1)*0.0005));
subROI1 = unique(Fish1.roi2map(uniqueROIs(subROIloc)));
subROI2 = unique(Fish2.roi2map(uniqueROIs(subROIloc)));
subROIlocActivity1 = Fish1.CalciumActivity(Fish1.roi2map(uniqueROIs(subROIloc)), :);
subROIlocActivity2 = Fish2.CalciumActivity(Fish2.roi2map(uniqueROIs(subROIloc)), :);
subROIActivity1 = Fish1.CalciumActivity(subROI1, :);
subROIActivity2 = Fish2.CalciumActivity(subROI2, :);
corr1 = corr(subROIActivity1');
corr2 = corr(subROIActivity2');
subROImatrix = zeros(size(subROIloc, 2));
for i = 1:size(subROIloc, 2)
    for j = 1:size(subROIloc, 2)
        iInd1 = find(subROI1 == unique(Fish1.roi2map(uniqueROIs(subROIloc(i)))));
        jInd1 = find(subROI1 == unique(Fish1.roi2map(uniqueROIs(subROIloc(j)))));
        iInd2 = find(subROI2 == unique(Fish2.roi2map(uniqueROIs(subROIloc(i)))));
        jInd2 = find(subROI2 == unique(Fish2.roi2map(uniqueROIs(subROIloc(j)))));
        subROImatrix(i, j) = 1 - (corr1(iInd1, jInd1) + ...
            corr2(iInd2, jInd2))./2;
    end
    if mod(i, 100) == 0
        disp('Percent Complete with Subsampling:')
        disp(i/size(subROIloc, 2)*100)
    end
end

%% Perform Hierarchical Clustering

% Perform clustering
merges = linkage(subROImatrix, 'ward', 'correlation');

% Plot dendrogram to visualize number of clusters
dendrogram(merges)

% Determine number of clusters
numclusters = 2;
sub_id = cluster(merges, 'maxclust', numclusters);

%% Cluster non-representative points


%% Cluster non-representative points
cluster_id = zeros(1, size(Fish1.CalciumActivity, 1));
for i = 1:size(Fish1.CalciumActivity, 1)
    % Find nearest point
    iCorr = 1 - (corr(Fish1.CalciumActivity(i, :)', subROIlocActivity1')
%         corr(Fish2.CalciumActivity(Fish2.roi2map(uniqueROIs(i)), :)', subROIlocActivity2'))./2; 
    [~,I] = min(iCorr);
    cluster_id(i) = sub_id(I);
    if mod(i, 1000) == 0
        disp(i);
    end
end
unique_id = cluster_id(Fish1.roi2map(uniqueROIs));

%% OLD CODE
% cluster_id = zeros(1, size(Fish1.CalciumActivity, 1));
% for i = 1:size(Fish1.CalciumActivity, 1)
%     % Find nearest point
%     iCorr = 1 - (corr(Fish1.CalciumActivity(Fish1.roi2map(uniqueROIs(i)), :)',subROIlocActivity1')
% %         corr(Fish2.CalciumActivity(Fish2.roi2map(uniqueROIs(i)), :)', subROIlocActivity2'))./2; 
%     [~,I] = min(iCorr);
%     cluster_id(i) = sub_id(I);
%     if mod(i, 1000) == 0
%         disp(i);
%     end
% end
    

%% Visualize clusters
visualization = zeros(size(refbrain));
for i = 1:size(uniqueROIs)
    [j, k, l] = ind2sub(size(Fish1.roi2map), uniqueROIs(i));
    if cluster_id(i) == 1
        visualization(j, k, 1, l) = 1;
    elseif cluster_id(i) == 2
        visualization(j, k, 2, l) = 1;
    elseif cluster_id(i) == 3
        visualization(j, k, 3, l) = 1;
    end
end
display = (1 - refbrain) + visualization;
implay(display);

% %% Compute average max response time delay
% centroids = zeros(1, numclusters);
% for i = 1:numclusters
%     centroids(i) = mean(distances(cluster_id == i));
% end
