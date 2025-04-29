
# Automatically set working directory to where the script is saved (RStudio only)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Set seed for reproducibility
set.seed(123)

# Parameters
n <- 1000  # Number of samples
phi <- 0.9  # AR coefficient
epsilon <- rnorm(n)  # White noise
Y <- rep(NA, n)  # Preallocate the series
Y[1] <- epsilon[1]  # Initial value

# Simulate AR(1) series
for (t in 2:n) {
  Y[t] <- phi * Y[t-1] + epsilon[t]
}

# Load necessary library
library(forecast)

# Fit an MA(10) model
fit <- Arima(Y, order = c(0, 0, 10))

# Fitted values as the deterministic component
fitted_values <- fitted(fit)

# Plot and save at the same time
# --- Save to a file ---
png("AR1_MA10_fit_plot.png", width = 600, height = 400)
plot(Y, type = "l", col = "blue", main = "AR(1) Simulated Series and MA(10) Fit",
     xlab = "Time", ylab = "Value")
lines(fitted_values, col = "red")
legend("topright", legend = c("Original Series", "Fitted Series"),
       col = c("blue", "red"), lty = 1)
dev.off()

# --- Display on screen ---
plot(Y, type = "l", col = "blue", main = "AR(1) Simulated Series and MA(10) Fit",
     xlab = "Time", ylab = "Value")
lines(fitted_values, col = "red")
legend("topright", legend = c("Original Series", "Fitted Series"),
       col = c("blue", "red"), lty = 1)
