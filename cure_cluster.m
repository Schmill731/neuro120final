%% Hierarchical Clustering using CURE

% Set parameters
subset_percent = 0.1;
correlation_cutoff = 0.75;

%% Load data
disp('Loading data...');
load('Data4Class/Fish1.mat');
load('Data4Class/Fish2.mat');

%% Subsample data
disp('Subsampling data...');
subActivityloc1 = randi(size(Fish1.CalciumActivity, 1), ...
    round(size(Fish1.CalciumActivity, 1)*subset_percent), 1);
subActivity1 = Fish1.CalciumActivity(subActivityloc1, :);
corr1 = 1 - corr(subActivity1');
subActivityloc2 = randi(size(Fish2.CalciumActivity, 1), ...
    round(size(Fish2.CalciumActivity, 1)*subset_percent), 1);
subActivity2 = Fish2.CalciumActivity(subActivityloc2, :);
corr2 = 1 - corr(subActivity2');

%% Perform Hierarchical Clustering
disp('Clustering subsample...');
% Perform clustering
merges1 = linkage(corr1, 'complete', 'correlation');
merges2 = linkage(corr2, 'complete', 'correlation');

% Plot dendrogram to visualize number of clusters
figure();
dendrogram(merges1);
figure();
dendrogram(merges2);

% Cluster subsample
sub_id1 = cluster(merges1,'cutoff', correlation_cutoff, 'criterion', 'distance');
max(sub_id1)
sub_id2 = cluster(merges2,'cutoff', correlation_cutoff, 'criterion', 'distance');
max(sub_id2)

%% Cluster non-representative points for Fish 1
disp('Clustering all of Fish 1...');
cluster_id1 = zeros(1, size(Fish1.CalciumActivity, 1));
parfor_progress(size(Fish1.CalciumActivity, 1));
parfor i = 1:size(Fish1.CalciumActivity, 1)
    % Find nearest point
    iCorr = 1 - corr(Fish1.CalciumActivity(i, :)', subActivity1');
    [~,I] = min(iCorr);
    cluster_id1(i) = sub_id1(I);
    parfor_progress;
end

%% Cluster non-representative points for Fish 2
disp('Clustering all of Fish 2...');
cluster_id2 = zeros(1, size(Fish2.CalciumActivity, 1));
parfor_progress(size(Fish2.CalciumActivity, 1));
parfor i = 1:size(Fish2.CalciumActivity, 1)
    % Find nearest point
    iCorr = 1 - corr(Fish2.CalciumActivity(i, :)', subActivity2');
    [~,I] = min(iCorr);
    cluster_id2(i) = sub_id2(I);
    parfor_progress;
end

%% Align clusters between fish
clustermap1 = Fish1.roi2map;
clustermap1(clustermap1~=0) = cluster_id1(clustermap1(clustermap1~=0));
clustermap2 = Fish2.roi2map;
clustermap2(clustermap2~=0) = cluster_id2(clustermap2(clustermap2~=0));
overlappingindices = and(clustermap1~=0, clustermap2~=0);
updatedclustermap = clustermap1;
maxclust = max([max(sub_id1) max(sub_id2)]);
for i = 1:max(sub_id1)
    disp(i)
    idx = find(clustermap1(overlappingindices) == i, 1);
    if not(isempty(idx))
        updatedcluster = clustermap2(idx);
    else
        maxclust = maxclust + 1;
        updatedcluster = maxclust;
    end
        updatedclustermap(clustermap1 == i) = updatedcluster;
end
updatedclustermap(clustermap2~=0) = clustermap2(clustermap2~=0);

%% Save Cluster Data
disp('Saving data...');
cur_time = clock;
save(sprintf('clusterData_%i-%i-%i_%i%i.mat', cur_time(1), ...
    cur_time(2), cur_time(3), cur_time(4), cur_time(5)));

%% Visualize clusters together
all_indices = 1:prod(size(clustermap1));
all_clusters = reshape(updatedclustermap, 1, prod(size(clustermap1)));
clusterroi2map = reshape(all_indices, size(clustermap1));
for i = 1:ceil(maxclust/6)
    disp(i)
    corrected = all_clusters - 6*(i - 1);
    display = visualize_brain(corrected, clusterroi2map);
    v = VideoWriter(sprintf('combinedfishcluster%i-%i', (6*(i-1)+1), (6*(i-1)+6)));
    open(v);
    writeVideo(v, display);
    close(v);
end
%% Visualize clusters separately
disp('Displaying fish1...');
for i = 1:round(max(sub_id1)/6)
    test = cluster_id1 - 6*(i - 1);
    display = visualize_brain(test, Fish1.roi2map);
    v = VideoWriter(sprintf('fish1cluster%i-%i', (6*(i-1)+1), (6*(i-1)+6)));
    open(v);
    writeVideo(v, display);
    close(v);
end
disp('Displaying Fish2...');
for i = 1:round(max(sub_id2)/6)
    test = cluster_id2 - 6*(i - 1);
    display = visualize_brain(test, Fish2.roi2map);
    v = VideoWriter(sprintf('fish2cluster%i-%i', (6*(i-1)+1), (6*(i-1)+6)));
    open(v);
    writeVideo(v, display);
    close(v);
end
disp('Done!');

%% Compute average
% centroids = zeros(1, numclusters);
% for i = 1:numclusters
%     centroids(i) = mean(test(cluster_id == i));
% end
