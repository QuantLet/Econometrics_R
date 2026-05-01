<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: DCC_GARCH_ETFs_Cholesky_Shocks

Published in: Econometrics_R

Description: This R script estimates constant-correlation and DCC-GARCH models for a small equity ETF universe and illustrates Cholesky-based orthogonalisation of shocks. It downloads adjusted closing prices for SPY (S&P 500), QQQ (Nasdaq 100), and EFA (MSCI EAFE) from Yahoo Finance via quantmod::getSymbols(), constructs daily log returns (in percent), and demeans them to obtain innovations. Each return series is first fitted with a univariate sGARCH(1,1) model (with ARMA(0,0) mean and normal innovations) using rmgarch::ugarchspec(), multispec(), and multifit(). Time-varying conditional standard deviations and standardized residuals are extracted and used to construct a constant-correlation GARCH model: a time-invariant correlation matrix is estimated from the standardized residuals, and for each t the conditional covariance matrix is built as Σ_t = D_t R D_t, where D_t is the diagonal matrix of conditional standard deviations.

Keywords: Econometrics, Financial Econometrics, Multivariate GARCH, DCC-GARCH, Constant-Correlation GARCH, Covariance Matrix, Correlation Matrix, Cholesky Decomposition, Orthogonal Shocks, SPY, QQQ, EFA, rmgarch, Quantmod, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
