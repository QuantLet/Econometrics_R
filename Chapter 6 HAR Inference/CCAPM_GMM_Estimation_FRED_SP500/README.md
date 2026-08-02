<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: CCAPM_GMM_Estimation_FRED_SP500

Published in: Econometrics_R

Description: This R script estimates a consumption-based CAPM (C-CAPM) via Generalized Method of Moments (GMM) using macro-financial data from FRED and S&P 500 returns from Yahoo Finance. It downloads monthly real personal consumption expenditures (PCECC96) and the 3-month Treasury bill rate (TB3MS) from FRED via fredr, converts them to xts objects, and computes a monthly risk-free rate (annualised T-bill rate divided by 12). It then retrieves S&P 500 index data (^GSPC) with quantmod::getSymbols(), constructs monthly returns, converts all three indexes to a common year-month representation, and merges them into a nonempty monthly panel.

The script computes log consumption growth and the gross market return. Its Euler error is β R^g_t exp(−γ Δc_t) − 1, where β is the subjective discount factor, γ is the coefficient of relative risk aversion, and R^g_t is the gross S&P 500 return. The error is multiplied by a constant and by one-period-lagged consumption growth and market excess return, so the nonconstant instruments are predetermined. This yields three moment conditions for two parameters. Using the gmm package, the script estimates θ = (β, γ), prints the estimation output, and computes the J-statistic and its chi-squared p-value for the over-identifying restrictions.

Keywords: Econometrics, Asset Pricing, C-CAPM, GMM, Euler Equation, Over-Identifying Restrictions, J-Statistic, FRED, Real Consumption, Risk-Free Rate, S&P 500, Quantmod, gmm, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
