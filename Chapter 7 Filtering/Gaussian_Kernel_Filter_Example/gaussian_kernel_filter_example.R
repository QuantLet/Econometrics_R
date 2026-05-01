# =====================================================
## 1. Define the Gaussian Kernel Function
## =====================================================
gaussian_kernel <- function(n, sigma) {
  r <- floor(n / 2)  # Calculate the radius (half the kernel size)
  x <- seq(-r, r, length.out = n)  # Create a sequence of points for the kernel
  kernel <- dnorm(x, mean = 0, sd = sigma)  # Apply the normal distribution to get the Gaussian kernel
  kernel / sum(kernel)  # Normalize the kernel to ensure the sum of weights is 1
}

# =====================================================
## 2. Example Usage and Parameters
## =====================================================
data <- c(20, 22, 24, 23, 25, 28, 27, 26, 30, 29)  # Example data series
n <- 5  # Define the length of the kernel
sigma <- 1  # Define the standard deviation for the Gaussian kernel

# =====================================================
## 3. Create the Gaussian Kernel
## =====================================================
kernel <- gaussian_kernel(n, sigma)  # Generate the Gaussian kernel using the function

# =====================================================
## 4. Apply the Gaussian Filter to Data
## =====================================================
# Use the 'filter' function from the 'stats' package to apply the Gaussian filter
gaussian_filtered <- stats::filter(data, kernel, sides = 2)  # Apply symmetric filter

# Print the Filtered Data
print(gaussian_filtered)  # Display the filtered data