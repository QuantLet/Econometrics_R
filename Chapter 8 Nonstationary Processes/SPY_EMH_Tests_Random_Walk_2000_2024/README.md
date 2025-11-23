<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_EMH_Tests_Random_Walk_2000_2024

Published in: Econometrics_R

Description: This R script implements a battery of weak-form EMH diagnostics for SPY daily log returns over 2000–2024 and a recent subsample starting on Jan 1st, 2024. It downloads SPY prices from Yahoo Finance using quantmod::getSymbols(), constructs log prices and log returns, and defines a full-sample and recent subsample return series. After plotting the two return series with ggplot2, it examines serial correlation using ACF plots and Ljung–Box tests at lag 20. Robust automatic portmanteau tests (Auto.Q) are computed to assess joint linear dependence while remaining valid under conditional heteroskedasticity.

To test for linear predictability, the script fits AR(5) regressions of returns on their own lags for both samples and performs heteroskedasticity-robust Wald tests (via lmtest: :waldtest with sandwich::vcovHC) of the joint null that all lag coefficients are zero. It then performs variance ratio analysis with vrtest::VR.minus.1 for holding periods k = 2, 5, 10, 20, computing VR(k) − 1, asymptotic Z-statistics, and \(p\)-values to detect mean reversion or momentum relative to a random-walk benchmark. Finally, it reports automatic variance ratio statistics (Auto.VR) that are robust to conditional heteroskedasticity, and outlines how to optionally run wild-bootstrap versions for finite-sample refinements. The combined evidence provides a comprehensive empirical check of the random-walk / i.i.d.\ assumptions underlying the strong form of the weak-form EMH for SPY.

Keywords: Econometrics, Time Series, Weak-Form EMH, Random Walk, SPY, Log Returns, ACF, Ljung–Box Test, Auto.Q, AR(5), Wald Test, Variance Ratio, VR.minus.1, Auto.VR, Quantmod, ggplot2, Forecast, lmtest, Sandwich, vrtest, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
