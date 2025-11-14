clc
clear all
close all

I_imported = imread("sample2.jpg");

if size(I_imported, 3) == 3
  I = rgb2gray(I_imported);
else
  I = I_imported;
end

figure;
imshow(I);
title("Original GS image");

figure;
imshow(I_imported);
title("Original Image");
