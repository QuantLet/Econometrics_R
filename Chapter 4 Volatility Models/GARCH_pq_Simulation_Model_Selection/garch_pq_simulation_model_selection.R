## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# install.packages("rugarch")  # if needed
library(rugarch)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate a GARCH(1,1) process
## =====================================================

set.seed(123)

n      <- 1000
eps    <- rnorm(n, mean = 0, sd = 1)   # standard normal innovations
sigma2 <- rep(1, n)                    # conditional variance
y      <- rep(0, n)                    # time series

# True GARCH(1,1) parameters
alpha0 <- 0.01
alpha1 <- 0.05
beta1  <- 0.9

# Initialize conditional variance using unconditional value
sigma2[1] <- alpha0 / (1 - alpha1 - beta1)

# Generate GARCH(1,1) series
for (i in 2:n) {
  sigma2[i] <- alpha0 + alpha1 * y[i - 1]^2 + beta1 * sigma2[i - 1]
  y[i]      <- rnorm(1, mean = 0, sd = sqrt(sigma2[i]))
}

## =====================================================
## 3. Grid search over (p, q) for sGARCH(p, q)
##    and compute AIC / BIC
## =====================================================

p_max <- 3
q_max <- 3

aic_values <- matrix(NA_real_, nrow = p_max, ncol = q_max,
                     dimnames = list(p = 1:p_max, q = 1:q_max))
bic_values <- matrix(NA_real_, nrow = p_max, ncol = q_max,
                     dimnames = list(p = 1:p_max, q = 1:q_max))

for (p in 1:p_max) {
  for (q in 1:q_max) {
    spec <- ugarchspec(
      variance.model = list(model = "sGARCH", garchOrder = c(p, q)),
      mean.model     = list(armaOrder = c(0, 0), include.mean = FALSE)
    )
    fit <- try(ugarchfit(spec = spec, data = y), silent = TRUE)
    if (!inherits(fit, "try-error")) {
      ic <- infocriteria(fit)
      aic_values[p, q] <- ic[1]
      bic_values[p, q] <- ic[2]
    }
  }
}

## =====================================================
## 4. Identify best (p, q) by AIC and BIC
## =====================================================

best_aic <- which(aic_values == min(aic_values, na.rm = TRUE), arr.ind = TRUE)
best_bic <- which(bic_values == min(bic_values, na.rm = TRUE), arr.ind = TRUE)

cat("Best (p, q) by AIC:", best_aic[1, "p"], best_aic[1, "q"], "\n")
cat("Best (p, q) by BIC:", best_bic[1, "p"], best_bic[1, "q"], "\n")