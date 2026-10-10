<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: CCAPM_GMM_Estimation_FRED_SP500

Published in: Econometrics_R

Description: Estimate a consumption-based asset-pricing model and compare unrestricted and bounded parameter estimates. Profile the discount factor and examine HAC inference and a Stock–Wright S profile with parameter-dependent moment covariance.



Keywords: Econometrics, Asset Pricing, C-CAPM, GMM, Euler Equation, Over-Identifying Restrictions, J-Statistic, FRED, Real Consumption, Risk-Free Rate, S&P 500, Quantmod, gmm, R

Author: Jiajing Sun

Submitted: 22 November 2025

Updated: 11 October 2026

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
