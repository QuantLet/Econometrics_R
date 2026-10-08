## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set folder to current script location (in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load necessary packages
# install.packages("forecast")
# install.packages("ggplot2")
library(forecast)
library(ggplot2)

## =====================================================
## 2. Simulate ARMA(1,1) data
## =====================================================

set.seed(123)   # For reproducibility
n    <- 200     # Number of data points
simulated_data <- arima.sim(list(ar = 0.5, ma = 0.3), n = n)

## =====================================================
## 3. Fit ARMA(1,1), forecast, and plot forecasts
## =====================================================

fit             <- Arima(simulated_data, order = c(1, 0, 1))
forecast_result <- forecast(fit, h = 20)

p_forecast <- autoplot(forecast_result) +
  labs(title = "Forecast from an ARMA(1,1) model. Dark and light bands are pointwise 80% and 95% Gaussian plug-in prediction intervals", x = "Time", y = "Value")

ggsave("forecast_result.png", plot = p_forecast, width = 6, height = 4, dpi = 300)
