'Question3'; %creating panorama

I=cell([1 6]);%contains RGB images with double pixel values
imageSize=zeros(6,2);%contains size of each image
Im=cell([1 6]);%contains gray-scale images with double pixel values

for j=1:6 %storing images with 'double' values
    
if (x=='h') %for the horizontal sequence   
Im{j}=imresize(imread(strcat(num2str(j-1), '.png')), [350 500]);
elseif (x=='v')  %for the vertical sequence    
Im{j}=imresize(imread(strcat(num2str(j), '.png')), [350 500]);
end

I{j} =  rgb2gray(Im{j});%gray-scale images
imageSize(j,:) = size(I{j});%size of the gray scale images
end

tforms = cell([1 6]); %contains 2-D projective geometric transformation
tforms{1}=projective2d(eye(3));%reference's transformation is identity matrix 

for n=2:6 
%converting homography to projective transformation
tforms{n} = projective2d(inv(Homography{n}'));%the outputs are of table format 
%computing all transfomrations according to the first image which is the
%reference
%.T is used to access the values stored as table format
tforms{n}.T = tforms{n}.T * tforms{n-1}.T;
end

%We would like to change the reference image to be the image with the mean
%size after transformation (mean x or mean y; you can change this)

xlim=zeros(6,2);
ylim=zeros(6,2);
for i = 1:6 
    %Compute the size of each image after transformation
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms{i}, [1 imageSize(i,2)], [1 imageSize(i,1)]) ;   
end
%computing mean of all x values (width of images)
%this can be changes to ylim to compute the mean of y values (height of
%images)
avgXLim = mean(xlim, 2);%mean of each row (each image) in matrix 
[~, idx] = sort(avgXLim);%sorting the values of x (or y) and returning its index
centerIdx = floor((numel(tforms)+1)/2); %the index of the center image in sequence
centerImageIdx = idx(centerIdx);%the index of the center image in ascending order of size

%For a better display, below line of code  should be uncommented for the sequence of photos taken by me. 
centerImageIdx = 3; 

%By experiment, the best display of panorama for horizontal sequence is
%given when reference image is set to image the 4th image: 3.png
%hence I change it to 4 for horizontal sequence
if(x=='h')
   centerImageIdx = 4;
end

%Changing the reference image to the center image
%we should multiply all transformations by inverse of reference's tranfromation
Tinv = invert(tforms{centerImageIdx});
for i = 1:6
    tforms{i}.T = (tforms{i}.T)*(Tinv.T);
end

%computing the output sizes after the final transformations with respect to
%the reference image
for i = 1:6           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms{i}, [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);%maximum size of the image

% The minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

%Since the output limits for horizental sequence is very large, and will
%cause memory error, I manually defined the limits. By experiment, below limits are chosen. 
if (x=='h')
    xMin = -2000;%-4000 and -1000 is also tested for a closer view
    xMax = 2000;%4000 and 1000 is also tested for a closer view
    yMin = -500;
    yMax = 1000;
end

%Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the empty panorama.
panorama = zeros([height width 3], 'like', Im{6});%the type of values is like the RGB images

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port'); %to blend images 

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];

panoramaView = imref2d([height width], xLimits, yLimits);
warpedImage = cell ([1 6]);
% Create the panorama.
for i = 1:6
    
   
    % Transform image into the panorama.
    warpedImage{i} = imwarp(Im{i}, tforms{i}, 'OutputView', panoramaView);
               
    % Generate a binary mask.    
    mask = imwarp(true(size(Im{i},1),size(Im{i},2)), tforms{i}, 'OutputView', panoramaView);
   
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage{i}, mask);
end

size(panorama)
figure;
imshow(panorama);
