<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: TSRV_AlphaVantage

Published in: Econometrics_R

Description: This R script downloads intraday high-frequency stock prices from the Alpha Vantage API using quantmod, and computes the Two-Scale Realized Volatility (TSRV) estimator to adjust for market microstructure noise. After fetching 1-minute intraday prices for a chosen symbol (e.g. AAPL), the script constructs a log-price series, splits it into K subsamples, computes subsample realized volatilities, and combines them with the full-sample realized volatility to obtain the TSRV estimate.

Keywords: high-frequency data, realized volatility, TSRV, Two-Scale Realized Volatility, microstructure noise, Alpha Vantage, quantmod, xts, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Intraday price data retrieved via the Alpha Vantage API

```
