
##########################################################################################
# 1. Environment Setup
##########################################################################################

# Clear all variables
rm(list = ls())

# Set working directory to the script location (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
library(rmgarch)   # For multivariate GARCH modeling
library(ggplot2)   # For visualization
library(imputeTS)  # For interpolating missing values

##########################################################################################
# 2. Helper Function to Compute Log Returns
##########################################################################################

price2return <- function(p) {
  N <- length(p)
  returns <- (log(p[2:N]) - log(p[1:(N - 1)])) * 100
  returns <- na_interpolation(returns)  # Interpolate any missing values
  return(returns)
}

##########################################################################################
# 3. Load and Clean Data
##########################################################################################

# Read the dataset and remove weekends (rows with "Saturday" or "Sunday")
temp.dat <- read.csv("stock_indices.csv")
dat <- temp.dat[!temp.dat$weekdays %in% c("Saturday", "Sunday"), ]

# Extract price series
Dow_Jones <- dat$Dow_Jones_Index_Industrial_Average
SP <- dat$S.P.TSX_Composite_Index

##########################################################################################
# 4. Compute Return Series
##########################################################################################

Dow_Jones.return <- price2return(Dow_Jones)
SP.return <- price2return(SP)
return_series <- cbind(Dow_Jones.return, SP.return)

##########################################################################################
# 5. Fit ARIMA Models and Extract Residuals
##########################################################################################

arima_dj <- auto.arima(Dow_Jones.return)
arima_sp <- auto.arima(SP.return)

residuals_dj <- residuals(arima_dj)
residuals_sp <- residuals(arima_sp)

# Combine residuals
ut <- cbind(residuals_dj, residuals_sp)

##########################################################################################
# 6. Specify and Fit DCC-GARCH(1,1) Model
##########################################################################################

# Define univariate GARCH(1,1) specification
garch11.spec <- ugarchspec(
  mean.model = list(armaOrder = c(0, 0), include.mean = FALSE),
  variance.model = list(garchOrder = c(1, 1), model = "sGARCH"),
  distribution.model = "norm"
)

# Define DCC(1,1) model
dcc.garch11.spec <- dccspec(
  uspec = multispec(replicate(2, garch11.spec)),
  dccOrder = c(1, 1),
  distribution = "mvnorm"
)

# Fit the DCC model
dcc.fit <- dccfit(dcc.garch11.spec, data = ut)
print(dcc.fit)

##########################################################################################
# 7. Extract and Plot Dynamic Conditional Correlation
##########################################################################################

# Extract dynamic conditional correlation matrices
dynamic_correlation <- rcor(dcc.fit)

# Extract off-diagonal dynamic correlation series (between Dow Jones and SP)
off_diag_corr <- dynamic_correlation[2, 1, ]

# Create time index
time_index <- as.Date(dimnames(dynamic_correlation)[[3]])

# Create data frame for plotting
dynamic_corr_df <- data.frame(
  time = time_index,
  correlation = off_diag_corr
)

# Create the plot
dcc_plot <- ggplot(dynamic_corr_df, aes(x = time, y = correlation)) +
  geom_line(color = "blue") +
  labs(
    title = "Dynamic Conditional Correlation (Off-Diagonal)",
    x = "Time",
    y = "Correlation"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the plot
print(dcc_plot)

# Save the plot as PNG
ggsave("dcc_dynamic_correlation.png", dcc_plot, width = 8, height = 5)
