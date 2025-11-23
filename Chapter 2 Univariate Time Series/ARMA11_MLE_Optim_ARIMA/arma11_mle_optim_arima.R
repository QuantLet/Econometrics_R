 
## =====================================================
## 1. Simulate ARMA(1,1) data
## =====================================================

set.seed(123)
n    <- 500
data <- arima.sim(n = n, model = list(ar = 0.5, ma = 0.4))

## =====================================================
## 2. Define the log-likelihood function for ARMA(1,1)
## =====================================================

loglik_arma11 <- function(par, data) {
  phi    <- par[1]        # AR(1) coefficient
  theta  <- par[2]        # MA(1) coefficient
  sigma2 <- par[3]^2      # Ensure sigma2 > 0
  
  n   <- length(data)
  eps <- numeric(n)
  for (t in 2:n) eps[t] <- data[t] - phi * data[t - 1] - theta * eps[t - 1]
  
  sum_ll <- -n / 2 * log(2 * pi * sigma2) - sum(eps^2) / (2 * sigma2)
  -sum_ll   # negative log-likelihood (optim() minimizes)
}

## =====================================================
## 3. Optimize the log-likelihood
## =====================================================

start_values <- c(0.5, 0.5, 1)  # initial guesses for phi, theta, sigma
result <- optim(par = start_values, fn = loglik_arma11, data = data,
                method = "BFGS", hessian = TRUE)

## =====================================================
## 4. Output results
## =====================================================

cat("Estimated parameters:", result$par, "\n")
cat("Log-likelihood value at the estimates:", -result$value, "\n")

## =====================================================
## 5. Estimate ARMA(1,1) via arima() (MLE)
## =====================================================

fit <- arima(data, order = c(1, 0, 1), method = "ML")

## =====================================================
## 3. Output results
## =====================================================

print(fit)