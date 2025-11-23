## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(ggplot2)
library(forecast)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate AR(1) and MA(1) processes
## =====================================================

set.seed(123)  # For reproducibility

n <- 1000

# AR(1): Y_t = 0.9 Y_{t-1} + epsilon_t
ar1_sim <- arima.sim(n = n, model = list(ar = 0.9))

# MA(1): Y_t = epsilon_t + 0.9 epsilon_{t-1}
ma1_sim <- arima.sim(n = n, model = list(ma = 0.9))

## =====================================================
## 3. PACF plots (square) for AR(1) and MA(1)
## =====================================================

p_ar1_pacf <- ggPacf(ar1_sim) +
  labs(title = "PACF for AR(1) process", x = "Lag", y = "Partial autocorrelation") 
ggsave("ar1_pacf.png", plot = p_ar1_pacf, width = 6, height = 4, dpi = 300)

p_ma1_pacf <- ggPacf(ma1_sim) +
  labs(title = "PACF for MA(1) process", x = "Lag", y = "Partial autocorrelation")  
ggsave("ma1_pacf.png", plot = p_ma1_pacf, width = 6, height = 4, dpi = 300)

## =====================================================
## 4. ACF plots (square) for AR(1) and MA(1)
## =====================================================

p_ar1_acf <- ggAcf(ar1_sim) +
  labs(title = "ACF for AR(1) process", x = "Lag", y = "Autocorrelation") 
ggsave("ar1_acf.png", plot = p_ar1_acf, width = 6, height = 4, dpi = 300)

p_ma1_acf <- ggAcf(ma1_sim) +
  labs(title = "ACF for MA(1) process", x = "Lag", y = "Autocorrelation")
ggsave("ma1_acf.png", plot = p_ma1_acf, width = 6, height = 4, dpi = 300)