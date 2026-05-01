## =====================================================
## 1. Prepare environment & download return data
## =====================================================

# install.packages(c("quantmod", "dplyr", "ranger"))  # if needed

library(quantmod)
library(dplyr)
library(ranger)

# Example asset: SPY (S&P 500 ETF)
getSymbols("SPY", src = "yahoo", from = "2010-01-01", 
           to = "2024-12-31",auto.assign = TRUE)

# Daily log returns (in percent, optional)
ret_xts <- na.omit(diff(log(Ad(SPY)))) * 100

# Build a data frame with date, return and "volatility" proxy (squared return)
vol_df <- data.frame(
  date = index(ret_xts),
  ret  = as.numeric(ret_xts)
) %>%
  mutate(
    vol_t    = ret^2,              # today's squared return
    vol_lead = dplyr::lead(vol_t)  # next-day squared return (forecast target)
  )

## =====================================================
## 2. Construct lagged features for the random forest
## =====================================================

max_lag <- 5

make_lags <- function(x, k_max, prefix) {
  out <- sapply(1:k_max, function(k) dplyr::lag(x, k))
  colnames(out) <- paste0(prefix, "_L", 1:k_max)
  as.data.frame(out)
}

rf_data <- vol_df %>%
  bind_cols(
    make_lags(vol_df$vol_t, max_lag, "vol"),
    make_lags(abs(vol_df$ret), max_lag, "absret")
  ) %>%
  # Response: next-day squared return
  select(date, vol_lead, starts_with("vol_"), starts_with("absret_")) %>%
  # Drop rows with missing lags or missing lead
  tidyr::drop_na()

# Rename response for convenience
rf_data <- rf_data %>%
  rename(y = vol_lead)

## =====================================================
## 3. Split into training and test samples
## =====================================================

T_total <- nrow(rf_data)
T_train <- floor(0.7 * T_total)

train_df <- rf_data[1:T_train, ]
test_df  <- rf_data[(T_train + 1):T_total, ]

## =====================================================
## 4. Fit a random forest for volatility prediction
## =====================================================

set.seed(123)  # for reproducibility

rf_fit <- ranger(
  formula    = y ~ .,
  data       = dplyr::select(train_df, -date),
  num.trees  = 500,
  mtry       = floor(sqrt(ncol(train_df) - 2)),  # predictors per split
  importance = "permutation"                     # compute variable importance
)

print(rf_fit)

## Variable importance (permutation-based)
print(sort(rf_fit$variable.importance, decreasing = TRUE))

## =====================================================
## 5. Out-of-sample predictions and RMSE
## =====================================================

rf_pred <- predict(rf_fit, data = dplyr::select(test_df, -date))$predictions

rmse_rf <- sqrt(mean((test_df$y - rf_pred)^2))
cat("Test RMSE (random forest volatility forecaster):", rmse_rf, "\n")

## Optional: naive benchmark (mean of training response)
y_hat_naive <- rep(mean(train_df$y), nrow(test_df))
rmse_naive  <- sqrt(mean((test_df$y - y_hat_naive)^2))
cat("Test RMSE (naive mean forecaster):", rmse_naive, "\n")