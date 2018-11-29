%% Hierarchical Clustering using CURE

%% Subsample data
% use randi
% output sub_dist

run('generate_time_matrix.m')

distances = time_distance(:, 3)';
sub_dist_loc = randi(size(distances, 2), 1, round(size(distances, 2)*0.05));
sub_dist = distances(:, sub_dist_loc);
sub_dist_matrix = dist(sub_dist);

%% Perform Hierarchical Clustering

% Perform clustering
merges = linkage(sub_dist_matrix, 'ward');

% Plot dendrogram to visualize number of clusters
dendrogram(merges)

% Determine number of clusters
numclusters = 3;
sub_id = cluster(merges, 'maxclust', numclusters);

%% Cluster non-representative points
cluster_id = zeros(1, size(Fish1.CalciumActivity, 1));
for i = 1:size(Fish1.CalciumActivity, 1)
    % Find nearest point
    diff = distances(i) - sub_dist;
    diff_dist = diff'*diff;
    [~,I] = min(diag(diff_dist));
    cluster_id(i) = sub_id(I);
    if mod(i, 100) == 0
        disp(i);
    end
end
    

%% Visualize clusters
display = visualize_brain('Fish1', cluster_id);
implay(display)


