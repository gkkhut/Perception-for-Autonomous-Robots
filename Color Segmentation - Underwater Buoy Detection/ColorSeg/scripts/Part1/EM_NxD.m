clear all; 
clc;
%% Takes number of gaussians N, data and plot path as inputs and outputs
% The array N × D mean & N × D × D covariance model parameters. 

N = 3; % number of gaussians
D = 1; % dimensions
data = []; % Array of data to be taken as input

%% Lets make our own data
MeanList = zeros(N,D);
VarianceList = zeros(N,D);
for g = 1:N
for h = 1:D
randMean = randi(20);
MeanList(g,h) = randMean; % = [MeanList  randMean];
randV = randi(10);
VarianceList(g,h) = randV; % = [VarianceList randV];
end
end % Created N mean & N variances

data = [];
data2 = [];
for p = 1:length(MeanList)
for q = 1:D
sample = mvnrnd(MeanList(p,q),VarianceList(p,q),100); % create samples for each mean/standard combo
data = [data sample]; % Create 1 long array of all samples
end
data2 = [data2 ; data];
data = [];  
end % Add samples from every mean/var to a long Data list

Gmm = fitgmdist(data2,N); % Fit N gaussians to all samples taken
MeanList; % Display original mean data 
Mean_obtained = Gmm.mu % N means of D dimensionality
Cov_obtained = Gmm.Sigma % There are N  DxD matrices representing covariance matrices for each gaussian