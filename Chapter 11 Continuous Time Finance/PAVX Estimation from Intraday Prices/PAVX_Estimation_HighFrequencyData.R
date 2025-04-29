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

# Read Excel file (no headers assumed)
aa <- read_excel("AA_daily20120103.xlsx", col_names = FALSE)

# Extract the relevant column (column 5 assumed for prices)
priceX <- aa$...5  

##########################################################################################
# 2. Define PAVX Estimator Function
##########################################################################################

PAVX <- function(priceX, theta = 0.1) {
  # Convert to matrix and compute log prices
  logPrice <- matrix(log(priceX), ncol = 1)
  n <- nrow(logPrice)
  
  # Set up estimation parameters
  delta_n <- 1 / n
  K_n <- round(theta / sqrt(delta_n) / 2) * 2  # Force K_n to be even
  
  # Constants based on Jacod et al. (2009)
  psi1 <- 1
  psi2 <- 1 / 12
  
  # Pre-averaging return matrix Z
  Z <- matrix(0, ncol = 1, nrow = 1)
  
  for (j in 1:(n - K_n + 1)) {
    r <- (1 / K_n) * colSums(logPrice[(j + K_n / 2):(j + K_n - 1), , drop = FALSE] - 
                               logPrice[j:(j + K_n / 2 - 1), , drop = FALSE])
    Z <- Z + r %*% t(r)
  }
  
  # Second term using simple returns
  simple_returns <- diff(logPrice)
  correction_term <- t(simple_returns) %*% simple_returns
  
  # Final pre-averaging estimator
  CX <- (sqrt(delta_n) / (theta * psi2)) * Z - 
    (psi1 * delta_n / (2 * theta^2 * psi2)) * correction_term
  
  # Annualize the estimate (252 trading days)
  return(CX * 252)
}

##########################################################################################
# 3. Compute and Print the PAVX Estimate
##########################################################################################

# Run the estimator with a reasonable theta
theta_val <- 0.1
PAVX_estimate <- PAVX(priceX, theta = theta_val)

# Display the result
cat("Estimated Annualized PAVX (theta =", theta_val, "):\n")
print(PAVX_estimate)
