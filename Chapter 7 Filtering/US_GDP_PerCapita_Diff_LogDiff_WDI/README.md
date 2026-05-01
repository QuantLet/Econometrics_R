<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: US_GDP_PerCapita_Diff_LogDiff_WDI

Published in: Econometrics_R

Description: This R script retrieves U.S. real GDP per capita data from the World Bank’s WDI database and compares the level series with its first and logarithmic differences. Using WDI::WDI(), it downloads the indicator NY.GDP.PCAP.KD (GDP per capita, constant prices) for the United States from 1960 to 2023. It then constructs two transformed series: the first difference of GDP per capita and the log difference (approximate growth rate), removing the initial NA observation induced by differencing. With ggplot2 and gridExtra, the script creates three time-series plots: (i) the original GDP per capita series, (ii) the first-differenced series, and (iii) the log-differenced series, each plotted against year with distinct colours and titles. The three panels are arranged vertically in a single figure via grid.arrange(), providing a visual comparison of levels, absolute changes, and relative (percentage) changes in U.S. real GDP per capita over time.

Keywords: Econometrics, Macroeconomics, Time Series, GDP per Capita, First Difference, Log Difference, Growth Rates, WDI, World Bank, ggplot2, gridExtra, R

Author: Jiajing Sun

Submitted: 22 November 2025

```
