
%please use script Q2_call.m for executing this function

function L=Q2(G,show)

%defining a cell array to put each level of Laplacian pyramid inside
L = cell([1 6]);

%computing laplacian pyramid

for k=6:-1:1%starting from level 5 to level 0 (level 6(last level) does not exist in Laplacian pyramid)
    
    %upsampling by a factor of 2 each time
    [M,N,~] = size(G{k});%The number of pixels is rounded up in some levels and
    %scaling the upsampled image by two causes dimension inconsistency between
    %the upsampled image and its original Gaussian level, Hence instead of
    %scaling by 2, we scale to the size of the original gaussian level image
    im_upsampled = imresize(G{k+1}, [M N], 'nearest'); %interpolating by Nearest-neighbor method
    %im_upsampled=imresize(L{k+1}, 2, 'bilinear'); %interpolating by bilinear method
    size(G{k})
    size(im_upsampled)
    L{k} = double(G{k})- double(im_upsampled); %taking the difference of each level and its next higher level
end

%plotting the Laplacian pyramid
if show
    
    w = size(G{1} ,1);%the width of the image
    L_pyramid = [];
    L_ = cell([1 8]);

    for m = 1 : numel(L)
        [r,u] = size(L{m}); %length and width of images in each level of pyramid
        %padding zeros/ones (or other numbers) at the bottom of each image
        % by concatenating image array with padding arrays row-wise (dimension 1)

        L_{m} = cat(1,L{m},ones(w - r, u)*125);%padding images with 256 to have a white background
        
        %adding a narrow margin between different levels for a more clear observation
        L_{m}= cat(2,L_{m},ones(w, 15)*125);
        
        %concatenating padded images and original image column-wise (dimension 2)
        L_pyramid = cat(2,L_pyramid,L_{m});
    end
    
    %displaying the pyramid
    figure;
    imshow(L_pyramid , [])
    
end
end