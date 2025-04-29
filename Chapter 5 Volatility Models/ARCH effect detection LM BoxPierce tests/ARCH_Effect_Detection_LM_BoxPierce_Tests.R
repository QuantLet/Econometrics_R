##########################################################################################
# ARCH Effect Detection: LM Test and Box-Pierce-Type Portmanteau Test
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("lmtest", "fUnitRoots"))  # Uncomment if not installed
library(lmtest)
library(fUnitRoots)

# Set seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate AR(1) Time Series Data
##########################################################################################

n <- 100  # Number of observations

# Generate AR(1) series
Y <- arima.sim(model = list(ar = 0.5), n = n)

# Fit AR(1) model as the conditional mean
model <- lm(Y[2:n] ~ Y[1:(n - 1)])

# Extract residuals
residuals <- model$residuals

##########################################################################################
# 2. LM Test for ARCH Effects
##########################################################################################

# Square the residuals
residuals_squared <- residuals^2

# Set lag order p (adjustable)
p <- 1

# Auxiliary regression: squared residuals on their lags
auxiliary_model <- lm(residuals_squared[(p + 1):n] ~ residuals_squared[1:(n - p)])

# Compute LM test statistic: (T - p) * R^2
lm_stat <- summary(auxiliary_model)$r.squared * (n - p)

# Output LM test statistic
cat("LM Test Statistic for ARCH Effects:", lm_stat, "\n")

##########################################################################################
# 3. Box-Pierce-Type (McLeod-Li) Portmanteau Test
##########################################################################################

# Compute sample mean of squared residuals
sigma_hat_squared <- mean(residuals_squared)

# Demean the squared residuals
demeaned_residuals_squared <- residuals_squared - sigma_hat_squared

# Compute sample variance (gamma_0)
gamma_hat_0 <- var(demeaned_residuals_squared)

# Compute sample autocovariances for lags 1 to p
gamma_hat_j <- sapply(1:p, function(j) {
  mean(demeaned_residuals_squared[(j + 1):n] * demeaned_residuals_squared[1:(n - j)], na.rm = TRUE)
})

# Calculate autocorrelations
rho_hat <- gamma_hat_j / gamma_hat_0

# Compute Box-Pierce-type statistic ML(p)
ml_stat <- n * sum(rho_hat^2)

# Output Box-Pierce-type statistic
cat("Box-Pierce-Type (McLeod-Li) Statistic:", ml_stat, "\n")
