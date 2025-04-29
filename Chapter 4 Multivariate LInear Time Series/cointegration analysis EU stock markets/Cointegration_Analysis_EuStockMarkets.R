##########################################################################################
# Cointegration Analysis of EuStockMarkets: Regression, ADF, and Johansen Tests
##########################################################################################

# Clear all objects from the workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("urca", "tseries"))  # Uncomment if needed
library(urca)
library(tseries)

##########################################################################################
# 1. Load and Explore Data
##########################################################################################

# Load the EuStockMarkets dataset
data("EuStockMarkets")

# Quick summary statistics
summary(EuStockMarkets)

##########################################################################################
# 2. Extract Series and Plot
##########################################################################################

# Extract DAX and SMI series
DAX <- EuStockMarkets[, "DAX"]
SMI <- EuStockMarkets[, "SMI"]

# Plot DAX vs. SMI and save it
png("scatter_DAX_vs_SMI.png", width = 600, height = 400)
plot(DAX, SMI, 
     main = "Scatter Plot: DAX vs. SMI", 
     xlab = "SMI Index", 
     ylab = "DAX Index", 
     pch = 19, col = "blue")
dev.off()

# Also display the plot
plot(DAX, SMI, 
     main = "Scatter Plot: DAX vs. SMI", 
     xlab = "SMI Index", 
     ylab = "DAX Index", 
     pch = 19, col = "blue")

##########################################################################################
# 3. Perform Linear Regressions
##########################################################################################

# Regress DAX on SMI
comb1 <- lm(DAX ~ SMI)

# Regress SMI on DAX
comb2 <- lm(SMI ~ DAX)

# Summaries of linear regressions
summary(comb1)
summary(comb2)

##########################################################################################
# 4. Plot Residuals and Check for Stationarity
##########################################################################################

# Plot residuals from DAX ~ SMI and save it
png("residuals_comb1_DAX_on_SMI.png", width = 600, height = 400)
plot(comb1$residuals, type = "l", 
     main = "Residuals from Regression: DAX ~ SMI", 
     xlab = "Time", ylab = "Residuals")
dev.off()

# Display the plot
plot(comb1$residuals, type = "l", 
     main = "Residuals from Regression: DAX ~ SMI", 
     xlab = "Time", ylab = "Residuals")

# Plot residuals from SMI ~ DAX and save it
png("residuals_comb2_SMI_on_DAX.png", width = 600, height = 400)
plot(comb2$residuals, type = "l", 
     main = "Residuals from Regression: SMI ~ DAX", 
     xlab = "Time", ylab = "Residuals")
dev.off()

# Display the plot
plot(comb2$residuals, type = "l", 
     main = "Residuals from Regression: SMI ~ DAX", 
     xlab = "Time", ylab = "Residuals")

##########################################################################################
# 5. Augmented Dickey-Fuller (ADF) Test on Residuals
##########################################################################################

# ADF test on comb1 residuals
adf.test(comb1$residuals, k = 1)

# ADF test on comb2 residuals (optional, uncomment if needed)
# adf.test(comb2$residuals, k = 1)

##########################################################################################
# 6. Johansen Cointegration Tests
##########################################################################################

# Johansen Eigenvalue test
johansen_eigen_test <- ca.jo(EuStockMarkets, type = "eigen", 
                             ecdet = "const", spec = "longrun", K = 2)
summary(johansen_eigen_test)

# Johansen Trace test
johansen_trace_test <- ca.jo(EuStockMarkets, type = "trace", 
                             ecdet = "const", spec = "longrun", K = 2)
summary(johansen_trace_test)
