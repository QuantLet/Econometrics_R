<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: EWMA_Covariance_ETFs

Published in: Econometrics_R

Description: This R script computes exponentially weighted moving average (EWMA) covariance and correlation matrices for a small set of liquid ETFs. It downloads daily prices for SPY (S&P 500), QQQ (Nasdaq 100), and EFA (MSCI EAFE) from Yahoo Finance via quantmod::getSymbols(), extracts adjusted closing prices, and constructs daily log returns (in percent). The returns are demeaned asset-by-asset to form an innovations matrix ε_t, which is then used to recursively update a time-varying covariance matrix Σ_t using the EWMA scheme Σ_t = λ Σ_{t−1} + (1 − λ) ε_{t−1} ε_{t−1}′ with decay factor λ = 0.94 and an initial Σ_1 taken as the sample covariance of ε. The script stores all Σ_t in a list, extracts the most recent covariance matrix Σ_T, and computes the corresponding EWMA correlation matrix R_T by standardizing with the diagonal of Σ_T. These objects (Σ_T and R_T) can be used, for example, in risk management, portfolio allocation, or as inputs to multivariate volatility models.

Keywords: Econometrics, Financial Econometrics, EWMA, Covariance Matrix, Correlation Matrix, Volatility, Risk Management, SPY, QQQ, EFA, Quantmod, Yahoo Finance, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
