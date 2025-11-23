############################################################
## 0. Packages and data
############################################################

# (Optional) set working directory to current script folder in RStudio
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# install.packages(c("quantmod", "dplyr", "tidyr", "lubridate",
#                    "glmnet", "ranger", "rugarch"))  # if needed

library(quantmod)
library(dplyr)
library(tidyr)
library(lubridate)
library(glmnet)
library(ranger)
library(rugarch)
library(ggplot2)

## Download SPY prices from Yahoo Finance
getSymbols("SPY", src = "yahoo", from = "2020-01-01", to = "2024-12-31", auto.assign = TRUE)

## Daily log returns in percent
ret_xts <- na.omit(diff(log(Ad(SPY)))) * 100

## Basic data frame: date, return, squared return, abs return, day-of-week
df <- data.frame(
  date = index(ret_xts),
  r    = as.numeric(ret_xts)
) %>%
  mutate(
    v    = r^2,                         # realised volatility proxy
    absr = abs(r),
    dow  = factor(wday(date, label = TRUE, week_start = 1))
  )

############################################################
## 1. Build lagged feature set for ML models
############################################################

make_lags <- function(x, k_max, prefix) {
  out <- sapply(1:k_max, function(k) dplyr::lag(x, k))
  colnames(out) <- paste0(prefix, "_L", 1:k_max)
  as.data.frame(out)
}

max_lag <- 10  # number of lags for v_t and |r_t|

df_lagged <- df %>%
  bind_cols(
    make_lags(.$v,    max_lag, "v"),
    make_lags(.$absr, max_lag, "absr")
  ) %>%
  mutate(
    y = v   # response variable = current squared return v_t
  ) %>%
  select(date, y, r, dow, starts_with("v_"), starts_with("absr_")) %>%
  drop_na()

N <- nrow(df_lagged)
cat("Usable observations after lagging:", N, "\n")

## Design matrix for ML models (drop date and response)
ml_dat <- df_lagged %>% select(-date)
X_all  <- model.matrix(y ~ ., data = ml_dat)[, -1]  # remove intercept column
y_all  <- ml_dat$y

############################################################
## 2. Time-series cross-validation for lasso penalty (lambda)
############################################################

set.seed(123)

## Use the first T0 observations for tuning lambda
T0 <- 1000L
if (N <= T0 + 50L) stop("Not enough observations for this setup.")

X_tune <- X_all[1:T0, ]
y_tune <- y_all[1:T0]

## Blocked folds (no shuffling) for time-series CV
K <- 5
foldid <- rep(1:K, length.out = T0)
foldid <- sort(foldid)

lasso_cv <- cv.glmnet(
  x      = X_tune,
  y      = y_tune,
  alpha  = 1,          # lasso
  nfolds = K,
  foldid = foldid
)

lambda_opt <- lasso_cv$lambda.min
cat("Selected lambda (lasso):", lambda_opt, "\n")

############################################################
## 3. Specification for GARCH(1,1) benchmark
############################################################

garch_spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)

############################################################
## 4. Rolling one-step-ahead forecasts
############################################################

## Evaluation indices: we need a full estimation window behind each point
eval_idx <- (T0 + 1):N
n_eval   <- length(eval_idx)

y_true   <- y_all[eval_idx]

f_ar     <- numeric(n_eval)
f_garch  <- numeric(n_eval)
f_lasso  <- numeric(n_eval)
f_rf     <- numeric(n_eval)

set.seed(456)  # for random forest

for (j in seq_along(eval_idx)) {
  i <- eval_idx[j]
  
  ## Rolling estimation window indices
  train_idx <- (i - T0):(i - 1)
  test_idx  <- i
  
  ## -----------------------------
  ## 4.1 AR(1) on squared returns
  ## -----------------------------
  y_train <- y_all[train_idx]
  ar_fit  <- arima(y_train, order = c(1, 0, 0))
  f_ar[j] <- as.numeric(predict(ar_fit, n.ahead = 1)$pred)
  
  ## -----------------------------
  ## 4.2 GARCH(1,1) on returns
  ## -----------------------------
  r_train   <- df_lagged$r[train_idx]
  garch_fit <- ugarchfit(garch_spec, data = r_train, solver = "hybrid")
  garch_fc  <- ugarchforecast(garch_fit, n.ahead = 1)
  f_garch[j] <- as.numeric(sigma(garch_fc))^2   # forecast of variance
  
  ## -----------------------------
  ## 4.3 Lasso (glmnet)
  ## -----------------------------
  X_train <- X_all[train_idx, ]
  X_test  <- X_all[test_idx, , drop = FALSE]
  
  lasso_fit <- glmnet(
    x      = X_train,
    y      = y_all[train_idx],
    alpha  = 1,
    lambda = lambda_opt
  )
  
  f_lasso[j] <- as.numeric(predict(lasso_fit, newx = X_test))
  
  ## -----------------------------
  ## 4.4 Random forest (ranger)
  ## -----------------------------
  rf_train_df <- df_lagged[train_idx, ]
  rf_test_df  <- df_lagged[test_idx, ]
  
  rf_fit <- ranger(
    formula    = y ~ .,
    data       = rf_train_df %>% select(-date),
    num.trees  = 500,
    mtry       = floor(sqrt(ncol(rf_train_df) - 2)),  # exclude date, y
    min.node.size = 5,
    importance = "none"
  )
  
  f_rf[j] <- as.numeric(
    predict(rf_fit, data = rf_test_df %>% select(-date))$predictions
  )
  
  if (j %% 50 == 0) cat("Finished", j, "of", n_eval, "forecasts\n")
}

############################################################
## 5. Compare forecast accuracy
############################################################

rmse <- function(e) sqrt(mean(e^2))

rmse_ar     <- rmse(f_ar    - y_true)
rmse_garch  <- rmse(f_garch - y_true)
rmse_lasso  <- rmse(f_lasso - y_true)
rmse_rf     <- rmse(f_rf    - y_true)

results <- data.frame(
  Model = c("AR(1) on v_t", "GARCH(1,1)", "Lasso", "Random forest"),
  RMSE  = c(rmse_ar, rmse_garch, rmse_lasso, rmse_rf)
)

print(results)

############################################################
## 6. Optional: simple plot of realised vs forecasts
############################################################

plot_df <- data.frame(
  date  = df_lagged$date[eval_idx],
  y     = y_true,
  AR1   = f_ar,
  GARCH = f_garch,
  Lasso = f_lasso,
  RF    = f_rf
)

p_lasso <- ggplot(plot_df, aes(x = date)) +
  geom_line(aes(y = y,     colour = "Realised"), linewidth = 0.4) +
  geom_line(aes(y = Lasso, colour = "Lasso"),    linewidth = 0.4) +
  scale_colour_manual(
    values = c("Realised" = "black", "Lasso" = "red"),
    name   = NULL
  ) +
  labs(
    title = "Realised volatility vs lasso forecast",
    x     = "Date",
    y     = "Squared return / forecast"
  ) +
  theme(
    legend.position = "top",
    plot.title = element_text(hjust = 0.5)
  )

# Display in R
print(p_lasso)

# Save to file: 6 x 4 inches, 300 dpi
ggsave(
  filename = "realised_vs_lasso.png",
  plot     = p_lasso,
  width    = 6,
  height   = 4,
  dpi      = 300
)