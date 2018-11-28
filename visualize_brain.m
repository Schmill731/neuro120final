%% Allows for Visualization of Brain Regions
function display = visualize_brain(fish, values)
% Fish should be 'Fish1' or 'Fish2'
% values should be an n x 1 matrix where n is the number of ROIs in Fish
% elements in values should be 0 for no color; 1 for red; 2 for green; 3
% for blue

    %% Load data files to visualize clusters
    load('Data4Class/refbrain.mat');
    if fish == 'Fish1'
        load('Data4Class/Fish1.mat');
        Fish = Fish1;
    elseif fish == 'Fish2'
        load('Data4Class/Fish2.mat');
        Fish = Fish2;
    else
        Fish = 0;
    end

    %% Build colored brain (just red)
    visualization = zeros(size(refbrain));
    for i = 1:size(refbrain, 1)
        for j = 1:size(refbrain, 2)
            for k = 1:size(refbrain, 4)
                if Fish.roi2map(i, j, k) ~= 0
                    if values(Fish.roi2map(i, j, k)) == 1
                        visualization(i, j, 1, k) = values(Fish.roi2map(i, j, k));
                    elseif values(Fish.roi2map(i, j, k)) == 2
                        visualization(i, j, 2, k) = values(Fish.roi2map(i, j, k));
                    elseif values(Fish.roi2map(i, j, k)) == 3
                        visualization(i, j, 3, k) = values(Fish.roi2map(i, j, k));
                    end
                end
            end
        end
    end

    %% Display colored brain on top of reference brain
    display = refbrain + visualization;
end