# Load required library
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# Set the working directory 
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}


# Define parameters for the simulation 
T <- 1000    # total number of observations

# Simulate a single realization of the process Y_t = Y_{t-1} + epsilon_t
Y <- numeric(T)
for (t in 2:T) {
  Y[t] <- Y[t - 1] + rnorm(1)
}

# Plot the single realization
png('single_realization.png', width = 400, height = 400)
plot(Y, type = 'l', main = 'Single Realization of a Random Walk Process', 
     xlab = 'Time', ylab = 'Y')
dev.off()

# Estimate by taking sample averages
mu_hat <- mean(Y)
sigma_hat_sq <- var(Y)

# Define the sample size and number of paths
N <- 50    # Number of paths
t_point <- 100  # Time point for ensemble average and variance calculation

# Initialize an array to store the random walks
random_walks <- matrix(nrow = N, ncol = T)

# Generate N random walks
for (i in 1:N) {
  epsilon <- rnorm(T)  # Generate random normal increments
  random_walks[i, ] <- cumsum(epsilon)  # CUSUM to get the random walk path
}

# Determine y-limits based on the min and max of all paths
y_min <- min(random_walks)
y_max <- max(random_walks)

# Plot the 50 random walk paths with adjusted y-limits
png('50_random_walks_plot.png', width = 400, height = 400)
par(mar = c(4, 4, 2, 1))  # Set margins
matplot(t(random_walks), type = 'l', lty = 1, 
        col = alpha('black', 0.5), ylim = c(y_min, y_max),
        xlab = 'Time', ylab = 'Random Walk', main = '50 Independent Random Walk Paths')
dev.off()

# Calculate ensemble average and variance at t=100
ensemble_average_t100 <- mean(random_walks[, t_point])
ensemble_variance_t100 <- var(random_walks[, t_point])

# Print out estimates for single realization
cat("Single Realization Estimates:\n")
cat("mu_hat:", mu_hat, "\nsigma_hat_sq:", sigma_hat_sq, "\n\n")

# Output the results for ensemble at t=100
cat(sprintf("Ensemble average at t=100: %f\\n", ensemble_average_t100))
cat(sprintf("Ensemble variance at t=100: %f", ensemble_variance_t100))