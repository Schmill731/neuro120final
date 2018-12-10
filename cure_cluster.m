%% Hierarchical Clustering using CURE

%% Load data
load('Data4Class/Fish1.mat');
load('Data4Class/Fish2.mat');

%% Subsample data
% use randi
% output sub_dist

subActivityloc2 = randi(size(Fish2.CalciumActivity, 1), ...
    round(size(Fish2.CalciumActivity, 1)*0.1), 1);
subActivity2 = Fish2.CalciumActivity(subActivityloc2, :);
corr2 = 1- corr(subActivity2');

% sub_dist = dist(test(subActivityloc1));

% run('generate_time_matrix.m')

% distances = mean(time_distance1, 2)';
% sub_dist_loc = randi(size(distances, 2), 1, round(size(distances, 2)*0.05));
% sub_dist = distances(:, sub_dist_loc);
% sub_dist_matrix = dist(sub_dist);

%% Perform Hierarchical Clustering

% Perform clustering
merges2 = linkage(corr2, 'complete', 'correlation');

% Plot dendrogram to visualize number of clusters
figure();
dendrogram(merges2)

% Determine number of clusters
numclusters = 5;
sub_id2 = cluster(merges2, 'maxclust', numclusters);
max(sub_id2)

%% Cluster non-representative points
cluster_id2 = zeros(1, size(Fish2.CalciumActivity, 1));
parfor_progress(size(Fish2.CalciumActivity, 1));
parfor i = 1:size(Fish2.CalciumActivity, 1)
    % Find nearest point
    iCorr = 1 - corr(Fish2.CalciumActivity(i, :)', subActivity2');
    [~,I] = min(iCorr);
    cluster_id2(i) = sub_id2(I);
    parfor_progress;
%     if mod(i, 500) == 0
%         disp(i);
%     end
end

% %% Cluster non-representative points
% cluster_id = zeros(1, size(Fish1.CalciumActivity, 1));
% for i = 1:size(Fish1.CalciumActivity, 1)
%     % Find nearest point
%     diff = test(i) - sub_dist;
%     distance = diff'*diff;
%     [~,I] = min(diag(distance));
%     cluster_id(i) = sub_id(I);
%     if mod(i, 500) == 0
%         disp(i);
%     end
% end

%% Visualize clusters
test = cluster_id;
test(test == 4) = 0;
display = visualize_brain(test, Fish1.roi2map);
implay(display)
v = VideoWriter('5cluster5showncorrmethodfish1test');
open(v);
writeVideo(v, display);
close(v);

%% Compute average
% centroids = zeros(1, numclusters);
% for i = 1:numclusters
%     centroids(i) = mean(test(cluster_id == i));
% end
