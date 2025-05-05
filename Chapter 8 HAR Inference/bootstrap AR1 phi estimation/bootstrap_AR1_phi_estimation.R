##########################################################################################
# Kernel Functions and Their Fourier Transforms: Plotting and Saving
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Set parameters
set.seed(123)
T <- 200                # Sample size
phi <- 0.6              # True AR(1) coefficient
sigma <- 1              # Std dev of white noise
S <- 1000               # Number of bootstrap replications

# Generate AR(1) data
y <- numeric(T)
eps <- rnorm(T, mean = 0, sd = sigma)
y[1] <- eps[1]
for (t in 2:T) {
  y[t] <- phi * y[t - 1] + eps[t]
}

# Step 1: Estimate phi_hat from original data using OLS
y_lag <- y[-T]
y_current <- y[-1]
phi_hat <- sum(y_current * y_lag) / sum(y_lag^2)

# Step 2: Compute residuals
residuals <- y_current - phi_hat * y_lag

# Step 3: Recenter residuals
res_centered <- residuals - mean(residuals)

# Bootstrap loop
RT_star <- numeric(S)

for (s in 1:S) {
  # Step 4: Resample residuals with replacement
  eps_star <- sample(res_centered, T, replace = TRUE)
  
  # Step 5: Generate bootstrap series
  y_star <- numeric(T)
  y_star[1] <- 0
  for (t in 2:T) {
    y_star[t] <- phi_hat * y_star[t - 1] + eps_star[t]
  }
  
  # Step 6: Estimate phi_star
  y_star_lag <- y_star[-T]
  y_star_current <- y_star[-1]
  phi_star <- sum(y_star_current * y_star_lag) / sum(y_star_lag^2)
  
  # Step 7: Compute bootstrap root
  RT_star[s] <- sqrt(T) * (phi_star - phi_hat)
}

# Summary and visualization
hist(RT_star, breaks = 30, probability = TRUE,
     main = "Bootstrap Distribution of Root",
     xlab = expression(R[T]^"*"))
abline(v = quantile(RT_star, c(0.025, 0.975)), col = "red", lty = 2)
