library(ggplot2)
library(forecast)

# Set seed for reproducibility
set.seed(123)
folder <- c("/Users/sunjiajing/Desktop/Hong2020/advance time series analysis -20240328/R_code/advanced-time-series-chapter1")
setwd(folder)

# Simulate Random Walk process
n_samples <- 500
Y <- rep(0, n_samples) 
epsilon <- rnorm(n_samples, 0, 1)

# For a random walk model, the previous state's weight is not needed, thus alpha is set to 1
for (t in 2:n_samples) {
  Y[t] <- Y[t-1] + epsilon[t] # Changed y to Y
}

# Time series plot
ts_plot <- ggplot(data.frame(t=1:n_samples, Y=Y), aes(x=t, y=Y)) +  
  geom_line() +
  ggtitle(expression("Simulated series for "~Y[t]==Y[t-1]+epsilon[t])) +  
  xlab("t") + ylab(expression(Y[t])) # Changed y to Y in ylab

# Save time series plot as PNG
ggsave("random_walk_plot.png", ts_plot, width = 7, height = 5)

# ACF and PACF plot
png("rw_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)
par(mfrow=c(1, 2))
Acf(Y, main=expression("ACF for " ~ Y[t] ==  Y[t-1] + epsilon[t])) 
Pacf(Y, main=expression("PACF for " ~ Y[t] ==  Y[t-1] + epsilon[t])) 
dev.off()
