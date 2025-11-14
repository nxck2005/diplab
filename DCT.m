clc;
close all;
clear all;
%pkg load image;
% i -> double -> dct -> magnitude -> scale
I = imread("sample2.jpg");
if size(I, 3) == 3
  I = rgb2gray(I);
end

I_double = double(I);
F = dct2(I_double);
F_mag = log(1 + abs(F));
F_scaled = uint8(mat2gray(F_mag) * 255);

F_inv = idct2(F);
I_back = uint8(F_inv);

figure;
imshow(I);
title("Original");

figure;
imshow(F_scaled);
title("Freq");

figure;
imshow(I_back);
title("Reobtained");
