##########################################################################################
# Simulating an ARCH(p) Process, Model Selection, and Diagnostic Testing
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear all objects from the workspace
rm(list = ls())

# Load required libraries
# install.packages(c("rugarch", "ggplot2", "FinTS"))  # Uncomment if needed
library(rugarch)
library(ggplot2)
library(FinTS)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate an ARCH(p) Process
##########################################################################################

# Simulation parameters
n <- 1000
omega <- 0.1
alphas <- c(0.5, 0.2, 0.1)  # ARCH(3) model (p = 3)

# Initialize variables
eps <- rnorm(n)
sigma2 <- rep(0, n)
sigma2[1:length(alphas)] <- omega / (1 - sum(alphas))

# Generate the ARCH(p) process
for (i in (length(alphas) + 1):n) {
  sigma2[i] <- omega + sum(alphas * eps[(i - 1):(i - length(alphas))]^2)
  eps[i] <- rnorm(1, sd = sqrt(sigma2[i]))
}

##########################################################################################
# 2. Plot and Save the Simulated ARCH(p) Series
##########################################################################################

# Prepare data frame
df <- data.frame(time = 1:n, eps = eps)

# Save the plot
png(filename = "simulated_ARCH_p_series.png", width = 800, height = 400)
ggplot(df, aes(x = time, y = eps)) +
  geom_line() +
  labs(title = "Simulated ARCH(p) Process", 
       x = "Time", 
       y = expression(epsilon[t])) +
  theme_minimal()
dev.off()

# Also display the plot
ggplot(df, aes(x = time, y = eps)) +
  geom_line() +
  labs(title = "Simulated ARCH(p) Process", 
       x = "Time", 
       y = expression(epsilon[t])) +
  theme_minimal()

##########################################################################################
# 3. Fit ARCH(p) Models of Different Orders and Select Best Model
##########################################################################################

# Model selection parameters
p_max <- 5  # Maximum order to consider
aic_values <- rep(NA, p_max)
bic_values <- rep(NA, p_max)

# Fit ARCH(p) models and compute information criteria
for (p in 1:p_max) {
  spec <- ugarchspec(variance.model = list(model = "sGARCH", 
                                           garchOrder = c(p, 0)),
                     mean.model = list(armaOrder = c(0, 0), 
                                       include.mean = FALSE))
  fit <- try(ugarchfit(spec, data = eps), silent = TRUE)
  
  if (!inherits(fit, "try-error")) {
    aic_values[p] <- infocriteria(fit)[1]
    bic_values[p] <- infocriteria(fit)[2]
  }
}

# Identify best model orders
best_p_aic <- which.min(aic_values)
best_p_bic <- which.min(bic_values)

# Print results
cat("Best p (based on AIC):", best_p_aic, "\n")
cat("Best p (based on BIC):", best_p_bic, "\n")

##########################################################################################
# 4. Fit Best Model and Perform Model Diagnostics
##########################################################################################

# Fit the best model selected by AIC
best_spec <- ugarchspec(variance.model = list(model = "sGARCH", 
                                              garchOrder = c(best_p_aic, 0)),
                        mean.model = list(armaOrder = c(0, 0), 
                                          include.mean = FALSE))
best_fit <- ugarchfit(best_spec, data = eps)

# Output model summary
show(best_fit)

# Perform Ljung–Box test on standardized residuals
standardized_residuals <- best_fit@fit$residuals / best_fit@fit$sigma
ljung_box_test <- Box.test(standardized_residuals, lag = 10, type = "Ljung-Box")

# Print Ljung-Box test results
print(ljung_box_test)
