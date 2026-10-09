## Two-scale and pre-averaging covariance on a common grid

# N counts return intervals; the input has N + 1 log prices.
tsx_cov <- function(log_prices, K, J = 1L, endpoint = FALSE) {
  x <- as.matrix(log_prices)
  N <- nrow(x) - 1L
  stopifnot(all(is.finite(x)), J == as.integer(J),
    K == as.integer(K), 1L <= J, J < K, K <= N)
  variation <- function(h) {
    z <- x[(h + 1L):(N + 1L), , drop = FALSE] -
         x[1L:(N + 1L - h), , drop = FALSE]
    crossprod(z) / h
  }
  nK <- (N - K + 1) / K
  nJ <- (N - J + 1) / J
  rho <- nK / nJ
  factor <- if (endpoint) N / ((K - J) * nK) else 1 / (1 - rho)
  factor * (variation(K) - rho * variation(J))
}

# Bias-corrected PAVX, or its positive-semidefinite version.
pavx <- function(log_prices, theta = 0.8, psd = FALSE) {
  r <- diff(as.matrix(log_prices))
  N <- nrow(r); d <- ncol(r)
  delta <- if (psd) 0.1 else 0
  k <- floor(theta * N^(0.5 + delta))
  stopifnot(N > k, k >= 2L, all(is.finite(r)))
  g <- function(u) pmin(u, 1 - u)
  weights <- g((1:(k - 1L)) / k)
  starts <- 0:(N - k + 1L)
  averaged <- matrix(0, length(starts), d)
  for (h in 1:(k - 1L))
    averaged <- averaged + weights[h] * r[starts + h, , drop = FALSE]
  first <- N / (N - k + 2) * crossprod(averaged) / ((1/12) * k)
  if (psd) return(first)
  psi1k <- k * sum(diff(g((0:k) / k))^2)
  psi2k <- sum(weights^2) / k
  noise_cov <- crossprod(r) / (2 * N)
  first - psi1k / (theta^2 * psi2k) * noise_cov
}
