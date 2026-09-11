## =====================================================
## 1. Prepare environment & (optionally) set working dir
## =====================================================

# install.packages(c("fredr", "dplyr", "tidyr", "lubridate",
#                    "purrr", "glmnet"))  # if needed

library(fredr)
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
library(glmnet)


## =====================================================
## 2. Set up FRED API key and download macro series
## =====================================================

## Put your key in an environment variable FRED_API_KEY.
fred_api_key <- Sys.getenv("FRED_API_KEY")
if (!nzchar(fred_api_key)) {
  stop("Please set the FRED_API_KEY environment variable before running this script.")
}
fredr_set_key(fred_api_key)

## We will forecast industrial production growth (INDPRO)
## using its own lags and lags of unemployment, inflation,
## and the federal funds rate.

series_ids <- c(
  "INDPRO",    # Industrial Production Index
  "UNRATE",    # Unemployment Rate
  "CPIAUCSL",  # CPI for All Urban Consumers
  "FEDFUNDS"   # Effective Federal Funds Rate
)

get_series <- function(id, start_date = "1980-01-01", end_date = "2024-12-31") {
  out <- fredr(
    series_id         = id,
    observation_start = as.Date(start_date),
    observation_end   = as.Date(end_date)
  ) %>%
    select(date, value)
  names(out)[names(out) == "value"] <- id
  out
}

data_list <- lapply(
  series_ids,
  get_series,
  start_date = "1980-01-01",
  end_date   = "2024-12-31"
)

# Merge all series on the date dimension
macro_raw <- purrr::reduce(
  data_list,
  dplyr::inner_join,
  by = "date"
) %>%
  dplyr::arrange(date)

## =====================================================
## 3. Construct growth rates and first differences
## =====================================================

macro <- macro_raw %>%
  mutate(
    ip_growth  = 100 * (log(INDPRO)   - lag(log(INDPRO))),   # monthly IP growth (%)
    cpi_infl   = 100 * (log(CPIAUCSL) - lag(log(CPIAUCSL))), # monthly inflation (%)
    d_unrate   = UNRATE   - lag(UNRATE),
    d_fedfunds = FEDFUNDS - lag(FEDFUNDS)
  ) %>%
  select(date, ip_growth, cpi_infl, d_unrate, d_fedfunds) %>%
  drop_na()

## =====================================================
## 4. Build a high-dimensional lagged feature set
## =====================================================

## We create 12 lags (one year) of each variable.

lag_df <- function(x, k_max, prefix) {
  out <- sapply(1:k_max, function(k) dplyr::lag(x, k))
  colnames(out) <- paste0(prefix, "_L", 1:k_max)
  as.data.frame(out)
}

max_lag <- 12

macro_lagged <- macro %>%
  bind_cols(
    lag_df(macro$ip_growth,  max_lag, "ip_growth"),
    lag_df(macro$cpi_infl,   max_lag, "cpi_infl"),
    lag_df(macro$d_unrate,   max_lag, "d_unrate"),
    lag_df(macro$d_fedfunds, max_lag, "d_fedfunds")
  ) %>%
  drop_na()

## Response: current IP growth
y <- macro_lagged$ip_growth

## Predictors: all lags of IP growth, inflation, unemployment, Fed funds
X <- macro_lagged %>%
  select(matches("_L[0-9]+$")) %>%
  as.matrix()

## =====================================================
## 5. Split into training and test samples
## =====================================================

## We'll use the first 70% of the sample for training,
## and the rest for out-of-sample evaluation.

T_total <- length(y)
T_train <- floor(0.7 * T_total)

X_train <- X[1:T_train, ]
y_train <- y[1:T_train]

X_test  <- X[(T_train + 1):T_total, ]
y_test  <- y[(T_train + 1):T_total]

## =====================================================
## 6. Fit lasso with expanding-window cross-validation
## =====================================================

