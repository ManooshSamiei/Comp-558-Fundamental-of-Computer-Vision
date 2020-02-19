function g= make2DGaussian(N, sigma)
%N = 2*M + 1
M=(N-1)/2;
% create a grid matrix of x and y to plot the gaussian function based on them
%note that the value of steps is multiplied by sigma. This helps to reduce
%number of points in larger sigmas which generate more points, and thus
%keeping the balance 
[x,y] = meshgrid(-M-1:M+1);
exponent = ((x).^2 + (y).^2)./(2*sigma^2);%the exponential part of 2D gaussian function
amplitude = 1 / (sigma * sqrt(2*pi)); % the coefficient(amplitude) of gaussian function 
g = amplitude * exp(-exponent); %2D gaussian function definition based on exponential and amplitude parts
figure %opening a new figure
surf(x,y,g) % show g as a surface plot.
end                                       

