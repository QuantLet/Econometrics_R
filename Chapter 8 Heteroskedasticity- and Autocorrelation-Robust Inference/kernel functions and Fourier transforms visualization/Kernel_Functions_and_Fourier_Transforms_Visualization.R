##########################################################################################
# Kernel Functions and Their Fourier Transforms: Plotting and Saving
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Clear the environment
rm(list = ls())

# Load required libraries
# install.packages(c("ggplot2", "gridExtra"))  # Uncomment if needed
library(ggplot2)
library(gridExtra)

##########################################################################################
# 1. Define Kernel Functions and Their Fourier Transforms
##########################################################################################

# Define kernel functions
kernels <- list(
  Truncated = function(x) ifelse(abs(x) <= 1, 1, 0),
  Bartlett  = function(x) ifelse(abs(x) <= 1, 1 - abs(x), 0),
  Daniell   = function(x) ifelse(x == 0, 1, sin(pi * x) / (pi * x)),
  Parzen    = function(x) ifelse(abs(x) <= 0.5, 1 - 6 * x^2 + 6 * abs(x)^3,
                                 ifelse(abs(x) <= 1, 2 * (1 - abs(x))^3, 0)),
  QS        = function(x) 3 / (pi * x)^2 * (sin(pi * x) / (pi * x) - cos(pi * x))
)

# Define Fourier transforms
fourier_transforms <- list(
  Truncated = function(u) (1 / pi) * (sin(u) / u),
  Bartlett  = function(u) (1 / (2 * pi)) * (sin(u / 2) / (u / 2))^2,
  Daniell   = function(u) (1 / (2 * pi)) * ifelse(abs(u) <= pi, 1, 0),
  Parzen    = function(u) (3 / (8 * pi)) * (sin(u / 4) / (u / 4))^4,
  QS        = function(u) (3 / (4 * pi)) * (1 - (u / pi)^2) * ifelse(abs(u) <= pi, 1, 0)
)

##########################################################################################
# 2. Generate Sequences for Plotting
##########################################################################################

x_seq <- seq(-2, 2, length.out = 1000)
u_seq <- seq(-10, 10, length.out = 1000)

##########################################################################################
# 3. Create Combined Kernel and Fourier Transform Plots
##########################################################################################

combined_plots <- lapply(names(kernels), function(name) {
  
  # Prepare data
  kernel_data <- data.frame(x = x_seq, y = sapply(x_seq, kernels[[name]]))
  fourier_data <- data.frame(x = u_seq, y = sapply(u_seq, fourier_transforms[[name]]))
  
  # Create kernel plot
  kernel_plot <- ggplot(kernel_data, aes(x, y)) +
    geom_line() +
    ggtitle(paste(name, "Kernel")) +
    ylab("k(x)") +
    theme_minimal()
  
  # Create Fourier transform plot
  fourier_plot <- ggplot(fourier_data, aes(x, y)) +
    geom_line() +
    ggtitle(paste(name, "Fourier Transform")) +
    ylab("K(u)") +
    theme_minimal()
  
  # Combine side-by-side
  grid.arrange(kernel_plot, fourier_plot, ncol = 2)
})

##########################################################################################
# 4. Save All Plots into One PNG File
##########################################################################################

# Save the combined grid of plots
png("kernel_and_fourier_transforms.png", width = 1200, height = 2400)
do.call(grid.arrange, c(combined_plots, ncol = 1))
dev.off()

# Also display the combined grid
do.call(grid.arrange, c(combined_plots, ncol = 1))
