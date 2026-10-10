# Saved 2014 temperature data

This snapshot contains the NOAA daily maximum-temperature observations used by the Appendix A example. It was retrieved on 10 October 2026 from NCEI's Daily Summaries service with `units=metric` and `dataTypes=TMAX`. Temperatures are already in degrees Celsius; do not divide them by ten. The dates of the observations are in 2014.

| File | Contents |
|---|---|
| `daily_tmax_2014.csv` | 77,752 station-date records for 222 stations; columns `id`, `date`, `tmax`. Missing values, where present, are `NA`. |
| `candidate_stations_2014.csv` | The five candidate stations nearest each of the 48 contiguous state capitals, their distances and observed TMAX coverage. |
| `representative_stations_2014.csv` | One selected station per contiguous state, using the selection rule in section 5 of the original script. |
| `nyc_daily_tmax_2014.csv` | The 365 daily records for New York City Central Park, station `USW00094728`. |
| `ghcnd-stations.txt.gz`, `ghcnd-inventory.txt.gz` | Compressed copies of the official metadata files used for station selection. |
| `manifest.json` | Source addresses, request parameters, units, retrieval date and SHA-256 checksums. |

## Use the saved observations

From this example's directory, load the packages and saved objects below, then run sections 6–8 of `Download_Data_and_Spatial_Plot.R` to draw the figures and report station coverage. The original script retains its online download procedure in sections 1–5.

```r
library(dplyr)
library(ggplot2)
library(maps)
library(viridis)

analysis_year <- 2014L
nyc_station <- "USW00094728"
snapshot_dir <- "data_2014_snapshot"
daily_data <- read.csv(file.path(snapshot_dir, "daily_tmax_2014.csv"))
daily_data$date <- as.Date(daily_data$date)
representative_stations <- read.csv(
  file.path(snapshot_dir, "representative_stations_2014.csv")
)
```

Each map value is the annual mean of daily maximum temperature at the selected station near a state capital. It is not an average over the area of the state. The snapshot request selects TMAX only; it does not archive other weather variables returned by the service. The older `US_Temperature_2014.RData` file is retained separately and is not this snapshot.

Source: NOAA National Centers for Environmental Information, GHCN-Daily station files and Daily Summaries service. The source files are public data. The map boundaries come from the R `maps` package.
