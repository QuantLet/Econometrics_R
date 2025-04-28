# Clear all objects in the environment
rm(list = ls())

# Set working directory
folder <- "/Users/sunjiajing/Desktop/github-econometrics/Econometrics_R/ARMA processes/ARMA"
setwd(folder)

# Load necessary libraries
library(ggplot2)
library(tseries)
library(forecast)
library(dplyr)

# Set seed for reproducibility
set.seed(123)

# Read the data
sse <- read.csv("sse.csv")

# Ensure the Date column is of type Date
sse$Date <- as.Date(sse$Date)

# Plot SSE index over time using ggplot2
sse_plot <- ggplot(sse, aes(x = Date, y = SSE)) +
  geom_line(color = "blue") + # Add blue line
  labs(title = "SSE Index Over Time", x = "Date", y = "SSE Index") +
  theme_minimal() + # Use minimal theme
  theme(
    panel.grid.major = element_line(color = "grey80"), # Change major grid line color
    panel.grid.minor = element_blank(), # Remove minor grid lines
    panel.background = element_rect(fill = "white"), # Set panel background to white
    plot.background = element_rect(fill = "white", colour = NA), # Set plot background to white
    axis.line = element_line(color = "black") # Add black axis lines
  )

# Display the plot
print(sse_plot)

# Save the time series plot as PNG
ggsave("sse_index_plot.png", plot = sse_plot, width = 10, height = 6)

# Calculate log returns
sse$Log_Returns <- c(NA, diff(log(sse$SSE)))
sse <- na.omit(sse) # Remove NA values caused by differencing

# Split the data into training and testing sets (95% training, 5% testing)
split_index <- floor(0.95 * nrow(sse))
train_data <- sse$Log_Returns[1:split_index]
test_data <- sse$Log_Returns[(split_index + 1):nrow(sse)]

# Save ACF plot of residuals as PNG
png(file = "acf_SSE.png")
acf(train_data)
dev.off() # Close the graphics device

# Save PACF plot of residuals as PNG
png(file = "pacf_SSE.png")
pacf(train_data)
dev.off() # Close the graphics device

# Create a new plotting window split into 1 row and 2 columns
par(mfrow = c(1, 2))
acf(train_data) # Draw ACF again to display in Plots pane
pacf(train_data) # Draw PACF again to display in Plots pane

# Fit ARIMA model to the training data
model <- auto.arima(train_data)
summary(model)

# Forecast using the model on the testing set
forecasts <- forecast(model, h = length(test_data))

# Prepare data for ggplot
train_df <- data.frame(Date = sse$Date[1:split_index], Value = train_data, Type = "Training Data")
forecast_df <- data.frame(Date = sse$Date[(split_index + 1):nrow(sse)], Forecast = forecasts$mean, Lower = forecasts$lower[, "80%"], Upper = forecasts$upper[, "80%"], Type = "Forecast Data")

# Plot training, forecast, and actual values using ggplot2
final_plot <- ggplot() +
  geom_line(data = train_df, aes(x = Date, y = Value, group = 1), color = "black") +
  geom_line(data = forecast_df, aes(x = Date, y = Forecast, group = 1), color = "blue") +
  geom_ribbon(data = forecast_df, aes(x = Date, ymin = Lower, ymax = Upper, group = 1), fill = "blue", alpha = 0.2) +
  geom_point(data = data.frame(Date = sse$Date[(split_index + 1):nrow(sse)], Actual = test_data), aes(x = Date, y = Actual), color = "red") +
  scale_x_date(date_breaks = "3 month", date_labels = "%Y-%m") +
  labs(title = "Training, Forecast, and Actual Data", x = "Date", y = "Log Returns") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", colour = "black"),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Display the final plot
print(final_plot)

# Save the final plot as PNG
ggsave("forecast_plot.png", plot = final_plot, width = 10, height = 6)
