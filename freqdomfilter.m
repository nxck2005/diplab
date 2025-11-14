clc;
clear all;
close all;

I = imread("sample2.jpg");
if size(I, 3) == 3
  I = rgb2gray(I);
end

Id = double(I);
F = fft2(Id);
Fs = fftshift(F);

[m, n] = size(I);
u = 0:m-1;
v = 0:n-1;

u = u - floor(m/2);
v = v - floor(n/2);

[U, V] = meshgrid(v,u);
D = sqrt(U.^2 + V.^2);

% make filter, D0 = 10
H = double(D <= 50);
G = Fs .* H;

G_img = uint8(real(ifft2(ifftshift(G))));

figure;
imshow(G_img);
