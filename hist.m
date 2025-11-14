clc;
close all;
clear all;

Ir = imread("sample2.jpg");
if size(Ir, 3) == 3
  I = rgb2gray(Ir);
else
  I = Ir;
end

% double for processing
I = double(I);
bins = 256;

hist_counts = zeros(1, bins);

[rows, cols] = size(I);
for i=1:rows
  for j=1:cols
    val = I(i,j);
    hist_counts(val + 1) = hist_counts(val + 1) + 1;
  end
end

figure;
imshow(uint8(I));
title("Original Image");

figure;
bar(0:255, hist_counts);
title("Histogram");
xlabel("Values");
ylabel("Counts");
xlim([0 255]);
