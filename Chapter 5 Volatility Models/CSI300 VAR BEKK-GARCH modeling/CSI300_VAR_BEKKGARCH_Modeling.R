##########################################################################################
# CSI300 Index and Futures Analysis: VAR and BEKK-GARCH Modeling
##########################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("readxl", "forecast", "vars", "mgarchBEKK"))  # Uncomment if needed
library(readxl)      # For reading Excel files
library(forecast)    # For time series analysis
library(vars)        # For VAR model estimation
library(mgarchBEKK)  # For BEKK-GARCH model estimation

##########################################################################################
# 1. Load and Prepare Data
##########################################################################################

# Read Excel file
dat <- read_excel("CSI300_stock_index_and_futures_closing_prices.xlsx")

# Remove missing values
dat <- na.omit(dat)

# Extract and log-transform the closing prices
date <- dat$Date
LnS <- log(dat$CSI300_Stock_Index_Close_Price)
LnF <- log(dat$CSI300_Index_Futures_Current_Month_Close_Price)

# Calculate returns
n <- length(LnS)
date_ret <- date[-1]
RS <- LnS[-1] - LnS[-n]
RF <- LnF[-1] - LnF[-n]

# Create time series data frames
RS_tSeries <- data.frame(time = date_ret, RS)
RF_tSeries <- data.frame(time = date_ret, RF)

# Combine returns into one matrix for VAR modeling
dat_var <- cbind(RF, RS)

##########################################################################################
# 2. Estimate VAR Model
##########################################################################################

# Perform lag order selection for VAR model
VARselect(dat_var, lag.max = 12, type = "const")

# Fit VAR model with selected lag order (assume p = 3 here based on selection)
var_model <- VAR(dat_var, p = 3, type = "const")

# Extract residuals from the fitted VAR model
ut <- na.omit(resid(var_model))

##########################################################################################
# 3. Estimate BEKK-GARCH Model
##########################################################################################

# Fit BEKK-GARCH(1,1) model to VAR residuals
bekk_estimated <- BEKK(ut)

# Diagnose the fitted BEKK-GARCH model
diagnoseBEKK(bekk_estimated)
