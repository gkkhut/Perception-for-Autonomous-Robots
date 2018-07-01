NewVid = VideoWriter('../../../Output/ExtraCredit/Video/GMM_HSV');
NewVid.FrameRate = 15;
open(NewVid);
colorimagepath = '../../../Output/ExtraCredit/Frames/';

for i = 42:149
    filenamecolor = sprintf('out_%d.jpg', i);
    filenamecolor_final = strcat(colorimagepath, filenamecolor);
    Image = imread(filenamecolor_final);
    
    writeVideo(NewVid,Image);
end
close(NewVid);
