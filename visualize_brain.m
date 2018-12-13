%% Allows for Visualization of Brain Regions
function display = visualize_brain(values, roi2map)
% Fish should be 'Fish1' or 'Fish2'
% values should be an n x 1 matrix where n is the number of ROIs in Fish
% elements in values should be 0 for no color; 1 for red; 2 for green; 3
% for blue

    %% Load data files to visualize clusters
    load('Data4Class/refbrain.mat');


    %% Build colored brain (just red)
    visualization = (1 - refbrain);
    for i = 1:size(refbrain, 1)
        for j = 1:size(refbrain, 2)
            for k = 1:size(refbrain, 4)
                if roi2map(i, j, k) ~= 0
                    if values(roi2map(i, j, k)) == 1
                        visualization(i, j, 1, k) = 1;
                    elseif values(roi2map(i, j, k)) == 2
                        visualization(i, j, 2, k) = 1;
                    elseif values(roi2map(i, j, k)) == 3
                        visualization(i, j, 3, k) = 1;
                    elseif values(roi2map(i, j, k)) == 4
                        visualization(i, j, 1:2, k) = 1;
                    elseif values(roi2map(i, j, k)) == 5
                        visualization(i, j, 2:3, k) = 1;
                    elseif values(roi2map(i, j, k)) == 6
                        visualization(i, j, [1 3], k) = 1;
                    elseif values(roi2map(i, j, k)) == 7
                        visualization(i, j, [2 3], k) = 1;
                    end
                end
            end
        end
    end

    %% Display colored brain on top of reference brain
    display = visualization;
end