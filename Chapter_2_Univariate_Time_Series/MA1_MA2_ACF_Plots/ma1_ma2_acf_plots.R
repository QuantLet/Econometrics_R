## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(ggplot2)
library(forecast)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate MA(1) and MA(2) processes
## =====================================================

set.seed(123)  # For reproducibility

n <- 1000

# MA(1): epsilon_t + 0.5 * epsilon_{t-1}
ma1_sim <- arima.sim(n = n, model = list(ma = 0.5))

# MA(2): epsilon_t + 0.5 * epsilon_{t-1} + 0.3 * epsilon_{t-2}
ma2_sim <- arima.sim(n = n, model = list(ma = c(0.5, 0.3)))

## =====================================================
## 3. ACF plots for side-by-side display
## =====================================================

acf_theme <- theme(
  plot.title = element_text(size = 10),
  axis.text = element_text(size = 9)
)

p_ma1_acf <- ggAcf(ma1_sim) +
  labs(title = "ACF for MA(1) process", x = "Lag", y = "Autocorrelation") +
  acf_theme
ggsave("ma1_acf.png", plot = p_ma1_acf, width = 3.5, height = 3.2, dpi = 300)

p_ma2_acf <- ggAcf(ma2_sim) +
  labs(title = "ACF for MA(2) process", x = "Lag", y = "Autocorrelation") +
  acf_theme
ggsave("ma2_acf.png", plot = p_ma2_acf, width = 3.5, height = 3.2, dpi = 300)
