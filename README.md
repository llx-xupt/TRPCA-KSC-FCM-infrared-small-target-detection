# Enhanced Infrared Small Target Detection via TRPCA-KSC-FCM

This repository contains the MATLAB implementation for the infrared small target detection algorithm described in the paper: **"Enhanced Infrared Small Target Detection via Tensor Decomposition and Kernelized Fuzzy Clustering"**.

## Overview

The proposed method combines **Tensor Robust Principal Component Analysis (TRPCA)** and **Kernelized Fuzzy C-Means (KSC-FCM)** to achieve robust target detection in complex backgrounds. The algorithm effectively separates the sparse target from low-rank backgrounds and refines target boundaries through local kernel-based clustering.

## Main Features

* **TRPCA Separation**: Decomposes the image tensor into a low-rank background and a sparse target component using Fast Fourier Transform (FFT) optimization.
* **MDPC Seed Detection**: Automatically identifies potential target locations using Multidimensional Density Peak Clustering.
* **KSC-FCM Segmentation**: Performs precise local segmentation using a kernelized fuzzy clustering approach in a sliding window (default 11x11) around seeds.
* **Target Enhancement**: A fusion strategy to suppress residual clutter and enhance target saliency.

## Repository Structure

* `demo.m`: The main entry script to run a detection example.
* `Utils/`: Contains core algorithm modules including the TRPCA model and clustering utilities.
* `Data/`: Directory for input images (e.g., `test_1.png`).

## Getting Started

### Prerequisites
* MATLAB (R2018b or later recommended).
* Image Processing Toolbox.

### Execution
1.  Clone the repository.
2.  Open MATLAB and set the project folder as the current directory.
3.  Run the `demo.m` script. The script will automatically add the `Utils/` path and process the sample image.

## Key Parameters

You can adjust the following parameters in `TRPCA_KSC_FCM.m`:
* `lambda`: Penalty parameter for the sparse component (default: 0.85).
* `nSeeds`: Maximum number of candidate seeds for MDPC (default: 10).
* `patchSize`: Size of the image patches for tensor construction (default: 50).
* `kernelType`: Kernel function for KSC-FCM ('rbf', 'poly', or 'linear').

## License

This project is released under the MIT License.
