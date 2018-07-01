clear all;
clc
warning off;
%% Red GMM Learning
filePath = '../../Images/TrainingSet/CroppedBuoys/R_';
Samples = [];
for i = 1:50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);
   
%% Get color channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);

%% Get arrays of every Channel value
[a b] = size(Red); % get dimensions of color channels
Rpixels = []; % matrices for color channels.
Gpixels = [];
Bpixels = [];
for i = 1:a
for j = 1:b
Rpixels = [Rpixels Red(i,j)];%add value to color matrix
Gpixels = [Gpixels Green(i,j)];
Bpixels = [Bpixels Blue(i,j)];
end
end

%% Transpose to make one column
Rpixels = Rpixels';
Gpixels = Gpixels';
Bpixels = Bpixels';
Sample = [Rpixels Gpixels Bpixels];
Samples = [Samples ; Sample];
end

%% Histograms for each channel
[yRed, x] = imhist(Samples(:,1));
stem(x, yRed,'r');
title('Red Buoy: red Channel')
hold on
[yGreen, x] = imhist(Samples(:,2));
figure
stem(x,yGreen,'g')
title('Red Buoy: green Channel')
hold on
[yBlue, x] = imhist(Samples(:,3));
figure
stem(x,yBlue,'b')
title('Red Buoy: blue Channel')
hold on

%% Create Gaussians
Gmm_Red = fitgmdist(double(Samples),6,'Regularize',.0001)
GmmMean_red = Gmm_Red.mu;
GmmVariance_red = Gmm_Red.Sigma;
 
Test = [200 150 213; 105 116 200];
y = pdf(Gmm_Red,Test);

%% Yellow GMM Learning

filePath = '../../Images/TrainingSet/CroppedBuoys/Y_';
Samples = [];
for i = 50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);

%% Get color channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);

%% Get arrays of every Channel value
[a b] = size(Red); % get dimensions of color channels
Rpixels = []; % matrices for color channels.
Gpixels = [];
Bpixels = [];
for i = 1:a
for j = 1:b
Rpixels = [Rpixels Red(i,j)]; % add value to color matrix
Gpixels = [Gpixels Green(i,j)];
Bpixels = [Bpixels Blue(i,j)];
end
end
%% Transpose to make 1 column
Rpixels = Rpixels';
Gpixels = Gpixels';
Bpixels = Bpixels';
Sample = [Rpixels Gpixels Bpixels];
Samples = [Samples ; Sample];
end

%% Histograms for each channel
figure
[yRed, x] = imhist(Samples(:,1));
stem(x, yRed,'r');
title('Yellow Buoy: red Channel')
% hold On
[yGreen, x] = imhist(Samples(:,2));
figure
stem(x,yGreen,'g')
title('Yellow Buoy: green Channel')
% hold On
[yBlue, x] = imhist(Samples(:,3));
figure
stem(x,yBlue,'b')
title('Yellow Buoy: blue Channel')
%  hold On

%% Create Gaussians
Gmm_Yellow = fitgmdist(double(Samples),4,'Regularize',.0001)
GmmMean_Yellow = Gmm_Yellow.mu;
GmmVariance_Yellow = Gmm_Yellow.Sigma;

%% Green GMM Learning

filePath = '../../Images/TrainingSet/CroppedBuoys/G_';
Samples = [];
for i = 1:22 % for every cropped image
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);
   
%% Get color channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);

%% Get arrays of every Channel value
[a b] = size(Red); % get dimensions of color channels
Rpixels = []; % matrices for color channels
Gpixels = [];
Bpixels = [];
for i = 1:a
for j = 1:b
Rpixels = [Rpixels Red(i,j)]; % add value to color matrix
Gpixels = [Gpixels Green(i,j)];
Bpixels = [Bpixels Blue(i,j)];
end
end
%% Transpose to make 1 column
Rpixels = Rpixels';
Gpixels = Gpixels';
Bpixels = Bpixels';
Sample = [Rpixels Gpixels Bpixels];
Samples = [Samples ; Sample];
end

%% Histograms for each channel
figure
[yRed, x] = imhist(Samples(:,1));
stem(x, yRed,'r');
title('Green Buoy: red Channel')
%  hold On
[yGreen, x] = imhist(Samples(:,2));
figure
stem(x,yGreen,'g')
title('Green Buoy: green Channel')
%  hold On
[yBlue, x] = imhist(Samples(:,3));
figure
stem(x,yBlue,'b')
title('Green Buoy: blue Channel')
% hold On

%% Create Gaussians
Gmm_Green = fitgmdist(double(Samples),7  ,'Regularize',.0001)
GmmMean_Green = Gmm_Green.mu;
GmmVariance_Green = Gmm_Green.Sigma;

close all