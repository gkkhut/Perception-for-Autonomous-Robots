clear all;
clc
filePath = '../../Images/TrainingSet/CroppedBuoys/R_';
Output = sprintf('../../Output/Part0');
RSample = [];
for i = 1 : 50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);

%% Finding Color Channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);

[a b] = size(Red); % get dimensions of color channels
Rpixels = []; % matrices for color channels. Basically want a straight array of values 0-255 for each pixel, for each color
Gpixels = [];
Bpixels = [];
for i = 1:a
for j = 1:b
Rpixels = [Rpixels Red(i,j)]; % add value to color matrix
Gpixels = [Gpixels Green(i,j)];
Bpixels = [Bpixels Blue(i,j)];
end
end
Rpixels = Rpixels'; % transpose to make 1 column
Gpixels = Gpixels';
Bpixels = Bpixels';

RSample = [RSample ; Rpixels];
end
 
%% Finding gaussian from randomly selected sample from values in the Red Channel

% Take random samples add to matrix called Data
Data = []; % Array holding all randomly selected samples
[size sigma] = size(RSample);
for i = 1:100001
a = randi([1 size]); % pick random element number
select = RSample(a); % take element from pixelR
Data = [Data select]; % Add randomly chosen element to Data
end
Data = Data';

% Random distribution represented as gaussian with mean, standard deviation
% This is the data for the red buoy
mu = mean(Data) % mean of Data
sigma = std(double(Data)) % variance of Data
% Plot
x = (-5 * sigma:0.01:5 * sigma) + mu;  % Plotting range
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x, y,'r')
hgexport(gcf, fullfile(Output, 'Gauss1D_Red.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');