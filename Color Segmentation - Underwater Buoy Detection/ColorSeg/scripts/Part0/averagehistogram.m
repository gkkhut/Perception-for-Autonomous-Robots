%% For Green Buoy
Path = '../../Images/TrainingSet/CroppedBuoys/G_';
bins = (0:1:255)';
CountRed = zeros(256,1);
CountGreen = zeros(256,1);
CountBlue = zeros(256,1);
Output = sprintf('../../Output/Part0');

for i = 1 : 22
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(Path, CroppedFileName);

im = imread(CroppedFileName_final);

Red = im(:,:,1);
Green = im(:,:,2);
Blue = im(:,:,3);
Red = medfilt2(Red,[1 1]);
Green = medfilt2(Green,[1 1]);
Blue = medfilt2(Blue,[1 1]);
[rc, ~] = imhist(Red(Red > 0));
[gc, ~] = imhist(Green(Green > 0));
[bc, ~] = imhist(Blue(Blue > 0));

for n = 1 : 256
CountRed(n) = CountRed(n) + rc(n);
CountGreen(n) = CountGreen(n) + gc(n);
CountBlue(n) = CountBlue(n) + bc(n);
end
end
CountRed = CountRed ./ n;
CountGreen = CountGreen ./ n;
CountBlue = CountBlue ./ n;
figure
%% Plotting histogram for green buoy
title('Histogram for Green colured buoy')
subplot(3,1,1)
area(bins, CountRed, 'FaceColor', 'r')
xlim([0 255])
hold on
subplot(3,1,2)
area(bins, CountGreen, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, CountBlue, 'FaceColor', 'b')
xlim([0 255])
hold off
pause(0.1)
hgexport(gcf, fullfile(Output, 'G_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% For Red buoy
Path = '../../Images/TrainingSet/CroppedBuoys/R_';
bins = (0:1:255)';
CountRed = zeros(256,1);
CountGreen = zeros(256,1);
CountBlue = zeros(256,1);
Output = sprintf('../../Output/Part0');
for i = 1 : 50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(Path, CroppedFileName);
im = imread(CroppedFileName_final);
Red = im(:,:,1);
Green = im(:,:,2);
Blue = im(:,:,3);
Red = medfilt2(Red,[2 2]);
Green = medfilt2(Green,[2 2]);
Blue = medfilt2(Blue,[2 2]);
[rc, ~] = imhist(Red(Red > 0));
[gc, ~] = imhist(Green(Green > 0));
[bc, ~] = imhist(Blue(Blue > 0));
for n = 1 : 256
CountRed(n) = CountRed(n) + rc(n);
CountGreen(n) = CountGreen(n) + gc(n);
CountBlue(n) = CountBlue(n) + bc(n);
end
end
CountRed = CountRed ./ 16;
CountGreen = CountGreen ./ 16;
CountBlue = CountBlue ./ 16;
figure
%% Plotting histogram for Red buoy
title('Histogram for Red colured buoy')
subplot(3,1,1)
area(bins, CountRed, 'FaceColor', 'r')
xlim([0 255])
hold on
subplot(3,1,2)
area(bins, CountGreen, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, CountBlue, 'FaceColor', 'b')
xlim([0 255])
pause(0.1)
hgexport(gcf, fullfile(Output, 'R_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');

%% For Yellow buoy
Path = '../../Images/TrainingSet/CroppedBuoys/Y_';
bins = (0:1:255)';
CountRed = zeros(256,1);
CountGreen = zeros(256,1);
CountBlue = zeros(256,1);
Output = sprintf('../../Output/Part0');
for i = 1 : 50
CroppedFileName = sprintf('%03d.jpg',i);
CroppedFileName_final = strcat(Path, CroppedFileName);
im = imread(CroppedFileName_final);
Red = im(:,:,1);
Green = im(:,:,2);
Blue = im(:,:,3);
Red = medfilt2(Red,[2 2]);
Green = medfilt2(Green,[2 2]);
Blue = medfilt2(Blue,[2 2]);
[rc, ~] = imhist(Red(Red > 0));
[gc, ~] = imhist(Green(Green > 0));
[bc, ~] = imhist(Blue(Blue > 0));
for n = 1 : 256
CountRed(n) = CountRed(n) + rc(n);
CountGreen(n) = CountGreen(n) + gc(n);
CountBlue(n) = CountBlue(n) + bc(n);
end
end
CountRed = CountRed ./ 16;
CountGreen = CountGreen ./ 16;
CountBlue = CountBlue ./ 16;
figure
%% Plotting Histogram for Yellow buoy
title('Histogram for Yellow colured buoy')
subplot(3,1,1)
area(bins, CountRed, 'FaceColor', 'r')
xlim([0 255])
hold on
subplot(3,1,2)
area(bins, CountGreen, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, CountBlue, 'FaceColor', 'b')
xlim([0 255])
pause(0.1)
hgexport(gcf, fullfile(Output, 'Y_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');