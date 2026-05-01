<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_SCAD_IP_Forecast_NCVREG

Published in: Econometrics_R

Description: This R script demonstrates how to forecast U.S. industrial production growth using high-dimensional lagged macroeconomic predictors and nonconvex regularization. It downloads monthly time series from the FRED API (industrial production, unemployment rate, CPI, and the federal funds rate), constructs transformed series (industrial production growth, inflation, and first differences of unemployment and the policy rate), and builds a feature set comprising 12 lags of each variable. The sample is split into training and test periods. A SCAD-penalised linear regression is then fitted using cv.ncvreg (family = "gaussian", penalty = "SCAD"), the selected variables and test RMSE are reported, and the performance is compared to both a

Keywords: Econometrics, Forecasting, SCAD, Lasso, Regularization, Industrial Production, Macroeconomic Data, FRED, ncvreg, High-dimensional Regression, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Monthly macroeconomic series retrieved via the FRED API

```
