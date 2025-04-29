##########################################################################################
# Visualization of Kernel Functions: Uniform, Gaussian, Epanechnikov, Quartic
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear workspace
rm(list = ls())

# Load required libraries
# install.packages(c("ggplot2", "dplyr"))  # Uncomment if not installed
library(ggplot2)
library(dplyr)

##########################################################################################
# 1. Define Kernel Functions
##########################################################################################

# Uniform Kernel
func_uniform <- function(x) {
  y <- numeric(length(x))
  idx <- abs(x) <= 1
  y[idx] <- 1/2
  return(y)
}

# Gaussian Kernel
func_gaussian <- function(x) {
  (1 / sqrt(2 * pi)) * exp(-0.5 * x^2)
}

# Epanechnikov Kernel
func_epanechnikov <- function(x) {
  y <- numeric(length(x))
  idx <- abs(x) <= 1
  y[idx] <- (3/4) * (1 - x[idx]^2)
  return(y)
}

# Quartic (Biweight) Kernel
func_quartic <- function(x) {
  y <- numeric(length(x))
  idx <- abs(x) <= 1
  y[idx] <- (15/16) * (1 - x[idx]^2)^2
  return(y)
}

##########################################################################################
# 2. Generate Data for Plotting
##########################################################################################

# Sequence of x values
x_vals <- seq(-3, 3, by = 0.01)

# Create data frames for each kernel
df_uniform <- data.frame(x = x_vals, y = func_uniform(x_vals), kernel = "Uniform")
df_gaussian <- data.frame(x = x_vals, y = func_gaussian(x_vals), kernel = "Gaussian")
df_epanechnikov <- data.frame(x = x_vals, y = func_epanechnikov(x_vals), kernel = "Epanechnikov")
df_quartic <- data.frame(x = x_vals, y = func_quartic(x_vals), kernel = "Quartic")

# Combine all data frames
df_kernels <- bind_rows(df_uniform, df_gaussian, df_epanechnikov, df_quartic)

##########################################################################################
# 3. Plot Kernel Functions
##########################################################################################
# Create the plot
plot_kernels <- ggplot(df_kernels, aes(x = x, y = y, color = kernel)) +
  geom_line(size = 1.2) +
  labs(
    title = "Kernel Functions",
    x = "x",
    y = "Density"
  ) +
  scale_color_manual(values = c("blue", "red", "green", "purple")) +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5)  # Center the plot title
  )

# Display the plot
print(plot_kernels)

# Save the plot to a file
ggsave("kernel_functions_plot.png", plot = plot_kernels, width = 7, height = 5)
