<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Baxter_and_King_Filter_Example

Published in: Econometrics_R

Description: This R script downloads US real GDP per capita (NY.GDP.PCAP.KD) from the World Development Indicators (WDI) database for 1960–2023, sorts the observations into chronological order, and then applies the Baxter–King band-pass filter (mFilter::bkfilter) to extract the cyclical component of the series using periodic limits pl = 12 and pu = 32 (with drift = TRUE). It appends the filtered cycle to the dataset, removes missing values created by filtering, and visualizes (i) the original GDP per capita series and (ii) the extracted Baxter–King cycle using ggplot2, arranged vertically with gridExtra.

Keywords: Time Series, Business Cycle, Baxter-King Filter, Band-Pass Filter, GDP per Capita, WDI, mFilter, ggplot2, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
