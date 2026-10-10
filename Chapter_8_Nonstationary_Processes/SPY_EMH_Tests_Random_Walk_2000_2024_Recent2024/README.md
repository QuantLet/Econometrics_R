<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_EMH_Tests_Random_Walk_2000_2024_Recent2024

Published in: Econometrics_R

Description: Examines SPY daily log returns in the 2000-2024 sample and in 2024 using saved adjusted prices. It reports autocorrelation diagnostics and heteroskedasticity-robust fixed-horizon variance-ratio tests. Non-rejection is not interpreted as proof of market efficiency.


Keywords: Econometrics, Time Series, Weak-Form EMH, Random Walk, SPY, Log Returns, ACF, Ljung–Box Test, Auto.Q, AR(5), Wald Test, Variance Ratio, VR.minus.1, Auto.VR, Quantmod, ggplot2, Forecast, lmtest, Sandwich, vrtest, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "spy_emh_tests_random_walk_2000_2024_recent2024.R"
```

Keep these data files beside the script:

- `SPY_adjusted_20000103_20241230.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
