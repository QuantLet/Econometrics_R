<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Nonlinear_Regression_Linear_vs_LOESS

Published in: Econometrics_R

Description: This R script compares a misspecified linear regression with a flexible nonparametric LOESS fit on data generated from a nonlinear relationship. It simulates 100 observations from the model y = sin(x) + ε over x ∈ [−3, 3], where ε is Gaussian noise with standard deviation 0.3, and stores the resulting (x, y) pairs in a data frame. A linear model y ~ x is fitted with lm(), and a local polynomial regression is fitted with loess(y ~ x, degree = 2). The script computes fitted values and residuals from both models and constructs three ggplot2 graphics: (i) a plot overlaying the observed data points with the linear and LOESS fitted curves, (ii) a scatter plot of the linear regression residuals versus x, and (iii) a scatter plot of the LOESS residuals versus x. These three plots are arranged side by side using ggpubr::ggarrange(), providing a visual comparison of how the parametric and nonparametric models capture the underlying nonlinear structure and how their residual patterns differ.

Keywords: Econometrics, Nonparametric Regression, LOESS, Linear Regression, Model Misspecification, Simulation, Residual Analysis, ggplot2, ggpubr, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
