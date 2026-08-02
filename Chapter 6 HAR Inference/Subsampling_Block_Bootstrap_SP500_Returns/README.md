<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Subsampling_Block_Bootstrap_SP500_Returns

Published in: Econometrics_R

Description: This R script illustrates subsampling and block bootstrap methods for inference on moments of S&P 500 daily returns. It downloads S&P 500 index data (^GSPC) from Yahoo Finance, computes daily returns, and analyzes two statistics: the mean return and the lag-1 autocorrelation of squared returns. For subsampling, it uses all T − b_sub + 1 overlapping windows of length b_sub, computes the statistic within each window, and forms the centered root √b_sub (stat_sub − stat_full). For the moving-block bootstrap, it draws enough blocks and truncates the concatenated series to exactly T observations, keeping the bootstrap root and sample length consistent. Histograms are produced with ggplot2, with the full-sample root √T · stat_full indicated as a vertical red line.

Keywords: Econometrics, Time Series, Subsampling, Block Bootstrap, Moving Blocks, Mean Return, Autocorrelation of Squared Returns, S&P 500, Daily Returns, Quantmod, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%206%20HAR%20Inference/Subsampling_Block_Bootstrap_SP500_Returns/block-bootstrap-mean.png" alt="Image" />
</div>
