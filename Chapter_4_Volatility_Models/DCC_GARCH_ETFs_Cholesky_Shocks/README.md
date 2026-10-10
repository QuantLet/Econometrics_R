<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: DCC_GARCH_ETFs_Cholesky_Shocks

Published in: Econometrics_R

Description: Fits univariate GARCH models and a DCC specification to SPY, QQQ and EFA returns from the accompanying 2015-2024 data. It compares constant and dynamic conditional correlations and illustrates Cholesky orthogonalisation of the final covariance matrix.


Keywords: Econometrics, Financial Econometrics, Multivariate GARCH, DCC-GARCH, Constant-Correlation GARCH, Covariance Matrix, Correlation Matrix, Cholesky Decomposition, Orthogonal Shocks, SPY, QQQ, EFA, rmgarch, Quantmod, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "dcc_garch_etfs_cholesky_shocks.R"
```

Keep these data files beside the script:

- `ETF_adjusted_2015_2024.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
