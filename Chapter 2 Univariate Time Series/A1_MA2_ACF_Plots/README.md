<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: MA1_MA2_ACF_Plots

Published in: Econometrics_R

Description: This R script simulates MA(1) and MA(2) time series and visualises their autocorrelation functions (ACFs). Using arima.sim() from base R, it generates two length-1000 moving-average processes: an MA(1) process of the form ε_t + 0.5·ε_{t-1} and an MA(2) process of the form ε_t + 0.5·ε_{t-1} + 0.3·ε_{t-2}, under Gaussian innovations with a fixed random seed for reproducibility. The script then employs forecast::ggAcf() to compute and plot the sample autocorrelations of each process, adds informative titles and axis labels with ggplot2, and saves the resulting figures as 6 x 4 inch PNG files ("ma1_acf.png" and "ma2_acf.png") in the working directory.

Keywords: Econometrics, Time Series, Moving Average, MA(1), MA(2), Autocorrelation, ACF, Simulation, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/A1_MA2_ACF_Plots/ma1_acf.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/A1_MA2_ACF_Plots/ma2_acf.png" alt="Image" />
</div>

