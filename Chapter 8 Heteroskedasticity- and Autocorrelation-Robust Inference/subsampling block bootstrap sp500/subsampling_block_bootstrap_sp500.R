# Load required libraries
library(zoo)
library(tseries)
library(quantmod)

# Get S&P500 data (or use your own data)
getSymbols("^GSPC", src = "yahoo", from = "2000-01-01", to = "2024-12-31")
returns <- dailyReturn(Cl(GSPC))  # daily log returns
returns <- na.omit(returns)
r <- as.numeric(returns)
T <- length(r)

# Parameters
b <- 252 * 5  # block/subsample size: 5 years of daily data (~252 trading days/year)
S <- 1000     # number of bootstrap replications

# --------------------------------------------
# Subsampling for Mean Return
# --------------------------------------------
n_sub <- T - b
rbar <- mean(r)
R_mean <- numeric(n_sub)

for (j in 1:n_sub) {
  r_sub <- r[j:(j + b - 1)]
  rbar_sub <- mean(r_sub)
  R_mean[j] <- sqrt(b) * (rbar_sub - rbar)
}

# Plot subsampling distribution for mean
hist(R_mean, breaks = 40, probability = TRUE,
     main = expression("Subsampling: " ~ sqrt(b) * (bar(r)[sub] - bar(r))),
     xlab = expression(R[b]^"*"))
abline(v = sqrt(T) * rbar, col = "red", lwd = 2)

# --------------------------------------------
# Subsampling for Lag-1 Autocorrelation of Squared Returns
# --------------------------------------------
rho_hat <- acf(r^2, lag.max = 1, plot = FALSE)$acf[2]
R_acf <- numeric(n_sub)

for (j in 1:n_sub) {
  r_sub <- r[j:(j + b - 1)]
  rho_sub <- acf(r_sub^2, lag.max = 1, plot = FALSE)$acf[2]
  R_acf[j] <- sqrt(b) * (rho_sub - rho_hat)
}

# Plot subsampling distribution for rho(1)
hist(R_acf, breaks = 40, probability = TRUE,
     main = expression("Subsampling: " ~ sqrt(b) * (hat(rho)[sub] - hat(rho))),
     xlab = expression(R[b]^"*"))
abline(v = sqrt(T) * rho_hat, col = "red", lwd = 2)

# --------------------------------------------
# Block Bootstrap for Mean Return
# --------------------------------------------
block_bootstrap_mean <- function(r, b, S) {
  T <- length(r)
  m <- floor(T / b)
  blocks <- embed(r, b)[, b:1]
  B <- nrow(blocks)
  
  boot_stats <- numeric(S)
  for (s in 1:S) {
    indices <- sample(1:B, m, replace = TRUE)
    boot_sample <- as.vector(t(blocks[indices, ]))
    boot_sample <- boot_sample[1:(b * m)]
    boot_rbar <- mean(boot_sample)
    boot_stats[s] <- sqrt(T) * (boot_rbar - mean(r))
  }
  return(boot_stats)
}

R_boot_mean <- block_bootstrap_mean(r, b = 252, S = 1000)

# Plot Block Bootstrap Distribution for Mean
hist(R_boot_mean, breaks = 40, probability = TRUE,
     main = expression("Block Bootstrap: " ~ sqrt(T) * (bar(r)[boot] - bar(r))),
     xlab = expression(R[T]^"*"))
abline(v = sqrt(T) * rbar, col = "red", lwd = 2)
