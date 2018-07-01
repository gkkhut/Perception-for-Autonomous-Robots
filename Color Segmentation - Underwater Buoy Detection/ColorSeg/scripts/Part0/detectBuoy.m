clear all;
clc;

video = VideoReader('../../Images/detectbuoy.avi');
NewVideo = VideoWriter('../../Output/Part0/Output_Part0');
NewVideo.FrameRate = 15;
open(NewVideo);
Imagepath = '../../Output/Part0/Seg_Img/';

for n = 1:175 % Max no of frames is 200
Img = read(video,n);
[L W e] = size(Img);

% Get Color Channels
Red = Img(:, :, 1);
Green = Img(:, :, 2);
Blue = Img(:, :, 3);
Yellow = (double(Red) + double(Green))/2;

%% Mean and Standard Deviation
% calculated mean and standard deviation values for red buoy
Redmean = 241.9501;
Rstd = 12.4567;

% calculated mean and standard deviation values for yellow buoy
Yellowmean = 233.1719;
Ystd = 9.4974;

% calculated mean and standard deviation values for green buoy
Greenmean = 218.9798;
Gstd = 25.8844;

%% Create Probability Matrix
% probability that a given pixel is a pixel on the red buoy
Pr = normpdf(double(Red),Redmean,Rstd);
Pmax = max(Pr(:)); % Find the max probability

% probability that a given pixel is a pixel on the yellow buoy
Py = normpdf(double(Yellow),Yellowmean,Ystd);
Pymax = max(Py(:));

% probability that a given pixel is a pixel on the green buoy
Green = (double(Green) + double(Blue))/2;
Pg = normpdf(double(Green),Greenmean,Gstd);
Pgmax = max(Pg(:));

%% Mapped Probability Matrix
% Map values from probability matrix so that 255 means full probability and
% 0 means well zero probability
maxinput = Pmax - 0; % input_end - input_start;
Inputy = Pymax; % yellow 
Inputg = Pgmax;
maxoutput =  255 - 0; % output_end - output_start;

%% Mapped probability matrices
RMapped = Pr * (maxoutput/(maxinput)); % mapped Probability matrix for red, max of 255 min of 0
YMapped = Py * (maxoutput/Inputy); % mapped probability for yellow
GMapped = Pg * (maxoutput/Inputg); % mapped probability green

%% Create Binary
% Find red
threshR = 240; % threshold probaility value for being a red buoy, must be greater than this
RBin = im2bw(Img); % if red over 240, less than 50 on yellow, then it is a red buoy. 255 is max, 0 is bottom of how sure we are
for i =1:480 % go though every pixel
for o = 1:640
if (RMapped(i,o) > threshR && YMapped(i,o)<50) % if current pixel's redChannel value has red buoy probability over threshold and probability under yellow buoy
RBin(i,o) = 1; % Make Binary image red. So if (probably a red buoy and probabily not a yellow buoy)
else
RBin(i,o) = 0; % If not red buoy make it black
end
end
end
RBin2 = bwareaopen(RBin,6); % Get rid of pixels here and there that made the cut
se1 = strel('disk', 10); % make binary buoy a little more defined
RBin3 = imdilate(RBin2,se1); % more defined

%% Find yellow, same method
threshY = 240;
YBin = im2bw(Img);
for i =1:480
for o = 1:640
if (YMapped(i,o) > threshY  && RMapped(i,o)< 199 && RMapped(i,o) > 150 && GMapped(i,o) < 90)
YBin(i,o) = 1;
else
YBin(i,o) = 0;
end
end
end
YBin2 = bwareaopen(YBin,1);% was 2
YBin3 = imdilate(YBin2,se1);

%% Find green, same method
threshG = 250;
GBin = im2bw(Img);
for i =1:480
for o = 1:640
if (GMapped(i,o) > threshG && RMapped(i,o) < 50 && YMapped(i,o) > 100)
GBin(i,o) = 1;
else
GBin(i,o) = 0;
end
end
end
GBin2 = bwareaopen(GBin,4);
GBin3 = imdilate(GBin2,se1);
imshow(GBin);
% figure

