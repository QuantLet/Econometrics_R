 
# Generates an AR(1) series where you can see the correlation decreasing over time in the ACF plot, 
# indicating a mixing condition.

# Creates a second series with artificially introduced correlation by averaging adjacent values, 
# and its ACF plot shows a different pattern, not indicative of mixing, as the correlation does not 
# decrease in the same way.


set.seed(123)
folder <- c("/Users/sunjiajing/Desktop/Hong2020/advance time series analysis -20240328/R代码/advanced-time-series-chapter1")
setwd(folder) 
# Install and load necessary package
if (!requireNamespace("forecast", quietly = TRUE)) install.packages("forecast")
library(forecast)
 

# Parameters for the AR(1) process
phi = 0.8
n = 1000
epsilon = rnorm(n)
Y = rep(0, n)

# Generate AR(1) series
Y[1] = epsilon[1]
for (t in 2:n) {
  Y[t] = phi * Y[t-1] + epsilon[t]
}

# Plot the AR(1) series
plot(Y, type = 'l', main = "AR(1) Time Series", xlab = "Time", ylab = "Value")

# Calculate and plot the autocorrelation function (ACF)
acf(Y, main = "ACF of AR(1) Series")

# Compare with a series with fixed correlation
# Generate a random series
Z = rnorm(n)

# Introduce fixed correlation by averaging adjacent values
Z_fixed_corr <- stats::filter(Z, c(1, 1)/2, sides=1)  

# Z_fixed_corr, is a new time series where each point is the average 
# of two consecutive points from the original series Z, smoothed to reduce short-term fluctuations.

# Since the filter introduces NA at the end, let's clean it
Z_fixed_corr_no_na = na.omit(Z_fixed_corr)

# Plot the series with fixed correlation
plot(Z_fixed_corr_no_na, type = 'l', main = "Series with Fixed Correlation", xlab = "Time", ylab = "Value")

# ACF for the series with fixed correlation, ensuring no NA values
acf(Z_fixed_corr_no_na, main = "ACF of Series with Fixed Correlation")