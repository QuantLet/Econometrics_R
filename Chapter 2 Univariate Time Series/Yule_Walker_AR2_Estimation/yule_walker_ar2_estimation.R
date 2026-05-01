## =====================================================
## 1. Simulate AR(2) series and compute sample ACF
## =====================================================

# Simulate an AR(2) series
set.seed(123)
ts_data <- arima.sim(n = 1000, model = list(ar = c(0.6, -0.4)))

# Calculate ACF (up to lag 2)
acf_vals <- acf(ts_data, plot = FALSE, lag.max = 2)$acf

# Extract necessary values from ACF
gamma0 <- acf_vals[1]
gamma1 <- acf_vals[2]
gamma2 <- acf_vals[3]

## =====================================================
## 2. Solve Yule–Walker equations for AR(2) coefficients
## =====================================================

# Set up the Yule–Walker equations
mat <- matrix(c(gamma0, gamma1,
                gamma1, gamma0),
              nrow = 2)
vec <- c(gamma1, gamma2)

# Solve the linear system for phi_1, phi_2
phi <- solve(mat, vec)

# Output the results
print(phi)


## =====================================================
## 3. Estimate AR parameters via ar.yw()
## =====================================================

ar_model <- ar.yw(ts_data, order.max = 2)

# Output estimated AR coefficients
print(ar_model$ar)