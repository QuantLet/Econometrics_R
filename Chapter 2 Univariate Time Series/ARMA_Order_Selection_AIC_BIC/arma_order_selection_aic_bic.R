## =====================================================
## 1. Simulate ARMA(1,1) data
## =====================================================

set.seed(123)
n    <- 500
data <- arima.sim(n = n, model = list(ar = 0.5, ma = 0.4))

## =====================================================
## 2. Load forecast package
## =====================================================

# install.packages("forecast")  # if not already installed
library(forecast)

## =====================================================
## 3. Select ARMA order using AIC and BIC
## =====================================================

fit_aic <- auto.arima(data, ic = "aic", stepwise = FALSE, approximation = FALSE)
fit_bic <- auto.arima(data, ic = "bic", stepwise = FALSE, approximation = FALSE)

## =====================================================
## 4. Output selected models
## =====================================================

print(fit_aic)
print(fit_bic)
