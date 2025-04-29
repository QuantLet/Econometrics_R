##########################################################################################
# Maximum Likelihood Estimation (MLE) for Normal Distribution and ARMA(1,1) Process
##########################################################################################

# Load necessary libraries
# (No special libraries needed for this example)

# Set random seed for reproducibility
set.seed(123)

##########################################################################################
# 1. MLE Estimation for Normal Distribution Parameters
##########################################################################################

# Generate simulated data
normal_data <- rnorm(100, mean = 5, sd = 3)

# Define the log-likelihood function for normal distribution
log_likelihood_normal <- function(params) {
  mu <- params[1]
  sigma2 <- params[2]
  n <- length(normal_data)
  
  # Negative log-likelihood (for minimization)
  neg_loglik <- -(-n/2 * log(2 * pi) - n/2 * log(sigma2) - sum((normal_data - mu)^2) / (2 * sigma2))
  return(neg_loglik)
}

# Perform MLE using optim()
start_values_normal <- c(mu = 0, sigma2 = 1)
result_normal <- optim(par = start_values_normal, fn = log_likelihood_normal)

# Output MLE estimates for normal distribution
cat("=== MLE for Normal Distribution ===\n")
cat("Estimated mu:", result_normal$par[1], "\n")
cat("Estimated sigma^2:", result_normal$par[2], "\n\n")

# Direct MLE estimates for comparison
mle_mu <- mean(normal_data)
mle_sigma2 <- sum((normal_data - mle_mu)^2) / length(normal_data)
cat("Direct MLE (mean):", mle_mu, "\n")
cat("Direct MLE (sigma^2):", mle_sigma2, "\n\n")

##########################################################################################
# 2. MLE Estimation for ARMA(1,1) Model Parameters
##########################################################################################

# Simulate ARMA(1,1) data
n <- 500
arma_data <- arima.sim(n = n, model = list(ar = 0.5, ma = 0.4))

# Define the log-likelihood function for ARMA(1,1)
log_likelihood_arma11 <- function(par, data) {
  phi <- par[1]         # AR(1) coefficient
  theta <- par[2]       # MA(1) coefficient
  sigma2 <- par[3]^2    # Enforce positivity for variance
  n <- length(data)
  
  eps <- rep(0, n)      # Initialize residuals
  for (t in 2:n) {
    eps[t] <- data[t] - phi * data[t-1] - theta * eps[t-1]
  }
  
  neg_loglik <- -(-n/2 * log(2 * pi * sigma2) - sum(eps^2) / (2 * sigma2))
  return(neg_loglik)
}

# Perform MLE using optim() for ARMA(1,1)
start_values_arma <- c(phi = 0.5, theta = 0.5, sigma = 1)
result_arma <- optim(par = start_values_arma, fn = log_likelihood_arma11, data = arma_data, 
                     method = "BFGS", hessian = TRUE)

# Output MLE estimates for ARMA(1,1)
cat("=== MLE for ARMA(1,1) Model ===\n")
cat("Estimated phi:", result_arma$par[1], "\n")
cat("Estimated theta:", result_arma$par[2], "\n")
cat("Estimated sigma:", result_arma$par[3], "\n")
cat("Log-likelihood value at the estimates:", -result_arma$value, "\n")
