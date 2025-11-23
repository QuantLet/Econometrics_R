<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Gaussian_Kernel_Filter_Example

Published in: Econometrics_R

Description: This R script defines and demonstrates a simple Gaussian kernel smoother for a univariate time series. It implements a gaussian_kernel() function that constructs a symmetric, normalized weight vector of length n based on the normal density with standard deviation σ, ensuring the weights sum to one. Using a short numeric example series (e.g., 20, 22, 24, …), the script generates a 5-point Gaussian kernel with σ = 1 and applies it as a symmetric linear filter via stats::filter() with sides = 2. The resulting smoothed series (Gaussian-filtered data) is printed to the console, illustrating how Gaussian kernels can be used to smooth noisy observations while giving more weight to nearby points.

Keywords: Time Series, Gaussian Kernel, Kernel Smoothing, Linear Filter, Signal Smoothing, Moving Average, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
