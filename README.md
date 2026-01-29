# Infrared Small Target Detection via Tensor Decomposition and Multiplicative Fuzzy Kernel Clustering

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18335917.svg)](https://doi.org/10.5281/zenodo.18335917)

## 📄 Paper Association
**Important Note**: This source code and dataset are the official implementation of the manuscript submitted to **Optics Communications**:

> **"Infrared Small Target Detection via Tensor Decomposition and Multiplicative Fuzzy Kernel Clustering"**

If you use this code, the **TRPCA-KSC-FCM** framework, or the provided dataset in your research, please cite the aforementioned manuscript.

## 🌟 Overview
This repository provides the MATLAB implementation of a robust coarse-to-fine infrared small target detection framework (TRPCA-KSC-FCM). It uniquely integrates **Tensor Robust Principal Component Analysis (TRPCA)** with a novel **Multiplicative Kernelized Spatially Constrained Fuzzy Clustering (KSC-FCM)** to address the "normalization trap" and "spatial weight cancellation effect" found in traditional methods.

### Key Technical Contributions:
* **Global Background Suppression (TRPCA)**: Utilizes Partial Sum of Tubal Nuclear Norm (PSTNN) combined with high-order Total Variation (TV) to effectively suppress complex background clutter while preserving target sparsity.
* **Spatial Attention Mechanism (DPC)**: Reinterprets Density Peak Clustering (DPC) as a spatial attention filter to rapidly identify high-confidence candidate regions and eliminate redundant computations.
* **Multiplicative Fuzzy Segmentation (KSC-FCM)**: Introduces a **Multiplicative Fuzzy Partition framework** with an additive spatial bias. This ensures precise target contour recovery and robust noise resistance in low-SNR scenarios.

### Performance Highlights:
Experiments on five public datasets and one simulated dataset demonstrate the method's superiority:
* **Signal-to-Clutter Ratio Gain (SCRG)**: > 47 dB
* **Background Suppression Factor (BSF)**: > 90 dB
* **Area Under the Curve (AUC)**: > 0.97

## 🛠 Prerequisites & Dependencies
* **Software**: MATLAB (Tested on R2024b, compatible with R2018b+).
* **Toolboxes**: Image Processing Toolbox.

## 🚀 Usage Guidelines
1.  **Clone the Repository**: Download or clone this project to your local machine.
2.  **Environment Setup**: Open MATLAB and set the project root directory as the current working directory.
3.  **Run Demo**: Execute the `demo.m` script. It will automatically add necessary paths and process sample images from the `Data/` folder.
4.  **Analyze Results**: The script will output:
    * Original Input Image
    * TRPCA Background/Target Separation Results
    * DPC Candidate Points
    * Final Binary Detection Result

## 📂 Repository Structure
* `demo.m`: Main entry point for replicating experimental results.
* `Utils/`: Core algorithm implementations (TRPCA optimization, DPC attention, Multiplicative KSC-FCM).
* `Data/`: Contains sample infrared images used for evaluation.

## 🔗 Citation
If you find this work useful, please cite our paper:

```bibtex
@article{wu2026infrared,
  title={Infrared Small Target Detection via Tensor Decomposition and Multiplicative Fuzzy Kernel Clustering},
  author={Wu, Chengmao and Liu, Longxin},
  journal={Optics Communications},
  year={2026},
  note={Under Review}
}
