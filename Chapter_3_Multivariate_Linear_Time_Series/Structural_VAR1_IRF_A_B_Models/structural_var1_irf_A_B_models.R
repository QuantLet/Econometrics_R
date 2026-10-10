## =====================================================
## 1. Set the simulation parameters
## =====================================================
# Clear the environment and set a seed for reproducibility
rm(list = ls())
set.seed(123)

# Length of the simulated time series
timeLength <- 500

# VAR(1) coefficient matrix (3-dimensional system)
CoeffMatrix <- matrix(c(0.25, 0.05, 0.20,
  0.10, 0.28, 0.22,
  0.65, 0.45, 0.28),
nrow = 3, byrow = TRUE)

# Structural impact matrix for contemporaneous shocks
ImpactMatrix <- diag(1, 3)
ImpactMatrix[lower.tri(ImpactMatrix)] <- c(-0.1, -0.06, 0.25)

## =====================================================
## 2. Simulate and plot the VAR process
## =====================================================
# Generate the time series data
timeSeriesData <- matrix(rnorm(3 * (timeLength + 1), 0, 1),
  nrow = 3, ncol = timeLength + 1)
for (i in 2:(timeLength + 1)) {
  timeSeriesData[, i] <- CoeffMatrix %*% timeSeriesData[,
    i - 1] +
    ImpactMatrix %*% rnorm(3, 0, 1)
}
timeSeriesData <- ts(t(timeSeriesData))  # Convert to time-series object
colnames(timeSeriesData) <- c("Series1", "Series2", "Series3")

# Plot the simulated series
plot.ts(timeSeriesData, main = "Simulated Time Series Data")

## =====================================================
## 3. Estimate the reduced-form VAR
## =====================================================
# Estimate a reduced-form VAR(1)
library(vars)
varModelEstimate <- vars::VAR(timeSeriesData, p = 1,
  type = "none")

## =====================================================
## 4. Estimate the structural A-model
## =====================================================

# A has a free diagonal; shock variances are normalized to
# one.
A_matrix <- matrix(NA_real_, 3, 3)
A_matrix[upper.tri(A_matrix)] <- 0

# Estimate structural VAR using A-model restrictions
SVAR_A_Model <- SVAR(varModelEstimate, Amat = A_matrix,
  max.iter = 1000)

# Display estimated A matrix and its standard errors
SVAR_A_Model
SVAR_A_Model$Ase

# Invert A to obtain the implied B matrix
solve(SVAR_A_Model$A)

## =====================================================
## 5. Estimate the structural B-model
## =====================================================

# B is lower triangular with free scale parameters.
B_matrix <- matrix(NA_real_, 3, 3)
B_matrix[upper.tri(B_matrix)] <- 0

# Estimate structural VAR using B-model restrictions
SVAR_B_Model <- SVAR(varModelEstimate, Bmat = B_matrix)

# Display estimated B matrix and its standard errors
SVAR_B_Model
SVAR_B_Model$Bse
