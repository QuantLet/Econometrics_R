## =====================================================
## 1. Load packages
## =====================================================

# install.packages("ggplot2")   # run once if needed
# install.packages("gridExtra") # run once if needed

library(ggplot2)
library(gridExtra)

## =====================================================
## 2. Define kernels and their Fourier transforms
## =====================================================

# Numerically stable sinc and quadratic-spectral functions
sinc <- function(z) {
  out <- rep(1, length(z))
  nz <- abs(z) > sqrt(.Machine$double.eps)
  out[nz] <- sin(z[nz]) / z[nz]
  out
}

qs_kernel <- function(x) {
  z <- pi * x
  out <- numeric(length(z))
  small <- abs(z) < 1e-4
  out[small] <- 1 - z[small]^2 / 10 + z[small]^4 / 280
  out[!small] <- 3 / z[!small]^2 *
    (sinc(z[!small]) - cos(z[!small]))
  out
}

# Time-domain kernel functions k(x)
kernels <- list(
  Truncated = function(x) ifelse(abs(x) <= 1, 1, 0),
  Bartlett  = function(x) ifelse(abs(x) <= 1, 1 - abs(x), 0),
  Daniell   = function(x) sinc(pi * x),
  Parzen    = function(x) ifelse(
    abs(x) <= 0.5,
    1 - 6 * x^2 + 6 * abs(x)^3,
    ifelse(abs(x) <= 1, 2 * (1 - abs(x))^3, 0)
  ),
  QS        = qs_kernel
)

# Frequency-domain Fourier transforms K(u)
fourier_transforms <- list(
  Truncated = function(u) (1 / pi) * sinc(u),
  Bartlett  = function(u) (1 / (2 * pi)) * sinc(u / 2)^2,
  Daniell   = function(u) (1 / (2 * pi)) * ifelse(abs(u) <= pi, 1, 0),
  Parzen    = function(u) (3 / (8 * pi)) * sinc(u / 4)^4,
  QS        = function(u) (3 / (4 * pi)) * (1 - (u / pi)^2) * ifelse(abs(u) <= pi, 1, 0)
)

## =====================================================
## 3. Define grids for x and u
## =====================================================

x_seq <- seq(-2, 2,  length.out = 1000)  # time domain
u_seq <- seq(-10, 10, length.out = 1000) # frequency domain

## =====================================================
## 4. Create kernel and Fourier-transform plots
## =====================================================

combined_plots <- lapply(names(kernels), function(name) {
  # Data for kernel k(x)
  kernel_data <- data.frame(
    x = x_seq,
    y = sapply(x_seq, kernels[[name]])
  )
  
  # Data for Fourier transform K(u)
  fourier_data <- data.frame(
    x = u_seq,
    y = sapply(u_seq, fourier_transforms[[name]])
  )
  
  # Plot k(x)
  kernel_plot <- ggplot(kernel_data, aes(x, y)) +
    geom_line() +
    ggtitle(paste(name, "Kernel")) +
    xlab("x") +
    ylab("k(x)")
  
  # Plot K(u)
  fourier_plot <- ggplot(fourier_data, aes(x, y)) +
    geom_line() +
    ggtitle(paste(name, "Fourier Transform")) +
    xlab("u") +
    ylab("K(u)")
  
  # Put the two plots side by side
  grid.arrange(kernel_plot, fourier_plot, ncol = 2)
})

## =====================================================
## 5. Arrange all kernels in one figure
## =====================================================

combined_grid <- do.call(grid.arrange, c(combined_plots, ncol = 1))
