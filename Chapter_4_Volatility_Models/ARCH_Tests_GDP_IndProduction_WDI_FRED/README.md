<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="../../assets/quantlet_design.png" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: ARCH_Tests_GDP_IndProduction_WDI_FRED

Published in: Econometrics_R

Description: Test for conditional heteroskedasticity in GDP growth and industrial-production growth. The industrial-production example reads the supplied FRED observations; the GDP example retrieves World Bank data.


Keywords: Econometrics, Time Series, ARCH, Conditional Heteroskedasticity, Engle LM Test, McLeod–Li Test, GDP Growth, Industrial Production, WDI, FRED, R

Author: Jiajing Sun

Submitted: 22 November 2025

Updated: 11 October 2026

```

## Data and execution

Run `arch_tests_gdp_indpro_WDI_FRED.R` with this folder as the working directory. The script requires the `WDI` package and an internet connection for the annual GDP series. Industrial production is read locally; it requires no API key or FRED connection.

`INDPRO.csv` is the same saved FRED series used in the book's industrial-production forecasting example. The source is the Board of Governors of the Federal Reserve System, distributed by FRED: https://fred.stlouisfed.org/series/INDPRO. The file contains monthly observations from January 1919 through August 2026; this example uses only January 1960 through December 2023. This saved sample reproduces the book's ARCH statistics. Later revisions to the underlying economic series can change results obtained from a fresh download.
