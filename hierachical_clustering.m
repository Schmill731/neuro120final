%% Hierarchical Clustering of Temporal Correlations

%% Perform Hierarchical Clustering
run('generate_time_matrix.m')

% Perform clustering
merges = linkage(dist1, 'ward');

% Plot dendrogram to visualize number of clusters
dendrogram(merges)

% Determine number of clusters
numclusters = 2;
cluster_id = cluster(merges, 'maxclust', numclusters);


%% Load data files to visualize clusters
load('Data4Class/Fish1.mat');
load('Data4Class/Fish2.mat');

%% Visualize clusters
display = visualize_brain('Fish1', cluster_id);
implay(display)


