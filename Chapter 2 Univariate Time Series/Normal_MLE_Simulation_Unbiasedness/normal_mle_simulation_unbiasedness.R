## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set folder to current script location (in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load necessary package
# install.packages("ggplot2")
library(ggplot2)

## =====================================================
## 2. Set parameters and run simulations
## =====================================================

set.seed(123)

mu_true    <- 5
sigma_true <- 2
n               <- 1000       # Sample size
num_simulations <- 100000     # Number of simulations

# Initialize vectors to store maximum likelihood estimates
mu_mle_values    <- numeric(num_simulations)
sigma_mle_values <- numeric(num_simulations)

# Perform multiple simulations
for (i in 1:num_simulations) {
  sample <- rnorm(n, mu_true, sigma_true)
  mu_mle_values[i]    <- mean(sample)
  sigma_mle_values[i] <- sqrt((n - 1) / n * var(sample))
}

# Check approximate unbiasedness
cat("Average of mu estimator:", mean(mu_mle_values), "\n")
cat("Average of sigma^2 estimator:", mean(sigma_mle_values^2), "\n")

## =====================================================
## 3. Prepare data for ggplot2
## =====================================================

df_mu    <- data.frame(mu_mle    = mu_mle_values)
df_sigma <- data.frame(sigma_mle = sigma_mle_values)

## =====================================================
## 4. Plot and save distribution of mu MLE
## =====================================================

p_mu <- ggplot(df_mu, aes(x = mu_mle)) +
  geom_histogram(aes(y = ..density..),
                 bins = 30, colour = "black", fill = "lightblue") +
  geom_density(colour = "red", linewidth = 1) +
  labs(title = "Distribution of mu MLE", x = "mu MLE", y = "Density")  

ggsave("mu_mle_distribution.png", plot = p_mu, width = 6, height = 4, dpi = 300)

## =====================================================
## 5. Plot and save distribution of sigma MLE
## =====================================================

p_sigma <- ggplot(df_sigma, aes(x = sigma_mle)) +
  geom_histogram(aes(y = ..density..),
                 bins = 30, colour = "black", fill = "lightblue") +
  geom_density(colour = "red", linewidth = 1) +
  labs(title = "Distribution of sigma MLE", x = "sigma MLE", y = "Density")  

ggsave("sigma_mle_distribution.png", plot = p_sigma, width = 6, height = 4, dpi = 300)