## ===================================================
## Simulating a VAR(1) Model with Structural Impact
## ===================================================

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

# Generate the time series data
timeSeriesData <- matrix(rnorm(3 * (timeLength + 1), 0, 1),
                         nrow = 3, ncol = timeLength + 1)
for (i in 2:(timeLength + 1)) {
  timeSeriesData[, i] <- CoeffMatrix %*% timeSeriesData[, i - 1] +
    ImpactMatrix %*% rnorm(3, 0, 1)
}
timeSeriesData <- ts(t(timeSeriesData))  # Convert to time-series object
colnames(timeSeriesData) <- c("Series1", "Series2", "Series3")

# Plot the simulated series
plot.ts(timeSeriesData, main = "Simulated Time Series Data")

# Estimate a reduced-form VAR(1)
library(vars)
varModelEstimate <- vars::VAR(timeSeriesData, p = 1, type = "none")

## A-model: restrictions on A (contemporaneous relations)

# A is lower triangular with ones on the diagonal; NA = free parameter
A_matrix <- diag(1, 3)
A_matrix[lower.tri(A_matrix)] <- NA

# Estimate structural VAR using A-model restrictions
SVAR_A_Model <- SVAR(varModelEstimate, Amat = A_matrix, max.iter = 1000)

# Display estimated A matrix and its standard errors
SVAR_A_Model
SVAR_A_Model$Ase

# Invert A to obtain the implied B matrix
solve(SVAR_A_Model$A)

## B-model: restrictions on B (impact matrix for orthogonal shocks)

# B is lower triangular with ones on the diagonal; NA = free parameter
B_matrix <- diag(1, 3)
B_matrix[lower.tri(B_matrix)] <- NA

# Estimate structural VAR using B-model restrictions
SVAR_B_Model <- SVAR(varModelEstimate, Bmat = B_matrix)

# Display estimated B matrix and its standard errors
SVAR_B_Model
SVAR_B_Model$Bse

# Impulse responses for the A-model
irf_A_model <- irf(SVAR_A_Model, n.ahead = 10, boot = TRUE, ci = 0.95)
plot(irf_A_model)

# Impulse responses for the B-model
irf_B_model <- irf(SVAR_B_Model, n.ahead = 10, boot = TRUE, ci = 0.95)
plot(irf_B_model)