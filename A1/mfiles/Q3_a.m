% sigma=1;
% N=15;
sigma=1;
N=13;
%calling function make2DGaussian with defined input values for n and sigma
%Note that function make2DGaussian is defined in another mfile
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
[p,q] = size(a_pad);
g=make2DLOG(N, sigma);
image_output = conv2(double(a_pad),double(g),'same');
figure;
imshow(image_output , [])

