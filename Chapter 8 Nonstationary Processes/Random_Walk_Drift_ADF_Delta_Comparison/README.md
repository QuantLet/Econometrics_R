<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Random_Walk_Drift_ADF_Delta_Comparison

Published in: Econometrics_R

Description: This R script studies the effect of different drift magnitudes on random walk behaviour and unit-root test outcomes. It defines a simulator for a random walk with drift, Y_t = Y_{t−1} + δ + ε_t, where ε_t is Gaussian white noise, and generates series of length 500 for three drift values δ ∈ {0.5, 0.1, 0.05}. For each drift, it performs an Augmented Dickey–Fuller (ADF) test with drift using urca::ur.df() (type = "drift", lags = 1, lag selection by AIC) and prints the test statistics (τ₂ and ϕ₁) along with their critical values. In parallel, the script produces a ggplot2 time-series plot for each simulated random walk and saves them as individual PNG files: "unit_root_delta05.png", "unit_root_delta01.png", and "unit_root_delta005.png". This setup illustrates how varying the drift parameter affects both the visual behaviour of random walks and the power of unit-root tests to detect nonstationarity.

Keywords: Econometrics, Time Series, Random Walk, Drift, Unit Root, Augmented Dickey–Fuller Test, ADF, urca, Simulation, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/Random_Walk_Drift_ADF_Delta_Comparison/unit_root_delta005.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/Random_Walk_Drift_ADF_Delta_Comparison/unit_root_delta01.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%208%20Nonstationary%20Processes/Random_Walk_Drift_ADF_Delta_Comparison/unit_root_delta05.png" alt="Image" />
</div>

