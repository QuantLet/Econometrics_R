##########################################################################################
# Linear vs Nonparametric Regression: Model Fitting and Residual Analysis
##########################################################################################

# Clear workspace
rm(list = ls())

# Load required libraries
# install.packages(c("ggplot2", "ggpubr"))  # Uncomment if not installed
library(ggplot2)
library(ggpubr)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

##########################################################################################
# 1. Simulate Nonlinear Data
##########################################################################################

# Set random seed for reproducibility
set.seed(123)

# Generate nonlinear data: y = sin(x) + noise
x_vals <- seq(-3, 3, length.out = 100)
y_vals <- sin(x_vals) + rnorm(length(x_vals), sd = 0.3)

# Create data frame
data <- data.frame(x = x_vals, y = y_vals)

##########################################################################################
# 2. Fit Models: Linear Regression and LOESS (Local Polynomial Regression)
##########################################################################################

# Fit linear regression model
linear_model <- lm(y ~ x, data = data)

# Fit nonparametric LOESS model (degree 2)
loess_model <- loess(y ~ x, data = data, degree = 2)

# Predict fitted values
data$y_pred_linear <- predict(linear_model, newdata = data)
data$y_pred_loess  <- predict(loess_model, newdata = data)

# Compute residuals
data$residuals_linear <- data$y - data$y_pred_linear
data$residuals_loess  <- data$y - data$y_pred_loess

##########################################################################################
# 3. Create Plots
##########################################################################################

# Plot 1: Fitted values from both models
plot1 <- ggplot(data, aes(x = x)) +
  geom_point(aes(y = y), color = "black") +
  geom_line(aes(y = y_pred_linear), color = "blue", size = 1) +
  geom_line(aes(y = y_pred_loess), color = "red", size = 1) +
  labs(title = "Fitted Values", x = "x", y = "y") +
  theme_minimal()

# Plot 2: Residuals of linear regression
plot2 <- ggplot(data, aes(x = x, y = residuals_linear)) +
  geom_point(color = "blue") +
  labs(title = "Residuals of Linear Regression", x = "x", y = "Residuals") +
  theme_minimal()

# Plot 3: Residuals of LOESS
plot3 <- ggplot(data, aes(x = x, y = residuals_loess)) +
  geom_point(color = "red") +
  labs(title = "Residuals of LOESS", x = "x", y = "Residuals") +
  theme_minimal()

##########################################################################################
# 4. Arrange and Save the Plots
##########################################################################################

# Arrange plots into a single row
combined_plot <- ggarrange(plot1, plot2, plot3, ncol = 3, nrow = 1)

# Display the combined plot
print(combined_plot)

# Save the arranged plot
ggsave(filename = "Linear_vs_LOESS_Fitted_and_Residuals.png", plot = combined_plot, 
       width = 15, height = 5, dpi = 300)
