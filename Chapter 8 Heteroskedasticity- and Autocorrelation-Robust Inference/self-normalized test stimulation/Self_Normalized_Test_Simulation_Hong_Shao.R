##########################################################################################
# Simulation of Self-Normalized Test Statistics: Hong (2024) and Shao (2010)
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear all objects from the workspace
rm(list = ls())

# Load required libraries
# install.packages(c("xtable", "sandwich", "ggplot2", "gridExtra"))  # Uncomment if needed
library(sandwich)
library(xtable)

# Set seed for reproducibility
set.seed(123456789)

##########################################################################################
# 1. Preliminary Example: LRV Estimation for DAX Returns
##########################################################################################

# Load EuStockMarkets dataset
data("EuStockMarkets")

# Extract DAX and compute log returns
dax <- EuStockMarkets[, "DAX"]
dax_returns <- diff(log(dax))
dax_returns <- na.omit(dax_returns)

# Calculate Newey-West long-run variance (LRV)
lrv_result <- sandwich::lrvar(dax_returns, type = "Newey-West") * length(dax_returns)

##########################################################################################
# 2. Define Function to Compute Long-Run Variance Covariance Matrix
##########################################################################################

computeLRVCovMatrix <- function(y, bandwidth) {
  n <- nrow(y)
  p <- ncol(y)
  lags <- floor(bandwidth * n)
  
  y_demeaned <- sweep(y, 2, colMeans(y))
  lrv_cov_matrix <- (t(y_demeaned) %*% y_demeaned) / n
  
  for (lag in 1:lags) {
    weight <- 1 - lag / (lags + 1)  # Bartlett kernel weight
    lagged_cov_pos <- (t(y_demeaned[1:(n - lag), ]) %*% y_demeaned[(lag + 1):n, ]) / n
    lagged_cov_neg <- (t(y_demeaned[(lag + 1):n, ]) %*% y_demeaned[1:(n - lag), ]) / n
    lrv_cov_matrix <- lrv_cov_matrix + weight * (lagged_cov_pos + lagged_cov_neg)
  }
  
  return(lrv_cov_matrix)
}

##########################################################################################
# 3. Main Simulation for M-Test, S-Test, and Standard Normal
##########################################################################################

# Set simulation parameters
numrep <- 10000
sample.size <- 200000

# Initialize vectors to store test statistics
Hong.M.test <- numeric(numrep)
Shao.S.test <- numeric(numrep)
standard.normal <- numeric(numrep)

# Simulation loop
for (i in 1:numrep) {
  times <- seq(0, 1, length.out = sample.size)
  dB <- rnorm(sample.size) / sqrt(sample.size)
  B <- cumsum(dB)
  Brownian.Bridge <- B - times * B[sample.size]
  
  adjusted.range.self.normalizer <- max(Brownian.Bridge) - min(Brownian.Bridge)
  B1 <- mean(dB) * sample.size
  M <- B1 / adjusted.range.self.normalizer
  Hong.M.test[i] <- M
  
  # Shao (2010) self-normalized statistic
  dt <- times[2] - times[1]
  Brownian.Bridge.integral <- sum(Brownian.Bridge^2) * dt
  S <- B1 / sqrt(Brownian.Bridge.integral)
  Shao.S.test[i] <- S
  
  # Standard normal benchmark
  standard.normal[i] <- B1
  
  if (i %% 1000 == 0) print(paste("Simulation iteration:", i))
}

##########################################################################################
# 4. Save Simulation Results
##########################################################################################

# Save to CSV
write.csv(Hong.M.test, "M-test.csv", row.names = FALSE)
write.csv(Shao.S.test, "Shao-SN.csv", row.names = FALSE)
write.csv(standard.normal, "N01.csv", row.names = FALSE)

##########################################################################################
# 5. Critical Value Calculations
##########################################################################################

# Define critical levels
cv.list <- c(5, 2.5, 1, 0.5, 0.1) / 100
cv.sample <- round(numrep * (1 - cv.list))

# Collect critical values
result <- rbind(cv.list,
                sort(Hong.M.test)[cv.sample],
                sort(Shao.S.test)[cv.sample],
                sort(standard.normal)[cv.sample])

rownames(result) <- c("alpha", "Hong et al.'s (2024) M", "Shao's (2010) S", "N(0,1)")
result <- t(result)

# Save critical values to LaTeX table
result.xtable <- xtable(result, digits = 4)
print(result.xtable, file = "cv.tex")

##########################################################################################
# 6. Plot Histograms and Density Estimates
##########################################################################################

# Save density plot
jpeg(filename = "dist-m-hat.png", width = 700, height = 350)
plot(density(Hong.M.test, adjust = 2), col = "red", lwd = 2, main = "", xlab = "", ylab = "")
lines(density(Shao.S.test, adjust = 2), col = "green", lwd = 2)
lines(density(standard.normal, adjust = 2), col = "blue", lwd = 2)
legend("topleft",
       legend = c("Hong et al.'s (2024) M", "Shao's (2010) S", "N(0,1)"),
       text.col = "black", lwd = 2, col = c("red", "green", "blue"))
dev.off()
