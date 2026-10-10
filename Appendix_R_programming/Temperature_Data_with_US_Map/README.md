<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of Quantlet: Temperature Data with US Map

Published in: Econometrics_R

Description: This R script downloads official GHCN-Daily station metadata and inventory files, then retrieves 2014 daily maximum temperature (TMAX) observations in metric units from NOAA's NCEI Daily Summaries service. For each of the 48 contiguous states, it identifies active stations near the state capital, checks actual 2014 coverage, and selects one representative station. It plots daily TMAX for New York City Central Park and maps the annual mean of daily TMAX at each selected representative station using state polygons from the maps package. The mapped values are representative-station means, not statewide spatial averages.

Keywords: Climate Data, GHCN-Daily, NOAA, NCEI, Daily Summaries API, TMAX, Temperature, Weather, Representative Stations, State Capitals, Contiguous United States, ggplot2, maps, Spatial Visualization, R

Author: Jiajing Sun

Submitted: 1 May 2025

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Appendix_R_programming/Temperature_Data_with_US_Map/NY_Temperature_2014.png" alt="Image" />
</div>

<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/Econometrics_R/main/Appendix_R_programming/Temperature_Data_with_US_Map/US_Temperature_Map_2014.png" alt="Map of the contiguous United States showing the 2014 annual mean of daily maximum temperature at one station near each state capital. Each state is coloured using its selected station’s value. White lines mark state boundaries. The colour scale below the map runs from dark purple for cooler values through magenta and orange to yellow for warmer values, from the low teens to just above 30 degrees Celsius. Northern states are generally cooler, southern states warmer, and Arizona has one of the highest values." />
</div>


## Saved observations

The [2014 data snapshot](data_2014_snapshot/) contains the temperature observations, station choices and source metadata. It includes instructions for running the plotting sections without repeating the API downloads. The original online R script is unchanged.
