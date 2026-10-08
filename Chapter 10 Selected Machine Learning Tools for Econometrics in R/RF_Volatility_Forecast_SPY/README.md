<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: RF_Volatility_Forecast_SPY

Published in: Econometrics_R

Description: Uses saved SPY adjusted prices to forecast next-day absolute log returns with a random forest. The script keeps the training sample before the test sample, reports permutation importance and test RMSE, and compares the forest with a constant forecast.


Keywords: econometrics, volatility forecasting, random forest, machine learning, squared returns, SPY, quantmod, ranger, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "rf_volatility_forecast_spy.R"
```

Keep these data files beside the script:

- `SPY_adjusted_20000103_20241230.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
