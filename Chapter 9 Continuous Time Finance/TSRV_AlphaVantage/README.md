<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: TSRV_AlphaVantage

Published in: Econometrics_R

Description: This R script downloads intraday high-frequency stock prices from the Alpha Vantage API using quantmod and computes the Two-Scale Realized Volatility (TSRV) estimator to adjust for market microstructure noise. After fetching 1-minute prices for a chosen symbol (e.g. AAPL), the script constructs K staggered grids, retains every available return interval on each grid, records the grid-specific counts, and subtracts the full-grid realized volatility with the corresponding average-count bias correction. The default grid count follows the canonical order K proportional to n^(2/3), and the API key is read from the ALPHAVANTAGE_API_KEY environment variable.

Keywords: high-frequency data, realized volatility, TSRV, Two-Scale Realized Volatility, microstructure noise, Alpha Vantage, quantmod, xts, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Intraday price data retrieved via the Alpha Vantage API

```
