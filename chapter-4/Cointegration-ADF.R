rm(list = ls())  
library(urca) 
library(tseries)

# Load the dataset
data("EuStockMarkets")
summary(EuStockMarkets)

DAX <- EuStockMarkets[,1]
SMI <- EuStockMarkets[,2] 

plot(DAX, SMI )

# Perform the linear regressions between the two price series 
comb1 <- lm(DAX~SMI)
comb2 <- lm(SMI~DAX)
summary(comb1)
summary(comb2)

# plot the residuals and visually assess the stationarity of the series:
plot(comb1$residuals, type="l"  )
plot(comb2$residuals, type="l"  )

# ADF teset of the residuals
adf.test(comb1$residuals, k=1) 
adf.test(comb2$residuals, k=1)

# Check if It's a Time Series
is.ts(EuStockMarkets)

# Performing Johansen cointegration test 
# Eigenvalue test
johansen_eigen_test <- ca.jo(uStockMarkets, type = "eigen", ecdet = "const", spec = "longrun", K = 2)
summary(johansen_eigen_test )

# Trace test 
johansen_trace_test <- ca.jo(uStockMarkets, type = "trace", ecdet = "const", spec = "longrun", K = 2)
summary(johansen_trace_test)