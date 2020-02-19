%choosing the sequence
%press v for sequence photos taken by me

prompt = 'which sequence are you using? press h for horizontal , press v for vertical / my photos ';
x = input(prompt,'s');

if(x=='h') %horizontal sequence
   i = 0:4;
elseif (x=='v')%vertical sequence
   i = 1:5;
else
    disp('you entered a wrong input');
end

matchedPoints1=cell([1,5]);
matchedPoints2=cell([1,5]);
image1=cell([1,5]);
image2=cell([1,5]);
r=1;%index used for cell parameters (we cant use below loop iterator as 
%index because it may start from zero for horizental sequence while cell 
%indices should start from 1)

for j=i 
    %extracting keypoints of the first image
    first_im = imread(strcat(num2str(j), '.png'));
    first_im = imresize(first_im, [350 500]);%resizing the image for panorama generation (memory saving)
    %note that some numbers and images in report relate to the original
    %size of the images, resizing was decided after encountering
    %memory error while creating panoramas 
    image1{r} = single(rgb2gray(first_im));%converting to gray scale
    [keypoints_1,features1] = sift(image1{r},'Levels',4,'PeakThresh',5);
    feature_vectors1=features1';%transpose of feature discriptor 
    keypoints_1=keypoints_1';%transpose of feature detector

    %extracting keypoints of the second image
    second_im = imread(strcat(num2str(j+1), '.png'));
    second_im = imresize(second_im, [350 500]);
    image2{r} = single(rgb2gray(second_im));
    [keypoints_2,features2] = sift(image2{r},'Levels',4,'PeakThresh',5);
    feature_vectors2=features2';
    keypoints_2=keypoints_2';

    %finding matched keypoints between the two images
    [indexPairs,~] = matchFeatures(feature_vectors1,feature_vectors2,...
    'Method', 'Exhaustive', 'MatchThreshold' , 100,'MaxRatio',0.6, 'Metric', 'SAD', 'Unique', true);

    size(indexPairs)%number of matched keypoints

    %finding the location of matched keypoints 
    matchedPoints1{r} = keypoints_1(indexPairs(:,1),1:2);
    matchedPoints2{r} = keypoints_2(indexPairs(:,2),1:2);
    
    %plotting the matched keypoints
    figure; ax = axes;
    showMatchedFeatures(image1{r} , image2{r} ,matchedPoints1{r},matchedPoints2{r},'montage','Parent',ax);
    legend(ax, 'Matched points 1','Matched points 2'); 
    
    r=r+1;
end