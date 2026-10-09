# Bias-corrected PAVX, or its positive-semidefinite version.
pavx <- function(log_prices, theta = 0.8, psd = FALSE) {
  ## =====================================================
  ## 1. Choose the pre-averaging window
  ## =====================================================
  r <- diff(as.matrix(log_prices))
  N <- nrow(r)
  d <- ncol(r)
  delta <- if (psd) 0.1 else 0
  k <- floor(theta * N^(0.5 + delta))
  stopifnot(N > k, k >= 2L, all(is.finite(r)))

  ## =====================================================
  ## 2. Form weighted return averages
  ## =====================================================
  g <- function(u) pmin(u, 1 - u)
  weights <- g((1:(k - 1L)) / k)
  starts <- 0:(N - k + 1L)
  averaged <- matrix(0, length(starts), d)
  for (h in 1:(k - 1L))
    averaged <- averaged + weights[h] * r[starts + h, , drop = FALSE]

  ## =====================================================
  ## 3. Apply the selected bias correction
  ## =====================================================
  first <- N / (N - k + 2) * crossprod(averaged) / ((1 / 12) * k)
  if (psd) return(first)
  psi1k <- k * sum(diff(g((0:k) / k))^2)
  psi2k <- sum(weights^2) / k
  noise_cov <- crossprod(r) / (2 * N)
  first - psi1k / (theta^2 * psi2k) * noise_cov
}
