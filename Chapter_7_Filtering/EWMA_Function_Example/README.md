<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: EWMA_Function_Example

Published in: Econometrics_R

Description: This R script defines and demonstrates an Exponentially Weighted Moving Average (EWMA) filter for a univariate time series. Under its parameterization, the recursion is EWMA_t = (1 − α) x_t + α EWMA_{t−1}, so α is the weight on the previous smoothed value. The function validates that α is strictly between zero and one, returns an empty numeric vector for empty input, and handles a one-observation input without entering the loop. It then applies the filter to a short numeric example with α = 0.2 and prints the smoothed values.

Keywords: Time Series, Exponentially Weighted Moving Average, EWMA, Smoothing, Filtering, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
