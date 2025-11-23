<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FTSE_Returns_Histogram_Density

Published in: Econometrics_R

Description: This R script downloads daily FTSE 100 index data from Yahoo Finance and visualises the distribution of daily log returns with a histogram and kernel density overlay. Using quantmod::getSymbols(), it retrieves FTSE prices from 2015 onwards, extracts closing prices, and computes daily log returns (scaled to percent) via dailyReturn(). The returns are converted into a data frame and plotted with ggplot2: a histogram of returns with binwidth 0.5 is constructed using aes(y = after_stat(density)) so that a smooth kernel density estimate can be overlaid on the same scale. The resulting plot, titled "Histogram & Kernel Density of FTSE 100 Daily Returns", includes appropriately labelled axes and is saved as a 6 x 4 inch PNG file ("ftse-returns-density.png") at 300 dpi in the working directory.

Keywords: Econometrics, Financial Econometrics, FTSE 100, Log Returns, Histogram, Kernel Density, Quantmod, ggplot2, Yahoo Finance, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%205%20Nonparametric%20Methods/FTSE_Returns_Histogram_Density/ftse-returns-density.png" alt="Image" />
</div>

