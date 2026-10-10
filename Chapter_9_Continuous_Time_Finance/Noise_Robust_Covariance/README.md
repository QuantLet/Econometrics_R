# Noise-robust covariance estimation on a common grid

These examples accompany Chapter 9 of *Econometrics and Time Series Methods:
Theory, Applications, and R Implementation*.

## R functions

Run the scripts with this directory as the working directory. Only base R is
required; all observations in the demonstration are simulated.

- covariance_estimators.R defines tsx_cov() and pavx().
- covariance_examples.R illustrates their use, verifies the identical-column
  and coordinate-transformation properties of TSX, and explains why subtracting
  positive-definite matrices can produce an indefinite matrix.

Both functions take a numeric matrix of synchronised **log prices**, with N+1
rows for N return intervals. Each column represents one asset.

### Two-scale covariance

tsx_cov(log_prices, K, J=1, endpoint=FALSE) applies the same finite-sample
factor to every covariance and variance entry. The default is the common
two-scale formula printed in the book. The endpoint option rescales the entire
matrix to remove its finite-sample signal bias under zero drift, constant
covariance and equally spaced observations. Neither option projects eigenvalues.

TSX is not guaranteed to be positive semidefinite. Bandwidths and the smallest
eigenvalues should be inspected before using an estimate for portfolio allocation.

### Pre-averaging covariance

pavx(log_prices, theta=0.8, psd=FALSE) computes the book's bias-corrected formula,
including cross-asset noise covariance. The window is floor(theta * sqrt(N)).

With psd=TRUE the window is floor(theta * N^0.6) and the subtraction is omitted.
The result is a positive multiple of a sum of outer products, so it is positive
semidefinite without a subsequent eigenvalue projection. Positive definiteness
additionally requires that the pre-averaged return vectors span the asset space.
The wider window and remaining finite-sample noise contribution affect accuracy.

## Reproduce the demonstration

Run Rscript covariance_examples.R from this directory. Expected output is in
example_output.txt. A positive-semidefinite guarantee does not imply invertibility,
a well-conditioned matrix, or smaller estimation error than competing methods.

References:
- Zhang (2011), Estimating covariation: Epps effect, microstructure noise,
  https://doi.org/10.1016/j.jeconom.2010.03.012
- Christensen, Kinnebrock and Podolskij (2010), Pre-averaging estimators of the
  ex-post covariance matrix in noisy diffusion models with non-synchronous data,
  https://doi.org/10.1016/j.jeconom.2010.05.001

## About this example

Compare two-scale and pre-averaging covariance estimates from simulated noisy log prices. Use the same finite-sample correction for TSX variances and covariances, and inspect eigenvalues before forming portfolio weights.

Notes updated: 11 October 2026.
