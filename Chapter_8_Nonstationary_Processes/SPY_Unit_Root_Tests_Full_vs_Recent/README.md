<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Unit_Root_Tests_Full_vs_Recent

Published in: Econometrics_R

Description: Applies ADF and KPSS tests to SPY log prices and log returns using the accompanying adjusted-price snapshot. It compares the 2000-2024 sample with 2024 alone and reports the deterministic specification and five-percent critical value for each test.


Keywords: Econometrics, Time Series, Unit Root, Stationarity, Augmented Dickey–Fuller, ADF, KPSS, SPY, Log Prices, Log Returns, Quantmod, urca, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "spy_unit_root_tests_full_vs_recent.R"
```

Keep these data files beside the script:

- `SPY_adjusted_20000103_20241230.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