## Ordinary K-fold CV can train on observations later than a held-out
## block. These splits always fit on the past and validate on the next
## contiguous block.
make_expanding_splits <- function(n, initial = floor(0.5 * n), K = 5L) {
  validation_idx <- seq.int(initial + 1L, n)
  block_id <- cut(seq_along(validation_idx), breaks = K, labels = FALSE)
  lapply(split(validation_idx, block_id), function(validate) {
    list(train = seq_len(min(validate) - 1L), validate = validate)
  })
}

ts_cv_glmnet <- function(X, y, alpha, lambda, splits) {
  block_mse <- matrix(NA_real_, nrow = length(splits), ncol = length(lambda))

  for (k in seq_along(splits)) {
    train <- splits[[k]]$train
    validate <- splits[[k]]$validate
    fit <- glmnet(
      X[train, , drop = FALSE], y[train],
      alpha = alpha, lambda = lambda
    )
    pred <- predict(
      fit,
      newx = X[validate, , drop = FALSE],
      s = lambda
    )
    block_mse[k, ] <- colMeans(sweep(pred, 1, y[validate], "-")^2)
  }

  mean_mse <- colMeans(block_mse)
  list(lambda.min = lambda[which.min(mean_mse)], cvm = mean_mse)
}

splits <- make_expanding_splits(T_train, K = 5L)
initial_idx <- splits[[1]]$train

## Derive the candidate path from the earliest training window only.
lasso_lambda <- glmnet(
  X_train[initial_idx, , drop = FALSE],
  y_train[initial_idx],
  alpha = 1
)$lambda

lasso_cv <- ts_cv_glmnet(
  X_train, y_train,
  alpha = 1,
  lambda = lasso_lambda,
  splits = splits
)

# Lambda that minimises cross-validated error
lambda_min <- lasso_cv$lambda.min

lasso_fit <- glmnet(
  X_train, y_train,
  alpha = 1,
  lambda = lasso_lambda
)

# Coefficients at the selected lambda
coef_lasso <- coef(lasso_fit, s = lambda_min)
print(coef_lasso)

# Variables actually used (non-zero coefficients)
selected_idx  <- which(coef_lasso != 0)
selected_vars <- rownames(coef_lasso)[selected_idx]
cat("Selected variables:\n")
print(selected_vars)

## =====================================================
## 7. Out-of-sample predictions and RMSE (lasso)
## =====================================================

y_hat_test <- predict(lasso_fit, newx = X_test, s = lambda_min)
y_hat_test <- as.numeric(y_hat_test)

rmse_test <- sqrt(mean((y_test - y_hat_test)^2))
cat("Test RMSE (lasso forecaster):", rmse_test, "\n")

## Optional: naive benchmark (mean of training sample)
y_hat_naive <- rep(mean(y_train), length(y_test))
rmse_naive  <- sqrt(mean((y_test - y_hat_naive)^2))
cat("Test RMSE (naive mean forecaster):", rmse_naive, "\n")

## =====================================================
## 8. Optional: compare with ridge regression
## =====================================================

ridge_lambda <- glmnet(
  X_train[initial_idx, , drop = FALSE],
  y_train[initial_idx],
  alpha = 0
)$lambda

ridge_cv <- ts_cv_glmnet(
  X_train, y_train,
  alpha = 0,
  lambda = ridge_lambda,
  splits = splits
)

lambda_ridge <- ridge_cv$lambda.min
ridge_fit <- glmnet(
  X_train, y_train,
  alpha = 0,
  lambda = ridge_lambda
)
coef_ridge <- coef(ridge_fit, s = lambda_ridge)

y_hat_test_ridge <- predict(ridge_fit, newx = X_test, s = lambda_ridge)
y_hat_test_ridge <- as.numeric(y_hat_test_ridge)

rmse_test_ridge <- sqrt(mean((y_test - y_hat_test_ridge)^2))
cat("Test RMSE (ridge forecaster):", rmse_test_ridge, "\n")
