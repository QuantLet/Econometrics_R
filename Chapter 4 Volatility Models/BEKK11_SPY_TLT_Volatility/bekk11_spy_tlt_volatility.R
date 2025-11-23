## =====================================================
## 1. Load packages & (optionally) set working directory
## =====================================================

# install.packages("BEKKs")   # run once if needed
# install.packages("quantmod")

library(BEKKs)
library(quantmod)

# Optional: set working directory to current script folder in RStudio
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)), silent = TRUE)
}

## =====================================================
## 2. Download daily prices from Yahoo (SPY & TLT)
## =====================================================

symbols <- c("SPY", "TLT")  # stock ETF + bond ETF

getSymbols(
  symbols,
  src         = "yahoo",
  from        = "2015-01-01",
  auto.assign = TRUE
)

# Extract adjusted close prices and merge into one xts object
price_xts <- na.omit(
  cbind(Ad(SPY), Ad(TLT))
)
colnames(price_xts) <- symbols

## =====================================================
## 3. Compute log returns and treat them as innovations
## =====================================================

# Daily log returns (in percent, optional scaling)
ret_xts <- na.omit(diff(log(price_xts)) * 100)

# Demean each series (so they look like residuals)
eps_xts <- sweep(ret_xts, 2, colMeans(ret_xts), FUN = "-")

# Quick sanity check
head(eps_xts)

## =====================================================
## 4. Specify and estimate a symmetric BEKK(1,1) model
## =====================================================

bekk_spec_obj <- bekk_spec()  # default: symmetric BEKK(1,1)

bekk_fit_obj <- bekk_fit(
  spec         = bekk_spec_obj,
  data         = eps_xts,   # use our bivariate return series
  QML_t_ratios = FALSE,
  max_iter     = 200,
  crit         = 1e-6
)

## =====================================================
## 5. Use base::summary() to avoid masked summary()
## =====================================================

base::summary(bekk_fit_obj)