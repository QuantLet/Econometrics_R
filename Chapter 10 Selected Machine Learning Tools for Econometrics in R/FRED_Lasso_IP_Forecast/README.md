<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_Lasso_IP_Forecast

Published in: Econometrics_R

Description: Forecasts monthly industrial-production growth using its own lags and lags of unemployment, inflation and the federal funds rate. Lasso and ridge penalties are selected with expanding-window validation. The accompanying FRED snapshots replace live API requests.


Keywords: Econometrics, Forecasting, Lasso, Ridge, Regularization, Industrial Production, Macroeconomic Data, FRED, glmnet, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Monthly macroeconomic series retrieved via the FRED API

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "fred_lasso_ip_forecast.R"
```

Keep these data files beside the script:

- `CPIAUCSL.csv`
- `FEDFUNDS.csv`
- `INDPRO.csv`
- `UNRATE.csv`

The saved FRED series are INDPRO, UNRATE, CPIAUCSL and FEDFUNDS. Historical observations may differ from later FRED revisions. No API key is needed.

Book and companion materials: https://econometricsandtimeseries.com/
