##########################################################################################
# Set working directory to the folder where this script is saved
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}
##########################################################################################

# Load required libraries
library(ggplot2)
library(forecast)
library(stats)

# Set random seed for reproducibility
set.seed(123)

######################
# 1. Simulate MA(2) process manually
######################

simulate_ma2 <- function(n, theta1, theta2, sigma) {
  eps <- rnorm(n + 2, sd = sigma)
  x <- numeric(n)
  for (i in 1:n) {
    x[i] <- eps[i + 2] + theta1 * eps[i + 1] + theta2 * eps[i]
  }
  return(x)
}

n <- 1000
theta1 <- 0.5
theta2 <- -0.3
sigma <- 1

ma2_data <- simulate_ma2(n, theta1, theta2, sigma)

# Plot MA(2) simulation
png(filename = "ma2_simulated_process.png", width = 600, height = 400)
ggplot(data.frame(time = 1:n, value = ma2_data), aes(x = time, y = value)) +
  geom_line() +
  ggtitle("Simulated MA(2) Process") +
  xlab("Time") +
  ylab("Value")
dev.off()

######################
# 2. Simulate ARMA(1,1) process
######################

set.seed(12345)
ar_param <- 0.6
ma_param <- 0.7

arma11_data <- arima.sim(list(order = c(1, 0, 1), ar = ar_param, ma = ma_param), n = n)

# Plot ARMA(1,1) simulation
png(filename = "arma11_simulated_process.png", width = 600, height = 400)
ggplot(data.frame(time = 1:n, value = arma11_data), aes(x = time, y = value)) +
  geom_line() +
  ggtitle("Simulated ARMA(1,1) Process") +
  xlab("Time") +
  ylab("Value")
dev.off()

######################
# 3. ACF and PACF plots
######################

# MA(1) process ACF
set.seed(123)
ma1_sim <- arima.sim(n = n, model = list(ma = c(0.5)))
png(filename = "ma1_acf.png", width = 600, height = 400)
acf(ma1_sim, main = "ACF for MA(1) Process")
dev.off()

# MA(2) process ACF
ma2_sim <- arima.sim(n = n, model = list(ma = c(0.5, 0.3)))
png(filename = "ma2_acf.png", width = 600, height = 400)
acf(ma2_sim, main = "ACF for MA(2) Process")
dev.off()

# AR(1) process PACF
ar1_sim <- arima.sim(n = n, model = list(ar = c(0.9)))
png(filename = "ar1_pacf.png", width = 600, height = 400)
pacf(ar1_sim, main = "PACF for AR(1) Process")
dev.off()

# MA(1) process PACF
ma1_sim <- arima.sim(n = n, model = list(ma = c(0.9)))
png(filename = "ma1_pacf.png", width = 600, height = 400)
pacf(ma1_sim, main = "PACF for MA(1) Process")
dev.off()

# (Optional) Print PACF values
pacf_values <- pacf(ma1_sim, plot = FALSE)$acf
print(pacf_values)
