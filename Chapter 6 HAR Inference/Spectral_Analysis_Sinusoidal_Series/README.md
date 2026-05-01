<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Spectral_Analysis_Sinusoidal_Series

Published in: Econometrics_R

Description: This R script illustrates basic spectral analysis on a synthetic time series composed of two sinusoidal components. It simulates a series x(t) as the sum of a 10-period cosine and a 5-period sine over t ∈ [0, 100] with step size 0.1, and stores the result in a data frame. The script then computes the (raw) periodogram using the base R spectrum() function with plotting suppressed, extracting the frequency grid and corresponding spectral density values. Two ggplot2 graphics are constructed: (i) a time-domain plot of the simulated series x(t), and (ii) a frequency-domain plot of the estimated spectrum versus frequency. These two panels are combined vertically using ggpubr::ggarrange() and saved as a single 6 x 4 inch PNG file ("spectral.png") at 300 dpi, providing a clear visual link between the time-series representation and its spectral decomposition.

Keywords: Econometrics, Time Series, Spectral Analysis, Periodogram, Frequency Domain, Sinusoidal Components, ggplot2, ggpubr, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%206%20HAR%20Inference/Spectral_Analysis_Sinusoidal_Series/spectral.png" alt="Image" />
</div>

