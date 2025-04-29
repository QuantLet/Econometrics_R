##########################################################################################
# Gaussian Kernel Smoothing on 1D Data
##########################################################################################

# Clear workspace
rm(list = ls())

# Define a Gaussian kernel function
gaussian_kernel <- function(n, sigma) {
  r <- floor(n / 2)
  x <- seq(-r, r, length.out = n)
  kernel <- dnorm(x, mean = 0, sd = sigma)
  return(kernel / sum(kernel))  # Normalize to ensure the kernel sums to 1
}

##########################################################################################
# Example Usage
##########################################################################################

# Sample data
data <- c(20, 22, 24, 23, 25, 28, 27, 26, 30, 29)

# Kernel parameters
n <- 5         # Length of the kernel (should be odd for symmetry)
sigma <- 1     # Standard deviation for the Gaussian kernel

# Generate the kernel
kernel <- gaussian_kernel(n, sigma)

# Apply the Gaussian filter using centered convolution
gaussian_filtered <- stats::filter(data, kernel, sides = 2)

# Print the smoothed output
print(gaussian_filtered)
