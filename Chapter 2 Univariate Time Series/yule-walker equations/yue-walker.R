# Simulate an AR(2) series
set.seed(123)
ts_data <- arima.sim(n = 1000, model=list(ar=c(0.6, -0.4)))

# Estimate using Yule-Walker equations
ar_model <- ar.yw(ts_data, order.max=2)

# Output the results
print(ar_model$ar)

