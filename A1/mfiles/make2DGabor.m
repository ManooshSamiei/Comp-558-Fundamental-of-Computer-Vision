function [even, odd] = make2DGabor(N, lambda, angle)
%angle is in radian
%lambda is wavelength
sigma=lambda;
freq=1/lambda;
%N = 2*M + 1
M=(N-1)/2;
% create a grid matrix of x and y to plot the gaussian function based on them 
%[x,y] = meshgrid(-M:0.1:M); %%for plotting use this grid
[x,y] = meshgrid(-M:M); %%for filtering use this grid
% Rotation 
x_prime=x*cos(angle)+y*sin(angle);
y_prime=-x*sin(angle)+y*cos(angle);
even=exp(-.5*((x_prime.^2+y_prime.^2)/sigma^2)).*cos(2*pi*freq*x_prime);
odd=exp(-.5*((x_prime.^2+y_prime.^2)/sigma^2)).*sin(2*pi*freq*x_prime);
%we can also plot the gaussian and sinusodial components seperately
%for the sinusoidal we should also separate the imaginary and real parts
gaussian=exp(-.5*((x_prime.^2+y_prime.^2)/sigma^2));%gaussian part
sinusoidal=exp(1i*(2*pi*freq*x_prime)); %sinosodial part
sinusoidal_real=cos(2*pi*freq*x_prime);
sinusoidal_imaginary=sin(2*pi*freq*x_prime);
%figure %opening a new figure
%surf(x,y,even)
%figure %opening a new figure
%surf(x,y,odd)
% uncomment below codes to plot gaussian & sinusodial components separately
% figure %opening a new figure
% surf(x,y,gaussian) % show g as a surface plot.
% figure %opening a new figure
% surf(x,y,sinusoidal_real)
% figure %opening a new figure
% surf(x,y,sinusoidal_imaginary)
end