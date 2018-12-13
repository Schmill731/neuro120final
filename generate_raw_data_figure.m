% Set parameters
fontsz = 16;

%% Load data
load('Data4Class/Fish1.mat');

%% Plot raw data
calcActivity = Fish1.CalciumActivity(1, :);
Stimulus = Fish1.Stimulus(:);

figure();
subplot(1, 2, 1);
plot(1:2999, Fish1.LeftPower, 'b--');
ax = gca;
ax.FontSize = fontsz;
hold on
plot(1:2999, Fish1.RightPower, 'r-.');
ax = gca;
ax.FontSize = fontsz;
xlabel('Time (~s)', 'FontSize', fontsz);
ylabel('Turning Power', 'FontSize', fontsz);
yyaxis right
plot(1:2999, Stimulus, 'k');
ax = gca;
ax.FontSize = fontsz;
ylabel('Concentration of NaCl', 'FontSize', fontsz);
legend('Left Turning Power', 'Right Turning Power', 'Concentration', 'Location', 'northwest', 'FontSize', fontsz);
text(-0.1,1.05,'A','Units', 'Normalized', 'VerticalAlignment', 'Top', 'FontSize', 24, 'FontWeight', 'bold')
subplot(1, 2, 2);
plot(1:2999, calcActivity, 'b');
ax = gca;
ax.FontSize = fontsz;
hold on
xlabel('Time (~s)', 'FontSize', fontsz);
ylabel('Calcium Activity', 'FontSize', fontsz);
yyaxis right
plot(1:2999, Stimulus, 'k');
ax = gca;
ax.FontSize = fontsz;
ylabel('Concentration of NaCl', 'FontSize', fontsz);
legend('Calcium Activity', 'Concentration', 'Location', 'northwest', 'FontSize', fontsz);
text(-0.1,1.05,'B','Units', 'Normalized', 'VerticalAlignment', 'Top', 'FontSize', 24, 'FontWeight', 'bold')
