# Load necessary library
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# Generate a sample from a normal distribution
x <- rnorm(1000)

# Define bandwidth; commonly used rule of thumb for bandwidth selection
h <- 1.06 * sd(x) * length(x)^(-1/5)

# Uniform kernel density estimation function
uniform_kernel_density <- function(x, xi, h) {
  n <- length(x)
  u <- (xi - x) / h
  # Calculate the kernel values (1/2 for |u| <= 1, 0 otherwise)
  kernel_values <- ifelse(abs(u) <= 1, 1, 0) * (1/2)
  # Calculate the density estimate
  density_estimate <- sum(kernel_values) / (n * h)
  return(density_estimate)
}

# Create a sequence of points where the density is to be estimated
xi_seq <- seq(min(x), max(x), length.out = 400)

# Calculate the density estimate for each point in xi_seq
density_estimates <- sapply(xi_seq, function(xi) uniform_kernel_density(x, xi, h))

# Create a data frame for the histogram (original sample data)
df_hist <- data.frame(x = x)

# Create a separate data frame for the kernel density estimates
df_kde <- data.frame(xi = xi_seq, density = density_estimates)

# Plot using ggplot2
ggplot() +
  geom_histogram(data = df_hist, aes(x = x, y = ..density.., fill = "Histogram"), binwidth = h, alpha = 0.3, show.legend = TRUE) +
  geom_line(data = df_kde, aes(x = xi, y = density, color = "Uniform Kernel"), linewidth = 1) +
  scale_fill_manual(name = "Estimate Type", values = c("Histogram" = "blue")) +
  scale_color_manual(name = "Estimate Type", values = c("Uniform Kernel" = "red")) +
  ggtitle("Histogram vs. Kernel Density Estimate") +
  theme_minimal() +
  labs(color = "") +
  coord_cartesian(xlim = c(min(x), max(x)))
