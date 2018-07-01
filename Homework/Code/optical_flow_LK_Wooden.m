clear all;
clc;

video = VideoWriter('Wooden_LK','MPEG-4');
video.FrameRate = 1;
open(video);

framepath = 'D:\Perception Assignments\Homework\eval-gray-allframes\eval-data-gray\Wooden\frame';
output = 'D:\Perception Assignments\Homework\Output_Wooden\';

for i = 7:13
filename1 = sprintf('%02d.png', i);
fullfilename1 = strcat(framepath, filename1);
I = imread(fullfilename1);
im1t = im2double(I);
im1 = imresize(im1t, 0.5); % downsize to half
l = i;
filename2 = sprintf('%02d.png', i+1);
fullfilename2 = strcat(framepath, filename2);
I2 = imread(fullfilename2);
im2t = im2double(I2);
im2 = imresize(im2t, 0.5); % downsize to half

ww = 45;
w = round(ww/2);

% Lucas Kanade Here
% for each point, calculate I_x, I_y, I_t
Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
u = zeros(size(im1));
v = zeros(size(im2));

% within window ww * ww
for i = w+1:size(Ix_m,1)-w
for j = w+1:size(Ix_m,2)-w
Ix = Ix_m(i-w:i+w, j-w:j+w);
Iy = Iy_m(i-w:i+w, j-w:j+w);
It = It_m(i-w:i+w, j-w:j+w);

Ix = Ix(:);
Iy = Iy(:);
b = -It(:); % get b here

A = [Ix Iy]; % get A here
nu = pinv(A)*b; % get velocity here

u(i,j)=nu(1);
v(i,j)=nu(2);
end
end

% downsize u and v
u_deci = u(1:10:end, 1:10:end);
v_deci = v(1:10:end, 1:10:end);
% get coordinate for u and v in the original frame
[m, n] = size(im1t);
[X,Y] = meshgrid(1:n, 1:m);
X_deci = X(1:20:end, 1:20:end);
Y_deci = Y(1:20:end, 1:20:end);

figure();
imshow(I2);
hold on;
% draw the velocity vectors
quiver(X_deci, Y_deci, u_deci,v_deci, 'y');
frame = getframe(gca);
image = frame2im(frame);
fileout = sprintf('Wooden_out%02d.jpg', l);
fullname = strcat(output, fileout);
imwrite(image, fullname, 'jpg');
end