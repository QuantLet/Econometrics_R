## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(ggplot2)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate a single random walk realization
##    Y_t = Y_{t-1} + epsilon_t
## =====================================================

set.seed(0)            # For reproducibility

T_len <- 1000          # Total number of observations

# Generate random walk increments and cumulative sum
eps_single <- rnorm(T_len)
Y          <- cumsum(eps_single)

# Estimate mean and variance from the single realization
mu_hat       <- mean(Y)
sigma_hat_sq <- var(Y)

# Data frame for plotting
df_single <- data.frame(
  Time  = 1:T_len,
  Value = Y
)

# Plot: single realization (square figure)
p_single <- ggplot(df_single, aes(x = Time, y = Value)) +
  geom_line() +
  labs(title = "Single realization of a random walk", x = "Time", y = "Y")  

ggsave("single_realization.png", plot = p_single,
       width = 6, height = 4, dpi = 300)

## =====================================================
## 3. Simulate N independent random walks and compute
##    ensemble statistics at a fixed time point
## =====================================================

N       <- 50    # Number of paths
t_point <- 100   # Time point for ensemble average / variance

random_walks <- matrix(NA_real_, nrow = N, ncol = T_len)

for (i in 1:N) {
  eps_i <- rnorm(T_len)
  random_walks[i, ] <- cumsum(eps_i)
}

# Ensemble average and variance at t = t_point
ensemble_average_t100  <- mean(random_walks[, t_point])
ensemble_variance_t100 <- var(random_walks[, t_point])

## =====================================================
## 4. Plot 50 random walk paths (square figure)
## =====================================================

# Reshape to long format for ggplot2
df_paths <- data.frame(
  Time  = rep(1:T_len, times = N),
  Path  = factor(rep(1:N, each = T_len)),
  Value = as.vector(t(random_walks))
)

p_paths <- ggplot(df_paths, aes(x = Time, y = Value, group = Path)) +
  geom_line(alpha = 0.4) +
  labs(title = "50 independent random walk paths", x = "Time", y = "Random walk") 

ggsave("50_random_walks_plot.png", plot = p_paths,
       width = 6, height = 4, dpi = 300)

## =====================================================
## 5. Print estimates
## =====================================================

cat("Single realization estimates:\n")
cat("mu_hat:", mu_hat, "\n")
cat("sigma_hat_sq:", sigma_hat_sq, "\n\n")

cat(sprintf("Ensemble average at t = %d: %f\n", t_point, ensemble_average_t100))
cat(sprintf("Ensemble variance at t = %d: %f\n", t_point, ensemble_variance_t100))