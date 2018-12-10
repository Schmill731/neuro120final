%% counts number of correlated roi above a threshold
map_type = 'stim';
filename = 'stim.avi';

stim = Fish1.Stimulus';
if strcmp(map_type,'left')
    stim = Fish1.LeftPower';
elseif strcmp(map_type,'right')
    stim = Fish1.RightPower';    
end

calcium = Fish1.CalciumActivity';
threshold_1 = 0.7;
threshold_2 = 0.6;
threshold_3 = 0.5;
correlated = zeros(numel(calcium(1,:)),1);

for i = 1:numel(calcium(1,:))
    c = corr(stim, calcium(:,i));
    if c > threshold_1
        correlated(i) = 1;
    elseif (c > threshold_2) && (c <= threshold_1)
        correlated(i) = 2;
    elseif (c > threshold_3) && (c <= threshold_2)
        correlated(i) = 3;
    end
    disp(i)
end

disp(sum(correlated(:) == 3))

% display = immovie(visualize_brain('Fish2',correlated'));
% mov = VideoWriter(filename);
% open(mov)
% writeVideo(mov, display)
% close(mov)
% implay(display)
