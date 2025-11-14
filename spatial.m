clear; close all; clc;

% -----------------------------
% Load an image (grayscale)
% -----------------------------
I = im2double(rgb2gray(imread('sample.jpg')));

figure; imshow(I); title('Original Image');

%% ============================================================
% 1) SPATIAL DOMAIN SMOOTHING FILTERS
% ============================================================

% ---- Mean filter 5x5 ----
mean_kernel = fspecial('average', [5 5]);
I_mean = imfilter(I, mean_kernel, 'replicate');

% ---- Gaussian smoothing filter ----
gauss_kernel = fspecial('gaussian', [5 5], 1);
I_gauss = imfilter(I, gauss_kernel, 'replicate');

% ---- Box filter (same as average but uniform weight) ----
box_kernel = ones(5,5) / 25;
I_box = imfilter(I, box_kernel, 'replicate');

figure;
subplot(1,3,1); imshow(I_mean); title('Mean Filter');
subplot(1,3,2); imshow(I_gauss); title('Gaussian Filter');
subplot(1,3,3); imshow(I_box); title('Box Filter');


%% ============================================================
% 2) SPATIAL DOMAIN SHARPENING FILTERS
% ============================================================

% ---- Laplacian filter ----
lap_kernel = fspecial('laplacian', 0.2);
I_lap = imfilter(I, lap_kernel, 'replicate');

% ---- Unsharp masking ----
I_blur = imgaussfilt(I, 2);
I_unsharp = I + (I - I_blur);   % sharpened

% ---- High-boost filtering ----
A = 1.5;  % boost factor
I_highboost = A*I - I_blur;

figure;
subplot(1,3,1); imshow(I_lap, []); title('Laplacian Sharpened');
subplot(1,3,2); imshow(I_unsharp); title('Unsharp Masking');
subplot(1,3,3); imshow(I_highboost); title('High-Boost Filtering');


%% ============================================================
% 3) IMAGE DENOISING USING MEDIAN FILTER
% ============================================================

% Add salt & pepper noise
I_noise_sp = imnoise(I, 'salt & pepper', 0.05);

% Apply 3x3 median filter
I_med = medfilt2(I_noise_sp, [3 3]);

figure;
subplot(1,3,1); imshow(I); title('Original');
subplot(1,3,2); imshow(I_noise_sp); title('S&P Noise');
subplot(1,3,3); imshow(I_med); title('Median Filter');


%% ============================================================
% 4) ALPHA-TRIMMED MEAN FILTER
% ============================================================

% Custom function at the bottom
alpha = 4;   % remove 4 extreme values (2 low + 2 high)
window = 5;  % 5x5 window

I_alpha = alpha_trimmed_mean(I_noise_sp, window, alpha);

figure;
subplot(1,2,1); imshow(I_noise_sp); title('Noisy Image');
subplot(1,2,2); imshow(I_alpha); title('Alpha-Trimmed Mean Filter');


%% ==========================
% FUNCTION: Alpha trim filter
%% ==========================
function out = alpha_trimmed_mean(I, w, alpha)

    [rows, cols] = size(I);
    pad = floor(w/2);
    Ipad = padarray(I, [pad pad], 'replicate');

    out = zeros(size(I));

    for r = 1:rows
        for c = 1:cols
            block = Ipad(r:r+w-1, c:c+w-1);
            vec = sort(block(:));
            trim = floor(alpha/2);

            vec = vec(trim+1 : end-trim);  % drop low and high values
            out(r,c) = mean(vec);
        end
    end
end

