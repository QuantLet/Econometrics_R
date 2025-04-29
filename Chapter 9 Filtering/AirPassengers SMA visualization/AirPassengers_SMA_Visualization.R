##########################################################################################
# Simple Moving Average (SMA) on AirPassengers Time Series Data
##########################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load the built-in AirPassengers dataset
data("AirPassengers")

##########################################################################################
# 1. Compute 12-Month Simple Moving Average (SMA)
##########################################################################################

# Define the window size (12 months for annual smoothing)
window_size <- 12

# Compute the centered simple moving average using stats::filter
sma <- stats::filter(AirPassengers, rep(1 / window_size, window_size), sides = 2)

##########################################################################################
# 2. Plot and Save the Time Series with SMA Overlay
##########################################################################################

# Save the plot as a PNG file
png(filename = "AirPassengers_12Month_SMA.png", width = 800, height = 600)

# Create the plot
plot(AirPassengers, type = "l", col = "blue", ylim = c(100, 700),
     main = "AirPassengers Data with 12-Month SMA",
     ylab = "Number of Passengers", xlab = "Year")
lines(sma, col = "red", lwd = 2)
legend("topright", legend = c("Original", "12-Month SMA"),
       col = c("blue", "red"), lty = 1, lwd = 2)

# Finalize and save the plot
dev.off()

# Optional: Show plot interactively
plot(AirPassengers, type = "l", col = "blue", ylim = c(100, 700),
     main = "AirPassengers Data with 12-Month SMA",
     ylab = "Number of Passengers", xlab = "Year")
lines(sma, col = "red", lwd = 2)
legend("topright", legend = c("Original", "12-Month SMA"),
       col = c("blue", "red"), lty = 1, lwd = 2)
