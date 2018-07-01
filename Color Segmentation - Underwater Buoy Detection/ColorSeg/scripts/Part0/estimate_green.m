clear all;
clc
filePath = '../../Images/TrainingSet/CroppedBuoys/G_';
Output = sprintf('../../Output/Part0');
GSample = [];
for i = 1 : 22
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);

%% Finding Color Channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);
Yellow = (double(Red) + double(Green))/2;

[a b] = size(Green); % get dimensions of color channels
Rpixels = []; % matrices for color channels. Basically want a straight array of values 0-255 for each pixel, for each color
Gpixels = [];
Bpixels = [];
Ypixels = [];
for i = 1:a
for j = 1:b
Gpixels = [Gpixels Green(i,j)];
end
end
Rpixels = Rpixels'; % transpose to make 1 column
Gpixels = Gpixels';
Bpixels = Bpixels';
Ypixels = Ypixels';

GSample = [GSample ; Gpixels];
end

%% Finding gaussian from randomly selected sample from values in the Green Channel

% Take random samples add to matrix called Data
Data = []; % Array holding all randomly selected samples
[size sigma] = size(GSample);
for i = 1:100001
a = randi([1 size]); % pick random element number
select = GSample(a); % take element from Gpixel
Data = [Data select]; % Add randomly chosen element to Data
end
Data = Data';
%Random distribution represented as gaussian with mean, standard deviation
% This is the data for the green buoy
mu = mean(Data) % mean of Data
sigma = std(double(Data)) % variance of Data
% Plot
x = (-5 * sigma:0.01:5 * sigma) + mu;  % Plotting range
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x, y,'g')
hgexport(gcf, fullfile(Output, 'Gauss1D_green.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');