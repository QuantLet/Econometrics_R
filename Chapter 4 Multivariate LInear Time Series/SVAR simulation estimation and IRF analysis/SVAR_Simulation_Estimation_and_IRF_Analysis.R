##########################################################################################
# Structural VAR (SVAR) Simulation, Estimation, and Impulse Response Analysis
##########################################################################################

# Clear the environment and set a seed for reproducibility
rm(list = ls())
set.seed(123)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required library
# install.packages("vars")  # Uncomment if not installed
library(vars)

##########################################################################################
# 1. Simulate Multivariate Time Series Data
##########################################################################################

# Number of observations
timeLength <- 500

# Define coefficient matrix for VAR(1) process
CoeffMatrix <- matrix(c(0.25, 0.05, 0.20,
                        0.10, 0.28, 0.22,
                        0.65, 0.45, 0.28), 
                      nrow = 3, byrow = TRUE)

# Define structural impact matrix
ImpactMatrix <- diag(1, 3)
ImpactMatrix[lower.tri(ImpactMatrix)] <- c(-0.1, -0.06, 0.25)

# Generate the time series
timeSeriesData <- matrix(rnorm(3 * (timeLength + 1)), nrow = 3)
for (i in 2:(timeLength + 1)) {
  timeSeriesData[, i] <- CoeffMatrix %*% timeSeriesData[, i - 1] + 
    ImpactMatrix %*% rnorm(3)
}

# Convert to time series format
timeSeriesData <- ts(t(timeSeriesData))
colnames(timeSeriesData) <- c("Series1", "Series2", "Series3")

# Plot and save the simulated time series
png("simulated_time_series.png", width = 600, height = 400)
plot.ts(timeSeriesData, main = "Simulated Time Series Data")
dev.off()

# Display plot as well
plot.ts(timeSeriesData, main = "Simulated Time Series Data")

##########################################################################################
# 2. Estimate Reduced-Form VAR(1) Model
##########################################################################################

# Fit the VAR(1) model without intercept
varModelEstimate <- VAR(timeSeriesData, p = 1, type = "none")

##########################################################################################
# 3. Structural VAR Estimation Using A-Model Restrictions
##########################################################################################

# Define A matrix (lower-triangular elements as NA)
A_matrix <- diag(1, 3)
A_matrix[lower.tri(A_matrix)] <- NA

# Estimate SVAR model (A-Model)
SVAR_A_Model <- SVAR(varModelEstimate, Amat = A_matrix, max.iter = 1000)

# Display A-Model results
print(SVAR_A_Model)
print(SVAR_A_Model$Ase)  # Standard errors for A

# Invert A to get the implied B matrix
B_from_A <- solve(SVAR_A_Model$A)
print(B_from_A)

##########################################################################################
# 4. Structural VAR Estimation Using B-Model Restrictions
##########################################################################################

# Define B matrix (lower-triangular elements as NA)
B_matrix <- diag(1, 3)
B_matrix[lower.tri(B_matrix)] <- NA

# Estimate SVAR model (B-Model)
SVAR_B_Model <- SVAR(varModelEstimate, Bmat = B_matrix)

# Display B-Model results
print(SVAR_B_Model)
print(SVAR_B_Model$Bse)  # Standard errors for B

##########################################################################################
# 5. Impulse Response Analysis
##########################################################################################

# Compute IRFs for A-Model
irf_A_model <- irf(SVAR_A_Model, n.ahead = 10, boot = TRUE, ci = 0.95)

# Plot and save IRFs for A-Model
png("irf_SVAR_A_model.png", width = 600, height = 400)
plot(irf_A_model)
dev.off()

# Display plot
plot(irf_A_model)

# Compute IRFs for B-Model
irf_B_model <- irf(SVAR_B_Model, n.ahead = 10, boot = TRUE, ci = 0.95)

# Plot and save IRFs for B-Model
png("irf_SVAR_B_model.png", width = 600, height = 400)
plot(irf_B_model)
dev.off()

# Display plot
plot(irf_B_model)
