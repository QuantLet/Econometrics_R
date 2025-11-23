
## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(ggplot2)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Define function to simulate an MA(2) process
## =====================================================

simulate_ma2 <- function(n, theta1, theta2, sigma) {
  eps <- rnorm(n + 2, sd = sigma)
  x   <- numeric(n)
  for (i in 1:n) {
    x[i] <- eps[i + 2] + theta1 * eps[i + 1] + theta2 * eps[i]
  }
  x
}

## =====================================================
## 3. Simulate MA(2) series
## =====================================================

set.seed(123)  # For reproducibility

n      <- 1000  # Length of the time series
theta1 <- 0.5   # First MA parameter
theta2 <- -0.3  # Second MA parameter
sigma  <- 1     # Standard deviation of the noise

ma2_data <- simulate_ma2(n, theta1, theta2, sigma)

df_ma2 <- data.frame(
  time  = 1:n,
  value = ma2_data
)

## =====================================================
## 4. Plot and save the simulated MA(2) series
## =====================================================

p_ma2 <- ggplot(df_ma2, aes(x = time, y = value)) +
  geom_line() +
  labs(title = "Simulated MA(2) process", x = "Time", y = "Value")

ggsave("simulated-ma2.png", plot = p_ma2, width = 6, height = 4, dpi = 300)