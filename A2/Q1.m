%please use script Q1_call.m for executing this function

function G= Q1(image,show)
%defining a cell array to put each level of gaussian pyramid inside
G = cell([1 8]);

%computing the size and bluring scale of each level in gaussian pyramid
for i=0:6
    %blurring the original image with a 2D Gaussian(with different sigmas)
    %cell arrays' index start from 1
    G{i+1}= imgaussfilt(image,2^i);
    %resizing the original image for each level in gaussian pyramid
    G{i+1}=imresize(G{i+1},2^-i);
    size(G{i+1})
end

%plotting the Gaussian pyramid
if show
    w = size(G{1} ,1);%the width of the image
    G_ = cell([1 8]); % this parameter is defined for holding the value of padded
    %images since we need to store the original size of images (unpadded) in each scale of
    %pyramid for using in later questions
    g_pyramid = [];

    for j = 1 : numel(G)
        [p,q] = size(G{j}); %length and width of images in each level of pyramid
        %padding zeros/ones (or other numbers) at the bottom of each image
        % by concatenating image array with padding arrays row-wise (dimension 1)
        
        G_{j} = cat(1,G{j},ones(w - p, q)*256);%padding images with 256 to have a white background
        
        %adding a narrow margin between different levels for a more clear observation
        G_{j}= cat(2,G_{j},ones(w, 15)*256);%15 pixel margin 
        
        %concatenating padded images and original image column-wise (dimension 2)
        g_pyramid = cat(2,g_pyramid,G_{j});
    end
    %displaying the pyramid
    figure;
    imshow(g_pyramid , [])
end

end