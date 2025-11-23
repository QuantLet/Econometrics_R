## =========================================================
## 1. Prepare environment & set working directory 
##    to the current script folder (optional for RStudio)
## =========================================================

if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

pkgs <- c("quantmod", "ggplot2", "dplyr")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

library(quantmod)
library(ggplot2)
library(dplyr)

## =========================================================
## 2. Download financial data from Yahoo Finance (example: SPY ETF)
##    You can replace "SPY" by "AAPL", "MSFT", etc.
## =========================================================

# Download daily data from January 1, 2015 to December 31, 2024
spy_xts <- getSymbols("SPY", src = "yahoo",
                      from = "2015-01-01", to = "2024-12-31", auto.assign = FALSE)


# Extract adjusted closing prices
spy_df <- data.frame(
  date  = index(spy_xts),
  price = as.numeric(Ad(spy_xts))
) %>%
  filter(!is.na(price)) %>%
  mutate(
    t         = row_number(),   # time index t = 1, 2, ..., T
    log_price = log(price)      # log prices
  )

T_obs <- nrow(spy_df)

## =========================================================
## 3. Global quadratic trend model (parametric)
## =========================================================

global_fit <- lm(log_price ~ t + I(t^2), data = spy_df)
summary(global_fit)

# Fitted global trend on the log-price scale
spy_df$trend_global_log <- fitted(global_fit)

# Optional: back-transform from log scale to price scale 
# with a simple bias correction for E(exp(ε))
bc_factor_global <- mean(exp(residuals(global_fit)))  # sample approximation to E(exp(ε))
spy_df$trend_global <- exp(spy_df$trend_global_log) * bc_factor_global

# Time of the peak of the global quadratic curve (if γ < 0)
b <- coef(global_fit)
if (b["I(t^2)"] < 0) {
  t_peak   <- -b["t"] / (2 * b["I(t^2)"])
  date_peak <- spy_df$date[round(t_peak)]
  message("Estimated peak (global quadratic) at t ≈ ",
          round(t_peak, 1), ", date ≈ ", as.character(date_peak))
}

## =========================================================
## 4. Rolling local quadratic trend (nonparametric / local)
##    At each time, fit a quadratic using the most recent 
##    n_window observations (rolling window)
## =========================================================

n_window <- 40  # window length; you may change to 30, 60, etc.

trend_local_log <- rep(NA_real_, T_obs)
trend_local      <- rep(NA_real_, T_obs)

for (i in seq_len(T_obs)) {
  # Skip the first (n_window - 1) points where the window is incomplete
  if (i < n_window) next
  
  idx_window <- (i - n_window + 1):i
  sub_dat    <- spy_df[idx_window, ]
  
  # Local quadratic trend: log_price ~ t + t^2 within the window
  local_fit <- lm(log_price ~ t + I(t^2), data = sub_dat)
  
  # Predicted local trend at time i on the log scale
  trend_local_log[i] <- predict(
    local_fit,
    newdata = data.frame(t = spy_df$t[i])
  )
  
  # Optional: local bias correction (or reuse bc_factor_global)
  bc_factor_local <- mean(exp(residuals(local_fit)))
  trend_local[i]  <- exp(trend_local_log[i]) * bc_factor_local
}

spy_df$trend_local_log <- trend_local_log
spy_df$trend_local     <- trend_local

## =========================================================
## 5. Plot log prices with global and local quadratic trends
## =========================================================

p_log <- ggplot(spy_df, aes(x = date)) +
  geom_line(aes(y = log_price), colour = "black", linewidth = 0.5) +
  geom_line(aes(y = trend_global_log), colour = "blue", linewidth = 0.8) +
  geom_line(aes(y = trend_local_log),  colour = "red",  linewidth = 0.8) +
  labs(title = "Log SPY price with global and local quadratic trends",
       x = "Date",
       y = "log(price)")  

print(p_log)

ggsave("spy_log_trend_global_local.png", p_log,
       width = 6, height = 4, dpi = 300)

## =========================================================
## 6. Plot prices with global and rolling local quadratic trends
##    (after simple bias correction)
## =========================================================

p_level <- ggplot(spy_df, aes(x = date)) +
  geom_line(aes(y = price), colour = "black", linewidth = 0.5) +
  geom_line(aes(y = trend_global), colour = "blue", linewidth = 0.8) +
  geom_line(aes(y = trend_local),  colour = "red",  linewidth = 0.8,
            na.rm = TRUE) +
  labs(title = "SPY price with global and rolling quadratic trend fits",
       x = "Date",
       y = "Price")  

print(p_level)

ggsave("spy_level_trend_global_local.png", p_level,
       width = 6, height = 4, dpi = 300)