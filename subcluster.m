maxclust1 = 38;
all_clusters = reshape(clustermap2, 1, prod(size(clustermap2)));
all_indices = 1:prod(size(clustermap2));
clusterroi2map = reshape(all_indices, size(clustermap2));
disp('Done')
%% Sum number of pixels in each cluster and convert to percent
disp('Quantifying/Investigating Clusters...');
numPixels = zeros(1, maxclust1);
for i = 1:maxclust1
    numPixels(i) = sum(all_clusters==i, 'double');
end
totalPixels = sum(sum(sum(clustermap2~=0)));
percentPixels = numPixels./totalPixels;
sortedPixels = sort(percentPixels, 'descend');

% Determine all clusters above 5% and plot them
top7 = find(ismember(percentPixels,sortedPixels(1:7)));
top7_clusters = all_clusters;
top7_clusters(~ismember(top7_clusters, top7)) = 0;
for i = 1:size(top7, 2)
    top7_clusters(top7_clusters == top7(i)) = i;
end
disp('Done')
%%
top_cluster_display = visualize_brain(top7_clusters, clusterroi2map);
top_cluster_display(refbrain<0.001) = 1;
v = VideoWriter('SupplementaryVideo1', 'MPEG-4');
open(v);
writeVideo(v, top_cluster_display);
close(v);

%% Find coordinates of pixels that are in each top cluster/ROIS
% top_clusters1=[7,15,19,20,26,27,31];
% top_clusters2=[1,4,12,16,22,37];
top_clusters1=[26];
top_clusters2=[22];
fish1_corr = zeros(1,7);
fish2_corr = zeros(1,6);
for i=1:size(top_clusters1)
    cluster_num = top_clusters1(i);
    temp=unique(Fish1.roi2map(clustermap1==top_clusters1(i)));
    subActivityloc1 = randi(size(temp, 1), ...
      round(size(temp, 1)*subset_percent), 1);
        
    subActivity1 = Fish1.CalciumActivity(subActivityloc1, :);

    fish1_corr = 1 - corr(subActivity1');
    
    % create new roi2map
    fish1newroi2map = Fish1.roi2map;
    
    % Perform clustering
    merges1 = linkage(fish1_corr, 'complete', 'correlation');
    % Plot Dendrogram to visualize number of clusters
    figure();
    dendrogram(merges1);
    % Cluster subsample
    sub_id1 = cluster(merges1,'cutoff', correlation_cutoff, 'criterion', 'distance');
    max(sub_id1)
    
    %% Cluster non-representative points in cluster
    disp('Clustering points in this cluster...');
    cluster_id1 = zeros(1, size(temp, 1));
    parfor_progress(size(temp, 1));
    parfor i = 1:size(temp, 1)
        % Find nearest point
        iCorr = 1 - corr(Fish1.CalciumActivity(i, :)', subActivity1');
        [~,I] = min(iCorr);
        cluster_id1(i) = sub_id1(I);
        parfor_progress;
    end
    
    %% Visualize clusters separately
    
    fish1newroi2map(~ismember(Fish1.roi2map, temp))=0;
    fish1newroi2map2 = zeros(1100,621,138);
    for i = 1:size(temp,1)
       fish1newroi2map2(ismember(fish1newroi2map, temp(i)))=i; 
    end
    %% Visualize
%     newroi2map2 = reshape(newroi2map2, size(Fish1.roi2map));
    disp('Visualizing clustering of this cluster...');
    for i = 1:round(max(sub_id1)/6)
        test = cluster_id1 - 6*(i - 1);
        display = visualize_brain(test, fish1newroi2map2);
        v = VideoWriter(sprintf('fish1cluster%i-subcluster%i-%i', cluster_num, (6*(i-1)+1), (6*(i-1)+6)));
        open(v);
        writeVideo(v, display);
        close(v);
    end
    disp(fprintf('Done with Fish 1 cluster %i', cluster_num))
end

for i=1:size(top_clusters2)
    cluster_num = top_clusters2(i)
    temp=unique(Fish2.roi2map(clustermap2==top_clusters2(i)));
    subActivityloc2 = randi(size(temp, 1), ...
      round(size(temp, 1)*subset_percent), 1);
        
    subActivity2 = Fish2.CalciumActivity(subActivityloc2, :);

    fish2_corr = 1 - corr(subActivity2');
    
    % create new roi2map
    fish2newroi2map = Fish2.roi2map;
    
    % Perform clustering
    merges2 = linkage(fish2_corr, 'complete', 'correlation');
    % Plot Dendrogram to visualize number of clusters
    figure();
    dendrogram(merges2);
    % Cluster subsample
    sub_id2 = cluster(merges2,'cutoff', correlation_cutoff, 'criterion', 'distance');
    max(sub_id2)
    
    %% Cluster non-representative points in cluster
    disp('Clustering points in this cluster...');
    cluster_id2 = zeros(1, size(temp, 1));
    parfor_progress(size(temp, 1));
    parfor i = 1:size(temp, 1)
        % Find nearest point
        iCorr = 1 - corr(Fish2.CalciumActivity(i, :)', subActivity2');
        [~,I] = min(iCorr);
        cluster_id2(i) = sub_id2(I);
        parfor_progress;
    end
    
    %% Visualize clusters separately
    
    fish2newroi2map(~ismember(Fish2.roi2map, temp))=0;
    fish2newroi2map2 = zeros(1100,621,138);
    for i = 1:size(temp,1)
       fish2newroi2map2(ismember(fish2newroi2map, temp(i)))=i; 
    end
    %% Visualize
%     newroi2map2 = reshape(newroi2map2, size(Fish1.roi2map));
    disp('Visualizing clustering of this cluster...');
    for i = 1:round(max(sub_id2)/6)
        test = cluster_id2 - 6*(i - 1);
        display = visualize_brain(test, fish2newroi2map2);
        v = VideoWriter(sprintf('fish1cluster%i-subcluster%i-%i', cluster_num, (6*(i-1)+1), (6*(i-1)+6)));
        open(v);
        writeVideo(v, display);
        close(v);
    end    
    disp(fprintf('Done with Fish 2 cluster %i', cluster_num))
end

