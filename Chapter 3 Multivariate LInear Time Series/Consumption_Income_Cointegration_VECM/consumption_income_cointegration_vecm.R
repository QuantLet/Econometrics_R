## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Load packages 
# install.packages(c("fredr", "urca", "vars", "ggplot2",
#                    "dplyr", "lubridate"))
library(fredr)
library(urca)
library(vars)
library(ggplot2)
library(dplyr)
library(lubridate)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Set FRED API key
fredr_set_key("Your_Own_Key") 

## =====================================================
## 2. Download income & consumption data from FRED
##    (Real PCE & Real Disposable Personal Income)
## =====================================================

start_date <- as.Date("1960-01-01")
end_date   <- Sys.Date()

# PCEC96: Real Personal Consumption Expenditures
cons_raw <- fredr(
  series_id         = "PCEC96",
  observation_start = start_date,
  observation_end   = end_date
)

# DSPIC96: Real Disposable Personal Income
inc_raw <- fredr(
  series_id         = "DSPIC96",
  observation_start = start_date,
  observation_end   = end_date
)

# Merge and take logs
df_raw <- inner_join(
  cons_raw %>% select(date, cons = value),
  inc_raw  %>% select(date, inc  = value),
  by = "date"
)

df <- df_raw %>%
  mutate(
    lcons = log(cons),
    linc  = log(inc)
  ) %>%
  # IMPORTANT: remove any rows with missing values
  filter(
    !is.na(lcons),
    !is.na(linc)
  ) %>%
  arrange(date)

# Quick check
summary(df[, c("cons", "inc", "lcons", "linc")])

## =====================================================
## 3. Convert to time series and plot levels
## =====================================================

start_year  <- year(min(df$date))
start_month <- month(min(df$date))

y_ts <- ts(
  df[, c("lcons", "linc")],
  start     = c(start_year, start_month),
  frequency = 12  # monthly
)
colnames(y_ts) <- c("lcons", "linc")

# Plot log levels
p_levels <- ggplot(df, aes(x = date)) +
  geom_line(aes(y = lcons, colour = "log C")) +
  geom_line(aes(y = linc,  colour = "log Yd")) +
  labs(
    title  = "Log real consumption and log real disposable income",
    x      = "Date",
    y      = "log(level)",
    colour = ""
  )  

print(p_levels)

ggsave(filename = "log-consumption-income.png", plot = p_levels, width = 6,  height = 4, 
       dpi = 300)

## =====================================================
## 4. ADF unit-root tests (I(1) vs I(0))
## =====================================================

# Levels with trend
adf_lcons <- ur.df(
  y_ts[, "lcons"],
  type       = "trend",   # constant + trend
  lags       = 12,        # max lag
  selectlags = "AIC"      # choose lag by AIC
)
summary(adf_lcons)

adf_linc <- ur.df(
  y_ts[, "linc"],
  type       = "trend",
  lags       = 12,
  selectlags = "AIC"
)
summary(adf_linc)

# First differences with drift only
dlcons <- diff(y_ts[, "lcons"])
dlinc  <- diff(y_ts[, "linc"])

adf_dlcons <- ur.df(
  dlcons,
  type       = "drift",   # constant, no trend
  lags       = 12,
  selectlags = "AIC"
)
summary(adf_dlcons)

adf_dlinc <- ur.df(
  dlinc,
  type       = "drift",
  lags       = 12,
  selectlags = "AIC"
)
summary(adf_dlinc)

## =====================================================
## 5. Engle–Granger residual-based cointegration test
## =====================================================

# Step 1: static cointegrating regression in levels
eg_reg <- lm(lcons ~ linc, data = df)
summary(eg_reg)

eg_resid <- resid(eg_reg)

# Step 2: ADF test on residuals (no constant, no trend)
eg_adf <- ur.df(
  eg_resid,
  type       = "none",  # residuals already ~ mean 0
  lags       = 12,
  selectlags = "AIC"
)
summary(eg_adf)

## Optional: Phillips–Ouliaris residual-based test
po_test <- ca.po(
  z      = df[, c("lcons", "linc")],
  demean = "constant",
  lag    = "long",
  type   = "Pz"
)
summary(po_test)

## =====================================================
## 6. Johansen system tests (trace & max eigenvalue)
##    and VECM estimation
## =====================================================

# 6.1 Choose VAR lag order in levels
lag_sel <- VARselect(y_ts, lag.max = 12, type = "trend")
lag_sel$selection

p_opt <- as.numeric(lag_sel$selection["SC(n)"])
cat("Selected VAR(p) order by SC:", p_opt, "\n")

# 6.2 Johansen trace test
joh_trace <- ca.jo(
  x     = y_ts,
  type  = "trace",
  ecdet = "trend",   # deterministic trend in cointegration space
  K     = p_opt,
  spec  = "transitory"
)
summary(joh_trace)

# 6.3 Johansen maximum eigenvalue test
joh_eigen <- ca.jo(
  x     = y_ts,
  type  = "eigen",
  ecdet = "trend",
  K     = p_opt,
  spec  = "transitory"
)
summary(joh_eigen)

# Assume rank r = 1 from the Johansen tests
r_ci <- 1

# 6.4 Estimate VECM (error-correction representation)
vecm_fit <- cajorls(joh_trace, r = r_ci)
summary(vecm_fit$rlm)

# 6.5 Extract estimated cointegrating vector β (normalised)
beta_hat <- joh_trace@V[, 1]        # first eigenvector
beta_hat <- beta_hat / beta_hat[1]  # normalise w.r.t. lcons
beta_hat

cat("Estimated cointegrating relation (normalised on lcons):\n")
cat("lcons_t -", abs(beta_hat[2]), "* linc_t ~ I(0)\n")