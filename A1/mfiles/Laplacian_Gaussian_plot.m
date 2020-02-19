%defining sigma and n( an odd number)  
% sigma=5;
% n=31;

sigma=1;
n=11;
%calling function make2DGaussian with defined input values for n and sigma
%Note that function make2DGaussian is defined in another mfile
make2DLOG(n, sigma);

%using fspecial for checking our results
h = fspecial('log',11 ,1);
figure;
surf(h)