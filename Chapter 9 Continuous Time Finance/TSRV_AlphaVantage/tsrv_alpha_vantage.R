## =====================================================
## 1. Load required packages, clear environment, set API
## =====================================================

# Clear environment
rm(list = ls())

# Set random seed for reproducibility
set.seed(123)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required packages
library(quantmod)  # getSymbols.av interface
library(xts)       # time-series handling

# Set your Alpha Vantage API key
api_key <- "Your_Own_Key"
setDefaults(getSymbols.av, api.key = api_key)

## =====================================================
## 2. Download intraday data and define TSRV function
## =====================================================

# Choose stock symbol and intraday frequency
symbol       <- "AAPL"       # example ticker (Apple Inc.)
interval     <- "1min"       # high-frequency interval
output_size  <- "full"       # request as many intraday points as allowed

# Download intraday data from Alpha Vantage
getSymbols(symbol,
           src          = "av",
           periodicity  = "intraday",
           interval     = interval,
           output.size  = output_size,
           auto.assign  = TRUE)

# Extract closing prices and drop missing values
data_xts <- Cl(get(symbol))
data_xts <- na.omit(data_xts)

# Convert to a numeric price vector
priceX <- as.numeric(data_xts)
n      <- length(priceX)

# Define TSRV function (input: price vector and number of subsamples K)
TSRV <- function(priceX, K) {
  n <- length(priceX)
  
  # Choose m so that K * (m + 1) <= n
  m <- floor(n / K) - 1
  
  # Compute log prices
  lprice <- log(priceX)
  
  # Initialize a vector to store realized volatility from each subsample
  RV_sub <- numeric(K)
  
  ## Compute RV for each subsample
  for (j in 1:K) {
    # Generate subsample of log prices
    sub_sample <- lprice[seq(from = j, by = K, length.out = m + 1)]
    
    # Compute returns (log price differences)
    returns <- diff(sub_sample)
    
    # Compute realized volatility for the subsample
    RV_sub[j] <- sum(returns^2)
  }
  
  ## Compute full-sample realized volatility
  returns_full <- diff(lprice)
  RV_n <- sum(returns_full^2)
  
  ## Compute TSRV estimate
  TSRV_estimate <- (1 / K) * sum(RV_sub) - (m / n) * RV_n
  
  return(list(
    TSRV = TSRV_estimate,
    K    = K,
    m    = m,
    n    = n
  ))
}

## =====================================================
## 3. Apply the TSRV function to the Alpha Vantage data
## =====================================================

# Set number of subsamples
K <- 5  # e.g., 5 subsamples

# Compute TSRV estimate
tsrv_result <- TSRV(priceX, K)

# Print the TSRV estimate
tsrv_result$TSRV
