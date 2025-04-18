rm(list=ls())
folder <- "/Users/sunjiajing/Desktop/Hong2020/advance time series analysis -20240328/R_code/advanced-time-series-chapter1"
setwd(folder)
set.seed(123) # For reproducibility
 
library("tsDyn")
library("stats") 
library("datasets") 
 
data <- ts(log10(datasets::lynx), start=1821, frequency=1)  
train <- data[1:80]
test <- data[81:114]
 
{par(mfrow=c(2,1))
  acf(train)
  pacf(train)}  

png("ACF_PACF_lynx_plots.png", width=800, height=600) 
{par(mfrow=c(2,1))
  acf(train)
  pacf(train)}  
dev.off()

# Lag plots: 
png("Lag_lynx_plots.png", width=800, height=600) 
{par(mfrow=c(2,2))
  scatter.smooth(Lag(train, 1), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-1", ylab = "t")
  scatter.smooth(Lag(train, 2), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-2", ylab = "t")
  scatter.smooth(Lag(train, 3), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-3", ylab = "t")
  scatter.smooth(Lag(train, 4), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-4", ylab = "t")
}
dev.off()

{par(mfrow=c(2,2))
  scatter.smooth(Lag(train, 1), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-1", ylab = "t")
  scatter.smooth(Lag(train, 2), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-2", ylab = "t")
  scatter.smooth(Lag(train, 3), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-3", ylab = "t")
  scatter.smooth(Lag(train, 4), train, span = 1/3, degree = 1,
                 family = c("symmetric", "gaussian"), evaluation = 50, 
                 xlab = "t-4", ylab = "t")
}


# Average Mutual Information 
par(mfrow=c(1,1)) 
mutualInformation(train)
png("mututal_information_lynx.png", width=800, height=600) 
{par(mfrow=c(1,1)) 
mutualInformation(train)}
dev.off()

# Likelihood Ratio test for threshold nonlinearity 

for (d in 1:3) {
  for (p in 1:3) {
    test_result <- thr.test(train, p=p, d=d) # Perform the test
    F_ratio <- test_result$F.ratio # Extract F-ratio
    df1 <- test_result$df[1] # First degree of freedom
    df2 <- test_result$df[2] # Second degree of freedom
    p_value <- test_result$p.value # Extract or calculate the p-value, assuming you have a way to do so 
    # Format and print the output 
    cat(sprintf("F-ratio = %.5f, df = [%d, %d], p-value = %.10f\n\n", F_ratio, df1, df2, p_value))
  }
}

# Hansen’s linearity test 
setarTest(train, m=3, nboot=500, test='1vs')
setarTest(train, m=3, nboot=500, test='2vs3')

selectSETAR(train, m=3, thDelay=1:2) 

# Start PNG device
png("grid_search_output.png", width=800, height=600)
selectSETAR(train, m=3, thDelay=1:2) 
# Turn off the device to save the plot
dev.off()

# Finalize the model setting 
model <- setar(train, m=3, thDelay = 2, th=2.940018)
summary(model)

# SETAR Model In-Sample Fitted Values
setar_fitted_values <- fitted(model) 

# Forecasting using TAR model \
# Initialize historical_values with the last known values from the training set
historical_values <- tail(train, 3)  # Adjust this based on your model's maximum lag
setar_forecast_values <- numeric(34)

# Initialize an empty vector to store your setar_forecast_values
for(i in 1:34) {
  # Determine the regime based on y(t-2)  
  regime <- ifelse(historical_values[2] <= 2.94, "low", "high")
  
  # Compute the next forecast based on the regime
  if (regime == "low") {
    next_forecast <- model$coefficients["const.L"] +
      model$coefficients["phiL.1"] * historical_values[3] +
      model$coefficients["phiL.2"] * historical_values[2] +
      model$coefficients["phiL.3"] * historical_values[1]  # Adjust as necessary for your model's specifics
  } else {
    next_forecast <- model$coefficients["const.H"] +
      model$coefficients["phiH.1"] * historical_values[3] +
      model$coefficients["phiH.2"] * historical_values[2] +
      model$coefficients["phiH.3"] * historical_values[1]  # Adjust similarly
  }
  
  # Store the forecast
  setar_forecast_values[i] <- next_forecast 
  
  # Update historical_values with the new forecast to use in the next iteration
  historical_values <- c(historical_values[-1], next_forecast)  # Shift historical_values for the next iteration
}


# The ARIMA process 
library(forecast)
model <- auto.arima(train) 
summary(model)  

# ARIMA Model In-Sample Fitted Values
arima_fitted_values <- fitted(model)

forecast_arima <- forecast(model, h=length(test))
arima_forecast_values <- forecast_arima$mean

# Plot the results 
# Convert the Time-Series object to a numeric vector
actual_values <- as.numeric(data)

# Prepare the actual data frame with correct years
actual_data <- data.frame(
  Time = 1821:(1821 + length(data) - 1),
  Value = as.numeric(data),
  Type = "Actual"
)

# Adjust 'forecast_data' and 'arima_forecast_data' to start after 'train'
forecast_data <- data.frame(
  Time = (1821 + length(train)):(1821 + length(train) + length(setar_forecast_values) - 1),
  Value = setar_forecast_values,
  Type = "SETAR Forecast"
)

arima_forecast_data <- data.frame(
  Time = (1821 + length(train)):(1821 + length(train) + length(arima_forecast_values) - 1),
  Value = arima_forecast_values,
  Type = "ARIMA Forecast"
)

# Combine the data frames
plot_data <- rbind(actual_data, forecast_data , arima_forecast_data)

library(ggplot2)
# Plotting with ggplot2
forecast_plot <-ggplot(plot_data, aes(x = Time, y = Value, color = Type)) +
  geom_line() +
  theme_minimal() +
  scale_color_manual(values = c("Actual" = "blue", "SETAR Forecast" = "red", "ARIMA Forecast" = "green")) +
  labs(title = "Lynx Data: Actual and Forecast",
       x = "Year",
       y = "Log10(Lynx Count)",
       color = "Data Type")

#  Calculating the Mean Squared Error (MSE) and Root Mean Squared Error (RMSE) 
#  for both the SETAR and ARIMA forecast models
 
# Display plot 
print(forecast_plot)

# Save the plot as a PNG file
ggsave("tar_arma_forecast_lynx_plot.png", plot = forecast_plot, width = 10, height = 6) 

# In-Sample Fit
# Calculate MSE and RMSE for SETAR Model
setar_insample_mse <- mean((train[-(1:3)] - setar_fitted_values[-(1:3)])^2)
setar_insample_rmse <- sqrt(setar_insample_mse)# Calculate MSE and RMSE for ARIMA Model
arima_insample_mse <- mean((train - arima_fitted_values)^2)
arima_insample_rmse <- sqrt(arima_insample_mse)

cat("SETAR In-Sample MSE:", setar_insample_mse, "\n")
cat("SETAR In-Sample RMSE:", setar_insample_rmse, "\n")
cat("ARIMA In-Sample MSE:", arima_insample_mse, "\n") 
cat("ARIMA In-Sample RMSE:", arima_insample_rmse, "\n")

# Forecasting MSFE and RMSFE
test_values <- as.numeric(test)
# Calculate forecasting MSE and RMSE
setar_msfe <- mean((test_values - setar_forecast_values)^2)
setar_rmsfe <- sqrt( setar_msfe)

arima_msfe <- mean((test_values - arima_forecast_values)^2)
arima_rmsfe <- sqrt( arima_msfe)

cat("SETAR MSFE:",  setar_msfe, "\n")
cat("SETAR RMSFE:",  setar_rmsfe, "\n")
cat("ARIMA MSFE:",  arima_msfe, "\n")
cat("ARIMA RMSFE:",  arima_rmsfe, "\n") 

