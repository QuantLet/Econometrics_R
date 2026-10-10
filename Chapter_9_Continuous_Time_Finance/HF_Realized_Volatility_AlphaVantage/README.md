<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: HF_Realized_Volatility_AlphaVantage

Published in: Econometrics_R

Description: Simulates one trading day of latent log prices, measurement noise and a single quote error of 0.12 log points, about 12.75% of the price. The figures show the two opposite return spikes caused by this error and compare realised variance across sampling intervals. The example uses simulated prices and needs no market-data account.


Keywords: high-frequency data, realized volatility, log-returns, aggregation, market microstructure, simulation, R

Author: Jiajing Sun

Submitted: 29 April 2025

Datafile: None; prices are simulated within the script.

See also: Intraday_Fixed_Sample, GBM_MLE_Approx_vs_Exact_Diagnostics

```

## Running this example

Set the working directory to this folder and install the packages loaded at the start of the script. Then run:

```sh
Rscript "hf_realized_volatility_alpha_vantage.R"
```

## Interpreting the quote error

The error at minute 180 raises one log price by 0.12, equivalent to a price increase of about 12.75%. When the following quote returns to the noisy price path, the two adjacent log returns have large, opposite spikes. Their leading contribution to realised variance is twice 0.12 squared, or 0.0288, compared with a latent integrated variance of 0.0004. This example therefore shows the effect of a large error. Its effect also depends on whether the sampling grid includes that quote.

Book and companion materials: https://econometricsandtimeseries.com/

![Simulated one-minute log returns over a 390-minute trading day. The red solid line shows returns calculated from prices with measurement noise. The turquoise dashed line also includes a single quote near minute 180 that is about 12.75% too high, an error of 0.12 log points. This quote produces a positive return of about 0.12 followed immediately by a negative return of similar size. Away from these two spikes, the lines nearly coincide close to zero.](log_returns_1min.png)

![Realised variance for the simulated trading day at sampling intervals from 1 to 20 minutes, shown on a logarithmic vertical scale. The green latent-price and blue noisy-price series remain near a few times 10 to the minus 4. The red series includes the single upward quote error of about 12.75%. Its realised variance is close to 0.03 when the sampling grid includes that quote and falls near the other series when the grid omits it.](volatility_comparison.png)
