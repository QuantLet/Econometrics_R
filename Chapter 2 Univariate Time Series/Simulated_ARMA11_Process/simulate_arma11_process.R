## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(ggplot2)
# stats is part of base R and attached by default, so library(stats)
# is not strictly necessary.

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate an ARMA(1,1) process
## =====================================================

set.seed(12345)  # For reproducibility

n        <- 1000   # Length of the time series
ar_param <- 0.6    # AR(1) parameter
ma_param <- 0.7    # MA(1) parameter

arma11_data <- arima.sim(list(order = c(1, 0, 1), ar = ar_param, ma = ma_param), n = n)

df_arma11 <- data.frame(
  time  = 1:n,
  value = as.numeric(arma11_data)
)

## =====================================================
## 3. Plot and save the simulated ARMA(1,1) series
## =====================================================

p_arma11 <- ggplot(df_arma11, aes(x = time, y = value)) +
  geom_line() +
  labs(title = "Simulated ARMA(1,1) process", x = "Time", y = "Value") 

ggsave("simulated-arma11.png", plot = p_arma11, width = 6, height = 4, dpi = 300) 
