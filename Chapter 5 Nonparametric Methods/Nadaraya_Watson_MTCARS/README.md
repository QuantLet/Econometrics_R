<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Nadaraya_Watson_MTCARS

Published in: Econometrics_R

Description: This R script applies Nadaraya–Watson kernel regression to explore the nonlinear relationship between horsepower and fuel efficiency in the built-in mtcars dataset. It extracts horsepower (hp) as the regressor and miles per gallon (mpg) as the response, selects an optimal bandwidth using KernSmooth::dpill(), and then estimates the regression function with locpoly() using a normal kernel, degree = 0 (Nadaraya–Watson), and a grid of 100 points. The fitted values are interpolated onto a fine grid over the range of horsepower and combined into a data frame for plotting. Using ggplot2, the script produces a scatter plot of the original (hp, mpg) observations with the estimated Nadaraya–Watson regression curve overlaid in blue. The resulting figure is saved as a 6 x 4 inch PNG file ("Nadaraya_Watson_Estimation.png") at 300 dpi.

Keywords: Econometrics, Nonparametric Regression, Nadaraya–Watson, Kernel Smoother, Bandwidth Selection, dpill, locpoly, Kernel Regression, mtcars, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%205%20Nonparametric%20Methods/Nadaraya_Watson_MTCARS/Nadaraya_Watson_Estimation.png" alt="Image" />
</div>

