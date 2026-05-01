## =====================================================
## 1. Load packages
## =====================================================

# install.packages("quantmod")   # run once if needed
# install.packages("sandwich")   # run once if needed

library(quantmod)

## =====================================================
## 2. Download DAX index data from Yahoo Finance
## =====================================================

getSymbols("^GDAXI", src = "yahoo",
           from = "2024-01-01", to = "2024-12-31")

# Extract daily closing index levels
dax_index <- Cl(GDAXI)

## =====================================================
## 3. Compute log-returns of the DAX index
## =====================================================

dax_returns <- diff(log(dax_index))  # log-returns
dax_returns <- na.omit(dax_returns)  # drop first NA
dax_returns <- as.numeric(dax_returns)

## =====================================================
## 4. Estimate Newey–West LRV
## =====================================================

lrv_result <- sandwich::lrvar(dax_returns, type = "Newey-West") *
  length(dax_returns)

# lrv_result is the Newey–West estimate of the LRV of the
# partial-sum process of DAX log-returns over the full sample.
# You can inspect it with:
lrv_result
 
## =====================================================
## 5. Function to compute LRV covariance matrix
##    (Bartlett kernel, fixed-b)
## =====================================================

computeLRVCovMatrix <- function(y, bandwidth) {
  ## -------------------------------------------------
  ## 1. Basic setup
  ## -------------------------------------------------
  
  # Ensure y is a matrix: rows = time, cols = variables
  if (is.vector(y)) {
    y <- matrix(y, ncol = 1)
  }
  
  n <- nrow(y)  # Number of observations
  p <- ncol(y)  # Number of variables
  lags <- floor(bandwidth * n)  # Maximum lag m = floor(b * n)
  
  ## -------------------------------------------------
  ## 2. Demean the data
  ## -------------------------------------------------
  
  y_demeaned <- sweep(y, 2, colMeans(y), FUN = "-")
  
  ## -------------------------------------------------
  ## 3. Initialize with lag-0 covariance
  ##     (sample covariance scaled by 1/n)
  ## -------------------------------------------------
  
  lrv_cov_matrix <- (t(y_demeaned) %*% y_demeaned) / n
  
  ## -------------------------------------------------
  ## 4. Add weighted autocovariances (lags 1,...,m)
  ## -------------------------------------------------
  
  if (lags > 0) {
    for (lag in 1:lags) {
      # Bartlett kernel weight: w_j = 1 - j / (m + 1)
      weight <- 1 - lag / (lags + 1)
      
      # Sample covariance for positive lag j:
      #  (1/n) sum_{t=1}^{n-j} y_t y_{t+j}'
      lagged_cov_positive <- (t(y_demeaned[1:(n - lag), ]) %*%
                                y_demeaned[(lag + 1):n, ]) / n
      
      # Sample covariance for negative lag -j:
      #  (1/n) sum_{t=1}^{n-j} y_{t+j} y_t'
      lagged_cov_negative <- (t(y_demeaned[(lag + 1):n, ]) %*%
                                y_demeaned[1:(n - lag), ]) / n
      # Alternatively, to enforce exact symmetry numerically:
      # lagged_cov_negative <- t(lagged_cov_positive)
      
      # Add weighted (Gamma_hat(j) + Gamma_hat(-j))
      lrv_cov_matrix <- lrv_cov_matrix +
        weight * (lagged_cov_positive + lagged_cov_negative)
    }
  }
  
  ## -------------------------------------------------
  ## 5. Return LRV covariance matrix
  ## -------------------------------------------------
  
  return(lrv_cov_matrix)
}