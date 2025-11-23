<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Local_Level_Kalman_Filter_Smoother_Missing

Published in: Econometrics_R

Description: This R script simulates a univariate local level state-space model with missing observations and compares Kalman filter and smoother estimates under different initialization schemes. It generates a latent state process α_t following a random walk with state noise σ_η = 0.5 and observations y_t = α_t + ε_t with observation noise σ_ε = 1, for N = 100 time points. Around 10% of observations are randomly set to NA to mimic missing data. Using dlm, the script specifies a local level model via dlmModPoly(), estimates the observation and state variances by maximum likelihood with dlmMLE(), and constructs the fitted DLM. Kalman filtering and smoothing are then applied with dlmFilter() and dlmSmooth(). Missing observations are interpolated using the filtered state means.

To study initialization effects, the script compares the default diffuse initialization with an “informed” initialization that sets the prior mean to the sample mean of the observed data and a tight prior variance. Both filtered paths are stored along with the true state, observed data, smoothed state, and interpolated series. The results are reshaped and plotted with ggplot2: a multi-line plot highlighting observed data, true state, diffuse and informed filter estimates, smoothed states, and interpolated values, with vertical dotted lines marking missing observation times. The plot is saved as a 6 x 4 inch PNG file ("local_level_kalman_plot.png"). Finally, the script reports the mean absolute difference between diffuse and informed filtered states as a numeric summary of initialization sensitivity.

Keywords: Econometrics, State-Space Model, Local Level Model, Kalman Filter, Kalman Smoother, Missing Data, Initialization, DLM, dlm, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%207%20Filtering/Local_Level_Kalman_Filter_Smoother_Missing/local_level_kalman_filters.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%207%20Filtering/Local_Level_Kalman_Filter_Smoother_Missing/local_level_kalman_main.png" alt="Image" />
</div>

