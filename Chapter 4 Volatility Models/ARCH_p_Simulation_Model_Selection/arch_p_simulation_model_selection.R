## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

library(rugarch)
library(ggplot2)
library(FinTS)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate an ARCH(p) process
## =====================================================

set.seed(123)

n      <- 1000
omega  <- 0.1
alphas <- c(0.5, 0.2, 0.1)  # p = 3

eps    <- rnorm(n)
sigma2 <- numeric(n)
sigma2[1:length(alphas)] <- omega / (1 - sum(alphas))

for (i in (length(alphas) + 1):n) {
  sigma2[i] <- omega + sum(alphas * eps[(i - 1):(i - length(alphas))]^2)
  eps[i]    <- rnorm(1, sd = sqrt(sigma2[i]))
}

## =====================================================
## 3. Plot simulated ARCH(p) series
## =====================================================

df_arch <- data.frame(time = 1:n, eps = eps)

p_arch <- ggplot(df_arch, aes(x = time, y = eps)) +
  geom_line() +
  labs(title = "Simulated ARCH(p) process",
       x     = "Time",
       y     = expression(epsilon[t])) 

ggsave("arch_p_series.png", plot = p_arch, width = 6, height = 4, dpi = 300)

## =====================================================
## 4. Fit ARCH(p) models and compute AIC/BIC
## =====================================================

p_max      <- 5
aic_values <- rep(NA_real_, p_max)
bic_values <- rep(NA_real_, p_max)

for (p in 1:p_max) {
  spec <- ugarchspec(
    variance.model = list(model = "sGARCH", garchOrder = c(p, 0)),
    mean.model     = list(armaOrder = c(0, 0), include.mean = FALSE)
  )
  fit <- try(ugarchfit(spec, data = eps), silent = TRUE)
  if (!inherits(fit, "try-error")) {
    ic <- infocriteria(fit)
    aic_values[p] <- ic[1]
    bic_values[p] <- ic[2]
  }
}

## =====================================================
## 5. Select best p, refit model, Ljung–Box test
## =====================================================

best_p_aic <- which.min(aic_values)
best_p_bic <- which.min(bic_values)

cat("Best p (AIC):", best_p_aic, "\n")
cat("Best p (BIC):", best_p_bic, "\n")

best_spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(best_p_aic, 0)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = FALSE)
)

best_fit <- ugarchfit(best_spec, data = eps)
show(best_fit)

ljung_box_test <- Box.test(best_fit@fit$residuals / best_fit@fit$sigma,
                           lag = 10, type = "Ljung-Box")
print(ljung_box_test)