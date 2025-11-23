## =====================================================
## 1. Prepare environment & set working directory
## =====================================================
library(ggplot2)
library(dplyr)
library(quantmod)     # for data downloading

# Optional: set working directory
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Download recent FTSE 100 data & compute returns
## =====================================================
# Use quantmod to get data from Yahoo Finance
getSymbols("^FTSE", src = "yahoo", from = "2015-01-01", auto.assign = TRUE)
ftse_prices <- Cl(FTSE)            # closing prices
ftse_returns <- dailyReturn(ftse_prices, type = "log") * 100  # log returns in percent
ftse_returns <- na.omit(ftse_returns)

# Ensure 'Return' column is correctly named and in data.frame format
ftse_df <- data.frame(Return = as.numeric(ftse_returns))  

## =====================================================
## 3. Plot histogram + kernel density and save plot as PNG
## =====================================================
p <- ggplot(ftse_df, aes(x = Return)) +
  geom_histogram(aes(y = after_stat(density)),   # Update with 'after_stat(density)'
                 binwidth = 0.5, color = "black", fill = "blue", alpha = 0.6) +
  geom_density(alpha = 0.2, fill = "#FF6666") +
  labs(title = "Histogram & Kernel Density of FTSE 100 Daily Returns",
       x = "Daily Log‑Return (%)", y = "Density")  

ggsave("ftse-returns-density.png", plot = p,
       width = 6, height = 4, dpi = 300)