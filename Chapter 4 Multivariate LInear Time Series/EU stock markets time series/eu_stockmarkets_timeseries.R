##########################################################################################
# Plotting EuStockMarkets Time Series with ggplot2
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear all objects from the workspace
rm(list = ls())

# Load required libraries
# install.packages(c("tidyverse", "ggplot2")) # Uncomment if not installed
library(tidyverse)
library(ggplot2)

##########################################################################################
# 1. Load and Prepare Data
##########################################################################################

# Load the EuStockMarkets dataset
data("EuStockMarkets")

# Convert to tibble and reshape to long format for ggplot2
eu_stocks_long <- as_tibble(EuStockMarkets) %>%
  mutate(Date = as.Date(1:nrow(.), origin = "1991-01-01")) %>%
  pivot_longer(cols = -Date, names_to = "Index", values_to = "Value")

##########################################################################################
# 2. Plot and Save the EuStockMarkets Time Series
##########################################################################################

# Create the plot
eu_plot <- ggplot(data = eu_stocks_long, aes(x = Date, y = Value, color = Index)) +
  geom_line() +
  theme_minimal() +
  labs(
    title = "EuStockMarkets Time Series",
    x = "Date",
    y = "Index Value",
    color = "Index"
  )

# Display the plot
print(eu_plot)

# Save the plot as a PNG file
ggsave(filename = "eu_stockmarkets_timeseries.png", plot = eu_plot, width = 10, height = 6)
