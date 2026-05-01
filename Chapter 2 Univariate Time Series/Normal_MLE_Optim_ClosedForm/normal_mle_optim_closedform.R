## =====================================================
## 1. Simulate data from a normal distribution
## =====================================================

set.seed(123)
data <- rnorm(100, mean = 5, sd = 3)

## =====================================================
## 2. Define the (negative) log-likelihood function
## =====================================================

log_likelihood <- function(params) {
  mu     <- params[1]
  sigma2 <- params[2]
  
  # Note: optim() minimizes, so we return the negative log-likelihood.
  n <- length(data)
  -(-n / 2 * log(2 * pi) - n / 2 * log(sigma2) -
      1 / (2 * sigma2) * sum((data - mu)^2))
}

## =====================================================
## 3. Maximize the log-likelihood via optim()
## =====================================================

start_values <- c(mu = 0, sigma2 = 1)  # Initial values
result       <- optim(start_values, log_likelihood)

cat("MLE via optim():\n")
cat("  mu      =", result$par[1], "\n")
cat("  sigma^2 =", result$par[2], "\n\n")

## =====================================================
## 4. Closed-form MLE for mu and sigma^2
## =====================================================

mle_mu     <- mean(data)
mle_sigma2 <- sum((data - mle_mu)^2) / length(data)

cat("Closed-form MLEs:\n")
cat("  mu      =", mle_mu, "\n")
cat("  sigma^2 =", mle_sigma2, "\n")
 
 