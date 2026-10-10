# Boundary bias: Nadaraya–Watson and local linear regression

This example reproduces Figure 5.6 in *Econometrics and Time Series Methods: Theory, Applications, and R Implementation*.

At the left boundary, a local average uses observations on only one side of the evaluation point. When the regression function is rising, this pulls the Nadaraya–Watson estimate upwards. A local linear regression fits a slope as well as an intercept and can substantially reduce this bias.

## Run the example

Install R and the plotting packages once:

```r
install.packages(c("ggplot2", "patchwork"))
```

Set the working directory to this folder, then run:

```r
source("nw_local_linear_boundary_bias.R")
```

Alternatively, run `Rscript nw_local_linear_boundary_bias.R` from this folder. No downloaded data, account or API key is needed. The example was checked with R 4.5.1, ggplot2 4.0.0 and patchwork 1.3.2.

## Simulation

The regression function is `r(x) = 1 + 4*x - 4*x^2`, with 400 independently sampled uniform predictors on `[0,1]` and independent normal errors of standard deviation 0.20. Both estimators use the Epanechnikov kernel with bandwidth 0.25 and are evaluated at zero, where `r(0) = 1`.

The left panel uses the first simulated response sample. Its coloured lines are the local fits at zero, drawn over the local window; they are not estimates refitted at each point along the horizontal axis. The right panel summarises 5,000 independent response samples, holding those same predictor values fixed. The random seed is 20261009.

Bias is calculated from the exact conditional expectation, using the estimator weights and the known regression function. The estimation error in one sample is not labelled as bias.

| Estimator | Conditional bias at zero | Conditional standard deviation |
| --- | ---: | ---: |
| Nadaraya–Watson | 0.324391 | 0.019838 |
| Local linear | 0.025074 | 0.039186 |

For this design, local linear regression has much smaller bias and greater sampling variability. The nonzero local linear bias reflects curvature within the window. The plotted densities summarise the simulated estimates; dotted vertical lines mark their exact conditional means.

The script verifies the weight identities and checks the local linear intercept and slope against `lm.wfit()`. It also compares the simulation averages with their analytic conditional expectations.

## Files

- `nw_local_linear_boundary_bias.R`: simulation, numerical checks and figure.
- `nw_local_linear_boundary_bias.pdf` and `.png`: vector and raster figures, with the legend below both panels.
- `simulated_sample.csv`: predictors, first response sample, true conditional means and kernel weights.
- `boundary_estimates.csv`: all 5,000 estimates from each method.
- `bias_summary.csv`: analytic conditional means, biases and standard deviations, and simulation summaries.
- `simulation_design.csv`: sample size, bandwidth, error standard deviation, seed and window size.

Running the script also writes `session_info.txt` with package versions.

The book prints the full R script for Figure 5.6, including its plotting commands. The code box links to this directory.

## About this example

Compare Nadaraya–Watson and local linear estimates near a support boundary using a known regression function. Repeated simulations distinguish systematic bias from variation in an individual fitted curve.

Notes updated: 11 October 2026.
