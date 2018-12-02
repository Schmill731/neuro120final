%% Hierarchical Clustering using CURE

%% Subsample data
% use randi
% output sub_dist

run('generate_time_matrix.m')

distances = mean(time_distance2, 2)';
sub_dist_loc = randi(size(distances, 2), 1, round(size(distances, 2)*0.05));
sub_dist = distances(:, sub_dist_loc);
sub_dist_matrix = dist(sub_dist);

%% Perform Hierarchical Clustering

% Perform clustering
merges = linkage(sub_dist_matrix, 'ward');

% Plot dendrogram to visualize number of clusters
dendrogram(merges)

% Determine number of clusters
numclusters = 4;
sub_id = cluster(merges, 'maxclust', numclusters);

%% Cluster non-representative points
cluster_id = zeros(1, size(Fish1.CalciumActivity, 1));
for i = 1:size(Fish1.CalciumActivity, 1)
    % Find nearest point
    diff = distances(i) - sub_dist;
    diff_dist = diff'*diff;
    [~,I] = min(diag(diff_dist));
    cluster_id(i) = sub_id(I);
    if mod(i, 500) == 0
        disp(i);
    end
end
    

%% Visualize clusters
test = cluster_id;
test(test == 3) = 0;
display = visualize_brain(cluster_id-1, Fish1.roi2map);
implay(display)

%% Compute average max response time delay
centroids = zeros(1, numclusters);
for i = 1:numclusters
    centroids(i) = mean(distances(cluster_id == i));
end
