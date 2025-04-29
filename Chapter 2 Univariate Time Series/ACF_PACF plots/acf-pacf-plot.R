##########################################################################################
# Simulation and ACF/PACF Analysis for MA(2), ARMA(1,1), AR(1), and MA(1) Processes
##########################################################################################

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("ggplot2", "forecast", "stats")) # Uncomment if necessary
library(ggplot2)
library(forecast)
library(stats)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. Simulate and Plot MA(2) Process
##########################################################################################

simulate_ma2 <- function(n, theta1, theta2, sigma) {
  eps <- rnorm(n + 2, sd = sigma)
  x <- numeric(n)
  for (i in 1:n) {
    x[i] <- eps[i + 2] + theta1 * eps[i + 1] + theta2 * eps[i]
  }
  return(x)
}

# Simulation parameters
n <- 1000
theta1 <- 0.5
theta2 <- -0.3
sigma <- 1

# Simulate MA(2) data
ma2_data <- simulate_ma2(n, theta1, theta2, sigma)

# Plot MA(2) simulation
png(filename = "ma2_simulated_process.png", width = 600, height = 400)
ggplot(data.frame(time = 1:n, value = ma2_data), aes(x = time, y = value)) +
  geom_line() +
  ggtitle("Simulated MA(2) Process") +
  xlab("Time") +
  ylab("Value")
dev.off()

##########################################################################################
# 2. Simulate and Plot ARMA(1,1) Process
##########################################################################################

set.seed(12345)
ar_param <- 0.6
ma_param <- 0.7

# Simulate ARMA(1,1) data
arma11_data <- arima.sim(list(order = c(1, 0, 1), ar = ar_param, ma = ma_param), n = n)

# Plot ARMA(1,1) simulation
png(filename = "arma11_simulated_process.png", width = 600, height = 400)
ggplot(data.frame(time = 1:n, value = arma11_data), aes(x = time, y = value)) +
  geom_line() +
  ggtitle("Simulated ARMA(1,1) Process") +
  xlab("Time") +
  ylab("Value")
dev.off()

##########################################################################################
# 3. ACF and PACF Plots
##########################################################################################

# Reset seed for consistent simulations
set.seed(123)

# MA(1) Process ACF
ma1_sim <- arima.sim(n = n, model = list(ma = 0.5))
png(filename = "ma1_acf.png", width = 600, height = 400)
acf(ma1_sim, main = "ACF for MA(1) Process")
dev.off()

# MA(2) Process ACF
ma2_sim <- arima.sim(n = n, model = list(ma = c(0.5, 0.3)))
png(filename = "ma2_acf.png", width = 600, height = 400)
acf(ma2_sim, main = "ACF for MA(2) Process")
dev.off()

# AR(1) Process PACF
ar1_sim <- arima.sim(n = n, model = list(ar = 0.9))
png(filename = "ar1_pacf.png", width = 600, height = 400)
pacf(ar1_sim, main = "PACF for AR(1) Process")
dev.off()

# MA(1) Process PACF
ma1_sim_pacf <- arima.sim(n = n, model = list(ma = 0.9))
png(filename = "ma1_pacf.png", width = 600, height = 400)
pacf(ma1_sim_pacf, main = "PACF for MA(1) Process")
dev.off()

# (Optional) Print PACF values
pacf_values <- pacf(ma1_sim_pacf, plot = FALSE)$acf
print(pacf_values)
