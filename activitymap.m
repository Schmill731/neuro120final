%% map correlated activity
map_type = 'stim';
filename = 'stim2.avi';

stim = Fish2.Stimulus';
if strcmp(map_type,'left')
    stim = Fish2.LeftPower';
elseif strcmp(map_type,'right')
    stim = Fish2.RightPower';    
end

calcium = Fish2.CalciumActivity';
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

display = immovie(visualize_brain('Fish2',correlated'));
mov = VideoWriter(filename);
open(mov)
writeVideo(mov, display)
close(mov)
implay(display)
