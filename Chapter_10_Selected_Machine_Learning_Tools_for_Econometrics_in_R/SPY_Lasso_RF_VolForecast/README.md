<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Lasso_RF_VolForecast

Published in: Econometrics_R

Description: Compares AR, GARCH, lasso and random-forest volatility forecasts using the accompanying 2020-2024 SPY adjusted-price data. It reports test-sample errors and plots realised volatility against the lasso forecast.


Keywords: SPY, volatility, squared returns, GARCH, lasso, random forest, glmnet, rugarch, ranger, time-series cross-validation, machine learning, forecasting, R

Author: Jiajing Sun

Submitted: 27 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_10_Selected_Machine_Learning_Tools_for_Econometrics_in_R/SPY_Lasso_RF_VolForecast/realised_vs_lasso.png" alt="Daily SPY squared returns and past-only-tuned lasso forecasts" />
</div>

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "SPY_Lasso_RF_VolForecast.R"
```

Keep these data files beside the script:

- `SPY_adjusted_20200102_20241231.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
