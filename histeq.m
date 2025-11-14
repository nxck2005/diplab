clc;
clear all;
close all;

I = imread("Lenne.jpg");
if size(I, 3) == 3
  I = rgb2gray(I);
end
L = 256;
hist_counts = zeros(1, L);

[rows, cols] = size(I);
for i=1:rows
  for j=1:cols
    val = I(i,j);
    hist_counts(val + 1) = hist_counts(val + 1) + 1;
  end
end

total = numel(I);
pdf = hist_counts / total;
cdf = cumsum(pdf);
map = round(cdf * (L - 1));
ie = zeros(rows, cols, 'uint8');

for r=1:rows
  for c=1:cols
    val = I(r,c);
    newval = map(val + 1);
    ie(r,c) = newval;
  end
end

histeqcounts = zeros(1, L);
for r=1:rows
  for c=1:cols
    val = ie(r,c);
    histeqcounts(val + 1) = histeqcounts(val + 1) + 1;
  end
end
figure;
imshow(I);
title("Original");

figure;
imshow(ie);
title("Equalised");

figure;
bar(0:255, hist_counts);
title("Original Histogram");
xlabel("Intensities");
ylabel("Counts");
xlim([0 255]);

figure;
bar(0:255, histeqcounts);
title("Eq. Histogram");
xlabel("Intensities");
ylabel("Counts");
xlim([0 255]);
