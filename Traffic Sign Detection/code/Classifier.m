%% CLASSIFIER (HOG-SVM)
train_files = fullfile('..\input\TSR\Training\');
trainSet = imageSet(train_files,   'recursive');
% test_folder = fullfile('D:\Perception Assignments\Project 4\input\TSR\Testing\');
% testSet = imageSet(test_folder, 'recursive');

trainFeatures = [];
trainLabels = [];

for i = 1:numel(trainSet)
    
numImages = trainSet(i).Count;
hog = [];
   
for j = 1:numImages
img = read(trainSet(i), j);
j
i
%Resize Image to 64x64
img = im2single(imresize(img,[64 64]));
%% Get HOG Features
hog_train = vl_hog(img, 4);
[hog_1, hog_2] = size(hog_train);
dim = hog_1*hog_2;
hog_train_trans = permute(hog_train, [2 1 3]);
hog_train = reshape(hog_train_trans,[1 dim]); 
hog(j,:) = hog_train;
end
labels = repmat(trainSet(i).Description, numImages, 1);
   
trainFeatures = [trainFeatures; hog];
trainLabels = [trainLabels; labels];
end

%% Training SVM Model
classifier = fitcecoc(trainFeatures, trainLabels);

filename = 'classifier.mat';
save(filename)