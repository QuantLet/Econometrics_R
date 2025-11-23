## =====================================================
## 1. Prepare environment & download data from Yahoo
## =====================================================

# install.packages("quantmod")   # run once if needed
# install.packages("rmgarch")    # run once if needed
# install.packages("dplyr")      # run once if needed

library(quantmod)
library(rmgarch)
library(dplyr)

# (Optional) set working directory in RStudio to this script's folder
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)), silent = TRUE)
}

# Example assets: S&P500, Nasdaq 100, MSCI EAFE
symbols <- c("SPY", "QQQ", "EFA")

getSymbols(
  symbols,
  src         = "yahoo",
  from        = "2015-01-01",
  to          = "2024-12-31",
  auto.assign = TRUE
)

# Adjusted close prices, merged
price_xts <- na.omit(
  cbind(Ad(SPY), Ad(QQQ), Ad(EFA))
)
colnames(price_xts) <- symbols

# Daily log returns (in %) and demean them => "innovations"
ret_xts <- na.omit(diff(log(price_xts)) * 100)
eps_xts <- sweep(ret_xts, 2, colMeans(ret_xts), FUN = "-")

T <- nrow(eps_xts)
k <- ncol(eps_xts)

## =====================================================
## 2. Univariate GARCH(1,1) for each series
## =====================================================

# Same univariate GARCH specification for all assets
uspec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)

# Build a multispec object (one spec per series)
mspec <- multispec(replicate(k, uspec, simplify = FALSE))

# Fit univariate GARCH models jointly series-by-series
u_fit <- multifit(mspec, data = ret_xts)

# Extract conditional sigmas and standardized residuals
sigma_mat <- sapply(1:k, function(j) sigma(u_fit@fit[[j]]))
colnames(sigma_mat) <- symbols
z_mat <- sapply(1:k, function(j) residuals(u_fit@fit[[j]]) / sigma(u_fit@fit[[j]]))
colnames(z_mat) <- symbols

## =====================================================
## 3. Constant–correlation GARCH construction
## =====================================================

# Estimate a time-invariant correlation matrix from standardized residuals
R_const <- cor(z_mat, use = "complete.obs")

# For each t, build Σ_t = D_t R_const D_t
Sigma_const_list <- vector("list", T)
for (t in 1:T) {
  D_t <- diag(sigma_mat[t, ])
  Sigma_const_list[[t]] <- D_t %*% R_const %*% D_t
}

# Example: last constant–correlation covariance and correlation
Sigma_const_last <- Sigma_const_list[[T]]
R_const_last     <- cov2cor(Sigma_const_last)

Sigma_const_last
R_const_last

## =====================================================
## 4. DCC–GARCH(1,1): dynamic correlations
## =====================================================

# DCC specification: univariate specs + DCC(1,1) correlation dynamics
dcc_spec <- dccspec(
  uspec    = mspec,
  dccOrder = c(1, 1),
  distribution = "mvnorm"
)

# Fit DCC model
dcc_fit <- dccfit(dcc_spec, data = ret_xts)

# Extract time-varying conditional covariance and correlation
# H_t is an array of dimension (k x k x T)
H_array <- rcov(dcc_fit)   # conditional covariance matrices
R_array <- rcor(dcc_fit)   # conditional correlation matrices

# Example: last DCC covariance and correlation
Sigma_dcc_last <- H_array[, , T]
R_dcc_last     <- R_array[, , T]

Sigma_dcc_last
R_dcc_last

## =====================================================
## 5. Cholesky decomposition & orthogonal shocks
## =====================================================

# Choose a time point (e.g. last one) and take Σ_T from DCC
Sigma_T <- Sigma_dcc_last

# Cholesky factor: note that chol() returns upper-triangular U with Σ = U'U
U_T <- chol(Sigma_T)
L_T <- t(U_T)  # lower-triangular so that Σ_T = L_T L_T'

# Take the corresponding innovations at time T
eps_T <- as.numeric(eps_xts[T, ])

# Orthogonal shocks: b_T = L_T^{-1} eps_T
b_T <- solve(L_T, eps_T)

# Check that these shocks are (approximately) uncorrelated with unit variance
# Var(b_T | F_{T-1}) = I_k if Σ_T is exact covariance of eps_T
b_T
t(b_T) %*% b_T          # squared length at one time point
# In practice you could apply this over all t to build a series of orthogonal shocks

## =====================================================
## 6. Summary
## =====================================================
# - Sigma_const_list[[t]] holds constant-correlation GARCH covariances.
# - H_array[,,t] and R_array[,,t] give DCC-GARCH covariances/correlations.
# - L_T and b_T illustrate a Cholesky-based orthogonalization at time T.