<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_Lasso_IP_Growth

Published in: Econometrics_R

Description: Downloads monthly US macroeconomic series from FRED (industrial production INDPRO, unemployment UNRATE, CPI inflation CPIAUCSL, and the federal funds rate FEDFUNDS), constructs industrial production growth, inflation, and first differences of unemployment and the policy rate, and builds a high-dimensional predictor set using 12 monthly lags of each variable. The script splits the sample into training and test sets, fits a lasso regression with cv.glmnet to forecast industrial production growth, reports the selected variables and out-of-sample RMSE, compares the lasso forecaster with a ridge regression benchmark, and shows how to adapt cv.glmnet to a time-series cross-validation scheme using a blocked foldid.

Keywords: FRED, lasso, ridge, glmnet, macroeconomics, forecasting, industrial production, inflation, unemployment, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%2010%20Selected%20Machine%20Learning%20Tools%20for%20Econometrics%20in%20R/RED_Lasso_IP_Growth/realised_vs_lasso.png" alt="Image" />
</div>

