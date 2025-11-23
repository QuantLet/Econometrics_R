<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Unit_Root_Prices_Returns_2000_2024

Published in: Econometrics_R

Description: This R script applies standard unit root and stationarity tests to SPY log prices and log returns over a long historical sample and a very recent subsample. It downloads daily SPY data from Yahoo Finance via quantmod::getSymbols() from 2000-01-01 to 2024-12-31, constructs log prices and log returns, and then defines a full-sample series together with a recent subsample beginning in 2024. A helper function run_unit_root_tests() wraps urca::ur.df() for Augmented Dickey–Fuller (ADF) tests and urca::ur.kpss() for KPSS tests. For log prices, the script runs ADF tests with drift and both level- and trend-stationary KPSS tests, reflecting the common view that prices are close to I(1). For log returns, it runs ADF tests without drift and KPSS tests for level stationarity only, reflecting the usual assumption that returns are closer to I(0). The console output summarizes test statistics, critical values, and sample sizes for each series and window, allowing a concise comparison of unit root behaviour in prices versus returns and in the full versus recent sample.

Keywords: Econometrics, Time Series, Unit Root, Stationarity, Augmented Dickey–Fuller, ADF, KPSS, SPY, Log Prices, Log Returns, Quantmod, urca, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
