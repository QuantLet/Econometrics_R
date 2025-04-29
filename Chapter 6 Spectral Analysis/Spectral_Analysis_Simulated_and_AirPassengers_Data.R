##########################################################################################
# Spectral Analysis of Simulated Data and AirPassengers Dataset
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear all objects from the workspace
rm(list = ls())

# Load necessary dataset
data("AirPassengers")

##########################################################################################
# 1. Simulate Time Series Data and Perform Spectral Analysis
##########################################################################################

# Define the time sequence
t <- seq(0, 100, by = 0.1)

# Generate time series data
x <- cos(2 * pi * t / 10) + 0.75 * sin(2 * pi * t / 5)

# Plot and save the simulated time series and its spectrum
png("simulated_timeseries_and_spectrum.png", width = 800, height = 600)
par(mfrow = c(2, 1))  # Set up 2 plots in 1 column
plot(t, x, type = 'l', main = "Simulated Time Series", xlab = "Time", ylab = "x(t)")
spectrum(x, main = "Spectrum of Simulated Time Series", xlab = "Frequency", ylab = "Spectral Density")
dev.off()

# Also display the plots
par(mfrow = c(2, 1))
plot(t, x, type = 'l', main = "Simulated Time Series", xlab = "Time", ylab = "x(t)")
spectrum(x, main = "Spectrum of Simulated Time Series", xlab = "Frequency", ylab = "Spectral Density")

##########################################################################################
# 2. Spectral Analysis of AirPassengers Dataset
##########################################################################################

# Plot and save the AirPassengers series and its spectrum
png("AirPassengers_timeseries_and_spectrum.png", width = 800, height = 600)
par(mfrow = c(2, 1))
plot(AirPassengers, 
     main = "Monthly Airline Passengers (1949-1960)", 
     ylab = "Number of Passengers", xlab = "Time")

# Spectral analysis with smoothing and detrending
ap_spectrum <- spectrum(AirPassengers, spans = c(3, 3), detrend = TRUE)
plot(ap_spectrum, 
     main = "Spectral Density of AirPassengers Data", 
     xlab = "Frequency", ylab = "Spectral Density")
dev.off()

# Also display the plots
par(mfrow = c(2, 1))
plot(AirPassengers, 
     main = "Monthly Airline Passengers (1949-1960)", 
     ylab = "Number of Passengers", xlab = "Time")

spectrum(AirPassengers, spans = c(3, 3), detrend = TRUE, 
         main = "Spectral Density of AirPassengers Data", 
         xlab = "Frequency", ylab = "Spectral Density")

##########################################################################################
# 3. Find the Frequency with the Highest Spectral Density
##########################################################################################

# Find the frequency corresponding to the highest spectral density
max_density_index <- which.max(ap_spectrum$spec)
highest_frequency <- ap_spectrum$freq[max_density_index]

# Print the highest frequency
cat("The highest frequency is:", highest_frequency, "\n")
