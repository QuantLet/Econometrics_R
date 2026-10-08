<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: TSRV_AlphaVantage

Published in: Econometrics_R

Description: Computes two-scale realised variance from Alpha Vantage intraday prices. The script selects positive, non-duplicate observations from the latest regular trading session and checks the exchange time zone and large price changes before estimation.


Keywords: high-frequency data, realized volatility, TSRV, Two-Scale Realized Volatility, microstructure noise, Alpha Vantage, quantmod, xts, R

Author: Jiajing Sun

Submitted: 22 November 2025

Datafile: Intraday price data retrieved via the Alpha Vantage API

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "tsrv_alpha_vantage.R"
```

Set `ALPHAVANTAGE_API_KEY` in the environment before running. Intraday data access depends on the Alpha Vantage account. The script prints the trading day selected for estimation.

Book and companion materials: https://econometricsandtimeseries.com/
