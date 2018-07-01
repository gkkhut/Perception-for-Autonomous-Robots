% input = 'D:\Perception Assignments\Homework\eval-gray-allframes\eval-data-gray\Wooden\frame';
input = 'D:\Perception Assignments\Homework\eval-gray-allframes\eval-data-gray\Grove\frame';
opticFlow = opticalFlowFarneback;
video = VideoWriter('D:\Perception Assignments\Homework\Output_Part2\Matlab_FB_Grove_output\Matlab_FB_Grove');
video.FrameRate = 5;
output = 'D:\Perception Assignments\Homework\Output_Part2\Matlab_FB_Grove_output\';
open(video);

for i = 7:13
file1 = sprintf('%02d.png', i);
filename1_full = strcat(input, file1);
frame = imread(filename1_full);
l=i;
flow = estimateFlow(opticFlow,frame); 

figure();
imshow(frame) 
hold on
plot(flow,'DecimationFactor',[5 5],'ScaleFactor',1)
hold off 
frame = getframe(gca);
image = frame2im(frame);
fileout = sprintf('Matlab_FB_Grove_out%02d.jpg', l);
fullname = strcat(output, fileout);
imwrite(image, fullname, 'jpg');
writeVideo(video,image);

end
close(video);