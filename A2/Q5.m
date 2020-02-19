%please use script Q5_call.m for executing this function

function sift_vector=Q5(counter,Gdir_all,Gmag_weighted_all,key,hist_index,show)

max_peak=zeros(1,counter);%maximum peak of histogram for each sift key point
loc_max_peak=zeros(1,counter);%the location of the maximum peak of histogram
bin_all=cell([1 counter]);%bins of gradient orentations of each 15x15 patch is stored.
bin_shifted_all=cell([1 counter]);%shifted bins to place the gradient direction with highest weight as the first entry
sift_vector=zeros(counter,39); %sift features vector

for g=1:counter
    
    [row,~]=size(Gdir_all{g}); 
    bin=zeros(1,36);% bin is calculated separately for each 15X15 window;it is set to zero for a new patch
    
    %keypoints whose 15X15 window was out of boundary, have zero row and
    %column in their gradient matrix, since they were skipped in script Q4
    if (row~=0) 
        e= Gdir_all{g};
        for w=1:15 % accessing each pixel's gradient in the matrix
            for q=1:15  
                if(e(w,q)<0) 
                     e(w,q)=e(w,q)+360; %converting negative angles to put them between: [0,360)
                end
                 
                for j=0:35 % defining 36 bins (each bin=10 degrees)
                    if(10*j<=e(w,q) && e(w,q)<10+10*j)
                        %bins index start from 1 to 36
                        bin(j+1)=bin(j+1)+Gmag_weighted_all{g}(w,q);%adding up 
                        %the weighted gradient magnitudes of all gradients
                        %in the 16x16 neighborhood whose orientations fall
                        %within each particular bin.
                        
                    end
                end
                
            end
        end
        bin_all{g}=bin(1,:); %bins for all gradient orentations of each 
        %15x15 patch is stored in this parameter
        [pks,locs] = findpeaks(bin_all{g});%finding the peaks of orientation histogram
        max_peak(g)=max(pks);% finding the maximum peak
        loc_max_peak(g)=locs(pks==max(pks));%the locations of max peak
        bin_shifted_all{g} = circshift(bin,36-loc_max_peak(g)+1);%circular shift of
        %bins to place the gradient direction with highest weight as the first entry
        
        %concatenating(x,y,sigma)tuple with peak-aligned histogram vector entries.  
        sift_vector(g,:)=cat(2,key(g,:),bin_shifted_all{g});%each row in this matrix is a sift feature vector (for a keypoint)
   
    end
end

if show
    %visualizing the histograms of the same key point visualized in script Q4 ('hist_index').           
    figure('Name','discrete plot');
    bar(bin_all{hist_index});
    
    xticks(1:36)
    labels={'0-10','10-20','20-30','30-40',...
    '40-50','50-60','60-70','70-80','80-90',...
    '90-100','100-110','110-120','120-130',...
    '130-140','140-150','150-160','160-170',...
    '170-180','180-190','190-200','200-210',...
    '210-220','220-230','230-240','240-250',...
    '250-260','260-270','270-280','280-290',...
     '290-300','300-310','310-320','320-330',...
     '330-340','340-350','350-360'};

    set(gca,'xtickLabel', labels);
    xtickangle(90);

    figure('Name','continuous plot(as in lecture 9 slide 33 ');
    p=1:36;
    plot(p,bin_all{hist_index});
end
end

