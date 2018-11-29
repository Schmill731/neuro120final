intervalTime = 40;
roiNum1 = size(Fish1.CalciumActivity);
roiNum2 = size(Fish2.CalciumActivity);
activity1 = Fish1.CalciumActivity;
activity2 = Fish2.CalciumActivity;
stimulus1 = Fish1.Stimulus;
stimulus2 = Fish2.Stimulus;
staTime = 40;

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
staCache = zeros([roiNum1(1) staTime 4]);
temp=1;
for i=1:4
    for j = 1:roiNum1(1)
        for k = 1:8
           staCache(j,:,i) = staCache(j,:,i) + activity1(j,times(temp):times(temp)+staTime-1);
           temp = temp+1;
        end
        temp = temp-8;
        staCache(j,:,i) = staCache(j,:,i)/8;
    end
    temp = temp+8;
end

%% Generate matrix of time differences between stimuluation and Ca activity 
%  per roi per stimulation level 
time_distance = zeros([roiNum1(1) 4]);
for i = 1:roiNum1(1)
   for j = 1:4
      [val,index]=max(staCache(i, 1:40, j)); 
      time_distance(i,j) = index;
   end
end

% dist1 = dist(time_distance(:,3)');