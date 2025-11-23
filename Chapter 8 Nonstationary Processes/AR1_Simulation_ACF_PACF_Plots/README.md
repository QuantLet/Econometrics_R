<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: AR1_Simulation_ACF_PACF_Plots

Published in: Econometrics_R

Description: This R script simulates an AR(1) time series and visualises its time-domain behaviour along with its autocorrelation and partial autocorrelation functions. It generates 500 observations from the process Y_t = 0.9 Y_{t−1} + ε_t with Gaussian white-noise innovations, starting from zero. A time-series plot of Y_t against t is created using ggplot2 and saved as a 6 x 4 inch PNG file ("AR1_plot.png"). The script then uses forecast::ggAcf() and forecast::ggPacf() to produce ggplot-based ACF and PACF plots for the simulated series, each annotated with the model expression in the title. These two graphics are combined side-by-side via patchwork and saved as a 12 x 4 inch PNG file ("AR1_acf_pacf_plot.png"), providing a concise illustration of the characteristic geometric decay of the ACF and single significant spike in the PACF for an AR(1) process.

Keywords: Econometrics, Time Series, AR(1), Autocorrelation Function, Partial Autocorrelation Function, ACF, PACF, Simulation, ggplot2, forecast, patchwork, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/AR1_Simulation_ACF_PACF_Plots/AR1_acf_pacf_plot.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/AR1_Simulation_ACF_PACF_Plots/AR1_plot.png" alt="Image" />
</div>

