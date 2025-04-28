# Load necessary libraries
library(ggplot2)
library(forecast)

# Set the working directory to the specified folder
folder <- c("/Users/sunjiajing/Desktop/Hong2020/advance time series analysis -20240328/R_code/advanced-time-series-chapter1")
setwd(folder)


# Set seed for reproducibility
set.seed(123)

# Simulate AR(1) process
n_samples <- 500
alpha <- 0.9
Y <- rep(0, n_samples) # Changed y to Y
epsilon <- rnorm(n_samples, 0, 1)

for (t in 2:n_samples) {
  Y[t] <- alpha * Y[t-1] + epsilon[t] # Changed y to Y in the loop
}

# Time series plot
ts_plot <- ggplot(data.frame(t=1:n_samples, Y=Y), aes(x=t, y=Y)) + # Changed y to Y in data.frame
  geom_line() +
  ggtitle(expression("Simulated series for "~Y[t]==0.9*Y[t-1]+epsilon[t])) +  # Changed y to Y in ggtitle
  xlab("t") + ylab(expression(Y[t])) # Changed y to Y in ylab

# Save time series plot as PNG
ggsave("AR1_plot.png", ts_plot, width = 7, height = 5)

# ACF and PACF plot
png("AR1_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)
par(mfrow=c(1, 2))
Acf(Y, main=expression("ACF for " ~ Y[t] == 0.9 * Y[t-1] + epsilon[t])) # Changed y to Y in Acf
Pacf(Y, main=expression("PACF for " ~ Y[t] == 0.9 * Y[t-1] + epsilon[t])) # Changed y to Y in Pacf
dev.off()
