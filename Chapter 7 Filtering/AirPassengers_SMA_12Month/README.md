<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: AirPassengers_SMA_12Month

Published in: Econometrics_R

Description: This R script computes and visualises a 12-month simple moving average (SMA) for the classic AirPassengers time series. It converts the built-in monthly AirPassengers series to a numeric vector and applies a symmetric 12-period simple moving average using stats::filter() with equal weights and sides = 2. The script constructs a data frame containing the time index, original passenger counts, and the SMA values (excluding boundary NAs), and then uses ggplot2 to plot both the original series (in blue) and the smoothed 12-month SMA (in red) on the same time axis. The resulting figure, titled “AirPassengers Data with 12-Month SMA”, is saved as a 6 x 4 inch PNG file ("sma_airpassenger.png") at 300 dpi in the working directory.

Keywords: Time Series, Smoothing, Simple Moving Average, SMA, AirPassengers, Seasonal Data, Trend Extraction, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%207%20Filtering/AirPassengers_SMA_12Month/sma_airpassenger.png" alt="Image" />
</div>

