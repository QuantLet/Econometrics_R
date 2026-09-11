<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: RF_Volatility_Forecast_SPY

Published in: Econometrics_R

Description: This R script illustrates prediction of next-day squared return from daily SPY data using a random forest. The feature set contains the squared return available at the forecast origin and older squared- and absolute-return measures. After a chronological training-test split, ranger fits a 500-tree forest with pre-specified mtry and minimum-node-size values, reports permutation importance as an internal diagnostic, and compares test RMSE with a historical-mean benchmark. For a tuned time-series application, hyperparameters should be selected by past-only rolling-origin validation rather than ordinary out-of-bag error.

Keywords: econometrics, volatility forecasting, random forest, machine learning, squared returns, SPY, quantmod, ranger, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
