## =====================================================
## 1. Preliminaries and setup
## =====================================================

rm(list = ls())              # Clear workspace
set.seed(123)                # Reproducibility (bootstrap seed)

# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Load packages
## =====================================================

# install.packages("ggplot2") # run once if needed

library(ggplot2)

## =====================================================
## 3. Simulation / bootstrap design
## =====================================================

T  <- 200   # Sample size
phi <- 0.6  # True AR(1) coefficient
sigma <- 1  # Std dev of white noise
S  <- 1000  # Number of bootstrap replications

## =====================================================
## 4. Generate AR(1) data and estimate phi_hat
## =====================================================

# Generate AR(1) data: y_t = phi * y_{t-1} + eps_t
y   <- numeric(T)
eps <- rnorm(T, mean = 0, sd = sigma)

y[1] <- eps[1]
for (t in 2:T) {
  y[t] <- phi * y[t - 1] + eps[t]
}

# OLS estimate of phi from regression y_t on y_{t-1}
y_lag     <- y[-T]
y_current <- y[-1]

phi_hat <- sum(y_current * y_lag) / sum(y_lag^2)

## =====================================================
## 5. Residuals and bootstrap setup
## =====================================================

# Step 2: Compute residuals from the fitted AR(1)
residuals <- y_current - phi_hat * y_lag

# Step 3: Recenter residuals
res_centered <- residuals - mean(residuals)

# Storage for bootstrap roots R_T^*
RT_star <- numeric(S)

## =====================================================
## 6. Bootstrap loop
## =====================================================

for (s in 1:S) {
  # Step 4: Resample residuals with replacement
  eps_star <- sample(res_centered, T, replace = TRUE)
  
  # Step 5: Generate bootstrap series using phi_hat
  y_star      <- numeric(T)
  y_star[1]   <- 0
  for (t in 2:T) {
    y_star[t] <- phi_hat * y_star[t - 1] + eps_star[t]
  }
  
  # Step 6: Estimate phi_star from bootstrap series
  y_star_lag     <- y_star[-T]
  y_star_current <- y_star[-1]
  phi_star <- sum(y_star_current * y_star_lag) / sum(y_star_lag^2)
  
  # Step 7: Compute bootstrap root
  RT_star[s] <- sqrt(T) * (phi_star - phi_hat)
}

## =====================================================
## 7. Bootstrap summary statistics
## =====================================================

# Basic summaries
RT_mean   <- mean(RT_star)
RT_sd     <- sd(RT_star)
RT_q025   <- quantile(RT_star, 0.025)
RT_q975   <- quantile(RT_star, 0.975)

cat("Mean of R_T^*:", RT_mean, "\n")
cat("SD of R_T^*  :", RT_sd,   "\n")
cat("2.5% quantile:", RT_q025, "\n")
cat("97.5% quantile:", RT_q975, "\n")

## =====================================================
## 8. ggplot2 visualization of bootstrap distribution
## =====================================================

df_boot <- data.frame(RT_star = RT_star)

q_low  <- RT_q025
q_high <- RT_q975

p_boot <- ggplot(df_boot, aes(x = RT_star)) +
  geom_histogram(aes(y = ..density..),
                 bins = 30,
                 fill = "lightblue",  # light blue bins
                 color = "black") +   # optional: black borders
  geom_vline(xintercept = c(q_low, q_high), linetype = "dashed") +
  labs(
    title = "Bootstrap Distribution of Root",
    x     = expression(R[T]^"*"),
    y     = "Density"
  )

print(p_boot)

# Optional: save figure (6 x 4 inches, 300 dpi)
ggsave(filename = "bootstrap-root-dist.png", plot = p_boot,
       width = 6, height = 4, dpi = 300)