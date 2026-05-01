<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Subsampling_Block_Bootstrap_SP500_Returns

Published in: Econometrics_R

Description: This R script illustrates subsampling and block bootstrap methods for inference on moments of S&P 500 daily returns. It downloads S&P 500 index data (^GSPC) from Yahoo Finance, computes daily returns, and sets up a framework to analyze the sampling distributions of two statistics: the mean return and the lag-1 autocorrelation of squared returns. For subsampling, it uses a moving window of length b_sub = 5 years of daily data, computes subsample means and subsample lag-1 autocorrelations of squared returns within each window, and forms self-normalized statistics √b_sub (stat_sub − stat_full). Histograms of the resulting subsampling distributions are produced via ggplot2, with the full-sample root √T · stat_full indicated as a vertical red line.

Keywords: Econometrics, Time Series, Subsampling, Block Bootstrap, Moving Blocks, Mean Return, Autocorrelation of Squared Returns, S&P 500, Daily Returns, Quantmod, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%206%20HAR%20Inference/Subsampling_Block_Bootstrap_SP500_Returns/block-bootstrap-mean.png" alt="Image" />
</div>

