##########################################################################################
# Set working directory to the folder where this script is saved
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}
##########################################################################################

##########################################################################################
# Simulating ARMA(1,1) Data, Model Selection, Fitting, and Forecasting
##########################################################################################

# Load necessary libraries
# install.packages("forecast") # Uncomment if not installed
library(forecast)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate ARMA(1,1) Data
##########################################################################################

n <- 500  # Number of observations
arma_data <- arima.sim(n = n, model = list(ar = 0.5, ma = 0.4))

# Save plot of simulated data
png(filename = "simulated_arma11_data.png", width = 600, height = 400)
plot(arma_data, main = "Simulated ARMA(1,1) Data", xlab = "Time", ylab = "Value")
dev.off()

##########################################################################################
# 2. Model Selection using AIC and BIC
##########################################################################################

# Select ARMA order using AIC
fit_aic <- auto.arima(arma_data, ic = "aic", stepwise = FALSE, approximation = FALSE)

# Select ARMA order using BIC
fit_bic <- auto.arima(arma_data, ic = "bic", stepwise = FALSE, approximation = FALSE)

# Output selected model parameters
cat("=== Model selected by AIC ===\n")
print(fit_aic)

cat("\n=== Model selected by BIC ===\n")
print(fit_bic)

##########################################################################################
# 3. Fit ARMA(1,1) Model and Forecast Future Values
##########################################################################################

# (For forecasting, use new simulated data if needed)
set.seed(123)
n_forecast <- 200
forecast_data <- arima.sim(list(ar = 0.5, ma = 0.3), n = n_forecast)

# Fit an ARMA(1,1) model
fit_forecast <- Arima(forecast_data, order = c(1, 0, 1))

# Forecast next 20 points
forecast_result <- forecast(fit_forecast, h = 20)

# Save plot of forecast results
png(filename = "arma11_forecast_result.png", width = 600, height = 400)
plot(forecast_result, main = "Forecast from ARMA(1,1) Model", xlab = "Time", ylab = "Value")
dev.off()
