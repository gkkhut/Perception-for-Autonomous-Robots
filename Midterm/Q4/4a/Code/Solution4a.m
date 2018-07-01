clear all;
imgL=imread('tsukuba_l.png'); %Load imageL
imgR=imread('tsukuba_r.png'); %Load imageR
s = 7; %scan window size
mr = size(imgL, 1) +1 -s;
mc = size(imgL, 2) +1 -s;
scale= 3; %Right Large search window Scale
for row = 1: mr
disp(['Processing image - row ',num2str(row), ' of ', num2str(mr)]);
for col = 1: mc  
l = SW(imgL, col, row, s, 1);  %define left window  
rw = s*scale;   %define right width        
rX = col - (s * ((scale-1)/2)) - ((s-1)/2);  %
rY = row ;
if (rX < 1)
rX = 1;
end           
if (rX > 1 + size(imgL, 2) - rw)
rX = 1 + size(imgL, 2) - rw; 
end
if (rY < 1)
rY = 1;
end
if (rY > 1 + size(imgL, 1) - rw)
rY = 1 + size(imgL, 1) - rw;
end
r = SW(imgR, rX, rY, s, scale); %define right window  
testX = 1; %match x
maxd = -9999999; %maximum display
aw = (scale * s) - (s -1 ); %define array width
xMid = ((aw - 1) / 2) + 1;
for yr = 1 : 1 + (size(r, 1) -s)
for xr = 1 : 1 + (size(r, 2) -s)
pW = SW(r, xr, yr, s, 1);    %poll window                
tDisp = SSD(l, pW); %temp display  % SSDmatrix = -(L-R).^2;            
if (tDisp > maxd)
maxd = tDisp;
testX = xr;   
end
end
end
x = testX - xMid + (2 * (xMid - testX));
mV = (255 / (xMid -1)) * abs(x); %mapped value           
dmap(row, col, 1) = uint8(mV); %display map
end
end
figure(1)
imshow(dmap)
colormap (gca,jet);
figure(2)
depth = 6000./dmap;
imshow(depth)
colormap (gca,jet);