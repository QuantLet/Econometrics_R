<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Wold_Decomposition_AR1_MA10

Published in: Econometrics_R

Description: This R script illustrates the Wold representation of a stationary AR(1) model by comparing an AR(1) recursion with its direct ten-lag truncation. It generates 1,000 observations with phi = 0.9 and Gaussian white-noise innovations. Both paths start from a zero initial value, so the first observations have smaller variance than the stationary model; this initial effect decays geometrically. The reconstruction sums the known terms from lag zero through ten and does not estimate an MA model. In the stationary model, the omitted terms account for phi^22, approximately 9.85%, of the total variance. The chart is saved as Wold_decomposition.png.

Keywords: Econometrics, Time Series, Wold Decomposition, AR(1), MA(10), Linear Processes, Forecast, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_2_Univariate_Time_Series/Wold_Decomposition_AR1_MA10/Wold_decomposition.png" alt="Simulated AR(1) series and its direct ten-lag Wold truncation" />
</div>
