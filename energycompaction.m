clc; close all; clear all;

I = imread("sample2.jpg");

if size(I,3) == 3
    I = rgb2gray(I);
end

I = double(I);

% --------------------
% 1. Compute DCT
% --------------------
F = dct2(I);

% --------------------
% 2. Compute energy of each coefficient
% --------------------
E = abs(F).^2;

% Sort energy in descending order
[sortedE, idx] = sort(E(:), "descend");

% --------------------
% 3. Set how much energy to preserve
% --------------------
preserve = 0.20;    % 20% energy (change to 0.10, 0.50, etc.)

total_energy = sum(sortedE);
target_energy = preserve * total_energy;

% Find how many coefficients we need to reach target energy
cumE = cumsum(sortedE);
k = find(cumE >= target_energy, 1);

% --------------------
% 4. Make a mask that keeps only the top-k coefficients
% --------------------
mask = zeros(size(F));
mask(idx(1:k)) = 1;

% Apply mask
F_kept = F .* mask;

% --------------------
% 5. Reconstruct image with inverse DCT
% --------------------
I_recon = idct2(F_kept);

I_recon = uint8(I_recon);

% --------------------
% 6. Show results
% --------------------
figure; imshow(uint8(I)); title("Original");
figure; imshow(log(1+abs(F)), []); title("DCT Magnitude");
figure; imshow(mask, []); title("Mask of Kept Coefficients");
figure; imshow(I_recon); title(sprintf("Reconstructed (%.0f%% energy)", preserve*100));

