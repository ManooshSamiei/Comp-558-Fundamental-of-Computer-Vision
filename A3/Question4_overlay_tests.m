'Question3';

%overlaying consecutive images two by two to see how they overlay

I=cell([1 6]); %store images with 'single' values
for j=1:6
    
if(x=='h')%for horizontal sequence image labels start with 0 index->(j-1)
%reading images (from their name in string) and resizing them to 350x500
%instead of 700x1000 for computational efficiency
%the images values should be converted to single for blending using 'alphablender' 
I{j} = im2single(imresize(imread(strcat(num2str(j-1), '.png')), [350 500]));%
elseif (x=='v')%for vertical/my sequence image labels start with 1 index->(j)
I{j} = im2single(imresize(imread(strcat(num2str(j), '.png')), [350 500]));
end

end

tforms =cell([1 6]);%converting homography matrices to 2-D projective geometric transformation
tforms{1}=projective2d(eye(3));%first transformation is an identity matrix (when reference is first image)
outputView = imref2d(size(I{1}));%the size of two overlaid images = size of reference image (1st image)

for m = 2:6 %starting from the second image in the sequence
H=Homography{m};    
tforms{m} = projective2d(inv(H'));%transforming homography matrices to 2-D projective geometric transformation
 
Ir = imwarp(I{m},tforms{m},'OutputView',outputView);%applying transformation on the each image
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port'); %using binary mask to overwrite the pixel 
%values of one image with the pixel values of another image.

%building a mask for blending images with binary mask
mask = imwarp(true(size(I{m},1),size(I{m},2)), tforms{m}, 'OutputView', outputView);
c = blender(I{m-1},Ir,mask);%blending each image with its previous image in sequence

%c = imfuse(I{m-1},Ir,'blend','Scaling','joint');
figure;
imshow(c);  
end

outputView = imref2d(size(I{1}));
c  = I{1};
%overlaying multiple images (4 images) 
for m = 2:4
%calculating transformations from the first image(as the reference)
tforms{m}.T = tforms{m}.T * tforms{m-1}.T; 
%warping each image based on the transformation
Ir = imwarp(I{m},tforms{m},'OutputView',outputView);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');
%building a mask for blending images with binary mask
mask = imwarp(true(size(I{m},1),size(I{m},2)), tforms{m}, 'OutputView', outputView);
%blending each transformed image with the blend of previously stitched images in the sequence
c = blender(c,Ir,mask);
%c = imfuse(c,Ir,'blend','Scaling','joint');

end
figure;
imshow(c);  
