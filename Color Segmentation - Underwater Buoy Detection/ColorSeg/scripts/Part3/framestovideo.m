NewVideo = VideoWriter('../../Output/Part3/Video/Video_GMM_new');
NewVideo.FrameRate = 15;
open(NewVideo);
colorimagepath = '../../Output/Part3/Frames/';

for i = 40:60
filenamecolor = sprintf('out_%d.jpg', i);
filenamecolor_final = strcat(colorimagepath, filenamecolor);
Image = imread(filenamecolor_final);
writeVideo(NewVideo,Image);
end
close(NewVideo);
