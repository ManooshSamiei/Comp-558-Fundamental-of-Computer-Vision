%please use script Q4_call.m for executing this function

function [Gdir_all,Gmag_weighted_all,hist_index]=Q4(key,counter,G,show)
Gmag_all = cell([ 1 counter]);%storing gradients' magnitude matrix for all keypoints
Gdir_all = cell([ 1 counter]);%storing gradients' direction matrix for all keypoints
Gmag_weighted_all = cell([ 1 counter]);%storing weighted gradients' magnitude matrix for all keypoints

for h=1:counter
    %finding the image at the scale of keypoint in Gaussian pyramid (L{d})
    %third column in key matrix includes the sigma of keypoint (key(:,3))
    img = G{log2(key(h,3))+1}; %the level of keypoint is derived from its sigma= 2^(d-1), we want to find d
    x=key(h,1);
    y=key(h,2);
    %considering 15X15 windows
    r_Lo = x-7; % lower row index of window
    r_Hi = x+7; % upper row index of window
    c_Lo = y-7; % lower column index of window
    c_Hi = y+7; % upper column index of window
    [row,column]=size(img);%number of rows and columns of image at scale of keypoint
    if( r_Lo >= 1 && r_Hi <= row && c_Lo >= 1 && c_Hi <= column )%checking if 15x15 window around keypoint is whithin the image boundaries 
       %generate a window with the specified boundary in the image
       imgWindow = img( (r_Lo : r_Hi) , (c_Lo : c_Hi) );
%        if (h == 697)
%            imshow(imgWindow ,[],'InitialMagnification','fit')
%        end
       %caluclating gradient magnitude and orientation using central
       %differences method
       [Gmag,Gdir] = imgradient(imgWindow ,'central');
       
       Gmag_all{h} = Gmag; %storing gradiants' magnitudes of each 15x15 window
       Gdir_all{h} = Gdir; %storing gradiants' orientations of each 15x15 window
       
       %calculating 2D Gaussian weighted gradient magnitude
       sigma=2; %choosing an arbitrary sigma for 2D Gaussian
       Gmag_weighted = Gmag.*fspecial('gaussian',15,sigma);
       Gmag_weighted_all{h} = Gmag_weighted;%storing weighted gradiants' magnitudes of each 15x15 window
       hist_index=h; %the index of the last keypoint whose 15x15 window is not out of boundary for displaying purposes 
    end
end

%the last keypoint whose 15x15 window is not out of boundary is
%visualized.

if show
    %visualizing image patch
    figure('Name','15x15 patch');
    imshow(imgWindow ,[],'InitialMagnification','fit')

    %visualizing gradient orientation on top of image patch
    figure('Name','Gradient Orientations');
    x = 1:15; %the x axis limits 
    y = 1:15; %the y axis limits
    imshow(imgWindow ,[],'XData', x, 'YData', y ,'InitialMagnification','fit')%showing image patch in a specified axis boundary
    hold on; %enable plotting overwrite

    theta = deg2rad(Gdir); %the direction of gradient are angles in degrees ,
    %we have to convert them to radian.
    
    %we convert angle and magnitude of vectors into cartesian coordinates
    [u,v] = pol2cart(theta,Gmag);
    v=-v;%the v of the above formula is negative of its actual value(it is flipped)
    quiver(x,y,u,v); %plotting gradient direction arrows on 15x15 patch

    %visualizing gradient magnitude
    figure('Name','Gradient Magnitudes');
    imshow(Gmag ,[],'InitialMagnification','fit')

    %visualizing weighted gradient magnitude
    figure('Name','Weighted Gradient Magnitudes');
    imshow(Gmag_weighted ,[],'InitialMagnification','fit')
    
    
end
end

