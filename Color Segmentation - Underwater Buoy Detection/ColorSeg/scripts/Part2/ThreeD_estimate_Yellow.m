clear all;
clc

filePath = '../../Images/TrainingSet/CroppedBuoys/Y_';
OutputPath = sprintf('../../Output/Part2');
C = cell(50,1);
Sample = [];
for i = 1 : 50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(filePath, CroppedFileName);
Img = imread(CroppedFileName_final);
%% Initialising color channels   
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);
%% Get dimensions of the color channels
[a b] = size(Blue); 
Rpixels = []; % matrices for the color channels. 
Gpixels = []; % Array of values 0-255 for each pixel, for each color
Bpixels = [];
for i = 1:a
for j = 1:b
%% Add value to color matrix
Rpixels = [Rpixels Red(i,j)]; 
Gpixels = [Gpixels Green(i,j)];
Bpixels = [Bpixels Blue(i,j)];
end
end
%% Take transpose
Rpixels = Rpixels'; 
Gpixels = Gpixels';
Bpixels = Bpixels';

Pixel = [Rpixels Gpixels Bpixels];
Sample = [Sample; Pixel];
end

%% Find gaussian from randomly selected sample from [RGB} values of yellow buoy
data = []; % Array holding all randomly selected samples
[size sigma] = size(Sample);
for i = 1:100000
a = randi([1 size]); % pick random element number
select = Sample(a,:); % Take element from pixelY
data = [data ;select]; % Add randomly chosen element to Data
end
R = data(:,1);
G = data(:,2);
B = data(:,3);
R = double(R);
G = double(G);
B = double(B);

%% Mean of R,G, B
meanR = mean(data(:,1));
meanG = mean(data(:,2));
meanB = mean(data(:,3));
mean = [meanR meanG meanB]

%% Standard deviation of R,G,B
stdR = std(double(data(:,1)));
stdG = std(double(data(:,2)));
stdB = std(double(data(:,3)));

%% Covariance 
%Red green
Crg = cov(R,G);
covarRG = Crg(1,2);
covarGR = Crg(2,1);
%red blue
Crb = cov(R,B);
covarRB = Crb(1,2);
covarBR = Crb(2,1);
%green blue
Cgb = cov(G,B);
covarGB = Cgb(1,2);
covarBG = Cgb(2,1);

covar = [stdR^2  covarRG  covarRB;
         covarGR stdG^2   covarGB;
         covarBR covarBG  stdB^2;]
         
%% View gaussian of channel
x = [0:10:300];
norm = normpdf(x,meanR,stdR);
plot(x,norm,'r','LineWidth',2)
hold on
norm1 = normpdf(x,meanG,stdG);
plot(x,norm1,'g','LineWidth',2)

norm2 = normpdf(x,meanB,stdB);
plot(x,norm2,'b','LineWidth',2)

hgexport(gcf, fullfile(OutputPath, 'EM_Yellow.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');