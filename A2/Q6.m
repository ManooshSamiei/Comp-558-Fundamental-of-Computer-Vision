
%please use script Q6_call.m for executing this function

%imrotate and imresize functions are only able to rotate & scale an image around 
%its center point. to rotate an image around another point in the image we
%can first pad the image with zeros (by calculating how many rows and 
%columns to pad to create a virtual center), rotating and resizing around 
%its center(using imrotate & imresize),and then cropping to remove the 
%initial padding (un-padding the image).

function [cropped_scale_rot,cropped_only_rotated,cropped_only_scaled]=Q6(image,x0,y0,theta,s,show)

 [imageHeight , imageWidth] = size(image);%image width and height
 center_x = floor((imageWidth/2)+1);%x coordinate of center of image
 center_y = floor((imageHeight/2)+1);%y coordinate of center of image
 
 padx=abs(imageWidth-2*x0);%padding columns
 pady=abs(imageHeight-2*y0);%padding rows
 
 %difference of coordinates of image's center and transformation origin
 dx=center_x-x0;
 dy=center_y-y0;
     
 if(dx>=0 && dy>=0)%transformation point is in first quarter of image
     padded=cat(1,zeros(pady,imageWidth),image);%padding rows
     padded=cat(2,zeros(imageHeight+pady,padx),padded);%padding columns

 elseif(dx<=0 && dy>=0)%transformation point in 2nd quarter of image
     padded=cat(1,zeros(pady,imageWidth),image);%padding rows
     padded=cat(2,padded,zeros(imageHeight+pady,padx));%padding columns
     
 elseif(dx>=0 &&dy<=0)%transformation point in 3rd quarter of image    
     padded=cat(1,image,zeros(pady,imageWidth));%padding rows
     padded=cat(2,zeros(imageHeight+pady,padx),padded);%padding columns
     
 elseif(dx<=0 &&dy<=0)%transformation point in 4th quarter of image
     padded=cat(1,image,zeros(pady,imageWidth)); %padding rows
     padded=cat(2,padded,zeros(imageHeight+pady,padx));%padding columns

 end
 
rotated=imrotate(padded,theta,'nearest','crop');%rotating around the center of padded image
scale_rot = imresize(rotated,s);%scaling the rotated image around the center
only_scaled = imresize(padded,s);%scaling around the center of padded image

[scale_rot_Height , scale_rot_Width] = size(scale_rot);%the width and height of the scaled and rotated image
%the coordinates of the center of scaled and rotated image
center_new_x = floor((scale_rot_Width/2)+1);
center_new_y = floor((scale_rot_Height/2)+1);
%defining a window around the tranformation point to crop the image (the
%final size will be again 1024x1024)
rect=[center_new_x-(imageWidth/2), center_new_y-(imageHeight/2), imageWidth-1, imageHeight-1];
cropped_scale_rot = imcrop(scale_rot,rect);%cropping the scaled and rotated image

cropped_only_scaled = imcrop(only_scaled,rect);%cropping only-scaled image

[rot_Height , rot_Width] = size(rotated); %the width and height of only-rotated image
%the coordinates of the center of only-rotated image
center_rot_new_x = floor((rot_Width/2)+1);
center_rot_new_y = floor((rot_Height/2)+1);
%defining a window around the tranformation point to crop the image (the
%final size will be again 1024x1024)
rect2=[center_rot_new_x-(imageWidth/2), center_rot_new_y-(imageHeight/2), imageWidth-1, imageHeight-1];
cropped_only_rotated = imcrop(rotated,rect2);%cropping the only-rotated image

if show
    
%     [padded_Height , padded_Width] = size(padded);
%     center_padded_x = floor((padded_Width/2)+1);
%     center_padded_y = floor((padded_Height/2)+1);
%     figure;
%     imshow(padded);
%     hold on;
%     plot(center_padded_x, center_padded_y, 'r+', 'LineWidth', 2, 'MarkerSize', 15);  % Put up red cross.
   
    figure('Name','original image');
    imshow(image);
    hold on;
    plot(x0, y0, 'r+', 'LineWidth', 2, 'MarkerSize', 15);  % Put up red cross.

    figure('Name','scaled and rotated around (x0,y0)');
    imshow(cropped_scale_rot);
    hold on;
    plot(center_x, center_y, 'r+', 'LineWidth', 2, 'MarkerSize', 15);  % Put up red cross.

    figure('Name','only rotated image around (x0,y0)');
    imshow(cropped_only_rotated);
    hold on;
    plot(center_x, center_y,'r+', 'LineWidth', 2, 'MarkerSize', 15);  % Put up red cross.

    figure('Name','only scaled image around (x0,y0)');
    imshow(cropped_only_scaled);
    hold on;
    plot(center_x, center_y, 'r+', 'LineWidth', 2, 'MarkerSize', 15);  % Put up red cross.
end
end

