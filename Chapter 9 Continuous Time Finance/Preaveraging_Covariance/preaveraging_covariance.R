# Bias-corrected pre-averaging covariance for synchronised log prices.
# N is the number of returns, not the number of observed prices.
pavx <- function(log_prices, theta = 0.8) {
  r <- diff(as.matrix(log_prices))
  N <- nrow(r); d <- ncol(r); k <- floor(theta * sqrt(N))
  stopifnot(N > k, k >= 2L, all(is.finite(r)))
  g <- function(u) pmin(u, 1 - u)
  weights <- g((1:(k - 1L)) / k)
  starts <- 0:(N - k + 1L)
  averaged <- matrix(0, length(starts), d)
  for (h in 1:(k - 1L))
    averaged <- averaged + weights[h] * r[starts + h, , drop = FALSE]
  psi1k <- k * sum(diff(g((0:k) / k))^2)
  psi2k <- sum(weights^2) / k
  noise_cov <- crossprod(r) / (2 * N)
  first <- N / (N - k + 2) * crossprod(averaged) / ((1/12) * k)
  first - psi1k / (theta^2 * psi2k) * noise_cov
}
