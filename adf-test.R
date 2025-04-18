# Set seed for reproducibility
set.seed(123)

# Simulate a random walk series
n <- 100 # Number of observations
delta <- 0.1  # Drift parameter
epsilon <- rnorm(n) # White noise - standard normal
y <- numeric(n) # Initialize the series
y[1] <- 0 # Starting value of the series

# Generate the random walk series
for (t in 2:n) {
  y[t] <- y[t-1] + delta + epsilon[t]
}

# Plot the series
plot(y, type = 'l', main = 'Simulated Random Walk Series', xlab = 'Time', ylab = 'Value')
# Install and load the urca package
if (!requireNamespace("urca", quietly = TRUE)) install.packages("urca")
library(urca)

# Perform the Augmented Dickey-Fuller test
adf_test <- ur.df(y, type = 'drift', lags = 1, selectlags = "AIC")

# Print the test results
summary(adf_test)
