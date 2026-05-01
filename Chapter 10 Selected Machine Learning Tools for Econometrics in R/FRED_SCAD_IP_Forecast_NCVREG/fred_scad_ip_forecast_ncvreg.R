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
library(ncvreg)

## =====================================================
## 2. Set up FRED API key and download macro series
## =====================================================

## Put your key in an environment variable FRED_API_KEY,
## or replace Sys.getenv(...) with your key as a string.

fredr_set_key(Sys.getenv("FRED_API_KEY"))
# fredr_set_key("YOUR_FRED_API_KEY_HERE")

## We will forecast industrial production growth (INDPRO)
## using its own lags and lags of unemployment, inflation,
## and the federal funds rate.

series_ids <- c(
  "INDPRO",    # Industrial Production Index
  "UNRATE",    # Unemployment Rate
  "CPIAUCSL",  # CPI for All Urban Consumers
  "FEDFUNDS"   # Effective Federal Funds Rate
)

get_series <- function(id, start_date = "1980-01-01") {
  out <- fredr(
    series_id         = id,
    observation_start = as.Date(start_date)
  ) %>%
    select(date, value)
  names(out)[names(out) == "value"] <- id
  out
}

data_list <- lapply(series_ids, get_series, start_date = "1980-01-01")

# Merge all series on the date dimension
macro_raw <- reduce(data_list, inner_join, by = "date") %>%
  arrange(date)

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
  select(-date, -ip_growth) %>%
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
## 6. Fit SCAD-penalised regression with cv.ncvreg
## =====================================================

set.seed(123)   # for reproducibility of the folds

## family = "gaussian" for continuous responses
## penalty = "SCAD" gives the smoothly clipped absolute deviation penalty

scad_cv <- cv.ncvreg(
  X      = X_train,
  y      = y_train,
  family = "gaussian",
  penalty = "SCAD"
)

# Lambda that minimises cross-validated error
lambda_min_scad <- scad_cv$lambda.min

## Coefficients at the selected lambda
coef_scad <- coef(scad_cv, lambda = lambda_min_scad)
print(coef_scad)

## Variables actually used (non-zero coefficients)
## coef_scad is a named vector, so use names(), not rownames()
nonzero_idx_scad   <- which(abs(coef_scad) > 1e-8)  # small tolerance for numerical zeros
selected_vars_scad <- names(coef_scad)[nonzero_idx_scad]

cat("Selected variables (SCAD):\n")
print(selected_vars_scad)

## =====================================================
## 7. Out-of-sample predictions and RMSE (SCAD)
## =====================================================

y_hat_test_scad <- predict(
  scad_cv,
  X_test,
  lambda = lambda_min_scad
)
y_hat_test_scad <- as.numeric(y_hat_test_scad)

rmse_test_scad <- sqrt(mean((y_test - y_hat_test_scad)^2))
cat("Test RMSE (SCAD forecaster):", rmse_test_scad, "\n")

## Optional: naive benchmark (mean of training sample)
y_hat_naive <- rep(mean(y_train), length(y_test))
rmse_naive  <- sqrt(mean((y_test - y_hat_naive)^2))
cat("Test RMSE (naive mean forecaster):", rmse_naive, "\n")

## =====================================================
## 8. Optional: compare with lasso penalty in ncvreg
## =====================================================

## Using penalty = "lasso" reproduces an L1-penalised estimator
## for comparison with SCAD.

lasso_cv <- cv.ncvreg(
  X      = X_train,
  y      = y_train,
  family = "gaussian",
  penalty = "lasso"
)

lambda_min_lasso <- lasso_cv$lambda.min
coef_lasso <- coef(lasso_cv, lambda = lambda_min_lasso)

y_hat_test_lasso <- predict(
  lasso_cv,
  X_test,
  lambda = lambda_min_lasso
)
y_hat_test_lasso <- as.numeric(y_hat_test_lasso)

rmse_test_lasso <- sqrt(mean((y_test - y_hat_test_lasso)^2))
cat("Test RMSE (lasso forecaster via ncvreg):", rmse_test_lasso, "\n")

## =====================================================
## 9. Note on time-series cross-validation
## =====================================================

## cv.ncvreg by default creates random folds. For strict time-series
## cross-validation, you can construct a 'folds' list with contiguous
## blocks rather than random indices, e.g.:
##
##   K     <- 10
##   idx   <- 1:T_train
##   folds <- split(idx, cut(idx, K, labels = FALSE))
##
##   scad_cv_ts <- cv.ncvreg(
##     X       = X_train,
##     y       = y_train,
##     family  = "gaussian",
##     penalty = "SCAD",
##     folds   = folds
##   )
##