<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_SCAD_IP_Forecast_NCVREG

Published in: Econometrics_R

Description: This R script demonstrates pseudo-out-of-sample forecasting of U.S. industrial production growth using nonconvex regularization and latest-vintage monthly FRED data through December 2024. It transforms industrial production, unemployment, CPI, and the federal funds rate and uses 12 lags of each series, excluding contemporaneous releases. Following a chronological training-test split, a custom expanding-window loop selects the SCAD and lasso penalties with past-only validation. The script reports selected variables and compares SCAD, lasso, and a historical-mean benchmark on the untouched test period. A real-time study would additionally require publication-date alignment and historical data vintages.

Keywords: Econometrics, Forecasting, SCAD, Lasso, Regularization, Industrial Production, Macroeconomic Data, FRED, ncvreg, High-dimensional Regression, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Monthly macroeconomic series retrieved via the FRED API

```
