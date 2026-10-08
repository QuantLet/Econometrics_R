# Preaveraging Covariance

```text
Name of Quantlet: Preaveraging_Covariance

Published in: Econometrics_R

Description: Implements the bias-corrected pre-averaging covariance estimator for synchronised log prices, using triangular weights and an explicit noise correction. Rows of the input matrix are observation times and columns are assets. The number of returns is one less than the number of price observations.

Keywords: Econometrics, R, Pre-averaging, Covariance, Microstructure Noise

Author: Jiajing Sun

Submitted: 9 October 2026
```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "preaveraging_covariance.R"
```

The script defines `pavx(log_prices, theta = 0.8)`. Supply a finite matrix of synchronised log prices, with time in rows and assets in columns, to obtain the covariance estimate.

Book and companion materials: https://econometricsandtimeseries.com/
