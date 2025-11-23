# Load necessary packages
library(ggplot2)
library(forecast)
library(patchwork)  # for combining ggplots side-by-side

## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate AR(1) process
##    Y_t = alpha * Y_{t-1} + epsilon_t
## =====================================================

set.seed(123)
n_samples <- 500
alpha     <- 0.9
Y         <- rep(0, n_samples)
epsilon   <- rnorm(n_samples, mean = 0, sd = 1)

for (t in 2:n_samples) {
  Y[t] <- alpha * Y[t - 1] + epsilon[t]
}

## =====================================================
## 3. Time series plot
## =====================================================

ts_plot <- ggplot(data.frame(t = 1:n_samples, Y = Y),
                  aes(x = t, y = Y)) +
  geom_line() +
  ggtitle(
    expression("Simulated series for " ~
                 Y[t] == 0.9 * Y[t - 1] + epsilon[t])
  ) +
  xlab("t") +
  ylab(expression(Y[t]))  

# Save time series plot as PNG (consistent format)
ggsave("AR1_plot.png", ts_plot,
       width = 6, height = 4, dpi = 300)

## =====================================================
## 4. ACF and PACF plots
## =====================================================

acf_plot <- ggAcf(Y) +
  ggtitle(
    expression("ACF for " ~
                 Y[t] == 0.9 * Y[t - 1] + epsilon[t])
  )  

pacf_plot <- ggPacf(Y) +
  ggtitle(
    expression("PACF for " ~
                 Y[t] == 0.9 * Y[t - 1] + epsilon[t])
  )  

# Combine ACF and PACF into a single figure
acf_pacf_plot <- acf_plot + pacf_plot

# Save combined ACF/PACF plot as PNG (consistent format)
ggsave("AR1_acf_pacf_plot.png", acf_pacf_plot,
       width = 12, height = 4, dpi = 300)