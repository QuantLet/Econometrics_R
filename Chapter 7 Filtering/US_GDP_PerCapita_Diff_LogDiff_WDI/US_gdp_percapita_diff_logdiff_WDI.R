
# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# =====================================================
## 1. Load Required Libraries and Download GDP Data
## =====================================================
# Load the WDI package
library(WDI)

# Download GDP data from World Bank API
gdp_data <- WDI(indicator = "NY.GDP.PCAP.KD", country = "US", start = 1960, end = 2023)

# =====================================================
## 2. Calculate the First and Logarithmic Differences of GDP
## =====================================================
# Calculate the first difference of GDP
gdp_data$GDP_Diff <- c(NA, diff(gdp_data$NY.GDP.PCAP.KD))

# Calculate the logarithmic difference of GDP
gdp_data$GDP_Log_Diff <- c(NA, diff(log(gdp_data$NY.GDP.PCAP.KD)))

# Remove the first NA row due to differencing
gdp_data <- gdp_data[-1,]

# =====================================================
## 3. Load Libraries for Plotting
## =====================================================
library(ggplot2)
library(gridExtra)

# =====================================================
## 4. Create Plots for GDP, First Difference, and Logarithmic Difference
## =====================================================
# Plot 1: Original GDP per Capita
p1 <- ggplot(gdp_data, aes(x = year, y = NY.GDP.PCAP.KD)) +
  geom_line(color = 'blue') +
  labs(title = "Original GDP per Capita (US)", x = "Year", y = "")

# Plot 2: First Difference of GDP per Capita
p2 <- ggplot(gdp_data, aes(x = year, y = GDP_Diff)) +
  geom_line(color = 'red') +
  labs(title = "First Difference of GDP per Capita (US)", x = "Year", y = "")

# Plot 3: Logarithmic Difference of GDP per Capita
p3 <- ggplot(gdp_data, aes(x = year, y = GDP_Log_Diff)) +
  geom_line(color = 'green') +
  labs(title = "Logarithmic Difference of GDP per Capita (US)", x = "Year", y = "")

# =====================================================
## 5. Arrange and Display Plots
## =====================================================
# Arrange the plots vertically
grid.arrange(p1, p2, p3, ncol = 1)