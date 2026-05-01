<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Global_vs_Local_Quadratic_Trends

Published in: Econometrics_R

Description: This R script compares a global quadratic trend and a rolling local quadratic trend for the SPY ETF price series. It downloads daily SPY prices from Yahoo Finance via quantmod::getSymbols() for 2015–2024, extracts adjusted closing prices, and constructs a time index t along with log prices. A global quadratic trend is estimated on the log-price scale via lm(log_price ~ t + t^2); the fitted log trend is back-transformed to the price scale with a simple bias correction factor based on exp(residuals). The script also computes a rolling local quadratic trend by repeatedly fitting the same quadratic model over a moving window of recent observations (default 40 days) and predicting the trend at the window endpoint, again with a local bias correction.

Two ggplot2 figures are produced: (i) log prices with the global and rolling local quadratic trends overlaid, saved as "spy_log_trend_global_local.png", and (ii) the level prices with their corresponding global and local quadratic fits, saved as "spy_level_trend_global_local.png". Additionally, if the global quadratic coefficient on t² is negative, the script reports the estimated time and calendar date of the global peak.

Keywords: Econometrics, Time Series, Trend Estimation, Quadratic Trend, Rolling Regression, Local Trend, SPY, Log Prices, Quantmod, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/SPY_Global_vs_Local_Quadratic_Trends/spy_level_trend_global_local.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/SPY_Global_vs_Local_Quadratic_Trends/spy_log_trend_global_local.png" alt="Image" />
</div>

