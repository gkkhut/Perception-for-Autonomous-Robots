%% remove noise from image using median filter
%read image
Data = imread ('TestImgResized.jpg');
%apply median filter
Datafilt = medfilt3 (Data);
subplot (2,1,1)
imshow (Data)
title ('Stock Image');
subplot (2,1,2)
imshow (Datafilt)
title ('Image after applying median filter');

%% To select all colored pins (excluding white and transparent)
% Three planes(R,G,B planes) and adding them for better detection of all colours(mostly yellow)
rmat = Datafilt (:,:,1);
gmat = Datafilt (:,:,2);
bmat = Datafilt (:,:,3); 

levelr = 0.5; levelg = 0.5; levelb = 0.4 ; 
Ir = im2bw (rmat, levelr);
Ig = im2bw (gmat, levelg);
Ib = im2bw (bmat, levelb);
Isum = (Ir&Ig&Ib);
% complimenting the binary image
Ibw = imcomplement (Isum);
se = strel ('disk', 10);
Ibwclr = imopen (Ibw, se);
% To select pins (excluding white and transparent)
statsr = regionprops(Ibwclr, 'Centroid', 'MajorAxisLength','MinorAxisLength');
c = cat (1,statsr.Centroid);
j = cat(1,statsr.MajorAxisLength);
k = cat(1,statsr.MinorAxisLength);
[L,num] = bwlabel(Ibwclr);

for i=1: length(statsr)
    dia(i,1) = mean([j(i,1) k(i,1)],2);
    radii(i,1) = dia(i,1)/2*1.5;
end

figure
imshow (Data)
title (['There are ', num2str(num), ' pins excluding white and transparent'])
hold on;
viscircles(c,radii, 'edgecolor', 'white');
hold off;

%% Selecting Individual color pins - 
%Red Pins
red = Datafilt(:,:,1); green = Datafilt(:,:,2); bluePin = Datafilt(:,:,3); 
redpin = red > 90 & green < 80 & bluePin < 100 ;  
ser = strel ('disk', 5);
rdpins = imopen (redpin, ser);

statsr = regionprops(rdpins, 'Centroid', 'MajorAxisLength','MinorAxisLength');
cr = cat(1,statsr.Centroid);
jr = cat(1,statsr.MajorAxisLength);
kr = cat(1,statsr.MinorAxisLength);
[L1,num1] = bwlabel(rdpins);

for i=1: length(statsr)
    diar(i,1) = mean([jr(i,1) kr(i,1)],2);
    radiir(i,1) = diar(i,1)/2*1.5;
end

%Green Pins
red = Datafilt(:,:,1); green = Datafilt(:,:,2); bluePin = Datafilt(:,:,3); 
greenpin = red < 50 & red > 0 & green > 40 & green < 200 & bluePin < 105 ;  
seg = strel ('disk', 4);
grnpins = imopen (greenpin, seg);

statsg = regionprops(grnpins, 'Centroid', 'MajorAxisLength','MinorAxisLength');
cg = cat(1,statsg.Centroid);
jg = cat(1,statsg.MajorAxisLength);
kg = cat(1,statsg.MinorAxisLength);
[L2,num2] = bwlabel(grnpins);

for i=1: length(statsg)
    diag(i,1) = mean([jg(i,1) kg(i,1)],2);
    radiig(i,1) = diag(i,1)/2*2;
end

%Blue Pins
red = Datafilt(:,:,1); green = Datafilt(:,:,2); bluePin = Datafilt(:,:,3); 
bluePin = red < 55 & green > 40 & green < 125 & bluePin < 200 & bluePin > 90 ;  
seb = strel ('disk', 4);
blupins = imopen (bluePin, seb);

statsb = regionprops(blupins, 'Centroid', 'MajorAxisLength','MinorAxisLength');
cb = cat(1,statsb.Centroid);
jb = cat(1,statsb.MajorAxisLength);
kb = cat(1,statsb.MinorAxisLength);
[L3,num3] = bwlabel(blupins);

for i=1: length(statsb)
    diab(i,1) = mean([jb(i,1) kb(i,1)],2);
    radiib(i,1) = diab(i,1)/2*2;
end

%Yellow Pins
red = Datafilt(:,:,1); green = Datafilt(:,:,2); bluePin = Datafilt(:,:,3); 
yellowpin = red < 230 & red > 100 & green > 100 & green < 200 & bluePin < 50 & bluePin > 0 ;  
sey = strel ('disk', 4);
yelopins = imopen (yellowpin, sey);

statsy = regionprops(yelopins, 'Centroid', 'MajorAxisLength','MinorAxisLength');
cy = cat(1,statsy.Centroid);
jy = cat(1,statsy.MajorAxisLength);
ky = cat(1,statsy.MinorAxisLength);
[L4,num4] = bwlabel(yelopins);

for i=1: length(statsy)
    diay(i,1) = mean([jy(i,1) ky(i,1)],2);
    radiiy(i,1) = diay(i,1)/2*2;
end

%plotting results for individual colored Pins - (Red, Green, Blue and Yellow)
figure
subplot (2,2,1); imshow (Data)
title (['Total ', num2str(num1), ' Red pins'])
hold on;
viscircles(cr,radiir, 'edgecolor', 'r');
hold off;

subplot (2,2,2); imshow (Data)
title (['Total ', num2str(num2), ' Green pins'])
hold on;
viscircles(cg,radiig, 'edgecolor', 'g');
hold off;

subplot (2,2,3); imshow (Data)
title (['Total ', num2str(num3), ' Blue pins'])
hold on;
viscircles(cb,radiib, 'edgecolor', 'b');
hold off;

subplot (2,2,4); imshow (Data)
title (['Total ', num2str(num4), ' Yellow pins'])
hold on;
viscircles(cy, radiiy, 'edgecolor', 'y');
hold off;

%% finding white and transparent pins in the image
comp = imcomplement (bmat);
figure
%imshowpair (bmat,comp,'montage')
compbw = im2bw (comp);
BW2 = bwpropfilt(compbw,'Area',[0 450]);

se3 = strel ('disk',3);
WTpins = imopen (BW2,se3);
statsWT = regionprops(WTpins, 'Centroid', 'MajorAxisLength','MinorAxisLength');
cWT = cat(1,statsWT.Centroid);
jWT = cat(1,statsWT.MajorAxisLength);
kWT = cat(1,statsWT.MinorAxisLength);
[L5,num5] = bwlabel(WTpins);

for i=1: length(statsWT)
    diaWT(i,1) = mean([jWT(i,1) kWT(i,1)],2);
    radiiWT(i,1) = diaWT(i,1)/2*2.5;
end

subplot (1,1,1); imshow (Data)
title (['Total ', num2str(num5), ' of White or Transpartent pins'])
hold on;
viscircles(cWT,radiiWT, 'edgecolor', 'w');
hold off;