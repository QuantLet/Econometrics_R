<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Baxter_and_King_Filter_Example

Published in: Econometrics_R

Description: This R script downloads annual U.S. real GDP per capita (NY.GDP.PCAP.KD) from the World Development Indicators (WDI) database for 1960–2023, sorts the observations into chronological order, and applies the Baxter–King band-pass filter (mFilter::bkfilter) with pl = 2 and pu = 8 to retain 2–8-year cycles. With drift = TRUE, the endpoint-to-endpoint linear drift is removed before filtering. The full original series is kept for the upper panel, while the interior cycle sample excludes the three unavailable observations at each endpoint. The two panels are arranged vertically and saved as "gdp-bk-fiter.png" at 300 dpi.

Keywords: Time Series, Business Cycle, Baxter-King Filter, Band-Pass Filter, GDP per Capita, WDI, mFilter, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Chapter%207%20Filtering/Baxter_and_King_Filter_Example/gdp-bk-fiter.png" alt="U.S. GDP per capita and the Baxter–King 2–8-year cycle" />
</div>
