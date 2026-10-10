source("covariance_estimators.R")

## =====================================================
## 1. Apply the estimators to one common log-price grid
## =====================================================
set.seed(321)
N <- 1200L
Sigma <- matrix(c(.0003, .00008, .00008, .0002), 2, 2)
increments <- matrix(rnorm(2*N), N, 2) %*% chol(Sigma/N)
x <- rbind(c(0, 0), apply(increments, 2, cumsum))
y <- x + matrix(rnorm(2*(N+1), sd = .0004), N+1, 2)
estimates <- list(TSX = tsx_cov(y, K = 80),
  PAVX = pavx(y), PAVX_plus = pavx(y, psd = TRUE))
for (name in names(estimates)) {
  cat("\n", name, "\n")
  print(estimates[[name]], digits = 7)
  cat("Eigenvalues:", eigen(estimates[[name]],
    symmetric = TRUE)$values, "\n")
}

## =====================================================
## 2. Check identical columns and a change of coordinates
## =====================================================
duplicated <- cbind(y[, 1], y[, 1])
s <- tsx_cov(duplicated, K = 80)
stopifnot(max(abs(s - s[1, 1])) < 1e-14)
A <- matrix(c(1, .2, .3, 1), 2, 2)
transformed <- tsx_cov(y %*% t(A), K = 80)
stopifnot(max(abs(transformed -
  A %*% estimates$TSX %*% t(A))) < 1e-14)

## =====================================================
## 3. Contrast subtraction with a sum of outer products
## =====================================================
P <- matrix(c(2, 1.5, 1.5, 2), 2, 2)
D <- diag(2)
cat("\nEigenvalues before and after subtraction:\n")
print(rbind(P = eigen(P)$values, D = eigen(D)$values,
  difference = eigen(P-D)$values))
stopifnot(min(eigen(P)$values) > 0, min(eigen(D)$values) > 0,
  min(eigen(P-D)$values) < 0)
stopifnot(min(eigen(estimates$PAVX_plus,
  symmetric = TRUE)$values) > -1e-12)
cat("\nAll algebraic checks passed.\n")
