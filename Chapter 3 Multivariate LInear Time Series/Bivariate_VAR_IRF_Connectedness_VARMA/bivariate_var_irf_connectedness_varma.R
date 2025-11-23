## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages(c("fredr", "vars", "ggplot2", "dplyr",
#                    "lubridate", "MTS"))

library(fredr)
library(vars)
library(ggplot2)
library(dplyr)
library(lubridate)
library(MTS)      # for VARMA simulation

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Set FRED API key (replace with your own!)
fredr_set_key("Your_Own_Key")

## =====================================================
## 2. Download bivariate macro data from FRED
##    Example: real consumption (PCEC96) and
##             real disposable income (DSPIC96)
## =====================================================

start_date <- as.Date("1960-01-01")
end_date   <- Sys.Date()

cons_raw <- fredr(
  series_id         = "PCEC96",   # Real PCE
  observation_start = start_date,
  observation_end   = end_date
)

inc_raw <- fredr(
  series_id         = "DSPIC96",  # Real DPI
  observation_start = start_date,
  observation_end   = end_date
)

df_raw <- inner_join(
  cons_raw %>% select(date, cons = value),
  inc_raw  %>% select(date, inc  = value),
  by = "date"
)

df <- df_raw %>%
  mutate(
    lcons = log(cons),
    linc  = log(inc)
  ) %>%
  filter(!is.na(lcons), !is.na(linc)) %>%
  arrange(date)

## =====================================================
## 3. Construct VAR data matrix and choose lag order
## =====================================================

start_year  <- year(min(df$date))
start_month <- month(min(df$date))

y_ts <- ts(
  df[, c("lcons", "linc")],
  start     = c(start_year, start_month),
  frequency = 12
)
colnames(y_ts) <- c("lcons", "linc")

# Choose VAR lag order by information criteria
lag_sel <- VARselect(y_ts, lag.max = 12, type = "const")
lag_sel$selection

p_opt <- as.numeric(lag_sel$selection["SC(n)"])
cat("Selected VAR(p) by SC:", p_opt, "\n")

## =====================================================
## 4. Estimate VAR(p) by OLS and inspect covariance
## =====================================================

var_fit <- vars::VAR(y_ts, p = p_opt, type = "const")
summary(var_fit)

# Extract estimated coefficient matrices and Omega
Phi_hat  <- Bcoef(var_fit)  # stacked coefficients
Omega_hat <- crossprod(resid(var_fit)) / nrow(resid(var_fit))
Omega_hat

# Sample covariance Gamma(0) of y_t
Gamma0_hat <- cov(y_ts)
Gamma0_hat

## =====================================================
## 5. Theoretical Gamma(0) for a VAR(1) approximation
##    (for illustration only)
## =====================================================

# Fit VAR(1)
var1_fit <- vars::VAR(y_ts, p = 1, type = "const")

# Coefficient matrix:
# rows = equations (lcons, linc)
# columns = const, l1.lcons, l1.linc
B1 <- Bcoef(var1_fit)

# Drop the intercept column, keep only lagged coefficients
# This is the A matrix in y_t = c + A y_{t-1} + eps_t
A_hat <- as.matrix(B1[, -1])  # n x n, no transpose

# Innovation covariance from VAR(1) residuals
Omega1_hat <- crossprod(resid(var1_fit)) / nrow(resid(var1_fit))

# Build I_{n^2} and compute vec(Gamma(0)) via (I - A⊗A)^{-1} vec(Omega)
n  <- ncol(y_ts)
I2 <- diag(n^2)

Gamma0_vec <- solve(I2 - kronecker(A_hat, A_hat)) %*% as.vector(Omega1_hat)
Gamma0_th  <- matrix(Gamma0_vec, nrow = n, ncol = n)

Gamma0_th
Gamma0_hat  # sample covariance for comparison

## =====================================================
## 6. Impulse Response Functions (IRFs)
## =====================================================

# 6.1 Standard (possibly orthogonalized) IRFs
irf_std <- irf(
  var_fit,
  impulse    = "linc",
  response   = "lcons",
  n.ahead    = 24,
  orth       = FALSE,  # set TRUE for Cholesky-orthogonalized
  boot       = TRUE,
  runs       = 500
)
plot(irf_std)

# 6.2 Full IRF array Psi_k from VAR coefficients
#     (following recursion in the text)
get_Psi_array <- function(Phi_list, K) {
  # Phi_list: list of Phi_1,...,Phi_p (each n x n)
  p <- length(Phi_list)
  n <- nrow(Phi_list[[1]])
  Psi <- array(0, dim = c(n, n, K + 1))
  Psi[, , 1] <- diag(n)  # Psi_0 = I_n
  
  for (k in 1:K) {
    tmp <- matrix(0, n, n)
    for (i in 1:min(p, k)) {
      tmp <- tmp + Psi[, , k + 1 - i] %*% Phi_list[[i]]
    }
    Psi[, , k + 1] <- tmp
  }
  Psi
}

