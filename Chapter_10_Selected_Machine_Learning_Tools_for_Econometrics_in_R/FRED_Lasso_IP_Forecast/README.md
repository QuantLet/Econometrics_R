<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_Lasso_IP_Forecast

Published in: Econometrics_R

Description: Forecast industrial-production growth from lagged macroeconomic predictors. Select penalties with expanding-window validation and compare forecasts on a later test sample.



Keywords: Econometrics, Forecasting, Lasso, Ridge, Regularization, Industrial Production, Macroeconomic Data, FRED, glmnet, R

Author: Jiajing Sun

Submitted: 22 November 2025

Updated: 11 October 2026

Datafile: Supplied INDPRO, UNRATE, CPIAUCSL and FEDFUNDS observations

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
