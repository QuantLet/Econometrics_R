# Clear the environment and set a seed for reproducibility
rm(list = ls())
set.seed(123456) 
  
# Set the number of observations for the time series
timeLength <- 500 

# Define the coefficient matrix for the VAR process
CoeffMatrix <- matrix(c(0.3, 0, 0.24,
                        0.12, 0.3, 0.24,
                        0.69, 0.48, 0.3), 3, byrow = TRUE)

# Define structural coefficients for the impact matrix
ImpactMatrix <- diag(1, 3)
ImpactMatrix[lower.tri(ImpactMatrix)] <- c(-0.14, -0.06, 0.39)

# Initialize and generate the time series data
timeSeriesData <- matrix(rnorm(3, 0, 1), 3, timeLength + 1) # Starting series
for (i in 2:(timeLength + 1)){
  timeSeriesData[, i] <- CoeffMatrix %*% timeSeriesData[, i - 1] +  ImpactMatrix %*% rnorm(3, 0, 1)
}

timeSeriesData <- ts(t(timeSeriesData)) # Convert to time series format
dimnames(timeSeriesData)[[2]] <- c("Series1", "Series2", "Series3") # Rename variables

# Plotting the generated time series
plot.ts(timeSeriesData, main = "Simulated Time Series Data") 

# Load necessary library for VAR model estimation
library(vars)

# Estimate a reduced form VAR model
varModelEstimate <- VAR(timeSeriesData, p = 1, type = "none") 

# Estimating the A-model
# Define the A matrix with restrictions for structural estimation
A_matrix <- diag(1, 3)
A_matrix[lower.tri(A_matrix)] <- NA

# Estimate structural VAR using A-model restrictions
SVAR_A_Model <- SVAR(varModelEstimate, Amat = A_matrix, max.iter = 1000)

# Display the estimated A-model
SVAR_A_Model

# Inverting A to get the B matrix for the A-model
solve(SVAR_A_Model$A)

# Estimating confidence intervals for the structural coefficients in A-model
SVAR_A_Model$Ase

# Estimating the B-model
# Define the B matrix with restrictions for structural estimation
B_matrix <- diag(1, 3)
B_matrix[lower.tri(B_matrix)] <- NA

# Estimate structural VAR using B-model restrictions
SVAR_B_Model <- SVAR(varModelEstimate, Bmat = B_matrix)

# Display the estimated B-model
SVAR_B_Model
 

# For long-run restrictions, you typically need to work with the model's impulse response
# This involves identifying which shocks are permanent and their effects
# Here we illustrate with a pseudo-code approach for conceptual purposes

# Estimate impulse responses
irf_results <- irf(varModelEstimate, n.ahead = 50, boot = TRUE)
plot(irf_results )
