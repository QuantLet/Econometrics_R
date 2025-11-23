<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: DAX_LRV_NeweyWest_Bartlett

Published in: Econometrics_R

Description: This R script estimates the long-run variance (LRV) of DAX index returns using both a univariate Newey–West estimator and a general multivariate Bartlett–kernel fixed-b estimator. It first downloads daily DAX (^GDAXI) data from Yahoo Finance via quantmod::getSymbols() for 2024, extracts closing prices, and computes daily log returns. The univariate LRV is obtained with sandwich::lrvar() using type = "Newey-West", scaled by the sample size to reflect the long-run variance of the partial-sum process. The script then defines a function computeLRVCovMatrix() that, for any univariate or multivariate series y and a chosen fixed-b bandwidth, constructs an LRV covariance matrix using the Bartlett kernel. The function demeans the data, computes the lag-0 covariance, and adds a weighted sum of positive and negative lag autocovariances up to m = floor(b · n), where the weight at lag j is 1 − j/(m + 1). This provides a reusable tool for estimating long-run covariance matrices in time-series applications, including multivariate settings.

Keywords: Econometrics, Time Series, Long-Run Variance, Newey–West, Bartlett Kernel, Fixed-b, DAX, Log Returns, Quantmod, Sandwich, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
