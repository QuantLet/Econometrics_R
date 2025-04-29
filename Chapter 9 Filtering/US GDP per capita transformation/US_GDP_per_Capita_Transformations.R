##########################################################################################
# U.S. GDP per Capita: Levels, First Differences, and Log Differences (1960–2020)
##########################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load necessary packages
# install.packages(c("WDI", "ggplot2", "gridExtra"))  # Uncomment if not already installed
library(WDI)
library(ggplot2)
library(gridExtra)

##########################################################################################
# 1. Download and Prepare GDP Data
##########################################################################################

# Fetch real GDP per capita (constant 2015 USD) for the United States
gdp_data <- WDI(indicator = "NY.GDP.PCAP.KD", country = "US", start = 1960, end = 2020)

# Compute first differences
gdp_data$GDP_Diff <- c(NA, diff(gdp_data$NY.GDP.PCAP.KD))

# Compute logarithmic differences
gdp_data$GDP_Log_Diff <- c(NA, diff(log(gdp_data$NY.GDP.PCAP.KD)))

# Remove the first row with NA
gdp_data <- gdp_data[-1, ]

##########################################################################################
# 2. Plot GDP Series: Level, First Difference, and Log Difference
##########################################################################################

# Plot original GDP per capita
p1 <- ggplot(gdp_data, aes(x = year, y = NY.GDP.PCAP.KD)) +
  geom_line(color = 'blue') +
  labs(title = "Original GDP per Capita (US)", x = "Year", y = "USD") +
  theme_minimal()

# Plot first difference
p2 <- ggplot(gdp_data, aes(x = year, y = GDP_Diff)) +
  geom_line(color = 'red') +
  labs(title = "First Difference of GDP per Capita (US)", x = "Year", y = "ΔUSD") +
  theme_minimal()

# Plot log difference
p3 <- ggplot(gdp_data, aes(x = year, y = GDP_Log_Diff)) +
  geom_line(color = 'green') +
  labs(title = "Log Difference of GDP per Capita (US)", x = "Year", y = "Δ log(USD)") +
  theme_minimal()

# Combine all plots into one figure
combined_plot <- grid.arrange(p1, p2, p3, ncol = 1)

# Save the combined plot
ggsave("US_GDP_per_Capita_Transformation_Plots.png", combined_plot, width = 8, height = 10, dpi = 300)

# Optional: Display in RStudio viewer as well
print(combined_plot)
