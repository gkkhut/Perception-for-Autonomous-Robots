clear all
clc
load('classifier.mat')
%% MAIN ALGORITHM  

cd ..;
cd 'input'
cd 'TSR';
cd 'input'
files = ls('*jpg');
names = files;

v = VideoWriter('../../../Output/Sign_detection1','MPEG-4');
v.FrameRate = 30;
open(v);

for frame = 90:2650
frame
name = names(frame,:);
img = imread(name);
% figure(1), imshow(img)

%% Applying Gaussian Filter to denoise the frames
mu = 5;
sigma = 2;
index = -floor(mu/2) : floor(mu/2);
[X Y] = meshgrid(index, index);
H = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
H = H / sum(H(:));
I_t = imfilter(img, H);
% figure(2), imshow(I_t)
%% Adjusting Contrast of the frames
I = imadjust(I_t, [0.2,0.7],[0.0,1.0]);
% figure(3), imshow(I)
%% Normalization over RGB Channels
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

red = uint8(max(0, min(R-B, R-G)));
blue = uint8(max(0, min(B-R, B-G)));

bb = im2bw(blue,.15);
br = im2bw(red,.15);
rb = red + blue;

%% Applying mask to the image
x = [1 1628 1628 1];
y = [1 1 618 618];
mask = poly2mask(x,y, 1236, 1628);
crop = uint8(immultiply(rb,mask));
  
%% Using Maximally Stable Extremal Regions (MSER Algorithm)
[r,f] = vl_mser(crop,'MinDiversity',0.7,...
                     'MaxVariation',0.2,...
                     'Delta',8);

M = zeros(size(crop));
for x = r'
s = vl_erfill(crop,x);
M(s) = M(s) + 1;
end
    
thresh = graythresh(M);
M = im2bw(M, thresh);
se = strel('octagon',6);
M = imdilate(M, se);
% figure(7), imshow(M)

%% Extract MSER regions from the image (Area filtering)
M = bwareafilt(M, [950 10000]);
% figure(8), imshow(M)
regions = regionprops( M, 'BoundingBox');

%% Get Bounding boxes for the blobs given by MSER
figure(9);
clf; 
imagesc(img);
hold on;
axis equal off;
colormap gray;

for k = 1 : length(regions)
box = regions(k).BoundingBox;
ratio = box(3)/box(4);
if ratio < 1.1 && ratio > 0.6 %Aspect Ration of detections
sign = imcrop(img, box);  
sign = im2single(imresize(sign,[64 64]));

%% TRAFFIC SIGNAL CLASSIFICATION %%
%% Extract HOG Features of detections 
hog = [];
hog_det = vl_hog(sign, 4);
[hog_1, hog_2] = size(hog_det);
dim = hog_1 * hog_2;
hog_det_trans = permute(hog_det, [2 1 3]);
hog_det = reshape(hog_det_trans,[1 dim]); 
hog = hog_det;

%% Predicting the sign using the trained SVM model
[predictedLabels, score] = predict(classifier, hog);
%label = str2num(predictedLabels);
for j = 1:length(score)
if (score(j) > -0.04)
rectangle('Position', box,'EdgeColor','g','LineWidth',2 )
cd ..
cd 'Sample'
samplename = strcat(predictedLabels,'.jpg');
im = imread(samplename);
im = im2single(imresize(im,[box(4) box(3)]));
image([int64(box(1)-box(3)) int64(box(1)-box(3))],[int64(box(2)) int64(box(2))],im);
cd ..
cd input
end
end
end    
end   
frame = getframe(gca);
writeVideo(v,frame);
pause(0.001);
end
cd ..
cd ..
cd ..
cd ..

close(v)