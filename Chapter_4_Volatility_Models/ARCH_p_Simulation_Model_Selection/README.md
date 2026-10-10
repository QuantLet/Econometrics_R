<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: ARCH_p_Simulation_Model_Selection

Published in: Econometrics_R

Description: This R script simulates an ARCH(p) process, performs model selection across different ARCH orders, and conducts diagnostic checks on the selected model. It first simulates a length-1000 ARCH(3) process with parameters ω = 0.1 and α = (0.5, 0.2, 0.1), recursively constructing the conditional variance σ_t^2 and innovations ε_t. The resulting series is plotted over time using ggplot2 and saved as a 6 x 4 inch PNG file ("arch_p_series.png"). Next, the script fits a sequence of symmetric GARCH models with pure ARCH(p) variance components (sGARCH with order (p, 0)) for p = 1,…,5 using rugarch::ugarchfit(), computes AIC and BIC via infocriteria(), and identifies the orders that minimise each criterion. It refits the AIC-selected model, prints its fitted results, and reports lag-10 Ljung–Box Q summaries for the standardised residuals and their centred squares. These two summaries describe remaining mean and variance dependence. The default Box.test chi-squared p-values are not used as formal tests of fitted ARCH residuals; significance requires a residual-adjusted test or a bootstrap that refits the model.

Keywords: Econometrics, Time Series, Volatility, ARCH, GARCH, Model Selection, AIC, BIC, Ljung–Box Test, rugarch, ggplot2, FinTS, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter_4_Volatility_Models/ARCH_p_Simulation_Model_Selection/arch_p_series.png" alt="Image" />
</div>

