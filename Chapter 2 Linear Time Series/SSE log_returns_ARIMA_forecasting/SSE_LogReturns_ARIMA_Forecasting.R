##########################################################################################
# SSE Index Analysis: Visualization, Log Returns, ARIMA Modeling, and Forecasting
##########################################################################################

# Clear all objects from the environment
rm(list = ls())

# Load necessary libraries
# install.packages(c("ggplot2", "forecast", "tseries", "dplyr"))  # Uncomment if needed
library(ggplot2)
library(forecast)
library(tseries)
library(dplyr)

# Set working directory to the folder where this script is saved (optional: if using RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

##########################################################################################
# 1. Data Loading and Preprocessing
##########################################################################################

# Read the SSE data
sse <- read.csv("sse.csv")

# Ensure the 'Date' column is in Date format
sse$Date <- as.Date(sse$Date)

##########################################################################################
# 2. Plot SSE Index over Time
##########################################################################################

sse_plot <- ggplot(sse, aes(x = Date, y = SSE)) +
  geom_line(color = "blue") +
  labs(title = "SSE Index Over Time", x = "Date", y = "SSE Index") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", colour = "black"),
    plot.background = element_rect(fill = "white", colour = NA),
    axis.line = element_line(color = "black")
  )

# Display and save the SSE Index plot
print(sse_plot)
ggsave("sse_index_plot.png", plot = sse_plot, width = 10, height = 6)

##########################################################################################
# 3. Calculate Log Returns
##########################################################################################

sse$Log_Returns <- c(NA, diff(log(sse$SSE)))
sse <- na.omit(sse)  # Remove NA values created by differencing

##########################################################################################
# 4. Split Data into Training and Testing Sets
##########################################################################################

split_index <- floor(0.95 * nrow(sse))
train_data <- sse$Log_Returns[1:split_index]
test_data <- sse$Log_Returns[(split_index + 1):nrow(sse)]

##########################################################################################
# 5. ACF and PACF Plots for Training Data
##########################################################################################

# Save ACF plot
png(filename = "acf_SSE.png", width = 600, height = 400)
acf(train_data, main = "ACF of SSE Log Returns")
dev.off()

# Save PACF plot
png(filename = "pacf_SSE.png", width = 600, height = 400)
pacf(train_data, main = "PACF of SSE Log Returns")
dev.off()

##########################################################################################
# 6. Fit ARIMA Model and Forecast
##########################################################################################

# Fit an ARIMA model to training data
model <- auto.arima(train_data)
summary(model)

# Forecast for the length of the testing data
forecasts <- forecast(model, h = length(test_data))

##########################################################################################
# 7. Visualization: Training, Forecast, and Actual Data
##########################################################################################

# Prepare data frames for ggplot
train_df <- data.frame(Date = sse$Date[1:split_index], Value = train_data)
forecast_df <- data.frame(
  Date = sse$Date[(split_index + 1):nrow(sse)],
  Forecast = forecasts$mean,
  Lower = forecasts$lower[, "80%"],
  Upper = forecasts$upper[, "80%"]
)
actual_df <- data.frame(
  Date = sse$Date[(split_index + 1):nrow(sse)],
  Actual = test_data
)

# Create the final plot
final_plot <- ggplot() +
  geom_line(data = train_df, aes(x = Date, y = Value), color = "black") +
  geom_line(data = forecast_df, aes(x = Date, y = Forecast), color = "blue") +
  geom_ribbon(data = forecast_df, aes(x = Date, ymin = Lower, ymax = Upper), fill = "blue", alpha = 0.2) +
  geom_point(data = actual_df, aes(x = Date, y = Actual), color = "red") +
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m") +
  labs(title = "Training, Forecast, and Actual Data", x = "Date", y = "Log Returns") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", colour = "black"),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Display and save the forecast plot
print(final_plot)
ggsave("forecast_plot.png", plot = final_plot, width = 10, height = 6)
