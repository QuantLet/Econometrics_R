<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Unit_Root_Tests_Full_vs_Recent

Published in: Econometrics_R

Description: This R script performs and compares unit root and stationarity tests on SPY log prices and log returns over a long historical sample and a more recent subsample. It downloads daily SPY prices from Yahoo Finance via quantmod::getSymbols() starting in 2000, constructs a data frame with dates, adjusted closing prices, log prices, and log returns, and then partitions the data into a full sample and a recent sample beginning in 2024. A helper function run_unit_root_tests() is defined to run Augmented Dickey–Fuller (ADF) tests using urca::ur.df() and KPSS tests using urca::ur.kpss(), printing concise summaries of test statistics and critical values.

Keywords: Econometrics, Time Series, Unit Root, Stationarity, Augmented Dickey–Fuller, ADF, KPSS, SPY, Log Prices, Log Returns, Quantmod, urca, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
