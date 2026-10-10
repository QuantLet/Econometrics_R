## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages(c("quantmod", "rugarch", "forecast", "MSwM"))
library(quantmod)
library(rugarch)
library(forecast)
library(MSwM)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Read January 2024--November 2025 prices and compute returns
## =====================================================

set.seed(123)  # For reproducibility

# Fixed Yahoo Finance adjusted-price snapshot supplied with the code.
spy_data <- read.csv("SPY_adjusted_20240102_20251114.csv")
spy_xts <- xts(spy_data$adjusted, order.by = as.Date(spy_data$date))


# Adjusted closing prices and log returns
spy_price <- spy_xts
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
