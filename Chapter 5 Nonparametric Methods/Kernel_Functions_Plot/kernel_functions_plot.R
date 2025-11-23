# Load necessary libraries
library(ggplot2)
library(dplyr)  # Ensure dplyr is loaded

## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Define kernel functions
## =====================================================

func_uniform <- function(x) {
  return(ifelse(abs(x) <= 1, 0.5, 0)) # Uniform kernel
}

func_gaussian <- function(x) {
  return(dnorm(x)) # Gaussian kernel
}

func_epan <- function(x) {
  return(ifelse(abs(x) <= 1, 0.75 * (1 - x^2), 0)) # Epanechnikov kernel
}

func_quartic <- function(x) {
  return(ifelse(abs(x) <= 1, 15/16 * (1 - x^2)^2, 0)) # Quartic kernel
}

## =====================================================
## 3. Generate a sequence of x values and plot the kernels
## =====================================================

x_vals <- seq(-3, 3, by = 0.01)

# Create a data frame for each kernel function
df_uniform <- data.frame(x = x_vals, y = func_uniform(x_vals), kernel = "Uniform")
df_gaussian <- data.frame(x = x_vals, y = func_gaussian(x_vals), kernel = "Gaussian")
df_epan <- data.frame(x = x_vals, y = func_epan(x_vals), kernel = "Epanechnikov")
df_quartic <- data.frame(x = x_vals, y = func_quartic(x_vals), kernel = "Quartic")

# Combine all data frames into a single data frame using bind_rows
df_kernels <- bind_rows(df_uniform, df_gaussian, df_epan, df_quartic)

# Create the plot using ggplot2
p <- ggplot(df_kernels, aes(x = x, y = y, color = kernel)) +
  geom_line(size = 1.2) +
  labs(title = "Kernel Functions", x = "x", y = "Density") +
  scale_color_manual(values = c("blue", "red", "green", "purple"))

# Save the plot as a PNG file with the specified size and aspect ratio
ggsave("kernel-functions.png", plot = p, width = 6, height = 4, dpi = 300)