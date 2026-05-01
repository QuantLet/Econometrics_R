<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Spectral_Kernels_Time_vs_Frequency

Published in: Econometrics_R

Description: This R script visualises several standard spectral window kernels alongside their Fourier transforms, illustrating the duality between time-domain and frequency-domain representations. It defines five kernel functions k(x) in the time domain—Truncated, Bartlett, Daniell, Parzen, and Quadratic Spectral (QS)—and their corresponding analytical Fourier transforms K(u). Using finely spaced grids for x (time domain) and u (frequency domain), the script evaluates each kernel and its transform, constructs separate ggplot2 line plots for k(x) and K(u), and arranges them side-by-side for each kernel via gridExtra::grid.arrange(). Finally, it stacks all kernel panels vertically into a combined multi-panel figure. This provides a compact visual comparison of the shape and smoothness of different window functions and the implied trade-off between localization in time and frequency in spectral analysis.

Keywords: Econometrics, Time Series, Spectral Analysis, Kernel, Spectral Window, Truncated Kernel, Bartlett Kernel, Daniell Kernel, Parzen Kernel, Quadratic Spectral Kernel, Fourier Transform, ggplot2, gridExtra, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
