<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FTSE_DAX_Multivariate_KDE

Published in: Econometrics_R

Description: This R script performs and visualises a bivariate kernel density estimation for joint daily returns of the FTSE 100 and DAX indices. It downloads recent FTSE (^FTSE) and DAX (^GDAXI) prices from Yahoo Finance using quantmod::getSymbols(), extracts closing prices, and computes daily log returns in percent via dailyReturn(). The two return series are merged by date into a clean data frame of matched observations, from which a 2-column matrix of FTSE and DAX returns is constructed. Using the ks package, the script applies kde() to estimate the joint probability density of the bivariate return vector. The resulting multivariate kernel density estimate is visualised in two ways: (i) a 2D filled contour plot showing the joint density levels, and (ii) a 3D perspective plot illustrating the shape of the estimated surface. These plots provide an intuitive view of the dependence structure and joint distribution of FTSE and DAX daily returns over the sample period.

Keywords: Econometrics, Financial Econometrics, FTSE 100, DAX, Multivariate Kernel Density, KDE, Joint Distribution, Quantmod, ks, Yahoo Finance, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
