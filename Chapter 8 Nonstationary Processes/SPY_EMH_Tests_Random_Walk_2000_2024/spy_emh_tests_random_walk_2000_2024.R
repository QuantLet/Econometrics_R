## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# (Optional) set working directory to current script folder in RStudio
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Packages needed for this illustration
pkgs <- c("quantmod", "dplyr", "ggplot2",
          "forecast", "lmtest", "sandwich", "vrtest")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

library(quantmod)
library(dplyr)
library(ggplot2)
library(forecast)
library(lmtest)
library(sandwich)
library(vrtest)

## =====================================================
## 2. Download SPY prices and construct log returns
## =====================================================

# Download daily SPY prices from Yahoo Finance
spy_xts <- getSymbols("SPY", src = "yahoo",
                      from = "2000-01-01",
                      to = "2024-12-31",
                      auto.assign = FALSE)

# Build a data frame with dates, prices and log returns
spy_df <- data.frame(
  date  = index(spy_xts),
  price = as.numeric(Ad(spy_xts))
) %>%
  filter(!is.na(price)) %>%
  mutate(
    log_price = log(price),
    ret       = c(NA, diff(log_price))
  )

# Drop the first NA return and define full / recent samples
spy_ret_full <- spy_df %>%
  filter(!is.na(ret)) %>%
  select(date, ret)

spy_ret_recent <- spy_ret_full %>%
  filter(date >= as.Date("2024-01-01"))

n_full   <- nrow(spy_ret_full)
n_recent <- nrow(spy_ret_recent)

summary(spy_ret_full$ret)
summary(spy_ret_recent$ret)

## Quick plots of returns (full vs recent sample)
p_full <- ggplot(spy_ret_full, aes(x = date, y = ret)) +
  geom_line(linewidth = 0.3) +
  labs(title = "SPY daily log returns (full sample)",
       x = "Date", y = "Return") 

p_recent <- ggplot(spy_ret_recent, aes(x = date, y = ret)) +
  geom_line(linewidth = 0.3) +
  labs(title = "SPY daily log returns (since 2024)",
       x = "Date", y = "Return")  

print(p_full)
print(p_recent)

## =====================================================
## 3. Serial correlation: ACF and Ljung-Box tests
##    (rw1-type tests: i.i.d. under the null)
## =====================================================

# ACF plots for full and recent samples
Acf(spy_ret_full$ret, lag.max = 30,
    main = "ACF of SPY daily log returns (full sample)")
Acf(spy_ret_recent$ret, lag.max = 30,
    main = "ACF of SPY daily log returns (since 2024)")

# Ljung-Box tests for joint zero autocorrelation
Box.test(spy_ret_full$ret, lag = 20, type = "Ljung-Box")
Box.test(spy_ret_recent$ret, lag = 20, type = "Ljung-Box")

## Robust automatic portmanteau tests (Auto.Q)
## These are designed to remain valid under conditional heteroskedasticity
autoQ_full   <- Auto.Q(spy_ret_full$ret)
autoQ_recent <- Auto.Q(spy_ret_recent$ret)

autoQ_full
autoQ_recent

## =====================================================
## 4. AR(p) regressions and Wald tests
##    (predictability of returns via lagged returns)
## =====================================================

# Helper function to fit AR(p) via OLS and perform robust Wald test
emh_ar_test <- function(r, p = 5, label = "") {
  r <- as.numeric(r)
  emb <- stats::embed(r, p + 1)
  df  <- as.data.frame(emb)
  colnames(df) <- c("ret", paste0("L", 1:p))
  fit <- lm(ret ~ ., data = df)
  
  cat("\n========================================\n")
  cat("AR(", p, ") regression for ", label, "\n", sep = "")
  print(summary(fit))
  
  cat("\nWald test (H0: all lag coefficients = 0)\n")
  # Restricted model: intercept-only
  wtest <- waldtest(fit, . ~ 1,
                    vcov = vcovHC,
                    test = "Chisq")
  print(wtest)
  invisible(fit)
}

fit_full   <- emh_ar_test(spy_ret_full$ret,   p = 5,
                          label = "SPY returns (full sample)")
fit_recent <- emh_ar_test(spy_ret_recent$ret, p = 5,
                          label = "SPY returns (since 2024)")

## =====================================================
## 5. Variance ratio tests
##    (random walk null vs. mean reversion / momentum)
## =====================================================

# Holding periods (k) for VR tests
kvec <- c(2, 5, 10, 20)

# Classical VR-1 statistics (Lo-Mac style) under homoskedasticity (rw1)
vr_full   <- VR.minus.1(spy_ret_full$ret,   kvec = kvec)
vr_recent <- VR.minus.1(spy_ret_recent$ret, kvec = kvec)

# Extract VR(k) - 1 and construct asymptotic Z-statistics
VRk_full   <- vr_full$VR.kvec     # VR(k) - 1
VRk_recent <- vr_recent$VR.kvec

Z_full <- sqrt(n_full * kvec / (2 * (kvec - 1))) * VRk_full
Z_recent <- sqrt(n_recent * kvec / (2 * (kvec - 1))) * VRk_recent

p_full <- 2 * (1 - pnorm(abs(Z_full)))
p_recent <- 2 * (1 - pnorm(abs(Z_recent)))

vr_table_full <- data.frame(
  k       = kvec,
  VR.minus.1 = VRk_full,
  Z.stat     = Z_full,
  p.value    = p_full
)

vr_table_recent <- data.frame(
  k       = kvec,
  VR.minus.1 = VRk_recent,
  Z.stat     = Z_recent,
  p.value    = p_recent
)

vr_table_full
vr_table_recent

## Automatic variance ratio tests robust to conditional heteroskedasticity
autoVR_full   <- Auto.VR(spy_ret_full$ret)
autoVR_recent <- Auto.VR(spy_ret_recent$ret)

autoVR_full
autoVR_recent

## Optional: wild bootstrap version of the automatic VR test
## (for small samples or strong conditional heteroskedasticity)
# set.seed(123)
# boot_full   <- AutoBoot.test(spy_ret_full$ret,   nboot = 1000, wild = "Normal")
# boot_recent <- AutoBoot.test(spy_ret_recent$ret, nboot = 1000, wild = "Normal")
# boot_full
# boot_recent