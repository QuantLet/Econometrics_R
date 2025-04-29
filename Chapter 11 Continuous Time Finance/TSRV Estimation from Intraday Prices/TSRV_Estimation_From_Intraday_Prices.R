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

# Extract the relevant price column (adjust index as needed)
priceX <- aa$...5  # Ensure this is the correct column for price data

##########################################################################################
# 2. Define TSRV Function
##########################################################################################

TSRV <- function(priceX, K, m, n) {
  lprice <- log(priceX)  # Compute log prices
  RV_sub <- numeric(K)   # Initialize vector for subsample RVs
  
  # Loop through K subsamples
  for (j in 1:K) {
    sub_sample <- lprice[seq(j, by = K, length.out = m + 1)]
    returns <- diff(sub_sample)
    RV_sub[j] <- sum(returns^2)
  }
  
  # Full-sample realized variance
  returns_full <- diff(lprice)
  RV_n <- sum(returns_full^2)
  
  # TSRV estimator
  TSRV_estimate <- (1 / K) * sum(RV_sub) - (m / n) * RV_n
  
  return(TSRV_estimate)
}

##########################################################################################
# 3. Compute TSRV Estimate
##########################################################################################

K <- 5             # Number of subsamples
m <- 100           # Observations per subsample
n <- length(priceX)  # Total number of observations

# Estimate TSRV
TSRV_estimate <- TSRV(priceX, K, m, n)

# Output the result
cat("TSRV Estimate:", TSRV_estimate, "\n")
