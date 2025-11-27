#========================================
# (Optional) Set working directory to script location
#========================================
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

#========================================
# Load required packages
#========================================
# install.packages("forecast")
# install.packages("ggplot2")
library(forecast)
library(ggplot2)

#========================================
# Simulate a stationary AR(1) process
#========================================
set.seed(123)           # For reproducibility

n   <- 1000             # Number of observations
phi <- 0.9              # AR(1) coefficient

epsilon <- rnorm(n)     # White noise innovations
Y       <- numeric(n)   # Preallocate the series

# Initialize and generate the AR(1) recursion
Y[1] <- epsilon[1]
for (t in 2:n) {
  Y[t] <- phi * Y[t - 1] + epsilon[t]
}

#========================================
# Fit an MA(10) model (Wold-style approximation)
#========================================
fit <- Arima(Y, order = c(0, 0, 10), include.mean = FALSE)

# Fitted values: linear predictor (finite MA approximation)
fitted_values <- fitted(fit)

#========================================
# Prepare data for plotting
#========================================
df_wold <- data.frame(
  Time    = 1:n,
  Original = as.numeric(Y),
  Fitted   = as.numeric(fitted_values)
)

#========================================
# Plot: Original AR(1) vs MA(10) approximation
#========================================
p_wold <- ggplot(df_wold, aes(x = Time)) +
  geom_line(aes(y = Original, colour = "Original series")) +
  geom_line(aes(y = Fitted,   colour = "MA(10) approximation")) +
  labs(
    title = "Demonstration of the Wold decomposition (AR(1) \u2248 MA(10))",
    x     = "Time",
    y     = "Value",
    colour = "Series"
  )  

# Save the figure 
ggsave(filename = "Wold_decomposition.png", plot = p_wold, width = 6, height = 4, dpi = 300)
