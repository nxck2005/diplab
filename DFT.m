clc;
close all;
clear all;
% i -> double -> fft -> shift -> magnitude -> scale
I = imread("sample2.jpg");
if size(I, 3) == 3
  I = rgb2gray(I);
end

I_double = double(I);
F = fft2(I_double);
F_shifted = fftshift(F);
F_mag = log(1 + abs(F_shifted));
F_scaled = uint8(mat2gray(F_mag) * 255);

F_back = ifftshift(F_shifted);
F_inv = real(ifft2(F_back));
I_inv = uint8(F_inv);

figure;
imshow(I);
title("Original");

figure;
imshow(F_scaled);
title("Frequency domain");

figure;
imshow(I_inv);
title("Reobtained");
