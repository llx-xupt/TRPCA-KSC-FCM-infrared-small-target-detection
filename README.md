# Enhanced Infrared Small Target Detection via Tensor Decomposition and Kernelized Fuzzy Clustering

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18335917.svg)](https://doi.org/10.5281/zenodo.18335917)

## 📄 Paper Association
**Important Note**: This source code and dataset are directly associated with the manuscript submitted to **The Visual Computer**:
> **"Enhanced Infrared Small Target Detection via Tensor Decomposition and Kernelized Fuzzy Clustering"**

If you use this code, the TRPCA-KSC-FCM framework, or the provided dataset in your research, please cite the aforementioned manuscript.

## 🌟 Overview
This repository provides the official MATLAB implementation of a robust infrared small target detection framework. It integrates **Tensor Robust Principal Component Analysis (TRPCA)** with **Kernelized Spatially Constrained Fuzzy Clustering (KSC-FCM)** to address challenges in complex infrared scenarios.

### Key Technical Components:
* **TRPCA Model**: Combines Partial Sum of Tubal Nuclear Norm (PSTNN) and high-order Total Variation (TV) for effective background suppression.
* **MDPC Detection**: Rapidly locates high-confidence candidate target regions using Multidimensional Density Peak Clustering.
* **KSC-FCM Segmentation**: Enhances target contour precision by addressing non-linear separability through kernelized clustering.
* **Target Enhancement Fusion**: A strategic fusion of original and sparse components to maximize target saliency.

## 🛠 Prerequisites & Dependencies
* **Software**: MATLAB (Tested on R2018b or later).
* **Toolboxes**: Image Processing Toolbox.

## 🚀 Usage Guidelines
1.  **Clone the Repository**: Download or clone this project to your local machine.
2.  **Environment Setup**: Open MATLAB and set the project root directory as the current working directory.
3.  **Run Demo**: Execute the `demo.m` script. It will automatically add necessary paths and process the sample image `test_1.png`.
4.  **Analyze Results**: The script will output the original image, the generated saliency map, and the final binary detection result.

## 📂 Repository Structure
* `demo.m`: Main entry point for replicating experimental results.
* `Utils/`: Core algorithm implementations (TRPCA, KSC-FCM, MDPC).
* `Data/`: Contains the sample infrared dataset used for evaluation.

## 🔗 Citation
Please cite this work using the following format (BibTeX):

```bibtex
@article{wu2026enhanced,
  title={Enhanced Infrared Small Target Detection via Tensor Decomposition and Kernelized Fuzzy Clustering},
  author={Wu, Chengmao and Liu, Longxin},
  journal={The Visual Computer},
  year={2026},
  note={DOI: 10.5281/zenodo.18335917}
}
