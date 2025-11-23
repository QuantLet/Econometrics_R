## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages(c("quantmod", "rugarch", "forecast", "MSwM"))
library(quantmod)
library(rugarch)
library(forecast)
library(MSwM)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Download SPY prices for 2024 and compute log returns
## =====================================================

set.seed(123)  # For reproducibility

# Daily SPY prices from Yahoo Finance starting 2024-01-01
spy_xts <- getSymbols(
  "SPY",
  src         = "yahoo",
  from        = "2024-01-01",
  auto.assign = FALSE
)

# Adjusted closing prices and log returns
spy_price <- Ad(spy_xts)
spy_ret   <- diff(log(spy_price))
spy_ret   <- na.omit(spy_ret)              # remove initial NA
log_ret   <- as.numeric(spy_ret)

## =====================================================
## 3. Fit ARMA model to log returns
## =====================================================

arma_fit <- auto.arima(
  log_ret,
  seasonal      = FALSE,
  stepwise      = FALSE,
  approximation = FALSE
)

summary(arma_fit)

## =====================================================
## 4. GARCH-family model estimation (conditional variance)
## =====================================================

# Standard GARCH(1,1)
spec_garch <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE)
)
garch_fit <- ugarchfit(spec = spec_garch, data = log_ret)

# EGARCH(1,1)
spec_egarch <- ugarchspec(
  variance.model = list(model = "eGARCH", garchOrder = c(1,  1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE)
)
egarch_fit <- ugarchfit(spec = spec_egarch, data = log_ret)

# GJR-GARCH(1,1)
spec_gjrgarch <- ugarchspec(
  variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE)
)
gjrgarch_fit <- ugarchfit(spec = spec_gjrgarch, data = log_ret)

# Threshold GARCH (TGARCH) as fGARCH submodel
spec_tgarch <- ugarchspec(
  variance.model = list(model = "fGARCH",
                        submodel   = "TGARCH",
                        garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE)
)
tgarch_fit <- ugarchfit(spec = spec_tgarch, data = log_ret)

## =====================================================
## 5. Markov-switching model for returns (two regimes)
## =====================================================

ret_df  <- data.frame(log_ret = log_ret)
ms_form <- log_ret ~ 1   # intercept-only switching mean

# sw: logical vector indicating which parameters can switch
ms_fit <- msmFit(ms_form, data = ret_df, k = 2, sw = c(TRUE, TRUE))

## =====================================================
## 6. Display estimation results
## =====================================================

garch_fit
egarch_fit
gjrgarch_fit
tgarch_fit
ms_fit