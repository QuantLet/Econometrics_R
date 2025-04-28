# 加载必要的库
library(ggplot2)
library(forecast)

folder <- c("/Users/sunjiajing/Desktop/github-econometrics/Econometrics_R/ARMA processes/RW-simulation")
setwd(folder)

setwd(folder)

# Set seed for reproducibility
set.seed(123)

# Simulate an AR(1) process
n_samples <- 500
alpha <- 0.9
y <- rep(0, n_samples)
epsilon <- rnorm(n_samples, 0, 1)

for (t in 2:n_samples) {
  y[t] <- alpha * y[t-1] + epsilon[t]
}

# Plot the time series
ts_plot <- ggplot(data.frame(t=1:n_samples, y=y), aes(x=t, y=y)) +
  geom_line() +
  ggtitle(expression("Simulated series for "~y[t]==0.9*y[t-1]+epsilon[t])) +
  xlab("t") + ylab(expression(y[t]))

# Save the time series plot as PNG
ggsave("AR1_plot.png", ts_plot, width = 7, height = 5)

# Plot ACF and PACF
png("AR1_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)

par(mfrow=c(1, 2))
Acf(y, main=expression("ACF for " ~ y[t] == 0.9 * y[t-1] + epsilon[t]))
Pacf(y, main=expression("PACF for " ~ y[t] == 0.9 * y[t-1] + epsilon[t]))
dev.off()