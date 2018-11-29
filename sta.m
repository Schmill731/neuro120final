clear all

load Fish1

%% Find correlation coefficients of calcium levels

stim = Fish1.Stimulus';
left = Fish1.LeftPower';
right = Fish1.RightPower';
calc = Fish1.CalciumActivity';
result = zeros(numel(calc(1,:)),1);
lresult = zeros(numel(calc(1,:)),1);
rresult = zeros(numel(calc(1,:)),1);
for i = 1:numel(calc(1,:))
    result(i) = corr(stim, calc(:,i));
    lresult(i) = corr(left, calc(:,i));
    rresult(i) = corr(right, calc(:,i));
end

figure()
plot(result)
figure()
plot(lresult)
figure()
plot(rresult)



