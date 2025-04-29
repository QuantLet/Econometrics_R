##########################################################################################
# Simulating a Random Walk with Drift and Performing ADF Test
##########################################################################################

# Load required package
if (!requireNamespace("urca", quietly = TRUE)) {
  install.packages("urca")
}
library(urca)

# Load plotting library
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate Random Walk with Drift
##########################################################################################
# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

n <- 500         # Number of observations
delta <- 0.5     # Drift parameter
epsilon <- rnorm(n)  # White noise

# Initialize the series
y <- numeric(n)
y[1] <- 0  # Starting value

# Generate the random walk series with drift
for (t in 2:n) {
  y[t] <- y[t-1] + delta + epsilon[t]
}

##########################################################################################
# 2. Plot and Save the Simulated Random Walk
##########################################################################################

# Base R plot (show on screen)
plot(y, type = 'l', 
     main = 'Simulated Random Walk Series with Drift', 
     xlab = 'Time', 
     ylab = 'Value')

# Save the plot to a PNG file
png(filename = "random_walk_with_drift.png", width = 600, height = 400)
plot(y, type = 'l', 
     main = 'Simulated Random Walk Series with Drift', 
     xlab = 'Time', 
     ylab = 'Value')
dev.off()

##########################################################################################
# 3. Perform Augmented Dickey-Fuller (ADF) Test
##########################################################################################

# Conduct ADF test with drift term and lag selected by AIC
adf_test <- ur.df(y, type = 'drift', lags = 1, selectlags = "AIC")

# Output the ADF test results
summary(adf_test)
