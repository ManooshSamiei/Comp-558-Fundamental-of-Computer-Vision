function g = make2DLOG(N, sigma)
%N = 2*M + 1
M=(N-1)/2; %M is mu (expected value) or center of gaussian function for both x and y axis
%[x,y] = meshgrid(-M:0.1:M) %% this one is used for plotting
[x,y] = meshgrid(-M:M); %% this one is used for filtering
exponent = ((x).^2 + (y).^2)./(2*sigma^2);%the exponential part of 2D gaussian function
amplitude = 1 / (sigma * sqrt(2*pi)); % the coefficient(amplitude) of gaussian function 
g = del2(amplitude * exp(-exponent));
figure %opening a new figure
surf(x,y,g) % show g as a surface plot.
end                                       
