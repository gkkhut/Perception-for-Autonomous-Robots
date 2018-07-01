clc
warning off;

vid = VideoReader('../../Images/detectbuoy.avi');
binaryimagepath = '../../Output/Part3/BinaryImages/';
colorimagepath = '../../Output/Part3/Frames/';

for n = 20:60
n
frame = read(vid,n);

%% Get color channels
[L W nf] = size(frame);
Red = frame(:, :, 1);
Green = frame(:, :, 2);
Blue = frame(:, :, 3);

%% Size of a color channel
[s1 s2] = size(Red);

%% Create Probability Map
R1 = reshape(Red,L*W,1);
G1 = reshape(Green,L*W,1);
B1 = reshape(Blue,L*W,1);
Pixel = [R1 G1 B1];
Pixel = double(Pixel);
% First entry is (1,1), second is 2nd row 1st col, third is 3rd row 1st col....
%% Probability Maps
% Create probability for every pixel. But every pixel is not aligned in matrix they are in a list.
RMapped = pdf(Gmm_Red,Pixel); 
Rmax = max(RMapped(:));

YMapped = pdf(Gmm_Yellow,Pixel);
Ymax = max(YMapped(:));

GMapped = pdf(Gmm_Green,Pixel);
Gmax = max(GMapped(:));

%% Reshaping to image format
% where (1,1) is first row first column
RMapped = reshape(RMapped,L,W);
YMapped = reshape(YMapped,L,W);
GMapped = reshape(GMapped,L,W);

%% Change values of probailtiy map to 0-255
Maxinput = Rmax - 0; % input end - input start;
inputY = Ymax;
inputG = Gmax;
Maxoutput =  255 - 0; % output end - output start;

%% Matrix multiplication by a quotient of ranges to map 0-->0 , max --> 255
RRR = RMapped*(Maxoutput/(Maxinput));
YYY = YMapped*(Maxoutput/(inputY));
GGG = GMapped*(Maxoutput/(inputG));
% RRR is now mapped probability matrix for the red buoy, 0 means not red buoy,
% higher value with max of 255 means better chance of pixel belonging to a red buoy

%% Thresholding
Yim = YYY; % Copy of 1st probability map
indexY = (YYY < 250); % if prob under 250 (255 is max) then set pixel to 0
Yim(indexY) = 0; % set pixel to 0

%% Red buoy image threshold
Rimg = RRR;
indexR = (RRR < 230);
Rimg(indexR) = 0;

Gimg = GGG;
indexG = (GGG < 1);
Gimg(indexG) = 0;
Gim2 = bwareaopen(Gimg,60);

se1 = strel('disk', 5);
se2 = strel('disk', 2);
se3 = strel('disk',1);
Rfimg = imdilate(Rimg,se1);
Yfimg = imdilate(Yim,se1);
Gfimg = imdilate(Gim2,se1);

%% Find coordinate where pixels remains after strict threshold
Rfimg = im2bw(Rfimg);
% Region of dilated pixel/couple of pixels that made the cut
RegionR = regionprops(Rfimg,'Centroid','Area');
if (length(RegionR) > 0)
rx = RegionR(1).Centroid(1);
ry = RegionR(1).Centroid(2);
end

Yfimg = im2bw(Yfimg);
RegionY = regionprops(Yfimg,'Centroid');
if(length(RegionY) > 0)
yx = RegionY(1).Centroid(1);
yy = RegionY(1).Centroid(2);
% get x&y value of pixel that made cut. so we know the area to look for the buoy
end

Gfimg = im2bw(Gfimg);
RegionG = regionprops(Gfimg,'Centroid','Area');
if(length(RegionG) > 0)
for s = 1:length(RegionG)
gx = RegionG(s).Centroid(1); % Find center of blob we made using pixel. Blob isnt perfect representation of Buoy
gy = RegionG(s).Centroid(2);
% If we have info for y, and we see green data near yellow
if (length(RegionY) > 0 && ((((yy - gy)^2 + (yx - gx)^2)^.5 < 70 || RegionG(s).Area > 5300)))
length(RegionY);
((yy - gy)^2 + (yx - gx)^2)^.5;
gy = yy;
gx = yx;
break
end
end
end

