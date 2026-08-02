# =====================================================
## 1. Load Libraries and Data
# =====================================================
library(WDI)        # For World Development Indicators
library(mFilter)    # For applying the Baxter and King filter
library(ggplot2)    # For plotting graphs
library(gridExtra)  # For arranging plots

# Download GDP data
gdp_data <- WDI(country = "US",
                indicator = "NY.GDP.PCAP.KD",
                start = 1960,
                end   = 2023,
                extra = FALSE,    # optional
                cache = NULL)     # optional

# Apply the time-series filter in chronological order.
gdp_data <- gdp_data[order(gdp_data$year), , drop = FALSE]

# =====================================================
## 2. Apply Baxter and King Filter
## pl and pu set the periodic limits for the business cycle frequency
# =====================================================
gdp_filtered <- bkfilter(gdp_data$NY.GDP.PCAP.KD, pl = 12, pu = 32, drift = TRUE)

# Prepare the dataframe for plotting
# Add the filtered cycle component to the dataframe
gdp_data$BK_Filtered <- gdp_filtered$cycle

# Remove rows with NA values in the BK_Filtered column
gdp_data <- gdp_data[!is.na(gdp_data$BK_Filtered), ]

# =====================================================
## 3. Create the Plots
## Plot Original GDP and Baxter & King Filtered GDP
# =====================================================
# Plot 1: Original GDP per Capita
p1 <- ggplot(gdp_data, aes(x = year, y = NY.GDP.PCAP.KD)) +
  geom_line(color = 'blue') +
  labs(title = "Original GDP per Capita (US)", x = "Year", y = "")

# Plot 2: Baxter and King Filtered GDP per Capita
p2 <- ggplot(gdp_data, aes(x = year, y = BK_Filtered)) +
  geom_line(color = 'red') +
  labs(title = "Baxter and King Filtered GDP per Capita (US)", x = "Year", y = "")

# =====================================================
## 4. Arrange and Display the Plots
# =====================================================
grid.arrange(p1, p2, ncol = 1)
