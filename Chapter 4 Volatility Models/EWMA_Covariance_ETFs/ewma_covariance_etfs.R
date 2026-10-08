## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages("quantmod")  # if needed
# install.packages("dplyr")     # if needed

library(quantmod)
library(dplyr)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Download price data from Yahoo Finance
## =====================================================

# Choose a small set of liquid ETFs/stocks
symbols <- c("SPY", "QQQ", "EFA")  # S&P 500, Nasdaq 100, MSCI EAFE

# Download daily prices from Yahoo
# Saved adjusted prices: 2015--2024, retrieved 8 October 2026.
d <- read.csv("ETF_adjusted_2015_2024.csv")
price_xts <- xts::xts(d[,symbols], order.by=as.Date(d$date))
price_xts <- na.omit(price_xts)


## =====================================================
## 3. Compute log returns and residual matrix eps
## =====================================================

# Compute daily log returns (in percent, optional)
ret_xts <- na.omit(diff(log(price_xts))) * 100

# In this simple example we use demeaned returns as "innovations"
# In a full model, eps would be residuals from a multivariate mean equation
eps_xts <- sweep(ret_xts, 2, colMeans(ret_xts), FUN = "-")

# Convert to T x k matrix
eps <- coredata(eps_xts)
T   <- nrow(eps)
k   <- ncol(eps)

## =====================================================
## 4. EWMA covariance matrices
## =====================================================

# Decay factor lambda: larger values = slower decay
lambda <- 0.94

# Initialize list to store Sigma_t
Sigma_list <- vector("list", T)
Sigma_list[[1]] <- cov(eps)  # initial covariance (e.g. sample)

# Recursive EWMA update
for (t in 2:T) {
  e_prev <- matrix(eps[t - 1, ], ncol = 1)
  Sigma_list[[t]] <-
    (1 - lambda) * (e_prev %*% t(e_prev)) +
      lambda * Sigma_list[[t - 1]]
}

## =====================================================
## 5. Example: extract latest EWMA covariance & correlations
## =====================================================

Sigma_last <- Sigma_list[[T]]        # Sigma_T
Sigma_last

# Corresponding EWMA correlations
D_last   <- diag(1 / sqrt(diag(Sigma_last)))
R_last   <- D_last %*% Sigma_last %*% D_last
R_last
