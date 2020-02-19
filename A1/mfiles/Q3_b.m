
a=imread('Paolina.jpg');
%a=imread('apple.jpeg');
figure;
imshow(a)
a_gray=rgb2gray(a);
% figure;
% imshow(a_gray);
%[m,n] = size(a_gray)
a_pad = padarray(a_gray,[(N-1)/2 (N-1)/2],0);
% figure;
% imshow(a_pad);
%[p,q] = size(a_pad);

N=15;
sigma=3;

g=make2DLOG(N, sigma);
output = conv2(double(a_pad),double(g),'same');

%finding zero crossing with a matlab function
% EDGEIMG = edge(output,'zerocross',.5);
% imshow(EDGEIMG)

%finding zero crossings from algorithm
[row,column]=size(output);
edge_detect=zeros([row,column]);

%defining a threshold for edge detection
threshold=0;
for i=2:row-1
    for j=2:column-1
        if(output(i,j)>0)
            if((output(i,j+1)>=0 && output(i,j-1)<0) || (output(i,j+1)<0 && output(i,j-1)>=0) && abs(output(i,j+1)-output(i,j-1))>threshold)
                
                edge_detect(i,j)=output(i,j+1);
  
            elseif((output(i+1,j)>=0 && output(i-1,j)<0) || (output(i+1,j)<0 && output(i-1,j)>=0) && abs(output(i+1,j)-output(i-1,j))>threshold)
                
                edge_detect(i,j)=output(i,j+1);

            elseif((output(i+1,j+1)>=0 && output(i-1,j-1)<0) || (output(i+1,j+1)<0 && output(i-1,j-1)>=0) && abs(output(i+1,j+1)-output(i-1,j-1))>threshold)
                
                edge_detect(i,j)= output(i,j+1);

            elseif((output(i-1,j+1)>=0 && output(i+1,j-1)<0) || (output(i-1,j+1)<0 && output(i+1,j-1)>=0) && abs(output(i+1,j-1)-output(i-1,j+1))>threshold)
                
                edge_detect(i,j)= output(i,j+1);
            end
        end
    end
end
figure;
imshow(edge_detect)
%showing edges on the original image with yellow color
Red_plane = a_pad;
Green_plane = a_pad;
Blue_plane = a_pad;
for i=1:row-1
    for j=1:column-1
        if(abs(edge_detect(i,j))>0.7)
            Red_plane (i,j) = 255;
            Green_plane(i,j) = 255;
            Blue_plane(i,j) = edge_detect(i,j); 
        end
    end
end        
original_padded = cat(3, Red_plane, Green_plane, Blue_plane);
figure;
imshow(original_padded)

