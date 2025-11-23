## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages("WDI")     # run once if needed
# install.packages("ggplot2") # run once if needed

library(WDI)
library(ggplot2)

# (Optional) set working directory to current script folder in RStudio
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Download real GDP growth from World Bank (annual)
## =====================================================

# Indicator: Real GDP growth (annual %, constant prices)
ind_code <- "NY.GDP.MKTP.KD.ZG"

gdp_us <- WDI(
  country   = "US",
  indicator = ind_code,
  start     = 1960,
  end       = 2024
)

# Sort by year
gdp_us <- gdp_us[order(gdp_us$year), ]

# Drop rows with missing GDP growth
gdp_us <- gdp_us[!is.na(gdp_us[[ind_code]]), ]

## Quick check
head(gdp_us)

## =====================================================
## 3. Construct ANNUAL time-series object
## =====================================================

y_vec <- gdp_us[[ind_code]]  # numeric series
yrs   <- gdp_us$year

start_year <- min(yrs, na.rm = TRUE)

# Annual data: frequency = 1
y_ts <- ts(y_vec, start = start_year, frequency = 1)

## =====================================================
## 4. Time-domain plot with ggplot2
## =====================================================

df_ts <- data.frame(
  year  = yrs,
  value = y_vec
)

p_time <- ggplot(df_ts, aes(x = year, y = value)) +
  geom_line() +
  geom_point() +
  ggtitle("US Real GDP Growth (Annual %, WDI)") +
  xlab("Year") +
  ylab("Growth rate (%)") 

print(p_time)

# (optional) save time plot
ggsave(
  "wdi_annual_gdp_growth_timeseries.png",
  p_time,
  width = 6, height = 4, dpi = 300
)

## =====================================================
## 5. Spectral analysis (annual data)
## =====================================================

spec_obj <- spectrum(y_ts, spans = c(3, 3), detrend = TRUE, plot = FALSE)

spec_df <- data.frame(
  freq = spec_obj$freq,
  spec = spec_obj$spec
)

p_spec <- ggplot(spec_df, aes(x = freq, y = spec)) +
  geom_line() +
  labs(
    title = "Smoothed spectral density of US annual GDP growth",
    x     = "Frequency",
    y     = "Spectral density"
  )  

print(p_spec)

# Save the spectral plot
ggsave(
  "wdi_annual_gdp_growth_spectrum.png",
  p_spec,
  width = 6, height = 4, dpi = 300
)