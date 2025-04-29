##########################################################################################
# Nadaraya–Watson Kernel Regression on mtcars Dataset
##########################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required library
# install.packages("KernSmooth")  # Uncomment if not installed
library(KernSmooth)

##########################################################################################
# 1. Load and Prepare Data
##########################################################################################

# Load built-in mtcars dataset
data("mtcars")

# Extract predictor and response variables
x <- mtcars$hp   # Horsepower
y <- mtcars$mpg  # Miles per Gallon

##########################################################################################
# 2. Perform Nadaraya–Watson Kernel Regression
##########################################################################################

# Select optimal bandwidth using plug-in method
bw <- dpill(x, y)

# Perform kernel regression (degree = 0 for Nadaraya–Watson estimator)
fit <- locpoly(x, y, bandwidth = bw, degree = 0, kernel = "normal", gridsize = 100)

##########################################################################################
# 3. Plot and Save Results
##########################################################################################

# Save the plot
png(filename = "Nadaraya_Watson_Regression_mtcars.png", width = 800, height = 600)

# Create plot
plot(x, y,
     main = "Nadaraya–Watson Estimation: MPG vs Horsepower",
     xlab = "Horsepower",
     ylab = "Miles per Gallon",
     pch = 19, col = "black")
lines(fit, col = "blue", lwd = 2)

# Finish saving
dev.off()

# Optional: Display plot interactively as well
plot(x, y,
     main = "Nadaraya–Watson Estimation: MPG vs Horsepower",
     xlab = "Horsepower",
     ylab = "Miles per Gallon",
     pch = 19, col = "black")
lines(fit, col = "blue", lwd = 2)
