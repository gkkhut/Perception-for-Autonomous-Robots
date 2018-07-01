clc;
close all;
clear all;
pvid = VideoReader('D:\Temp\proj 1 - perception\project_video.mp4');
nFrames = pvid.NumberOfFrames();
% plots the highlighted lane and creates a video
video = VideoWriter('laneDetection-outputvideo','MPEG-4');
video.FrameRate = 25;
open(video);
for frames = 1 : 750
   frames;
   img = read(pvid,frames);
    
%% Denoising the image
% Appling a Median filter to remove noise
F = medfilt3 (img);
%imshow(F);
% figure(1), imshow(img)
% hold on

%% Edge Detection
% converting grayscale frames to binary frames
BW = im2bw(F,0.55);
%using canny edge detection to find edges
BW = edge(BW,'canny');
% figure(2), imshow(BW)
    
%% Extracting the Region of Interest
x = [210 550 717 1280];
y = [720 450 450 720];
%Obtain the Region of interest through observation
poly_top = y(2) + 20;
%Applying mask on each channel   
m = poly2mask(x,y, 720, 1280);
%Combining to get the processed frame
croped = immultiply(BW,m);
%figure(5), imshow(croped)
       
%% Applying Hough Transform

[H,T,R] = hough(croped);
%Hough Peaks
P = houghpeaks(H,10,'threshold',ceil(0.1*max(H(:))));
%Hough Lines
L = houghlines(croped,T,R,P,'MinLength',15);
%figure(6), imshow(croped) 
%hold on
for S = 1:length(L)
  xy = [L(S).point1; L(S).point2];
% plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
      
% Plot start and end of the lines
% plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','blue');
% plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','blue');
end
    
%% Lane Lines
%Obtain slope of all the lines which can be a part of the lane
sthreshold = 0.35;
i = 1;
for S = 1:length(L)
  initial = L(S).point1;
  final = L(S).point2;
if final(1) - initial(1) == 0
  slope = 1000; 
else
  slope = (final(2) - initial(2))/(final(1) - initial(1));
end
if abs(slope) > sthreshold %absolute value
  slopes(i) = slope;
  lines(i) = L(S);
  i = i + 1;
end
end
%Split the lines into right or left lines
img_size = size(img);
center = img_size(2)/2;
i = 1; j = 1;
for S = 1:length(lines)
  initial = lines(S).point1;
  final = lines(S).point2;
if slopes(S) > 0 && final(1) > center && initial(1) > center
  right_lines(i) = lines(S);
  tagright = 1;
  i = i + 1;
elseif slopes(S) < 0 && final(1) < center && initial(1) < center
  left_lines(j) = lines(S);
  tagleft = 1;
  j = j + 1;
else
  tagright = 0; tagleft = 0;
end
end
    
%Linear regression to fit a polynomial for right/left line
if (tagright == 0 || tagleft == 0)
continue
end   
%Right line
  i = 1;
  if tagright == 1
for S = 1:length(right_lines)
  initial = right_lines(S).point1;
  final = right_lines(S).point2;
  rx(i) = initial(1);
  ry(i) = initial(2);
  i = i + 1;
  rx(i) = final(1);
  ry(i) = final(2);
  i = i + 1;
end
if length(rx) > 0
% y = m*x + b
  pol = polyfit(rx, ry, 1);
  rm = pol(1);
  rb = pol(2);
else
  rm = 1; 
  rb = 1;
end
end
    
%Left Lane
   i = 1;
  if tagleft == 1
  for S = 1:length(left_lines)
     initial = left_lines(S).point1;
     final = left_lines(S).point2;
     lx(i) = initial(1);
     ly(i) = initial(2);
     i = i + 1;
     lx(i) = final(1);
     ly(i) = final(2);
     i = i + 1;
  end
  if length(lx) > 0
% y = m*x + b
   pol = polyfit(lx, ly, 1);
   lm = pol(1); 
   lb = pol(2);
  else
   lm = 1; lb = 1;
  end
  end
    
% Finding the endpoints using the equation of the line, Once you get the lines
% x = (y - b) / m
y1 = img_size(1);
y2 = poly_top;
right_x1 = (y1 - rb) / rm;
right_x2 = (y2 - rb) / rm;
left_x1 = (y1 - lb) / lm;
left_x2 = (y2 - lb) / lm;
 
%% Plotting
% Draw Polygon for lane
pt1 = [left_x1, y1];
pt2 = [left_x2, y2];
pt3 = [right_x2, y2];
pt4 = [right_x1, y1];
pt_x = [pt1(1) pt2(1) pt3(1) pt4(1)];
pt_y = [pt1(2) pt2(2) pt3(2) pt4(2)];
BW = poly2mask(pt_x, pt_y, 720, 1280);
clr = [0 0 255];            % blue color
a = 0.3;                    % blending factor
z = false(size(BW));
m = cat(3,BW,z,z); img(m) = a*clr(1) + (1-a)*img(m);
m = cat(3,z,BW,z); img(m) = a*clr(2) + (1-a)*img(m);
m = cat(3,z,z,BW); img(m) = a*clr(3) + (1-a)*img(m);
figure(10), imshow(img)
hold on
%Plot the lines
plot([left_x1, left_x2],[y1, y2],'LineWidth',5,'Color','black');
plot([right_x1, right_x2],[y1, y2],'LineWidth',5,'Color','black');
    
%% Predicting the turn

if (lm <= -.80)
  text_display = 'Left';
  print = text(580,605,text_display,'Color','white','FontSize',20); 
elseif (lm >= -.68)
  text_display = 'Right';
  print = text(580,605,text_display,'Color','white','FontSize',20);
%else 
  %text_display = 'Straight';
 % print = text(580,605,text_display,'Color','white','FontSize',20);
end
G(:,:,frames) = lm;   

frame = getframe(gca);
writeVideo(video,frame);
%pause(0.002)
end
close(video)