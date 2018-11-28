%% Hierarchical Clustering of Temporal Correlations

%% Perform Hierarchical Clustering
% Assume that matrix of distances is already present
time_distance = rand(37324);
time_distance = time_distance - eye(37324)*diag(time_distance);


% Perform clustering
merges = linkage(time_distance, 'ward');

% Plot dendrogram to visualize number of clusters
dendrogram(merges)

% Determine number of clusters
numclusters = 2;
cluster_id = cluster(merges, 'maxclust', k);


%% Load data files to visualize clusters
load('Data4Class/Fish1.mat');
load('Data4Class/Fish2.mat');

%% Visualize clusters
maxActivity = max(max(Fish1.CalciumActivity));
normalizedActivity = Fish1.CalciumActivity/maxActivity;
toi = 321;
toiActivity = normalizedActivity(:, toi);
meanActive = toiActivity - mean(toiActivity);
moreActive = meanActive > 0;
lessActive = meanActive < 0;
input = moreActive + lessActive*3;
display = visualize_brain('Fish1', input);
implay(display)


