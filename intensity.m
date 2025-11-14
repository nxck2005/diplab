clc;
clear all;
close all;

I = imread("sample2.jpg");
if size(I,3) == 3
  I = rgb2gray(I);
end
L = 256;
% pointwise operations
I_inv = 255 - I;
t = 100;
I_thresh = I > t;
I_sliced = (I >= t) & (I <= 200);
% log = c * log(1+r)
cmax = max(max(double(I)));
clog = (L - 1) / log2(1 + cmax); % or use 255
I_log = log2(double(I) + 1);
I_log = uint8(255 * mat2gray(I_log));
% gamma = c * r ^ gamma; <1 = brighten and v.v.
gam = 1.3;
cgam = 1;
I_gam = im2uint8(cgam * (im2double(I) .^ gam));
% stretching
low_in = 50;
low_out = 0;
high_in = 100;
high_out = 255;
I_piece = zeros(size(I), 'uint8');
I_piece(I < low_in) = low_out;
I_piece(I > high_in) = high_out;
I_piece(I >= low_in & I <= high_in) = round(low_out + (high_out - low_out) * (I(I >= low_in & I <= high_in) - low_in) / (high_in - low_in));
% or
% imadjust(Image, [low_in high_in], [low_out high_out])
% NOTE: imadjust expects the ranges as percentages (0.0 to 1.0)
I_piecewise = imadjust(I, [0.196 0.784], [0 1]);

I_thresh = im2uint8(I_thresh);
I_sliced = im2uint8(I_sliced);

%montage(I, I_inv, I_thresh, I_sliced, I_log, I_gam);
figure;
imshow(I);
title("Original");

figure;
imshow(I_inv);
title("Inverse");

figure;
imshow(I_thresh);
title("Thresholding");

figure;
imshow(I_sliced);
title("Sliced");

figure;
imshow(I_log);
title("Log");

figure;
imshow(I_gam);
title("Gamma");

figure;
imshow(I_piece);
title("Contrast Stretching");

figure;
imhist(I);
title("Original Histogram");

figure;
imhist(I_piece);
title("Contrast stretched hist");
