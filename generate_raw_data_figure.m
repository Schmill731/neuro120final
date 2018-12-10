%% Load data
load('Data4Class/Fish1.mat');

%% Plot raw data
calcActivity = Fish1.CalciumActivity(1, :);
Stimulus = Fish1.Stimulus(:);

figure();
subplot(1, 2, 1);
plot(1:2999, Fish1.LeftPower, 'b--');
hold on
plot(1:2999, Fish1.RightPower, 'r-.');
xlabel('Time (~s)');
ylabel('Turning Power');
yyaxis right
plot(1:2999, Stimulus, 'k');
ylabel('Concentration of NaCl');
legend('Left Turning Power', 'Right Turning Power', 'Concentration', 'Location', 'northwest');
text(-0.1,1.05,'A','Units', 'Normalized', 'VerticalAlignment', 'Top', 'FontSize', 16, 'FontWeight', 'bold')
subplot(1, 2, 2);
plot(1:2999, calcActivity, 'b');
hold on
xlabel('Time (~s)');
ylabel('Calcium Activity');
yyaxis right
plot(1:2999, Stimulus, 'k');
ylabel('Concentration of NaCl');
legend('Calcium Activity', 'Concentration', 'Location', 'northwest');
text(-0.1,1.05,'B','Units', 'Normalized', 'VerticalAlignment', 'Top', 'FontSize', 16, 'FontWeight', 'bold')
