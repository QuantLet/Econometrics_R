# Load necessary libraries
# install.packages("forecast")
library(forecast)

# Simulate ARMA(1,1) data
set.seed(123)  # Set random seed for reproducibility
n <- 200  # Number of data points
# simulated_data <- arima.sim(list(ar=0.5, ma=0.3), n=n)

# You can also simulate higher order ARMA process as follows: 

 ar_coefficients <- c(0.5, -0.25, 0.2, -0.15, 0.1)
 ma_coefficients <- c(0.3, -0.2, 0.1)

 simulated_data <- arima.sim(n = n, model = list(ar = ar_coefficients, ma = ma_coefficients))

# Save the plot of simulated data as PNG file
png(filename="simulated_data.png")
plot(simulated_data, main="Simulated ARMA(5,3 Data", 
     xlab="Time", ylab="Value")
dev.off()

# Fit ARMA(1,1) model
fit <- Arima(simulated_data, order=c(5,0,3))

# Predict next 20 data points
forecast_result <- forecast(fit, h=20)

# Save the plot of forecast result as PNG file
png(filename="forecast_result.png")
plot(forecast_result, main="Forecast from ARMA(5,3) Model", 
     xlab="Time", ylab="Value")
dev.off()