Ronly = RRR;
for i = 1:L
for j = 1:W
if (RRR(i,j) > .01)
Ronly(i,j) = 255;
end
end
end
Ronly = im2bw(Ronly);
filename = sprintf('R_binary_%d.jpg', n);
filename_final = strcat(binaryimagepath, filename);
imwrite(Ronly, filename_final,'jpg');

rbound = 70;
if (length(RegionR) > 0)
for aa = 1:L
for bb = 1:W
if (aa < ry - rbound || aa > ry + rbound || bb < rx - rbound || bb > rx + rbound)
% If anywhere in image besides close to the pixel from buoy
Ronly(aa,bb) = 0; % Make black
end
end
end
end
Ronly = imfill(Ronly,'holes'); % Fill holes
imshow(Ronly)

%% Yellow buoy image threshold
Yonly = YYY;
for i = 1:L
for j = 1:W
if (YYY(i,j) > .01)
Yonly(i,j) = 255;
end
end
end

%% Creating image used for drawing boundaries on
if (length(RegionY) > 0)
for aa = 1:L
for bb = 1:W
% If anywhere in image besides close to the pixel from buoy
if (aa < yy - 40 || aa > yy + 40 || bb < yx - 40 || bb > yx + 40)
Yonly(aa,bb) = 0; % Make black
end
end
end
end

%% Making binary for yellow
Yonly = im2bw(Yonly);
filename = sprintf('Y_binary_%d.jpg', n);
filename_final = strcat(binaryimagepath, filename);
imwrite(Yonly, filename_final,'jpg');
Yonly = imfill(Yonly,'holes'); % Fill holes
imshow(Yonly)

Gonly = GGG;
for i = 1:L
for j = 1:W
if (GGG(i,j) > 1)
Gonly(i,j) = 255;
else
Gonly(i,j) = 0;
end
end
end
if (length(RegionG) > 0)
for aa = 1:L
for bb = 1:W
% If anywhere in image besides close to the pixel from buoy
if (aa < gy - 15 || aa > gy + 15 || bb < gx - 15 || bb > gx + 15)
Gonly(aa,bb) = 0; % Make black
end
end
end
end

%% Making binary for green
Gonly = im2bw(Gonly); 
filename = sprintf('G_binary_%d.jpg', n);
filename_final = strcat(binaryimagepath, filename);
imwrite(Gonly, filename_final,'jpg');

Gonly = imfill(Gonly,'holes');
Gonly = bwareaopen(Gonly,10);
Gonly = imdilate(Gonly,se3);
imshow(Gonly)

% Now green is in line (y axis) with other buoys
% If we see a blob for green buoy too high, black it out
for i = 1:L
for j = 1:W
if(i < ry - 40)
Gfimg(i,j) = 0;
end
end
end
imshow(frame)
hold on

%% Drawing Countours
B = bwboundaries(Ronly); % Boundaries of the white in binary image
for  k = 1:length(B)
boundary = B{k};
if (((yy - ry)^2 + (yx - rx)^2)^.5 > 70 && abs(yx - rx) > 70)
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3)
% Plot the boundaries in red
end 
end
% Boundaries of the white in binary image
B = bwboundaries(Yonly);
for  k = 1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 3)
% Plot the boundaries in red
end 

B = bwboundaries(Gfimg); % Boundaries of the white in binary image
Gcir = regionprops(Gfimg,'Centroid','Area');
if (length(Gcir) > 0)
Gmax = 0;
for i = 1:length(Gcir)
if(abs(Gcir(i).Centroid(1) - yx) > 70 && abs(Gcir(i).Centroid(2) - yy < 20)...
&& abs(Gcir(i).Centroid(1) - rx > 40) )
if (Gcir(i).Area > Gmax)
Gmax = Gcir(i).Area;
Gi = i;
Gcx = Gcir(i).Centroid(1);
Gcy = Gcir(i).Centroid(2);
end
scatter(Gcir(Gi).Centroid(1),Gcir(Gi).Centroid(2),400,'g','LineWidth',3)
end
end
end

title(n)
f = getframe(gca);
im = frame2im(f);
filenamecolor = sprintf('out_%d.jpg', n);
filenamecolor_final = strcat(colorimagepath, filenamecolor);
imwrite(im, filenamecolor_final,'jpg');
set(gcf,'visible','off')
cla % clear axis

end