# Extract Phi_1,...,Phi_p from 'var_fit'
p <- p_opt
n <- ncol(y_ts)
Phi_list <- vector("list", p)
for (ell in 1:p) {
  # 'Phi' stacked: each block (for a lag) is a 2x2 matrix row-wise
  # Bcoef(var_fit) returns: each row = eq, columns = const + lags
  Bmat <- Bcoef(var_fit)
  Phi_block <- matrix(NA, n, n)
  for (i in 1:n) {
    Phi_block[i, ] <- Bmat[i, (1 + (ell - 1) * n + 1):(1 + ell * n)]
  }
  Phi_list[[ell]] <- Phi_block
}

K_max <- 24
Psi_hat <- get_Psi_array(Phi_list, K = K_max)

# Example: response of lcons to a unit shock in the linc innovation
#          at horizons k = 0,...,K_max
irf_lcons_linc <- Psi_hat[1, 2, ]   # (i=1, j=2)
irf_lcons_linc

## =====================================================
## 7. Diebold-Yilmaz (2014) connectedness measure
##    d_ij^K computed from IRFs and Omega_hat
## =====================================================

connectedness_d <- function(Psi_array, Omega, K) {
  n <- dim(Psi_array)[1]
  d_mat <- matrix(0, n, n)
  
  for (i in 1:n) {
    for (j in 1:n) {
      num <- 0
      den <- 0
      sigma_jj <- Omega[j, j]
      e_i <- rep(0, n); e_i[i] <- 1
      e_j <- rep(0, n); e_j[j] <- 1
      
      for (k in 0:(K - 1)) {
        Psi_k <- Psi_array[, , k + 1]
        num <- num +
          (t(e_i) %*% Psi_k %*% Omega %*% e_j)^2
        den <- den +
          t(e_i) %*% Psi_k %*% Omega %*% t(Psi_k) %*% e_i
      }
      d_mat[i, j] <- as.numeric((1 / sigma_jj) * num / den)
    }
  }
  d_mat
}

K_spill <- 10
d_mat <- connectedness_d(Psi_hat, Omega_hat, K = K_spill)
d_mat

## =====================================================
## 8. VMA(1) example and cross-autocorrelation
##    (Example: y_1t i.i.d., y_2t MA(1))
## =====================================================

set.seed(123)
T_len <- 200
theta <- 0.7

eps1 <- rnorm(T_len)
eps2 <- rnorm(T_len)

y1 <- eps1 + c(0, eps2[-T_len])
y2 <- eps2 + theta * c(0, eps2[-T_len])

y_vma <- cbind(y1, y2)

# Empirical autocovariance at lag 1
Gamma1_hat <- cov(y_vma[-1, ], y_vma[-T_len, ])
Gamma1_hat

# Empirical autocorrelation matrix at lag 1
R1_hat <- cor(y_vma[-1, ], y_vma[-T_len, ])
R1_hat

# Theoretical quantities from the example:
# Gamma_11(1) = 0
# Gamma_21(1) = 1
# Gamma_22(1) = theta
# R_21(1)  = 1 / sqrt(2(1+theta^2))
# R_22(1)  = theta / (1+theta^2)

Gamma11_1_th <- 0
Gamma21_1_th <- 1
Gamma22_1_th <- theta

R21_1_th <- 1 / sqrt(2 * (1 + theta^2))
R22_1_th <- theta / (1 + theta^2)

Gamma11_1_th; Gamma21_1_th; Gamma22_1_th
R21_1_th; R22_1_th

## =====================================================
## 9. VARMA(1,1) simulation via MTS::VARMAsim
##    and approximation by a higher-order VAR
## =====================================================

# Make sure MTS is installed and loaded
# install.packages("MTS")
library(MTS)

k <- 2  # dimension

## AR(1) coefficient matrix: phi (2 x 2)
phi <- matrix(c(0.5, 0.1,
                0.2, 0.4),
              nrow = k, byrow = TRUE)

## MA(1) coefficient matrix: theta (2 x 2)
theta <- matrix(c(-0.3,  0.0,
                  0.0, -0.2),
                nrow = k, byrow = TRUE)

## Innovation covariance matrix sigma (2 x 2, positive definite)
Sigma_eps <- matrix(c(1.0, 0.3,
                      0.3, 1.0),
                    nrow = k, byrow = TRUE)

set.seed(123)

varma_sim <- VARMAsim(
  nobs   = 500,
  arlags = c(1),       # VAR(1)
  malags = c(1),       # VMA(1)
  cnst   = rep(0, k),  # zero mean
  phi    = phi,        # AR coefficient matrix
  theta  = theta,      # MA coefficient matrix
  sigma  = Sigma_eps   # innovation covariance
)

# Extract simulated series
y_varma <- varma_sim$series
colnames(y_varma) <- c("y1", "y2")

# Quick check: plot the simulated series
matplot(y_varma, type = "l",
        main = "Simulated VARMA(1,1) series",
        xlab = "Time", ylab = "",
        col = 1:2, lty = 1)
legend("topleft", legend = c("y1", "y2"), col = 1:2, lty = 1, bty = "n")

# Approximate VARMA(1,1) with a higher-order VAR

var4_fit <- vars::VAR(y_varma, p = 4, type = "const")
summary(var4_fit)

# Impulse response functions from the VAR(4) approximation
irf_var4 <- vars::irf(var4_fit, n.ahead = 20, ortho = TRUE)
plot(irf_var4)