%% Countour Preparation
Rcheck = 0;
Ycheck = 0;
Gcheck =0;

% Draw line on buoy from MapR which looks a lot nicer
BlobRed = regionprops(RBin3,'Centroid');
if (length(BlobRed) > 0)
% Find center of blob we made using RedBin3. Blob isnt perfect representation of Buoy
rx = BlobRed(1).Centroid(1);
ry = BlobRed(1).Centroid(2);

xmin = rx - 75;% Define the nearby area of our Blob
xmax = rx + 75;
ymin = ry - 75;
ymax = ry + 75;
% Create an image that only keeps the white in the nearby area. 
% So use image MapR that has good looking buoy outline, keep white only on bouy in that image
RCopy = RMapped;
for i = 1:L
for j = 1:W
if (j < xmin || j > xmax || i < ymin || i > ymax)
RCopy(i,j) = 0;
end
end
end
Rcheck = 1;
end

% Yellow countour preparation
BlobYellow = regionprops(YBin3,'Centroid');
if (length(BlobYellow) > 0)
yx = BlobYellow(1).Centroid(1); % Find center of blob we made using pixel. Blob isnt perfect representation of Buoy
yy = BlobYellow(1).Centroid(2);
% Define the nearby area of our Blob
xmin = yx - 75;
xmax = yx + 75;
ymin = yy - 75;
ymax = yy + 75;
% Create an image that only keeps the white in the nearby area. So use image MapR that has good looking buoy outline, keep white only on bouy in that image
YCopy = YMapped;
for i = 1:L
for j = 1:W
if (j < xmin || j > xmax || i < ymin || i > ymax)
YCopy(i,j) = 0;
end
end
end
Ycheck = 1;
end

% Green contour preparation
BlobGreen = regionprops(GBin2,'Centroid','Area');
if (length(BlobGreen) > 0)
% Look at where every blob is in GBin2, if they are right on top of
% yellow then assign gy = yy, gx = yx, so when drawing countours green isnt drawn.
for s = 1:length(BlobGreen)
gx = BlobGreen(s).Centroid(1);% Find center of blob we made using pixel.
gy = BlobGreen(s).Centroid(2); % Blob isnt perfect representation of Buoy
% If we have info for y, and we see green data near yellow, or huge green data
if (Ycheck == 1 && (((yy - gy)^2 + (yx - gx)^2)^.5 < 70 || BlobGreen(s).Area > 100))
gy = yy;
gx = yx;
break
end
end
end
imshow(Img)
hold on

%% Draw Contours
% Draw red
if(Rcheck == 1)
RCopy = im2bw(RCopy);
% Boundaries of the white in binary image
B = bwboundaries(RCopy);
for  k = 1:length(B)
boundary = B{k};
% Plot the boundaries in red
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end 
end

% Draw yellow
if(Ycheck == 1)
YCopy = im2bw(YCopy);
% Boundaries of the white in binary image
B = bwboundaries(YCopy);
for  k = 1:length(B)
boundary = B{k};
% Plot the boundaries in red
plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 3)
end 
end

% Draw green
Gcen = regionprops(GBin3,'Centroid');
if (length(Gcen) > 0)
for i = 1:length(Gcen)
if (abs(Gcen(i).Centroid(1)-yx)> 70 && abs(Gcen(i).Centroid(2)-yy) < 70)
gx = Gcen(i).Centroid(1);
gy = Gcen(i).Centroid(2);
scatter(gx,gy,500,'g','LineWidth',3)
end
end
end

title(n)
f = getframe(gca);
filename = sprintf('seg_%d.jpg', n);
fullfilename = strcat(Imagepath, filename);
im = frame2im(f);
imwrite(im, fullfilename,'jpg');
writeVideo(NewVideo,im) % Add frame to video
cla % clear axis
end
close(NewVideo);