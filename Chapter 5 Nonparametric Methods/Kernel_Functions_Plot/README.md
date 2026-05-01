<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Kernel_Functions_Plot

Published in: Econometrics_R

Description: This R script defines and visualises several common kernel functions used in nonparametric statistics and kernel density estimation. It first specifies four kernels as R functions: the Uniform kernel, the Gaussian kernel (via dnorm), the Epanechnikov kernel, and the Quartic (biweight) kernel, each with support on [−1, 1] except for the Gaussian. A fine grid of x-values from −3 to 3 is constructed, and the corresponding kernel values are evaluated and stored in separate data frames, which are combined using dplyr::bind_rows() into a long-format dataset. Using ggplot2, the script plots all four kernels on the same axes as coloured line graphs, with a title and axis labels indicating the argument x and the kernel “density”. The resulting figure is saved as a 6 x 4 inch PNG file ("kernel-functions.png") at 300 dpi in the working directory.

Keywords: Econometrics, Nonparametric, Kernel Functions, Uniform Kernel, Gaussian Kernel, Epanechnikov Kernel, Quartic Kernel, Density Estimation, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%205%20Nonparametric%20Methods/Kernel_Functions_Plot/kernel-functions.png" alt="Image" />
</div>

