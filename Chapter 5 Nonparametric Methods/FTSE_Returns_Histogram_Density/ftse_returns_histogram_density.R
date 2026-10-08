# Create the output directory when this example is run on its own.
dir.create("figures", recursive = TRUE, showWarnings = FALSE)

## =====================================================
## 1. Prepare environment & set working directory
## =====================================================
library(ggplot2)
library(dplyr)
library(quantmod)     # for time-indexed data

# Optional: set working directory
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Read the saved FTSE 100 data and compute returns
## =====================================================
raw <- read.csv("FTSE_close_2015_2024.csv")
ftse_prices <- xts(raw$close,as.Date(raw$date))
ftse_returns <- na.omit(diff(log(ftse_prices))) * 100

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
       x = "Daily Log-Return (%)", y = "Density")

ggsave("figures/ftse-returns-density.png", plot = p,
       width = 6, height = 4, dpi = 300)
