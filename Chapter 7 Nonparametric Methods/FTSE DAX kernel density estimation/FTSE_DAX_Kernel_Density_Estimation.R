##########################################################################################
# Multivariate Kernel Density Estimation of FTSE and DAX Daily Returns
##########################################################################################

# Clear workspace
rm(list = ls())

# Load necessary libraries
# install.packages(c("ks", "datasets"))  # Uncomment if not installed
library(datasets)
library(ks)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

##########################################################################################
# 1. Load and Prepare Data
##########################################################################################

# Load the EuStockMarkets dataset
data("EuStockMarkets")

# Extract FTSE (UK) and DAX (Germany) price series
ftse_prices <- EuStockMarkets[, "FTSE"]
dax_prices <- EuStockMarkets[, "DAX"]

# Compute daily percentage returns
ftse_returns <- diff(ftse_prices) / stats::lag(ftse_prices, -1) * 100
dax_returns <- diff(dax_prices) / stats::lag(dax_prices, -1) * 100

# Remove NA values caused by differencing
ftse_returns <- na.omit(ftse_returns)
dax_returns <- na.omit(dax_returns)

# Combine returns into a data frame
market_returns <- data.frame(FTSE_Returns = as.numeric(ftse_returns), 
                             DAX_Returns = as.numeric(dax_returns))

# Convert to matrix for multivariate KDE
data_matrix <- as.matrix(market_returns)

##########################################################################################
# 2. Multivariate Kernel Density Estimation
##########################################################################################

# Perform multivariate KDE
kde_result <- kde(x = data_matrix)

##########################################################################################
# 3. Plot and Save Results
##########################################################################################

# Save 2D filled contour plot
png(filename = "FTSE_DAX_KDE_FilledContour.png", width = 800, height = 600)
plot(kde_result, display = "filled.contour", cont = c(25, 50, 75, 90, 95))
dev.off()

# Save 3D perspective plot
png(filename = "FTSE_DAX_KDE_3D_Persp.png", width = 800, height = 600)
plot(kde_result, display = "persp")
dev.off()

# Display plots interactively (optional)
plot(kde_result, display = "filled.contour", cont = c(25, 50, 75, 90, 95))
plot(kde_result, display = "persp")
