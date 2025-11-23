<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: SPY_Volatility_Regimes_2024

Published in: Econometrics_R

Description: This R script analyzes daily SPY log returns in 2024 using a range of conditional volatility and regime-switching models. It first downloads SPY prices from Yahoo Finance via quantmod::getSymbols(), extracts adjusted closing prices, and computes daily log returns, removing the initial NA. An ARMA specification for the conditional mean is selected using forecast::auto.arima() with a non-seasonal, exhaustive search. The script then estimates several GARCH-family models for the conditional variance using rugarch: a standard GARCH(1,1), an EGARCH(1,1), a GJR-GARCH(1,1), and a threshold GARCH (TGARCH) implemented as an fGARCH submodel, all with an ARMA(0,0) mean and an included intercept. In addition, it fits a two-regime Markov-switching model for the return mean using MSwM::msmFit() with an intercept-only specification, allowing both regimes’ parameters and transition probabilities to vary. The fitted objects for the GARCH, EGARCH, GJR-GARCH, TGARCH, and Markov-switching models are printed to the console to facilitate comparison of parameter estimates, persistence, and regime characteristics.

Keywords: Econometrics, Financial Econometrics, Volatility, GARCH, EGARCH, GJR-GARCH, TGARCH, Markov-Switching, Regime-Switching, SPY, Log Returns, Yahoo Finance, Quantmod, Rugarch, Forecast, MSwM, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
