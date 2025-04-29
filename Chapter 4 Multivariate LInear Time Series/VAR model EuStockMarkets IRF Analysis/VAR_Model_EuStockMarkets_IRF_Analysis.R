##########################################################################################
# Impulse Response Function (IRF) Analysis Using a VAR Model on EuStockMarkets Data
##########################################################################################

# Clear the workspace
rm(list = ls())

# Set seed for reproducibility
set.seed(123)

# Load necessary libraries
# install.packages(c("vars", "tidyverse"))  # Uncomment if needed
library(vars)
library(tidyverse)

##########################################################################################
# 1. Load and Prepare Data
##########################################################################################

# Load EuStockMarkets dataset
data("EuStockMarkets")

# Convert to tibble for easier manipulation
market_data <- as_tibble(EuStockMarkets)

# Calculate logarithmic returns
returns <- market_data %>% 
  mutate(across(everything(), ~ c(NA, diff(log(.))))) %>%
  na.omit()

##########################################################################################
# 2. Fit VAR Model
##########################################################################################

# Select optimal lag length using AIC
lag_selection <- VARselect(returns, type = "const")
optimal_lag <- lag_selection$selection[1]  # Choose lag order minimizing AIC

# Fit VAR model
var_model <- VAR(returns, p = optimal_lag, type = "const")

##########################################################################################
# 3. Set Working Directory (only works in RStudio)
##########################################################################################

if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

##########################################################################################
# 4. Generate and Save Impulse Response Function (IRF) Plots
##########################################################################################

# Get variable names
var_names <- colnames(returns)

# Loop over all impulse-response pairs
for (impulse_var in var_names) {
  for (response_var in var_names) {
    # Define file name
    file_name <- paste0("IRF_", impulse_var, "_to_", response_var, ".png")
    
    # Open PNG device
    png(file_name, width = 600, height = 400)
    
    # Plot the IRF
    plot(irf(var_model, impulse = impulse_var, response = response_var, 
             ortho = TRUE, n.ahead = 10, boot = TRUE),
         main = paste(impulse_var, "to", response_var))
    
    # Close the device to save the plot
    dev.off()
  }
}
