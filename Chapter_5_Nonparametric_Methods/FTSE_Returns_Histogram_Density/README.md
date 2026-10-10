<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: FTSE_Returns_Histogram_Density

Published in: Econometrics_R

Description: Plots a histogram and kernel density estimate of daily FTSE log returns from the accompanying 2015-2024 closing-price snapshot. Missing differences are removed after returns have been calculated.


Keywords: Econometrics, Financial Econometrics, FTSE 100, Log Returns, Histogram, Kernel Density, Quantmod, ggplot2, Yahoo Finance, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_5_Nonparametric_Methods/FTSE_Returns_Histogram_Density/ftse-returns-density.png" alt="Image" />
</div>

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "ftse_returns_histogram_density.R"
```

Keep these data files beside the script:

- `FTSE_close_2015_2024.csv`

These are the saved market-data observations used by the revised example. Dates and column names are retained in the CSV files.

Book and companion materials: https://econometricsandtimeseries.com/
