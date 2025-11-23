<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Consumption_Income_Cointegration_VECM

Published in: Econometrics_R

Description: This R script conducts a full cointegration and error-correction analysis of US real consumption and real disposable income using FRED data. It first retrieves monthly real personal consumption expenditures (PCEC96) and real disposable personal income (DSPIC96) from FRED via fredr, starting in 1960, merges the series, and takes natural logarithms of both variables after cleaning missing values. The log levels of real consumption and income are plotted with ggplot2 and saved as "log-consumption-income.png". The script then constructs a bivariate monthly time series object and applies augmented Dickey–Fuller (ADF) unit-root tests using ur.df() to assess whether each series is I(1) in levels and I(0) in first differences. An Engle–Granger residual-based cointegration test is implemented by regressing log consumption on log income, extracting residuals, and applying an ADF test on the residuals; a Phillips–Ouliaris cointegration test is also performed via ca.po(). Next, a VAR lag order is selected in levels using VARselect() with up to 12 lags. Johansen trace and maximum eigenvalue tests are run using ca.jo() (with deterministic trend and transitory specification), and—assuming rank r = 1—a VECM is estimated via cajorls(). The script reports the error-correction dynamics and extracts the estimated cointegrating vector, normalising it on log consumption, and prints the implied long-run relation between log consumption and log disposable income.

Keywords: Econometrics, Time Series, Cointegration, Engle–Granger, Phillips–Ouliaris, Johansen, VECM, ADF Test, VAR, FRED, Real Consumption, Real Disposable Income, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%203%20Multivariate%20LInear%20Time%20Series/Consumption_Income_Cointegration_VECM/log-consumption-income.png" alt="Image" />
</div>

