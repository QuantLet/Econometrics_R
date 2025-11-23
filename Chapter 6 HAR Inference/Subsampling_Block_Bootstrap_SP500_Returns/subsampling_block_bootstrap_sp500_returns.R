## =====================================================
## 1. Preliminaries and setup
## =====================================================

rm(list = ls())              # Clear workspace
set.seed(123456)             # Reproducibility

# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Load packages
## =====================================================

# install.packages("zoo")
# install.packages("tseries")
# install.packages("quantmod")
# install.packages("ggplot2")

library(zoo)
library(tseries)
library(quantmod)
library(ggplot2)

## =====================================================
## 3. Data: S&P 500 returns
## =====================================================

# Get S&P 500 data (or use your own data)
getSymbols("^GSPC", src = "yahoo",
           from = "2000-01-01", to = "2024-12-31")

returns <- dailyReturn(Cl(GSPC))  # daily returns
returns <- na.omit(returns)

r <- as.numeric(returns)
T <- length(r)

## =====================================================
## 4. Parameters for subsampling and bootstrap
## =====================================================

b_sub   <- 252 * 5   # subsample/block length for subsampling (5 years of daily data)
b_boot  <- 252       # block length for block bootstrap (1 year)
S       <- 1000      # number of bootstrap replications

## =====================================================
## 5. Subsampling for mean return
## =====================================================

n_sub  <- T - b_sub
rbar   <- mean(r)
R_mean <- numeric(n_sub)

for (j in 1:n_sub) {
  r_sub     <- r[j:(j + b_sub - 1)]
  rbar_sub  <- mean(r_sub)
  R_mean[j] <- sqrt(b_sub) * (rbar_sub - rbar)
}

# ggplot2: subsampling distribution for mean
df_mean <- data.frame(R_mean = R_mean)

p_sub_mean <- ggplot(df_mean, aes(x = R_mean)) +
  geom_histogram(aes(y = ..density..),
                 bins  = 40,
                 fill  = "lightblue",
                 color = "black") +
  geom_vline(xintercept = sqrt(T) * rbar,
             color = "red", linewidth = 1) +
  labs(
    title = expression("Subsampling: " ~ sqrt(b) * (bar(r)[sub] - bar(r))),
    x     = expression(R[b]^"*"),
    y     = "Density"
  ) +
  theme_minimal()

print(p_sub_mean)

# Optional: save figure
# ggsave("subsampling-mean.png", plot = p_sub_mean,
#        width = 6, height = 4, dpi = 300)

## =====================================================
## 6. Subsampling for lag-1 autocorrelation of squared returns
## =====================================================

rho_hat <- acf(r^2, lag.max = 1, plot = FALSE)$acf[2]
R_acf   <- numeric(n_sub)

for (j in 1:n_sub) {
  r_sub   <- r[j:(j + b_sub - 1)]
  rho_sub <- acf(r_sub^2, lag.max = 1, plot = FALSE)$acf[2]
  R_acf[j] <- sqrt(b_sub) * (rho_sub - rho_hat)
}

# ggplot2: subsampling distribution for rho(1)
df_acf <- data.frame(R_acf = R_acf)

p_sub_acf <- ggplot(df_acf, aes(x = R_acf)) +
  geom_histogram(aes(y = ..density..),
                 bins  = 40,
                 fill  = "lightblue",
                 color = "black") +
  geom_vline(xintercept = sqrt(T) * rho_hat,
             color = "red", linewidth = 1) +
  labs(
    title = expression("Subsampling: " ~ sqrt(b) * (hat(rho)[sub] - hat(rho))),
    x     = expression(R[b]^"*"),
    y     = "Density"
  ) +
  theme_minimal()

print(p_sub_acf)

# Optional: save figure
# ggsave("subsampling-acf.png", plot = p_sub_acf,
#        width = 6, height = 4, dpi = 300)

## =====================================================
## 7. Block bootstrap for mean return
## =====================================================

block_bootstrap_mean <- function(r, b, S) {
  T <- length(r)
  m <- floor(T / b)                 # number of blocks needed
  blocks <- embed(r, b)[, b:1]      # overlapping blocks
  B <- nrow(blocks)                 # number of available blocks
  
  boot_stats <- numeric(S)
  for (s in 1:S) {
    indices     <- sample(1:B, m, replace = TRUE)
    boot_sample <- as.vector(t(blocks[indices, ]))
    boot_sample <- boot_sample[1:(b * m)]
    boot_rbar   <- mean(boot_sample)
    boot_stats[s] <- sqrt(T) * (boot_rbar - mean(r))
  }
  return(boot_stats)
}

R_boot_mean <- block_bootstrap_mean(r, b = b_boot, S = S)

## =====================================================
## 8. ggplot2: block bootstrap distribution for mean
## =====================================================

df_boot_mean <- data.frame(R_boot_mean = R_boot_mean)

p_boot_mean <- ggplot(df_boot_mean, aes(x = R_boot_mean)) +
  geom_histogram(aes(y = ..density..),
                 bins  = 40,
                 fill  = "lightblue",
                 color = "black") +
  geom_vline(xintercept = sqrt(T) * rbar,
             color = "red", linewidth = 1) +
  labs(
    title = expression("Block Bootstrap: " ~ sqrt(T) * (bar(r)[boot] - bar(r))),
    x     = expression(R[T]^"*"),
    y     = "Density"
  ) +
  theme_minimal()

print(p_boot_mean)

# Optional: save figure
 ggsave("block-bootstrap-mean.png", plot = p_boot_mean,
       width = 6, height = 4, dpi = 300)
