<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_Lasso_IP_Forecast

Published in: Econometrics_R

Description: This R script demonstrates pseudo-out-of-sample forecasting of U.S. industrial production growth using regularized regression and latest-vintage monthly FRED data through December 2024. It transforms industrial production, unemployment, CPI, and the federal funds rate and uses 12 lags of each series; no contemporaneous macro release enters the predictor matrix. After a chronological training-test split, a custom expanding-window validation loop selects the lasso and ridge penalties using past-only estimation. The script reports the lasso's selected coefficients and compares lasso, ridge, and a historical-mean benchmark on the untouched test period. A real-time study would additionally require publication-date alignment and historical data vintages.

Keywords: Econometrics, Forecasting, Lasso, Ridge, Regularization, Industrial Production, Macroeconomic Data, FRED, glmnet, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Monthly macroeconomic series retrieved via the FRED API

```
