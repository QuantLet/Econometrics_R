<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: ARCH_Tests_GDP_IndProduction_WDI_FRED

Published in: Econometrics_R

Description: This R script implements LM and McLeod–Li tests for conditional heteroskedasticity (ARCH effects) in macroeconomic time series using World Bank (WDI) and FRED data. First, it retrieves annual U.S. real GDP growth (NY.GDP.MKTP.KD.ZG) from the World Bank via WDI, orders and cleans the series, and fits an AR(1) mean model. Using the squared residuals from this model, it computes an Engle LM test statistic by regressing the squared residuals on their own lags, and calculates a McLeod–Li test statistic based on the sample autocorrelations of the demeaned squared residuals up to p = 4 lags, reporting both statistics along with the chi-squared reference distribution.

Second, the script downloads the monthly U.S. Industrial Production Index (INDPRO) from FRED via quantmod: :getSymbols(), computes monthly log growth rates (in percent), and fits an AR(1) mean model to the IP growth series. It then repeats the same LM and McLeod–Li procedures on the squared residuals, this time using p = 12 lags (one year of monthly data), and prints the resulting LM(p) and ML(p) statistics together with their asymptotic chi-squared references. This provides a practical illustration of volatility diagnostics for annual and high-frequency macroeconomic series.

Keywords: Econometrics, Time Series, ARCH, Conditional Heteroskedasticity, Engle LM Test, McLeod–Li Test, GDP Growth, Industrial Production, WDI, FRED, Quantmod, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
