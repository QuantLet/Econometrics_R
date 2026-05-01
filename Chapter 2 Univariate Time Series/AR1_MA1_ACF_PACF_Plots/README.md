<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: AR1_MA1_ACF_PACF_Plots

Published in: Econometrics_R

Description: This R script simulates AR(1) and MA(1) time series and visualises both their partial autocorrelation functions (PACFs) and autocorrelation functions (ACFs). Using arima.sim(), it generates two length-1000 processes under Gaussian innovations: an AR(1) process Y_t = 0.9 Y_{t-1} + ε_t and an MA(1) process Y_t = ε_t + 0.9 ε_{t-1}, with a fixed random seed for reproducibility. The script then applies forecast::ggPacf() and forecast::ggAcf() to compute and plot the PACF and ACF for each series, adds descriptive titles and axis labels with ggplot2, and saves the resulting four figures as 6 x 4 inch PNG files ("ar1_pacf.png", "ma1_pacf.png", "ar1_acf.png", and "ma1_acf.png") in the working directory.

Keywords: Econometrics, Time Series, AR(1), MA(1), Autocorrelation, Partial Autocorrelation, ACF, PACF, Simulation, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/AR1_MA1_ACF_PACF_Plots/ar1_acf.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/AR1_MA1_ACF_PACF_Plots/ar1_pacf.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/AR1_MA1_ACF_PACF_Plots/ma1_acf.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/AR1_MA1_ACF_PACF_Plots/ma1_pacf.png" alt="Image" />
</div>

