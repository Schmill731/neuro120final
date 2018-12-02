load('Data4Class/Fish1.mat')
load('Data4Class/Fish2.mat')

intervalTime = 40;
roiNum1 = size(Fish1.CalciumActivity);
roiNum2 = size(Fish2.CalciumActivity);
activity1 = Fish1.CalciumActivity;
activity2 = Fish2.CalciumActivity;
stimulus1 = Fish1.Stimulus;
stimulus2 = Fish2.Stimulus;
staTime = 2;

%% Generate background activity (activity when no stimulus occurs)
% backgroundTimes = stimulus1 <= 1;
% backgroundActivity1 = Fish1.CalciumActivity(:, backgroundTimes);
% backgroundActivity2 = Fish2.CalciumActivity(:, backgroundTimes);

%% Subtract out background activity
% heightenedActivity1 = Fish1.CalciumActivity - mean(backgroundActivity1, 2);
% heightenedActivity2 = Fish2.CalciumActivity - mean(backgroundActivity2, 2);
% weirdROIs = sum(Fish1.CalciumActivity(:, :) < 0.1, 2);
% trashROIs = find(weirdROIs > 2975);
% new_ROI2map = Fish1.roi2map;
% new_ROI2map(ismember(new_ROI2map, trashROIs)) = 0;
% display = visualize_brain(ones(1, 37324), new_ROI2map);
% implay(display)
% 
% for i = 2000:2390
%     plot(activity1(i, :));
%     disp(i)
%     pause
% end

    

%% Generate list of times at which stimulus begins
t = 312;
temp = 1;
times = zeros([1 32]);
for i = 1:4
    for j = 1:8
    times(temp) = t;
    t = t+intervalTime;
    temp = temp+1;
    end
    t = t+7*intervalTime;
end

%% Generate STAs for each ROI for each stimulus level
staCache1 = zeros([roiNum1(1) staTime 4]);
temp=1;
for i=1:4
    for j = 1:roiNum1(1)
        for k = 1:8
           staCache1(j,:,i) = staCache1(j,:,i) + activity1(j,times(temp):times(temp)+staTime-1);
           temp = temp+1;
        end
        temp = temp-8;
        staCache1(j,:,i) = staCache1(j,:,i)/8;
    end
    temp = temp+8;
end

%% Generate STAs for each ROI for each stimulus level
staCache2 = zeros([roiNum2(1) staTime 4]);
temp=1;
for i=1:4
    for j = 1:roiNum2(1)
        for k = 1:8
           staCache2(j,:,i) = staCache2(j,:,i) + activity2(j,times(temp):times(temp)+staTime-1);
           temp = temp+1;
        end
        temp = temp-8;
        staCache2(j,:,i) = staCache2(j,:,i)/8;
    end
    temp = temp+8;
end

%% Generate matrix of time differences between stimuluation and Ca activity 
%  per roi per stimulation level 
time_distance1 = zeros([roiNum1(1) 4]);
for i = 1:roiNum1(1)
   for j = 1:4
      [val,index]=max(staCache1(i, 1:staTime, j)); 
      time_distance1(i,j) = index;
   end
end


%% Generate matrix of time differences between stimuluation and Ca activity 
%  per roi per stimulation level 
time_distance2 = zeros([roiNum2(1) 4]);
for i = 1:roiNum2(1)
   for j = 1:4
      [val,index]=max(staCache2(i, 1:staTime, j)); 
      time_distance2(i,j) = index;
   end
end

% dist1 = dist(time_distance(:,3)');