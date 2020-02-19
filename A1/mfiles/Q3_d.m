%a=imread('Paolina.jpg');
a=imread('apple.jpeg');
figure;
imshow(a)
a_gray=rgb2gray(a);

a_pad = padarray(a_gray,[(N-1)/2 (N-1)/2],0);
[row,column]=size(a_pad);
edge_detect=zeros([row,column]);

N=15;
lambda=[2 3];
angle=[0 pi/4 pi/2]; 
%angle=pi/6

 for k=1:2
 for h=1:3   
    [odd,even]= make2DGabor(N, lambda(k), angle(h));
    output = conv2(double(a_pad),double(odd),'same');
    %finding zero crossings
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
 end
 end

figure;
imshow(edge_detect);
%showing edges on the original image with yellow color
Red_plane = a_pad;
Green_plane = a_pad;
Blue_plane = a_pad;
for w=1:row-1
    for t=1:column-1
        if(abs(edge_detect(w,t))>10)
            Red_plane (w,t) = 255;
            Green_plane(w,t) = 255;
            Blue_plane(w,t) = edge_detect(w,t); 
        end
    end
end        
original_padded = cat(3, Red_plane, Green_plane, Blue_plane);
figure;
imshow(original_padded)