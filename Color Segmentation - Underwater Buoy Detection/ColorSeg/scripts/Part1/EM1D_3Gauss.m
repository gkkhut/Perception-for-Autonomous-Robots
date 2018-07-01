clear all; 
clc;
warning off;
Output = sprintf('../../Output/Part1');
%% Generating samples by 3 1-D Gaussians, with different means and variances.
mean1 = 0;  
mean2 = 6;
mean3 = 10;
variance1 = .5;
variance2 = 2;
variance3 = 4;

% Generate random samples
sample1 = mvnrnd(mean1,variance1,1000);
sample2 = mvnrnd(mean2,variance2,1000);
sample3 = mvnrnd(mean3,variance3,1000);

%% Plotting pdf from mean/variance we picked
x = [-5:.1:20];
normal1 = normpdf(x,mean1,(variance1)^.5);
plot(x,normal1,'c','LineWidth',2)
normal2 = normpdf(x,mean2,(variance2)^.5);
hold on
plot(x,normal2,'m','LineWidth',2)
normal3 = normpdf(x,mean3,(variance3)^.5);
plot(x,normal3,'g','LineWidth',2)
title('Recovered mean and variance for 3 Gaussians')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'Recovered mean and variance for 3 Gaussians.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% Recovering the model parameters used in previous part, from the gednerated samples
% All sample data points are in one column, for 1D
D = [sample1 ;sample2 ;sample3];
% Find a model, 3 components, D hs only 1 column so it is 1 dimensionsal, it will find 3 1D gassians
GMModel = fitgmdist(D,3)
mean_obtained = GMModel.mu;
variance_obtained = [GMModel.Sigma(1) GMModel.Sigma(2) GMModel.Sigma(3)];
gmm1 = normpdf(x,mean_obtained(1),variance_obtained(1)^.5);
gmm2 = normpdf(x,mean_obtained(2),variance_obtained(2)^.5);
gmm3 = normpdf(x,mean_obtained(3),variance_obtained(3)^.5);
figure
plot(x,gmm1,'r','LineWidth',2)
hold on
plot(x,gmm2,'b','LineWidth',2)
plot(x,gmm3,'g','LineWidth',2)
title('Data samples from 3 1-D Gaussians, with different means and variance')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'EM1D3N.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% Recovering model parameters for 4 Gaussians (means and variances of 4 Gaussians)
Fit_four = fitgmdist(D,4);
Fit_four_mean = Fit_four.mu;
Fit_four_variance = [Fit_four.Sigma(1) Fit_four.Sigma(2) Fit_four.Sigma(3) Fit_four.Sigma(4)];
Fit_four_gmm1 = normpdf(x,Fit_four_mean(1),Fit_four_variance(1)^.5);
Fit_four_gmm2 = normpdf(x,Fit_four_mean(2),Fit_four_variance(2)^.5);
Fit_four_gmm3 = normpdf(x,Fit_four_mean(3),Fit_four_variance(3)^.5);
Fit_four_gmm4 = normpdf(x,Fit_four_mean(4),Fit_four_variance(4)^.5);
figure
plot(x,Fit_four_gmm1,'r','LineWidth',2)
hold on
plot(x,Fit_four_gmm2,'b','LineWidth',2)
plot(x,Fit_four_gmm3,'g','LineWidth',2)
plot(x,Fit_four_gmm4,'y','LineWIdth',2)
title('Fitting 4 Gaussians to sample data')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'EM1D4N.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');