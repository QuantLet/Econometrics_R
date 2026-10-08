<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Bivariate_VAR_IRF_Connectedness_VARMA

Published in: Econometrics_R

Description: Fits a bivariate VAR to consumption and income growth rates computed from saved FRED observations for January 2007-August 2025. It studies impulse responses and connectedness and illustrates a VARMA model and its finite-order VAR approximation.


Keywords: Econometrics, Time Series, VAR, VARMA, VMA, Impulse Response Functions, Diebold–Yilmaz Connectedness, Innovation Covariance, FRED, Real Consumption, Real Disposable Income, MTS, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "bivariate_var_irf_connectedness_varma.R"
```

Keep these data files beside the script:

- `DSPIC96.csv`
- `PCEC96.csv`

The consumption and income files were retrieved from FRED on 8 October 2026; the analysis uses January 2007-August 2025.

Book and companion materials: https://econometricsandtimeseries.com/
