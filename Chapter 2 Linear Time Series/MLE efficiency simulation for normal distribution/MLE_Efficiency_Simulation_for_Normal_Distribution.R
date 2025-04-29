##########################################################################################
# Set working directory to the folder where this script is saved
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}
##########################################################################################

##########################################################################################
# Simulating MLE Efficiency for Normal Distribution Parameters
##########################################################################################

# Set seed for reproducibility
set.seed(123)

# Define true parameters
mu_true <- 5        # True mean
sigma_true <- 2     # True standard deviation
n <- 1000           # Sample size per simulation
num_simulations <- 100000  # Number of simulations

# Initialize vectors to store MLE estimates
mu_mle_values <- numeric(num_simulations)
sigma_mle_values <- numeric(num_simulations)

##########################################################################################
# Simulation: Perform multiple MLE estimations
##########################################################################################

for (i in 1:num_simulations) {
  sample <- rnorm(n, mean = mu_true, sd = sigma_true)
  mu_mle_values[i] <- mean(sample)                     # MLE for mean
  sigma_mle_values[i] <- sqrt(var(sample))              # MLE for standard deviation
}

##########################################################################################
# Results: Check Efficiency of MLE Estimates
##########################################################################################

cat("=== Summary of MLE Estimates ===\n")
cat("Average of mu MLE:", mean(mu_mle_values), "\n")  
cat("Average of sigma^2 MLE:", mean(sigma_mle_values^2), "\n\n")

##########################################################################################
# Visualization: Distribution of MLE Estimates
##########################################################################################

# Save histogram of mu MLE
png(filename = "mu_mle_distribution.png", width = 600, height = 400)
hist(mu_mle_values, 
     main = "Distribution of MLE for mu", 
     xlab = "MLE of mu", 
     breaks = 30, 
     probability = TRUE, 
     col = rgb(0.2, 0.8, 0.5, 0.7))
lines(density(mu_mle_values), col = "red", lwd = 2)
dev.off()

# Save histogram of sigma MLE
png(filename = "sigma_mle_distribution.png", width = 600, height = 400)
hist(sigma_mle_values, 
     main = "Distribution of MLE for sigma", 
     xlab = "MLE of sigma", 
     breaks = 30, 
     probability = TRUE, 
     col = rgb(0.2, 0.8, 0.5, 0.7))
lines(density(sigma_mle_values), col = "red", lwd = 2)
dev.off()
