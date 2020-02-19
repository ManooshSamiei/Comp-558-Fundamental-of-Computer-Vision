
rgb = imread('0.png');
image1 = single(rgb2gray(rgb));
[keypoints,features] = sift(image1,'Levels',4,'PeakThresh',5);
figure;
subplot(1,2,1)
imshow(rgb);hold on;
viscircles(keypoints(1:2,:)',keypoints(3,:)');

theta = 45;
image2=imrotate(image1,theta,'crop');
[keypoints_rotate,features_rotate] = sift(image2,'Levels',4,'PeakThresh',5);  
subplot(1,2,2)
imshow(imrotate(rgb,theta,'crop'));hold on;
viscircles(keypoints_rotate(1:2,:)',keypoints_rotate(3,:)');
 
%finding matched keypoints between two images to compare their histogram
[indexPairs,matchmetric] = matchFeatures(features',features_rotate',...
'Method', 'Exhaustive', 'MatchThreshold' , 2,'MaxRatio',0.6, 'Metric', 'SAD', 'Unique', true);

keypoints_1=keypoints';
keypoints_2=keypoints_rotate';

%finding the location of matched keypoints 
matchedPoints1 = keypoints_1(indexPairs(:,1),1:2);
matchedPoints2 = keypoints_2(indexPairs(:,2),1:2);

figure('Name', 'Histogram of two matched points');

%showing histogram for first matched keypoint
subplot(1,2,1);
bar(features(:,indexPairs(1,1))); 
title('keypoint in original image') 

subplot(1,2,2)
bar(features_rotate(:,indexPairs(1,2)));
title('keypoint in rotated image')


