<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SelfNormalized_M_S_Critical_Values

Published in: Econometrics_R

Description: Calculates critical values for the signed self-normalised S and range-based M statistics and their multivariate quadratic forms. Numerical integration is used for the univariate tail probabilities; simulation illustrates their distributions and the multivariate cases.


Keywords: Econometrics, Time Series, Brownian Motion, Brownian Bridge, Self-Normalization, Hong M Statistic, Shao S Statistic, Critical Values, Monte Carlo Simulation, Kernel Density, ggplot2, xtable, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_6_HAR_Inference/SelfNormalized_M_S_Critical_Values/dist-m-hat.png" alt="Image" />
</div>

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "self_normalized_M_S_critical_values.R"
```

Book and companion materials: https://econometricsandtimeseries.com/

The script exports PDF and PNG versions of Figure 6.4 in `figures/`, with a shared horizontal legend below the axes. The simulation seed, critical-value calculations and density estimates are unchanged.
