##########################################################################################
# Simulating a GARCH(1,1) Process and Model Selection by AIC and BIC
##########################################################################################

# Install and load rugarch package if needed
# install.packages("rugarch")
library(rugarch)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate a GARCH(1,1) Process
##########################################################################################

# Simulation parameters
n <- 1000
eps <- rnorm(n, mean = 0, sd = 1)  # Standard normal innovations
sigma2 <- rep(1, n)                # Conditional variance placeholder
y <- rep(0, n)                     # Time series placeholder

# True GARCH(1,1) parameters
alpha0 <- 0.01
alpha1 <- 0.05
beta1 <- 0.9

# Initialize first conditional variance
sigma2[1] <- alpha0 / (1 - alpha1 - beta1)

# Generate the GARCH(1,1) series
for (i in 2:n) {
  sigma2[i] <- alpha0 + alpha1 * y[i - 1]^2 + beta1 * sigma2[i - 1]
  y[i] <- rnorm(1, mean = 0, sd = sqrt(sigma2[i]))
}

##########################################################################################
# 2. Model Selection: Fit GARCH(p,q) Models and Compare AIC/BIC
##########################################################################################

# Define the maximum lag order
p_max <- 3
q_max <- 3

# Initialize matrices to store AIC and BIC values
aic_values <- matrix(NA, nrow = p_max, ncol = q_max,
                     dimnames = list(p = 1:p_max, q = 1:q_max))
bic_values <- matrix(NA, nrow = p_max, ncol = q_max,
                     dimnames = list(p = 1:p_max, q = 1:q_max))

# Fit GARCH(p,q) models across (p, q) combinations
for (p in 1:p_max) {
  for (q in 1:q_max) {
    spec <- ugarchspec(
      variance.model = list(model = "sGARCH", garchOrder = c(p, q)),
      mean.model = list(armaOrder = c(0, 0), include.mean = FALSE)
    )
    
    fit <- try(ugarchfit(spec = spec, data = y), silent = TRUE)
    
    if (!inherits(fit, "try-error")) {
      aic_values[p, q] <- infocriteria(fit)[1]  # AIC
      bic_values[p, q] <- infocriteria(fit)[2]  # BIC
    }
  }
}

##########################################################################################
# 3. Identify Best Models According to AIC and BIC
##########################################################################################

# Find the (p,q) pair minimizing AIC and BIC
best_aic <- which(aic_values == min(aic_values, na.rm = TRUE), arr.ind = TRUE)
best_bic <- which(bic_values == min(bic_values, na.rm = TRUE), arr.ind = TRUE)

# Print best (p, q) results
cat("Best (p, q) by AIC: (", best_aic[,"p"], ",", best_aic[,"q"], ")\n")
cat("Best (p, q) by BIC: (", best_bic[,"p"], ",", best_bic[,"q"], ")\n")
