##########################################################################################
# Two-Scale Realized Variance (TSRV) Estimation from High-Frequency Data
##########################################################################################

# Clear environment
rm(list = ls())

# Set seed for reproducibility
set.seed(123)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required package
library(readxl)

##########################################################################################
# 1. Load Data
##########################################################################################

# Read Excel file without headers
aa <- read_excel("AA_daily20120103.xlsx", col_names = FALSE)

# Extract the relevant price column (adjust index if needed)
priceX <- aa$...5  

##########################################################################################
# 2. Define TSX Estimator Function
##########################################################################################


# RKX Estimator Function
RKX <- function(priceX, slowFreq, fastFreq) {
  # Compute log-prices
  logPrice <- log(priceX)
  
  # Determine number of subsamples for slow and fast frequencies
  binSlow <- floor(nrow(logPrice) / slowFreq)
  binFast <- floor(nrow(logPrice) / fastFreq)
  
  # Compute realized variance using slow frequency
  rvSlowMatrix <- matrix(0, nrow = slowFreq, ncol = ncol(logPrice))
  for (j in 1:slowFreq) {
    indices <- seq(j + nrow(logPrice) %% slowFreq, length.out = binSlow, by = slowFreq)
    subLog <- logPrice[indices, , drop = FALSE]
    rvSlowMatrix[j, ] <- colSums(diff(subLog)^2)
  }
  rvSlow <- colMeans(rvSlowMatrix)
  
  # Compute realized variance using fast frequency
  rvFastMatrix <- matrix(0, nrow = fastFreq, ncol = ncol(logPrice))
  for (j in 1:fastFreq) {
    indices <- seq(j + nrow(logPrice) %% fastFreq, length.out = binFast, by = fastFreq)
    subLog <- logPrice[indices, , drop = FALSE]
    rvFastMatrix[j, ] <- colSums(diff(subLog)^2)
  }
  rvFast <- colMeans(rvFastMatrix)
  
  # Estimate the noise variance
  noiseVariance <- rvFast / ((binFast - 1) * 2)
  
  # Determine the optimal bandwidth
  h <- round(mean(3.51 * (noiseVariance / rvSlow)^0.4 * (nrow(logPrice) - 1)^0.6))
  
  # Compute return matrix
  returns <- diff(logPrice)
  
  # Initialize RKX estimator with the raw realized covariance
  rkx <- t(returns) %*% returns
  
  # Add lagged autocovariances using the Parzen kernel
  for (hh in 1:h) {
    x <- (hh - 1) / h
    if (x <= 0.5) {
      k <- 1 - 6 * x^2 + 6 * x^3
    } else {
      k <- 2 * (1 - x)^3
    }
    laggedCov1 <- t(returns[(hh + 1):nrow(returns), , drop = FALSE]) %*% returns[1:(nrow(returns) - hh), , drop = FALSE]
    laggedCov2 <- t(returns[1:(nrow(returns) - hh), , drop = FALSE]) %*% returns[(hh + 1):nrow(returns), , drop = FALSE]
    rkx <- rkx + k * (laggedCov1 + laggedCov2)
  }
  
  # Return the annualized RKX estimator
  return(rkx * 252)
}

##########################################################################################
# 3. Compute RKX Estimate and Display Output
##########################################################################################

# Convert price series to matrix format for multivariate compatibility
price_matrix <- as.matrix(priceX)

# Set slow and fast frequencies
slowFreq <- 5
fastFreq <- 1

# Compute RKX estimator
rkx_result <- RKX(price_matrix, slowFreq, fastFreq)

# Display the estimated RKX matrix
cat("Estimated RKX Matrix:\n")
print(rkx_result)

##########################################################################################
# 4. Optional: Save RKX Output to CSV
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

write.csv(rkx_result, "rkx_estimator_output.csv", row.names = FALSE)

##########################################################################################
# 5. Optional: Visualize RKX Estimate (If Univariate)
##########################################################################################

if (ncol(price_matrix) == 1) {
  rkx_value <- as.numeric(rkx_result)
  barplot(rkx_value,
          main = "RKX Estimate (Univariate)",
          col = "steelblue",
          ylab = "Estimated Volatility")
}
