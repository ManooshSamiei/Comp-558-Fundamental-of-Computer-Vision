'Question2';

% Computation of homography using RANSAC algorithm

Homography=cell([1 6]);%contains the homography matrix
Homography{1}=eye(3);%first homography is the indentity matrix (for the reference image)
for m=1:5
    [Index_max,~] = size(matchedPoints1{m});%maximum index is equal to number of matching keypoints 

    Th = 0; %Consensus set threshold (how many matches fit the homography)

    while Th < 0.90*Index_max %defining a threshold that 90 percent of matches fit the homography   

    %randomly choosing four pair of matching points
        len = 4;
    
    %4 random indices should be between (0,Index_max) 
        ind = ceil(rand(1,len).*(Index_max:-1:Index_max-len+1));
    
        points_1 = matchedPoints1{m}(ind,:);
        points_2 = matchedPoints2{m}(ind,:);
    
    % Computing the homography using function Q3_Homography
        H = Q3_Homography(points_1,points_2);
    
    % Finding the consensus set for the specified homography
    % In other words, finding the number of remaining matches that fit the homography

        Hmatched_points = H*[matchedPoints1{m}';ones(1,Index_max)];
        norm_Hmatched_points = [Hmatched_points(1,:)./Hmatched_points(3,:);... %normalizing to the dummy variable
                            Hmatched_points(2,:)./Hmatched_points(3,:);...
                            ones(1,Index_max)];
   %compute the distance between the real matching point and the 
   %homography-estimated matching point
        dist_ransac  = norm_Hmatched_points - [matchedPoints2{m}';ones(1,Index_max)];
    %norm 2 distance magnitude calculation                                                 
        distance_mag = sqrt(sum(dist_ransac.^2,1)); %summing elements in each column  
        consensus_set = distance_mag < 10;  %defining a threshold for the distance magnitude
        Th = size(find(consensus_set),2);%calculate the size of consensus set to be compared with the threshold
    
    end

    Cons_Set=find(consensus_set);%indices of the inliers

% using the consensus set to re-estimate a final homography (to remove noisy
% points)
    Homography{m+1} = Q3_Homography(matchedPoints1{m}(Cons_Set,:),matchedPoints2{m}(Cons_Set,:));

%plotting the matched inliers after application of RANSAC
    figure; ax = axes;
    showMatchedFeatures(image1{m} , image2{m} ,matchedPoints1{m}(Cons_Set,:), ...
    matchedPoints2{m}(Cons_Set,:),'montage','Parent',ax);
    legend(ax, 'Matched points 1','Matched points 2');
end
