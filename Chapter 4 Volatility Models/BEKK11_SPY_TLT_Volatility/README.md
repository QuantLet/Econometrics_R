<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: BEKK11_SPY_TLT_Volatility

Published in: Econometrics_R

Description: This R script estimates a symmetric BEKK(1,1) multivariate volatility model for a bivariate system of daily stock and bond ETF returns. It downloads adjusted closing prices for SPY (S&P 500 ETF) and TLT (long-term U.S. Treasury ETF) from Yahoo Finance via quantmod::getSymbols() starting in 2015, constructs daily log returns (scaled by 100), and demeans each return series so that they resemble mean-zero innovations. Using the BEKKs package, the script specifies a default symmetric BEKK(1,1) model with bekk_spec(), fits it to the bivariate residual series via bekk_fit() with quasi-maximum likelihood (QML) and convergence controls, and then reports the estimated parameters and diagnostics using base::summary() to avoid masking. The fitted BEKK model captures time-varying variances and covariances between equity and bond returns, illustrating a standard tool for modeling multivariate financial volatility.

Keywords: Econometrics, Financial Econometrics, Multivariate GARCH, BEKK(1,1), Volatility, Covariance Dynamics, SPY, TLT, Quantmod, BEKKs, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
