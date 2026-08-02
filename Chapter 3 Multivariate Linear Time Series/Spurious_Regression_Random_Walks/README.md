<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Spurious_Regression_Random_Walks

Published in: Econometrics_R

Description: This R script demonstrates spurious regression arising from regressing one non-stationary random walk on another. It simulates two independent length-100 random walks by cumulatively summing independent standard normal innovations and then runs an OLS regression of RW1 on RW2 using lm(). The regression summary is printed to the console, typically showing seemingly significant coefficients and high R² despite the underlying series being independent. To visualise the spurious relationship, the script constructs a scatter plot of RW1 against RW2 with a fitted OLS line overlaid via ggplot2, and saves the resulting figure as a 6 x 4 inch PNG file ("rw1-rw2.png") at 300 dpi.

Keywords: Econometrics, Time Series, Spurious Regression, Random Walk, Non-stationarity, OLS, Simulation, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
