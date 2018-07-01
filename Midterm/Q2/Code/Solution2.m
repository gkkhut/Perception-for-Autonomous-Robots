%Get the low contrast image
Img=imread('low-contrast-ex.png');
mag= size(Img);
Pixelcount = (mag(1)*mag(2)); %define pixel count
figure,imshow(Img); %display image
title('Low-contrast');

%Defining matrices
Histogrameql=uint8(zeros(mag(1),mag(2)));
a=zeros(256,1);
probf=zeros(256,1);%finding probability of a
probc=zeros(256,1);
cumf=zeros(256,1);
output=zeros(256,1);

%Finding frequency of each gray value 
for i=1:mag(1)
for j=1:mag(2)
pixlevalue=Img(i,j);
a(pixlevalue)=a(pixlevalue)+1;
end
end

%Probability for each gray scale
for i = 1:256
probf(i)=a(i)/Pixelcount;
end

%Finding cumulative frequencies
sum=0;
for i=1:256
sum=sum+a(i);
cumf(i)=sum;
end

%Finding probability of output matrix and cumulative frequencies
for i= 1:256
probc(i)=cumf(i)/Pixelcount;
output(i)=round(probc(i)*255);
end

%Each pixel values of low-contrast image are transfromed to get equalized image
for i=1:mag(1)
for j=1:mag(2)
Histogrameql(i,j)=output(Img(i,j)); 
end
end

%plotting equlized image
figure,imshow(Histogrameql); %display image
title('Equalized-image');
figure,imhist(Histogrameql); %display image
title('Equalized-histogram');
figure,imhist(Img); %display image
title('Output-histogram-sample-image');