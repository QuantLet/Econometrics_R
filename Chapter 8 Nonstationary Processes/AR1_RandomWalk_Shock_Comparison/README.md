<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: AR1_RandomWalk_Shock_Comparison

Published in: Econometrics_R

Description: This R script compares the impact of a one-time negative shock on a stationary AR(1) process and on a random walk. It simulates two AR(1) series with coefficient φ = 0.8 over 250 observations using the same innovation sequence: one baseline series without shocks and one where a negative shock of size −5 is added to the innovation at a chosen time point (t = 100). The resulting paths are assembled into a data frame and plotted with ggplot2, showing the “With Shock” and “Without Shock” series together; the figure is saved as a 6 x 4 inch PNG file ("ar1_comparison_plot.png"). The script then repeats the exercise for a random walk X_t = X_{t−1} + ε_t, again with and without a one-time negative shock, using a common innovation sequence. A second ggplot compares the shocked and unshocked random walk paths, saved as "rw_comparison_plot.png". Together, these plots visually illustrate how shocks to stationary and non-stationary processes differ in persistence: mean-reverting in the AR(1) case versus permanent level shifts in the random walk case.

Keywords: Econometrics, Time Series, AR(1), Random Walk, Shock, Impulse, Stationarity, Persistence, Simulation, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/AR1_RandomWalk_Shock_Comparison/ar1_comparison_plot.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/AR1_RandomWalk_Shock_Comparison/rw_comparison_plot.png" alt="Image" />
</div>

