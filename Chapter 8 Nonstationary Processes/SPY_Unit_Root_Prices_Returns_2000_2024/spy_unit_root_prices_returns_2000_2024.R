## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Packages needed: data download, manipulation, and unit root tests
pkgs <- c("quantmod", "dplyr", "urca")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

library(quantmod)
library(dplyr)
library(urca)

## =====================================================
## 2. Download SPY data from Yahoo Finance and
##    construct log prices and log returns
## =====================================================

# Download daily data for SPY starting from 2000-01-01
spy_xts <- getSymbols("SPY", src = "yahoo",
                      from = "2000-01-01",
                      to = "2024-12-31", 
                      auto.assign = FALSE)

# Build a data frame with date, price, log price and log return
spy_df <- data.frame(
  date  = index(spy_xts),
  price = as.numeric(Ad(spy_xts))
) %>%
  filter(!is.na(price)) %>%
  arrange(date) %>%
  mutate(
    log_price  = log(price),
    log_return = c(NA_real_, diff(log_price))
  )

## =====================================================
## 3. Define full-sample and recent-sample windows
## =====================================================

# Full sample: all available data
spy_full <- spy_df

# Recent sample: e.g. data from 2024-01-01 onwards
cutoff_recent <- as.Date("2024-01-01")
spy_recent <- spy_df %>%
  filter(date >= cutoff_recent)

## Helper function to run DF/ADF and KPSS tests on a series
run_unit_root_tests <- function(x, series_name = "", 
                                adf_type = c("drift", "none"),
                                kpss_trend = TRUE) {
  adf_type <- match.arg(adf_type)
  
  # Remove NAs (e.g. first log return)
  x <- na.omit(x)
  
  cat("\n==================================================\n")
  cat("Series:", series_name, "\n")
  cat("Number of observations:", length(x), "\n")
  cat("==================================================\n")
  
  ## -------------------------
  ## Augmented Dickey–Fuller (ADF)
  ## -------------------------
  adf_obj <- ur.df(x,
                   type      = adf_type,   # "drift" for prices, "none" for returns
                   lags      = 1,
                   selectlags = "AIC")
  cat("\nADF (ur.df) results:\n")
  print(summary(adf_obj))
  
  ## -------------------------
  ## KPSS tests (level and trend)
  ## -------------------------
  # Level-stationary null
  kpss_mu <- ur.kpss(x, type = "mu", lags = "short")
  cat("\nKPSS (level-stationary null, type = 'mu'):\n")
  print(summary(kpss_mu))
  
  # Trend-stationary null (for series that may have a deterministic trend)
  if (kpss_trend) {
    kpss_tau <- ur.kpss(x, type = "tau", lags = "short")
    cat("\nKPSS (trend-stationary null, type = 'tau'):\n")
    print(summary(kpss_tau))
  }
}

## =====================================================
## 4. Unit root tests on log prices: full vs recent sample
##    (log prices are often close to I(1))
## =====================================================

# Full sample: log price with drift in ADF and both KPSS variants
run_unit_root_tests(
  x            = spy_full$log_price,
  series_name  = "SPY log price (full sample)",
  adf_type     = "drift",
  kpss_trend   = TRUE
)

# Recent sample: log price since 2024
run_unit_root_tests(
  x            = spy_recent$log_price,
  series_name  = "SPY log price (recent sample, from 2024)",
  adf_type     = "drift",
  kpss_trend   = TRUE
)

## =====================================================
## 5. Unit root tests on log returns: full vs recent sample
##    (log returns are typically closer to I(0))
## =====================================================

# For returns, it is common to use an ADF without drift,
# and KPSS with a level-stationary null.
run_unit_root_tests(
  x            = spy_full$log_return,
  series_name  = "SPY log return (full sample)",
  adf_type     = "none",
  kpss_trend   = FALSE   # only level-stationary KPSS
)

run_unit_root_tests(
  x            = spy_recent$log_return,
  series_name  = "SPY log return (recent sample, from 2024)",
  adf_type     = "none",
  kpss_trend   = FALSE
)