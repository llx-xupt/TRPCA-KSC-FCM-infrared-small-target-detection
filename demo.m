% Demo script for TRPCA-KSC-FCM
% Paper: Enhanced Infrared Small Target Detection via Tensor Decomposition and Kernelized Fuzzy Clustering
clc; clear; close all;
baseDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(baseDir, 'Utils')));
img_path = fullfile(baseDir, 'Data', 'test_1.png');

if ~exist(img_path, 'file')
    error('Error: Test image not found. Please check: %s', img_path);
end
img = imread(img_path);

params.nSeeds = 10;
params.maxIter = 50;

fprintf('Running TRPCA-KSC-FCM on %s...\n', 'test_1.png');

[final_binary, ~, ~, ~, final_saliency] = TRPCA_KSC_FCM(img, params);

figure('Name', 'TRPCA-KSC-FCM Demo', 'NumberTitle', 'off');
subplot(1, 3, 1); imshow(img); title('Original Image');
subplot(1, 3, 2); imshow(final_saliency, []); title('Saliency Map');
subplot(1, 3, 3); imshow(final_binary); title('Detection Result');

fprintf('Done.\n');