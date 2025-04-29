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

TSX <- function(priceX, slowFreq, fastFreq) {
  # Convert to log-prices
  logPrice <- log(as.matrix(priceX))  
  
  # Dimensions
  n_obs <- nrow(logPrice)
  p_dim <- ncol(logPrice)
  
  # Compute number of bins
  binSlow <- floor(n_obs / slowFreq)
  binFast <- floor(n_obs / fastFreq)
  
  # Initialize sums
  rvSlowSum <- matrix(0, nrow = p_dim, ncol = p_dim)
  rvFastSum <- matrix(0, nrow = p_dim, ncol = p_dim)
  
  # Slow frequency calculation
  for (j in 1:slowFreq) {
    indices <- seq(j + n_obs %% slowFreq, by = slowFreq, length.out = binSlow)
    subLog <- logPrice[indices, , drop = FALSE]
    subReturn <- diff(subLog)
    rvSlowSum <- rvSlowSum + t(subReturn) %*% subReturn
  }
  rvSlow <- rvSlowSum / slowFreq
  
  # Fast frequency calculation
  for (j in 1:fastFreq) {
    indices <- seq(j + n_obs %% fastFreq, by = fastFreq, length.out = binFast)
    subLog <- logPrice[indices, , drop = FALSE]
    subReturn <- diff(subLog)
    rvFastSum <- rvFastSum + t(subReturn) %*% subReturn
  }
  rvFast <- rvFastSum / fastFreq
  
  # TSX estimator
  tsx <- rvSlow - (fastFreq / slowFreq) * rvFast
  
  # Return annualized estimate
  return(tsx * 252)  
}

##########################################################################################
# 3. Compute TSX Estimate
##########################################################################################

# Parameters
slowFreq <- 5    # Number of slower subsampling intervals
fastFreq <- 2    # Number of faster subsampling intervals

# Compute TSX covariance matrix
tsx_estimate <- TSX(priceX, slowFreq, fastFreq)

# Output the TSX estimate
print(tsx_estimate)
 