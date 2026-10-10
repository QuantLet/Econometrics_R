<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FRED_SCAD_IP_Forecast_NCVREG

Published in: Econometrics_R

Description: Compare SCAD, lasso and a historical-mean forecast using lagged macroeconomic predictors. Penalty selection uses past-only validation before evaluation on the held-out period.


Keywords: Econometrics, Forecasting, SCAD, Lasso, Regularization, Industrial Production, Macroeconomic Data, FRED, ncvreg, High-dimensional Regression, R

Author: Jiajing Sun

Submitted: 22 November 2025

Updated: 11 October 2026

Datafile: INDPRO.csv, UNRATE.csv, CPIAUCSL.csv, FEDFUNDS.csv

```

## Running this example

Keep the four CSV files beside the R script and run it with this folder as the working directory. The saved series match those used in the book and the preceding lasso example. No API key is needed.

Install dplyr, tidyr, lubridate, purrr, glmnet and ncvreg, then run:

```sh
Rscript fred_scad_ip_forecast_ncvreg.R
```
