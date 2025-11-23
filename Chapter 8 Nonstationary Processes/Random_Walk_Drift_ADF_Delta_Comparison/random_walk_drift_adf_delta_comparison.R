# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# =====================================================
## 1. Load necessary packages
## =====================================================
library(ggplot2)
library(urca)

# =====================================================
## 2. Set seed for reproducibility
## =====================================================
set.seed(123)

# =====================================================
## 3. Define the function to simulate the random walk process with a drift (delta)
##    Y_t = Y_{t-1} + delta + epsilon_t
## =====================================================
simulate_rw <- function(delta, n) {
  epsilon <- rnorm(n)  # Generate white noise (epsilon)
  y <- numeric(n)      # Initialize vector to hold random walk values
  y[1] <- 0            # Set the starting value of the series
  for (t in 2:n) {
    y[t] <- y[t - 1] + delta + epsilon[t]  # Generate the random walk process
  }
  return(y)  # Return the simulated series
}

# =====================================================
## 4. Parameters for simulation
## =====================================================
n_samples <- 500  # Number of samples
delta_values <- c(0.5, 0.1, 0.05)  # Different delta values to simulate the process

# Create a list to store the plots
plot_list <- list()

# =====================================================
## 5. Simulate the data and perform ADF tests for different delta values
## =====================================================
for (i in 1:length(delta_values)) {
  delta <- delta_values[i]
  
  # Simulate the random walk with the given delta value
  y <- simulate_rw(delta, n_samples)
  
  # Perform Augmented Dickey-Fuller Test on the simulated data
  adf_test <- ur.df(y, type = "drift", lags = 1, selectlags = "AIC")
  
  # Create a plot for the time series
  p <- ggplot(data.frame(t = 1:n_samples, y = y), aes(x = t, y = y)) +
    geom_line() +
    ggtitle(paste("Random Walk: Delta =", delta)) +
    xlab("Time") +
    ylab("Value")
  
  # Add the plot to the list
  plot_list[[i]] <- p
  
  # Print the results for the ADF test
  cat("\nResults for delta =", delta, "\n")
  cat("Value of test-statistic (tau2):", adf_test@teststat[1], "\n")
  cat("Value of test-statistic (phi1):", adf_test@teststat[2], "\n")
  cat("Critical values for test statistics (tau2 and phi1):\n")
  print(adf_test@cval)
}

# =====================================================
## 6. Save the plots as individual PNG files
## =====================================================
ggsave("unit_root_delta05.png", plot_list[[1]], width = 6, height = 4, dpi = 300)
ggsave("unit_root_delta01.png", plot_list[[2]], width = 6, height = 4, dpi = 300)
ggsave("unit_root_delta005.png", plot_list[[3]], width = 6, height = 4, dpi = 300)
