<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: AR1_Bootstrap_Root_Distribution

Published in: Econometrics_R

Description: This R script illustrates residual bootstrap inference for the autoregressive parameter in an AR(1) model. It first simulates a length-200 AR(1) process y_t = φ y_{t−1} + ε_t with true φ = 0.6 and Gaussian white-noise innovations of standard deviation 1, then estimates φ̂ by OLS regression of y_t on y_{t−1}. Using the fitted model, it computes and recenters the residuals, which serve as the basis for a residual bootstrap. Across 1,000 bootstrap replications, it resamples centered residuals with replacement, generates bootstrap series under the estimated AR(1) with φ̂, re-estimates φ* for each bootstrap sample, and constructs the bootstrap root R_T* = √T (φ* − φ̂). The script reports summary statistics for the bootstrap distribution of R_T* (mean, standard deviation, and 2.5% / 97.5% quantiles) and uses ggplot2 to plot a histogram of R_T* with vertical dashed lines at the empirical 2.5% and 97.5% quantiles. The resulting figure is saved as a 6 x 4 inch PNG file ("bootstrap-root-dist.png") at 300 dpi.

Keywords: Econometrics, Time Series, AR(1), Residual Bootstrap, Bootstrap Distribution, Root Statistic, Monte Carlo, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%206%20HAR%20Inference/AR1_Bootstrap_Root_Distribution/bootstrap-root-dist.png" alt="Image" />
</div>

