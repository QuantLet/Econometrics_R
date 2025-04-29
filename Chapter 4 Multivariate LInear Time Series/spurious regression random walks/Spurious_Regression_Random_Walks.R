##########################################################################################
# Spurious Regression: Regressing One Random Walk on Another
##########################################################################################

# Set random seed for reproducibility
set.seed(123)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear all objects from the workspace
rm(list = ls())

##########################################################################################
# 1. Simulate Two Independent Random Walks
##########################################################################################

n <- 100  # Number of observations

# Generate independent random walks
RW1 <- cumsum(rnorm(n))
RW2 <- cumsum(rnorm(n))

##########################################################################################
# 2. Perform Linear Regression of RW1 on RW2
##########################################################################################

# Fit a linear model
model <- lm(RW1 ~ RW2)

# Output the summary of the regression model
summary(model)

##########################################################################################
# 3. Plot and Save the Scatter Plot with Regression Line
##########################################################################################

# Base R plot (display)
plot(RW2, RW1, 
     main = "Spurious Regression: RW1 vs RW2", 
     xlab = "RW2", 
     ylab = "RW1", 
     pch = 19, col = "blue")
abline(model, col = "red", lwd = 2)

# Save the plot as a PNG file
png(filename = "spurious_regression_plot.png", width = 600, height = 400)
plot(RW2, RW1, 
     main = "Spurious Regression: RW1 vs RW2", 
     xlab = "RW2", 
     ylab = "RW1", 
     pch = 19, col = "blue")
abline(model, col = "red", lwd = 2)
dev.off()
