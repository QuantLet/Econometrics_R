##########################################################################################
# U.S. GDP per Capita: Baxter and King Filter Analysis
##########################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("WDI", "mFilter", "ggplot2", "gridExtra"))  # Uncomment if needed
library(WDI)
library(mFilter)
library(ggplot2)
library(gridExtra)

##########################################################################################
# 1. Download GDP Data and Apply Baxter-King Filter
##########################################################################################

# Fetch real GDP per capita (constant 2015 USD) for the U.S.
gdp_data <- WDI(indicator = "NY.GDP.PCAP.KD", country = "US", start = 1960, end = 2020)

# Apply the Baxter-King filter (business cycle frequencies: 2–8 years)
bk_result <- bkfilter(gdp_data$NY.GDP.PCAP.KD, pl = 12, pu = 32, drift = TRUE)

# Attach the cycle component to the dataset
gdp_data$BK_Filtered <- bk_result$cycle

# Remove NA values introduced by the filter
gdp_data <- gdp_data[!is.na(gdp_data$BK_Filtered), ]

##########################################################################################
# 2. Create Plots
##########################################################################################

# Plot 1: Original GDP per Capita
p1 <- ggplot(gdp_data, aes(x = year, y = NY.GDP.PCAP.KD)) +
  geom_line(color = 'blue') +
  labs(title = "Original GDP per Capita (US)", x = "Year", y = "USD") +
  theme_minimal()

# Plot 2: Baxter and King Filtered Component
p2 <- ggplot(gdp_data, aes(x = year, y = BK_Filtered)) +
  geom_line(color = 'red') +
  labs(title = "Baxter and King Filtered GDP per Capita (US)", x = "Year", y = "Cyclical Component") +
  theme_minimal()

# Combine both plots vertically
combined_plot <- grid.arrange(p1, p2, ncol = 1)

##########################################################################################
# 3. Save the Combined Plot as PNG
##########################################################################################

ggsave("US_GDP_BK_Filter_Analysis.png", combined_plot, width = 8, height = 10, dpi = 300)

# Optional: Show the combined plot interactively
print(combined_plot)
