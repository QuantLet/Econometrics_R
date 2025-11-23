## =====================================================
# 1. Load required package
## =====================================================

if (!requireNamespace("quadprog", quietly = TRUE)) {
  install.packages("quadprog")
}
library(quadprog)

### =====================================================
# 2. Unconstrained GMVP Weights (allows short-selling)
## =====================================================
compute_mvp_weights_simple <- function(cov_matrix) {
  n <- nrow(cov_matrix)                   # Number of assets
  ones <- rep(1, n)                       # Vector of ones
  inv_cov_matrix <- solve(cov_matrix)     # Inverse of the covariance matrix
  
  # GMVP formula: weights = Σ⁻¹1 / (1ᵀΣ⁻¹1)
  weights <- inv_cov_matrix %*% ones / as.numeric(t(ones) %*% inv_cov_matrix %*% ones)
  return(as.vector(weights))
}

## =====================================================
# 3. Constrained GMVP Weights (no short-selling)
## =====================================================
compute_mvp_weights <- function(cov_matrix) {
  n <- nrow(cov_matrix)
  
  Dmat <- 2 * cov_matrix                 # Quadratic term (multiplied by 2)
  dvec <- rep(0, n)                      # Linear term
  Amat <- cbind(rep(1, n), diag(n))     # Constraints: sum(weights) = 1 and weights >= 0
  bvec <- c(1, rep(0, n))                # RHS for constraints
  meq <- 1                               # One equality constraint (sum = 1)
  
  # Solve QP problem
  solution <- quadprog::solve.QP(Dmat, dvec, Amat, bvec, meq)
  return(solution$solution)
}
