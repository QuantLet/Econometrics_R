##########################################################################################
# Simulation of Single and Multiple Random Walks
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required library
library(ggplot2)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate a Single Random Walk
##########################################################################################

T <- 1000  # Total number of observations

# Simulate Y_t = Y_{t-1} + epsilon_t
Y <- numeric(T)
for (t in 2:T) {
  Y[t] <- Y[t - 1] + rnorm(1)
}

# Plot single realization
png('single_realization.png', width = 600, height = 400)
plot(Y, type = 'l', main = 'Single Realization of a Random Walk Process', 
     xlab = 'Time', ylab = 'Y')
dev.off()

# Estimate mean and variance from the single realization
mu_hat <- mean(Y)
sigma_hat_sq <- var(Y)

##########################################################################################
# 2. Simulate Multiple Random Walks and Analyze at a Specific Time Point
##########################################################################################

N <- 50       # Number of random walk paths
t_point <- 100  # Time point for ensemble statistics

# Initialize matrix to store random walk paths
random_walks <- matrix(nrow = N, ncol = T)

# Generate N independent random walks
set.seed(0)  # New seed for ensemble simulation
for (i in 1:N) {
  epsilon <- rnorm(T)  # Random increments
  random_walks[i, ] <- cumsum(epsilon)
}

# Plot the 50 random walk paths
png('50_random_walks_plot.png', width = 600, height = 400)
par(mar = c(4, 4, 2, 1))  # Set margins
matplot(t(random_walks), type = 'l', lty = 1, 
        col = rgb(0, 0, 0, 0.3), ylim = range(random_walks),
        xlab = 'Time', ylab = 'Random Walk', 
        main = '50 Independent Random Walk Paths')
dev.off()

# Calculate ensemble average and variance at time t = 100
ensemble_average_t100 <- mean(random_walks[, t_point])
ensemble_variance_t100 <- var(random_walks[, t_point])

##########################################################################################
# 3. Output Results
##########################################################################################

cat("=== Single Realization Estimates ===\n")
cat("mu_hat:", mu_hat, "\n")
cat("sigma_hat_sq:", sigma_hat_sq, "\n\n")

cat("=== Ensemble Statistics at t = 100 ===\n")
cat(sprintf("Ensemble average at t=100: %.6f\n", ensemble_average_t100))
cat(sprintf("Ensemble variance at t=100: %.6f\n", ensemble_variance_t100))
