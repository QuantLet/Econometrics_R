<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Consumption_Income_Cointegration_VECM

Published in: Econometrics_R

Description: Analyses monthly US real consumption and real disposable income from January 2007 to August 2025 using saved FRED observations. The script applies level and difference unit-root tests, residual-based cointegration tests and Johansen tests, estimates a rank-one VECM, and compares deterministic specifications.


Keywords: Econometrics, Time Series, Cointegration, Engle–Granger, Phillips–Ouliaris, Johansen, VECM, ADF Test, VAR, FRED, Real Consumption, Real Disposable Income, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%203%20Multivariate%20Linear%20Time%20Series/Consumption_Income_Cointegration_VECM/log-consumption-income.png" alt="Log real consumption and log real disposable income" />
</div>

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "consumption_income_cointegration_vecm.R"
```

Keep these data files beside the script:

- `DSPIC96.csv`
- `PCEC96.csv`

The consumption and income files were retrieved from FRED on 8 October 2026; the analysis uses January 2007-August 2025.

Book and companion materials: https://econometricsandtimeseries.com/
