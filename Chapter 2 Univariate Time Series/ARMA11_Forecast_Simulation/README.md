<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: ARMA11_Forecast_Simulation

Published in: Econometrics_R

Description: This R script simulates an ARMA(1,1) time series, fits the corresponding model, and produces forecasts with visualisation. It first sets the working directory to the script location (for RStudio users), then generates 200 observations from an ARMA(1,1) process with parameters ar = 0.5 and ma = 0.3 under Gaussian innovations. Using forecast::Arima(), the script estimates an ARMA(1,1) model for the simulated data and computes 20-step-ahead forecasts via forecast(). The forecast path, including point forecasts and prediction intervals, is plotted with autoplot() from the forecast package and annotated with axis labels and a title using ggplot2. The resulting forecast figure is saved as a 6 x 4 inch PNG file ("forecast_result.png") in the working directory.

Keywords: Econometrics, Time Series, ARMA(1,1), Forecasting, Simulation, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/ARMA11_Forecast_Simulation/forecast_result.png" alt="Image" />
</div>

