clear all
close all
clc
warning off
%% Extract the camera parameters for each image
[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('Oxford_dataset/stereo/centre','Oxford_dataset/model');
K = [fx, 0, cx;
     0, fy, cy;
     0, 0, 1];
cameraParams = cameraParameters('IntrinsicMatrix',K');

pos = [0 0 0];
Rpos = [1 0 0;
        0 1 -2
        0 0 1];
posinbuilt =  [0 0 0];
Rposinbuilt = [1 0 0;
               0 1 0;
               0 0 1];
v = VideoWriter('Output2','MPEG-4');
v.FrameRate = 25;
open(v);

cd Oxford_dataset/stereo/centre

images.filename = ls('*png');
stack = size(images.filename); 
for i = 30:stack(1)-1
i
I = imread(images.filename(i,:));
Ic = demosaic (I, 'gbrg');
% figure(1); imshow (Ic);
Inext = imread(images.filename(i+1,:));
Inextc = demosaic(Inext,'gbrg');
% figure(2); imshow (Inextc);

Img = UndistortImage(Ic, LUT);
% figure(3), imshow(Img)
Imgnext = UndistortImage(Inextc, LUT);
% figure(4), imshow(Imgnext)

%% Denoise image
Img = imgaussfilt(Ic, 0.8);
Imgnext = imgaussfilt(Inextc, 0.8);
% figure (3); imshow(Img)
% figure (4); imshow(Imgnext)

%% Gray Image
Img = rgb2gray(Img);
Imgnext = rgb2gray(Inextc);
% figure(3), imshow(Img)
% figure(4), imshow(Imgnext)

harris1 = detectSURFFeatures(Img);
harris2 = detectSURFFeatures(Imgnext); 

[f1,vp1] = extractFeatures(Img, harris1);
[f2,vp2] = extractFeatures(Imgnext, harris2);

indexPairs = matchFeatures(f1,f2,'MaxRatio', 0.2);
mp1 = vp1(indexPairs(:,1),:);
mp2 = vp2(indexPairs(:,2),:);
% figure(5); showMatchedFeatures(Img, Imgnext, mp1, mp2);

m1 = mp1.Location;
m2 = mp2.Location;
    
m1x = m1(:,1);
m1y = m1(:,2);
m2x = m2(:,1);
m2y = m2(:,2);

s = size(m1x);
    
X1h = [m1x'; m1y'; ones(1, s(1))];
X2h = [m2x'; m2y'; ones(1, s(1))];
    
X1 = [m1x'; m1y']';
X2 = [m2x'; m2y']';
     
[Tl,X1n] = norm2d(X1);
[Tr,X2n] = norm2d(X2);
     
%% Find Fundamental Matrix
for i = 30: size(X1n,1)
    % map the points
    xl = X1n(i, 1);
    yl = X1n(i, 2);
    xr = X2n(i, 1);
    yr = X2n(i, 2);
    Q(i, :) = [xl * xr yl * xr xr xl * yr yl * yr yr xl yl 1]; 
end

[U, S, V] = svd(Q);
temp = reshape(V(:,end), [3 3])';
[U, S, V] = svd(temp);
S(3,3) = 0;
S2 = S;

Fnorm = U * S2 * V';
%% Fundamental Matrix using RANSAC
iterations = 300;   
thres = .001;
binliers = 0;
for i = 1: iterations
% select 8 random points in each iteration
testindices = randperm(size(X1,1), 8);
ts1 = X1(testindices, :);
ts2 = X2(testindices, :);
[T1,ts1n] = norm2d(ts1);
[T2,ts2n] = norm2d(ts2);
    
for i = 1: size(ts1n,1)
% map the points
xlt = ts1n(i, 1);
ylt = ts1n(i, 2);
xrt = ts2n(i, 1);
yrt = ts2n(i, 2);
B(i, :) = [xlt * xrt ylt * xrt xrt xlt * yrt ylt * yrt yrt xlt ylt 1]; 
end

[Ut, St, Vt] = svd(B);
tempt = reshape(Vt(:,end), [3 3])';
[Ut, St, Vt] = svd(tempt);
St(3,3) = 0;
St3 = St;

tF = Ut * St3 * Vt';   
% compute outliers
tcountinliers = 0;
tinlierindices = [];
tempoutliersindices = [];
% make sure this is above threshold
current_diff = zeros(8, 1) + 1; 
for j = 1: 8
eval = [ts2n(j,:) 1] * tF * [ts1n(j,:) 1]';
if (abs(eval) < thres)
tcountinliers = tcountinliers + 1;
tinlierindices = [tinlierindices; testindices(1,j)];
current_diff(j) = abs(eval); 
end
end    
if (tcountinliers > binliers)
binliers = tcountinliers;
Best_Fmatrix_temp = T2'*tF*T1;
Best_Fmatrix = Best_Fmatrix_temp/norm(Best_Fmatrix_temp);
if Best_Fmatrix(end) < 0
Best_Fmatrix = -Best_Fmatrix; 
end
best_diff = current_diff;
best_inliers = tinlierindices;
end
end
inliers1 = X1(best_inliers,:);
inliers2 = X2(best_inliers,:);
p1 = [inliers1(1,:) 1]';
p2 = [inliers2(1,:) 1]';
   
E = K' * Best_Fmatrix * K;
%% Essential Matrix
[U, D, V] = svd(E);
e = (D(1,1) + D(2,2)) / 2;
D(1,1) = 1;
D(2,2) = 1;
D(3,3) = 0;
E = U * D * V';
[U, ~, V] = svd(E);

W = [0 -1 0;
     1 0 0; 
     0 0 1];
  
R1 = U * W * V';
if det(R1) < 0
R1 = -R1;
end
R2 = U * W' * V';
if det(R2) < 0
R2 = -R2;
end

t1 = U(:,3)';
t2 = -t1;

Rs = cat(3, R1, R1, R2, R2);
Ts = cat(1, t1, t2, t1, t2);

%% Choose the right solution for rotation and translation
numNegatives = zeros(1, 4);
P1 = cameraMatrix(cameraParams, eye(3), [0,0,0]);

for k = 1:size(Ts, 1)
P2 = cameraMatrix(cameraParams,Rs(:,:,k)', Ts(k, :));
% Triangulation
points3D_1 = zeros(size(inliers1, 1), 3, 'like', inliers1);
P1a = P1';
P2a = P2';

M1 = P1a(1:3, 1:3);
M2 = P2a(1:3, 1:3);

c1 = -M1 \ P1a(:,4);
c2 = -M2 \ P2a(:,4);

for kk = 1:size(inliers1,1)
u1 = [inliers1(kk,:), 1]';
u2 = [inliers2(kk,:), 1]';
a1 = M1 \ u1;
a2 = M2 \ u2;
A = [a1, -a2];
y = c2 - c1;

alpha = (A' * A) \ A' * y;
p = (c1 + alpha(1) * a1 + c2 + alpha(2) * a2) / 2;
points3D_1(kk, :) = p';
end
%Triangulation ends
points3D_2 = bsxfun(@plus, points3D_1 * Rs(:,:,k)', Ts(k, :));
numNegatives(k) = sum((points3D_1(:,3) < 0) | (points3D_2(:,3) < 0));
end

[val, idx] = min(numNegatives);
R = Rs(:,:,idx)';
t = Ts(idx, :);
tNorm = norm(t);
if tNorm ~= 0
t = t ./ tNorm;
end

%% Rotation and translation
R = R';
t = -t * R;

%% Trajectory
Rpos = R * Rpos;
pos = pos + t * Rpos;

Finbuilt = estimateFundamentalMatrix(inliers1,inliers2,'Method','Norm8Point');
[relativeOrientation,relativeLocation] = relativeCameraPose(Finbuilt,cameraParams,inliers1,inliers2);
Rposinbuilt = relativeOrientation * Rposinbuilt; 
posinbuilt = posinbuilt + relativeLocation * Rposinbuilt;
   
figure(8)
subplot(2,2,1)
title('Camera Feed')
imshow(Ic)
subplot(2,2,3)
title('Trajectory')
plot(pos(1),pos(3),'o','MarkerEdgeColor','r')
hold on
subplot(2,2,4)
title('Trajectory-matlab')
plot(posinbuilt(1),posinbuilt(3),'o','MarkerEdgeColor','k')
hold on;

frame = getframe(gcf);
writeVideo(v,frame);
    
pause(0.005)
end
close(v)
cd ../../..