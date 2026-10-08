<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: CCAPM_GMM_Estimation_FRED_SP500

Published in: Econometrics_R

Description: Estimates a consumption-based asset-pricing model from the accompanying monthly data. It profiles the discount factor, compares unrestricted and bounded parameter estimates, and computes HAC standard errors and a Stock-Wright S profile with a parameter-dependent moment covariance.


Keywords: Econometrics, Asset Pricing, C-CAPM, GMM, Euler Equation, Over-Identifying Restrictions, J-Statistic, FRED, Real Consumption, Risk-Free Rate, S&P 500, Quantmod, gmm, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "ccapm_gmm_estimation_fred_sp500.R"
```

Keep these data files beside the script:

- `ch06_ccapm_vintage.csv`

The monthly snapshot combines real consumption, the price index, the equity-price series and the Treasury-bill rate used in the book. The script reports the selected sample window.

Book and companion materials: https://econometricsandtimeseries.com/
