rm(list = ls())
set.seed(123456)
library(vars)
library(tidyverse)

# Load the dataset
data("EuStockMarkets")

# Convert EuStockMarkets to a tibble
market_data <- as_tibble(EuStockMarkets)

# Calculate logarithmic returns
returns <- market_data %>%
  mutate(across(everything(), ~c(NA, diff(log(.))))) %>%
  na.omit()  # Removes rows with NA (the first row in this case)

# Fit a VAR model to the returns data
# Selecting an appropriate lag length using AIC
lag_selection <- VARselect(returns, type = "const")
optimal_lag <- lag_selection$selection[1]  # Use AIC to determine the optimal lag


var_model <- VAR(returns, p = optimal_lag, type = "const")

folder <- "/Users/R_code/advanced-time-series-chapter3/VAR-impulse-folder"
setwd(folder)

# Get the names of the variables in the VAR model
var_names <- colnames(returns)

# Loop through each pair of variables to generate IRFs
for (impulse_var in var_names) {
  for (response_var in var_names) {
    # Define the file name based on impulse and response variables
    file_name <- paste0("IRF_", impulse_var, "_to_", response_var, ".png")
    
    # Open a PNG device
    png(file_name, width = 400, height = 300)
    
    # Plot the IRF from 'impulse_var' to 'response_var'
    plot(irf(var_model, impulse = impulse_var, response = response_var, n.ahead = 10,ortho = TRUE, boot = TRUE), main = paste(impulse_var, "to", response_var))
    
    # Turn off the device (saves the file)
    dev.off()
  }
}