<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Lasso_RF_VolForecast

Published in: Econometrics_R

Description: Downloads daily SPY prices from Yahoo Finance, computes log returns and squared returns as a proxy for realised volatility, and constructs a high-dimensional predictor set using lags of squared and absolute returns plus day-of-week dummies. The script uses a blocked time-series cross-validation scheme on the initial subsample to select the lasso penalty in a glmnet regression, specifies a GARCH(1,1) benchmark via rugarch, and then runs a rolling-window forecasting exercise. For each forecast origin it re-estimates an AR(1) on squared returns, a GARCH(1,1) on returns, a lasso regression, and a random forest model, produces one-step-ahead volatility forecasts, and compares their out-of-sample RMSEs. An optional ggplot2 figure illustrates realised volatility versus the lasso forecast over the evaluation period.

Keywords: SPY, volatility, squared returns, GARCH, lasso, random forest, glmnet, rugarch, ranger, time-series cross-validation, machine learning, forecasting, R

Author: Jiajing Sun

Submitted: 27 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%2010%20Selected%20Machine%20Learning%20Tools%20for%20Econometrics%20in%20R/RED_Lasso_IP_Growth/realized_vs_lasso.png" alt="Image" />
</div>

