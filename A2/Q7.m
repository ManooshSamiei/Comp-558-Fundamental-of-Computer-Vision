%please run scripts Q1 to Q6 before this script.
'Q6_call';

theta=45;
y=375;%y of transformation origin point
x=500;%x of transformation origin point
show=0;%not showing again the original & transformed images from Q6
[cropped_scale_rot,cropped_only_rotated,cropped_only_scaled]=Q6(original_image,x,y,theta,s,show);

%computing sift vector for scaled/rotated/scaled & rotated image
show=0;%to show the results put show=1
G_trans=Q1(cropped_scale_rot,show);%generating gaussian pyramid
L_trans=Q2(G_trans,show);%generating laplacian pyramid
[key_trans,counter_trans]=Q3(cropped_scale_rot,L_trans,show);%detecting sift keypoints
[Gdir_all_trans,Gmag_weighted_all_trans,hist_index_trans]=Q4(key_trans,counter_trans,G_trans,show);%calculating gradients magnitude,orientation and histograms
sift_vector_trans=Q5(counter_trans,Gdir_all_trans,Gmag_weighted_all_trans,key_trans,hist_index_trans,show);%generating sift feature vectors


 y=500;%y of transformation origin point
 x=550;%x of transformation origin point
 ROI_original = original_image(x-64:x+64,y-64:y+64);%region of interest in original image
 figure;
 imshow(ROI_original);

ROI_transformed = cropped_scale_rot(x-200:x+200,y-200:y+200);%region of interest in transformed image
figure;
imshow(ROI_transformed);
          
    [row_trans,~]=size(sift_vector_trans);%number of rows in sift vector of transformed image
    [row,~]=size(sift_vector);%number of rows in sift vector of original image
    Bhatt_coeff=zeros(1,row_trans);
    sift_vector_norm=zeros(row,36);%normalized sift vector of original
    sift_vector_trans_norm=zeros(row_trans,36);%normalized sift vector of transformed
    u=0;
    matchedPoints1=zeros(row,2);%matched points in original image
    matchedPoints2=zeros(row,2);%matched points in transformed image
  
for i=1:row  
        %key points in ROI
        if((sift_vector(i,1)*sift_vector(i,3))<(x+64) && ...
           (sift_vector(i,1)*sift_vector(i,3))>(x-64) &&...
           (sift_vector(i,2)*sift_vector(i,3))<(y+64) && ...
           (sift_vector(i,2)*sift_vector(i,3))>(y-64))

            %normalising sift feature vectors and removing the first 3 arguments 
            %which are location and scale of sift keypoint
            S=sum(sift_vector(i,4:end));

            sift_vector_norm(i,:) = double(sift_vector(i,4:end))./double(S);
           
            for j=1:row_trans
                [r,~]=size(sift_vector_trans(j,1));
                if(r~=0)%not consider out of image boundary sift keypoints
                  if((sift_vector_trans(j,1)*sift_vector_trans(j,3))<(x+200) && ...
                     (sift_vector_trans(j,1)*sift_vector_trans(j,3))>(x-200) && ...
                     (sift_vector_trans(j,2)*sift_vector_trans(j,3))<(y+200) && ...
                     (sift_vector_trans(j,2)*sift_vector_trans(j,3))>(y-200))
                        
                        %normalising sift feature vectors and removing the first 3 arguments 
                        %which are location and scale of sift keypoint
                        S2=sum(sift_vector_trans(j,4:end));%not considering the first three arguments of sift vector which are location and sigma
                        sift_vector_trans_norm(j,:) = double(sift_vector_trans(j,4:end))./double(S2);%normalizing the sift vector for each keypoint
                        %Bhattacharya coefficient between associated feature vectors
                        Bhatt_coeff(1,j) = sum(sqrt(sift_vector_trans_norm(j,:).* sift_vector_norm(i,:)));
                        
                  end
                 end
            end
            
            [max_num,z] = max(Bhatt_coeff(1,:));%maximum bhattacharya coefficient value and index
%             if(u==19)
%                 max_num
%             end
            u=u+1;
            t=sift_vector_trans(z,1)*sift_vector_trans(z,3);
            n=sift_vector_trans(z,2)*sift_vector_trans(z,3);
            matchedPoints2(u,:)=[n t];
            
            w=sift_vector(i,1)*sift_vector(i,3);
            k=sift_vector(i,2)*sift_vector(i,3);
            matchedPoints1(u,:)=[k w];
        end
end
%drawing matched points
matchedPoints2=matchedPoints2(1:u,:);
matchedPoints1=matchedPoints1(1:u,:);
size(matchedPoints1)
figure; ax = axes;
showMatchedFeatures(original_image,cropped_scale_rot,...
matchedPoints1(4:8,:),matchedPoints2(4:8,:),'montage','Parent',ax);% change the index to see other points
legend(ax, 'Matched points 1','Matched points 2');
