<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Random_Walk_ACF_PACF_Demo

Published in: Econometrics_R

Description: This R script simulates a univariate random walk and visualises its time-series behaviour as well as its autocorrelation and partial autocorrelation functions. It generates 500 observations from the model Y_t = Y_{t−1} + ε_t with Gaussian white-noise innovations, starting from zero. Using ggplot2, the script produces a time-series plot of the simulated random walk, and with forecast::ggAcf() and forecast::ggPacf() it constructs ACF and PACF plots. The ACF and PACF are combined into a single panel via patchwork and displayed in the R plotting window. Together, these plots highlight the slow decay of the autocorrelations and the nonstationary nature of the random walk.

Keywords: Econometrics, Time Series, Random Walk, Nonstationarity, Autocorrelation Function, Partial Autocorrelation Function, ACF, PACF, Simulation, ggplot2, forecast, patchwork, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/Random_Walk_ACF_PACF_Demo/random_walk_plot.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/Random_Walk_ACF_PACF_Demo/rw_acf_pacf_plot.png" alt="Image" />
</div>

