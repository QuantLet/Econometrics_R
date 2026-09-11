<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Lasso_RF_VolForecast

Published in: Econometrics_R

Description: Downloads daily SPY prices from Yahoo Finance, computes returns and a daily squared-return volatility proxy, and constructs a predictor set from lagged squared and absolute returns plus day-of-week dummies. The contemporaneous return is retained only for GARCH estimation and excluded from the machine-learning design because the target is its square. A custom expanding-window validation loop selects the lasso penalty using past-only fits; the random forest uses clearly pre-specified settings rather than claimed OOB tuning. The rolling evaluation re-estimates an AR(1), a GARCH(1,1), lasso, and random forest at each origin. The GARCH forecast targets the squared-return conditional expectation by adding the squared conditional-mean forecast to the variance forecast. The script compares RMSEs and plots observed daily squared returns against lasso forecasts.

Keywords: SPY, volatility, squared returns, GARCH, lasso, random forest, glmnet, rugarch, ranger, time-series cross-validation, machine learning, forecasting, R

Author: Jiajing Sun

Submitted: 27 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%2010%20Selected%20Machine%20Learning%20Tools%20for%20Econometrics%20in%20R/SPY_Lasso_RF_VolForecast/realised_vs_lasso.png" alt="Daily SPY squared returns and past-only-tuned lasso forecasts" />
</div>
