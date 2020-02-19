%to be used for calling the function in Q1 script

%reading the image and converting to gray scale
original_image=rgb2gray(imread('0.png'));
show=1;%show=1 if you want to show the pyramid

G=Q1(original_image,show);

