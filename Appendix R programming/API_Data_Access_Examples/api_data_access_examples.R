## =====================================================
## World Bank data via the WDI package
## =====================================================

# install.packages(c("WDI", "dplyr", "ggplot2"))
library(WDI)
library(dplyr)
library(ggplot2)

# Search for indicators related to GDP per capita
WDIsearch("gdp per capita") |> head()

# Download GDP per capita and population for selected countries, 1990-2022
wdi_data <- WDI(
  country = c("US", "GB", "CN"),
  indicator = c(
    gdp_pc = "NY.GDP.PCAP.KD",
    pop    = "SP.POP.TOTL"
  ),
  start = 1990,
  end   = 2022
)

# Plot GDP per capita over time
ggplot(wdi_data, aes(x = year, y = gdp_pc, color = country)) +
  geom_line() +
  labs(title = "GDP per Capita (constant 2015 USD)",
       x = "Year", y = "GDP per capita", color = "Country")

## =====================================================
## Financial time series from Yahoo Finance
## =====================================================

# install.packages("quantmod")
library(quantmod)

# Download daily prices for Apple Inc. from Yahoo Finance
getSymbols("AAPL", src = "yahoo")
head(AAPL)

## =====================================================
## FRED, OECD, and Eurostat examples
## =====================================================

# install.packages("fredr")
library(fredr)

fred_api_key <- Sys.getenv("FRED_API_KEY")
if (nzchar(fred_api_key)) {
  fredr_set_key(fred_api_key)
  cpi <- fredr(series_id = "CPIAUCSL",
               observation_start = as.Date("2000-01-01"))
  head(cpi)
} else {
  message("Set FRED_API_KEY to run the FRED example.")
}

# install.packages("OECD")
library(OECD)
oecd_datasets <- get_datasets()
head(oecd_datasets)

# install.packages("eurostat")
library(eurostat)
unemp <- get_eurostat("une_rt_m", time_format = "date")
head(unemp)
