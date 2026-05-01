<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_EMH_Tests_Random_Walk_2000_2024_Recent2024

Published in: Econometrics_R

Description: This R script conducts a suite of weak-form EMH diagnostics for SPY daily log returns over a long historical sample (2000–2024) and a very recent subsample starting in 2024. It downloads SPY prices from Yahoo Finance using quantmod::getSymbols(), constructs log prices and daily log returns, and defines (i) a full-sample return series and (ii) a recent subsample from 2024 onward. The script first visualises both series with ggplot2. It then examines serial correlation via forecast::Acf() plots, Ljung–Box tests at lag 20, and robust automatic portmanteau tests (Auto.Q) that remain valid under conditional heteroskedasticity.

To assess linear predictability, the script fits AR(5) models of returns on their own lags in both samples and applies heteroskedasticity-robust Wald tests (lmtest: :waldtest with sandwich::vcovHC) of the joint null that all lag coefficients are zero. For random-walk behaviour at multi-day horizons, it computes classical variance ratio statistics using vrtest::VR.minus.1 for holding periods k = 2, 5, 10, 20, derives asymptotic Z-statistics and two-sided p-values, and organises the results in data frames for the full and recent samples. Finally, it reports automatic variance ratio statistics (Auto.VR) that are robust to conditional heteroskedasticity, with commented code showing how to implement wild bootstrap refinements via AutoBoot.test(). Together, these tools provide a comprehensive empirical check of random-walk behaviour and weak-form efficiency for SPY at the daily frequency.

Keywords: Econometrics, Time Series, Weak-Form EMH, Random Walk, SPY, Log Returns, ACF, Ljung–Box Test, Auto.Q, AR(5), Wald Test, Variance Ratio, VR.minus.1, Auto.VR, Quantmod, ggplot2, Forecast, lmtest, Sandwich, vrtest, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
