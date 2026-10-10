<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: ARMA11_Forecast_Simulation

Published in: Econometrics_R

Description: Fit an ARMA(1,1) to simulated observations and construct twenty-step forecasts. The plot includes pointwise 80% and 95% Gaussian plug-in prediction intervals.



Keywords: Econometrics, Time Series, ARMA(1,1), Forecasting, Simulation, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

Updated: 11 October 2026

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_2_Univariate_Time_Series/ARMA11_Forecast_Simulation/forecast_result.png" alt="Forecasts from an ARMA(1,1) model, with time on the horizontal axis and the series value on the vertical axis. The black line shows 200 observations fluctuating around zero. The blue forecast mean quickly approaches zero over the next 20 periods. Dark-blue and light-blue shading show the pointwise 80% and 95% prediction intervals, respectively. Their widths settle rapidly as the forecast horizon increases." />
</div>

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "arma11_forecast_simulation.R"
```

Book and companion materials: https://econometricsandtimeseries.com/
