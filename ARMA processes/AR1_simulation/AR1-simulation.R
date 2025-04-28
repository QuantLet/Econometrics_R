###################################################################################################
# Load necessary libraries
library(ggplot2)
library(forecast)

# Set working directory
folder <- c("/Users/sunjiajing/Desktop/github-econometrics/Econometrics_R/ARMA processes/AR1_simulation")
setwd(folder)

# Set seed to ensure reproducibility
set.seed(123)

# Simulate an AR(1) process
n_samples <- 500
alpha <- 0.9
y <- rep(0, n_samples)
epsilon <- rnorm(n_samples, 0, 1)

for (t in 2:n_samples) {
  y[t] <- alpha * y[t-1] + epsilon[t]
}

# Plot time series
ts_plot <- ggplot(data.frame(t = 1:n_samples, y = y), aes(x = t, y = y)) +
  geom_line() +
  ggtitle(expression("Simulated series for "~y[t]==0.9*y[t-1]+epsilon[t])) +
  xlab("t") +
  ylab(expression(y[t]))

# Save the time series plot as a PNG file
ggsave("AR1_plot.png", ts_plot, width = 7, height = 5)

# Plot and save ACF and PACF
png("AR1_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)

par(mfrow = c(1, 2))
Acf(y, main = expression("ACF for "~y[t]==0.9*y[t-1]+epsilon[t]))
Pacf(y, main = expression("PACF for "~y[t]==0.9*y[t-1]+epsilon[t]))
dev.off()
###################################################################################################
