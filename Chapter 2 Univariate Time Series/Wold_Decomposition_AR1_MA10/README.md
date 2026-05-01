<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Wold_Decomposition_AR1_MA10

Published in: Econometrics_R

Description: This R script illustrates the Wold decomposition idea by approximating a stationary AR(1) process with a finite-order MA model. It first simulates a length-1000 AR(1) time series with coefficient phi = 0.9 using Gaussian white noise innovations. It then fits an MA(10) model without a mean term using forecast::Arima(), treating the MA(10) specification as a finite Wold-style representation of the underlying AR(1) process. The script extracts the fitted values from the MA(10) model, combines the original and fitted series into a data frame, and uses ggplot2 to generate a line plot comparing the true AR(1) path against its MA(10) approximation over time. The resulting figure is saved as a 6 x 4 inch PNG file ("Wold-decomposition.png").

Keywords: Econometrics, Time Series, Wold Decomposition, AR(1), MA(10), Linear Processes, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%202%20Univariate%20Time%20Series/Wold_Decomposition_AR1_MA10/Wold-decomposition.png" alt="Image" />
</div>

