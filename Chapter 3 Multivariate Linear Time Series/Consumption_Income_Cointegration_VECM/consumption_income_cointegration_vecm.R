## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Load packages
# install.packages(c("fredr", "urca", "vars", "ggplot2",
#                    "dplyr", "lubridate"))
library(urca)
library(vars)
library(ggplot2)
library(dplyr)
library(lubridate)

# Read the accompanying monthly consumption and income CSV files.
# Select the common monthly observation window.
start_date <- as.Date("2007-01-01")
end_date <- as.Date("2025-08-01")
read_snapshot <- function(id) {
  d <- read.csv(paste0(id, ".csv"), na.strings = c(".", ""))
  names(d) <- c("date", "value")
  d$date <- as.Date(d$date)
  d[d$date >= start_date & d$date <= end_date, ]
}
cons_raw <- read_snapshot("PCEC96")
inc_raw <- read_snapshot("DSPIC96")

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
  geom_line(aes(y = lcons, colour = "log C", linetype = "log C")) +
  geom_line(aes(y = linc, colour = "log Yd", linetype = "log Yd")) +
  scale_linetype_manual(values = c("log C" = "solid",
                                   "log Yd" = "dashed")) +
  labs(
    title  = "Log real consumption and log real disposable income",
    x      = "Date",
    y      = "log(level)",
    colour = "",
    linetype = ""
  ) +
  guides(colour = guide_legend(nrow = 1),
         linetype = guide_legend(nrow = 1)) +
  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.key.width = grid::unit(1.1, "cm"),
        legend.title = element_blank(),
        plot.title = element_text(size = 12))

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
## 5. Engle-Granger residual-based cointegration test
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
# The printed tau1 critical values do not apply to estimated residuals.
# Use the residual cointegration table for a regressor with drift.

## Optional: Phillips-Ouliaris residual-based test
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
lag_sel <- VARselect(y_ts, lag.max = 24, type = "both")
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

# Conditional rank-one fit for the trend specification
r_ci <- 1

# 6.4 Estimate VECM (error-correction representation)
vecm_fit <- cajorls(joh_trace, r = r_ci)
summary(vecm_fit$rlm)

# 6.5 Extract estimated cointegrating vector beta (normalised)
beta_hat <- joh_trace@V[, 1]        # first eigenvector
beta_names <- rownames(joh_trace@V)
beta_hat <- beta_hat / beta_hat[1]  # normalise w.r.t. lcons
beta_hat

cat("Estimated cointegrating relation (normalised on lcons):\n")
relation_terms <- paste0(
  ifelse(beta_hat >= 0, "+ ", "- "),
  formatC(abs(beta_hat), digits = 6, format = "f"),
  " * ", beta_names
)
relation_text <- sub("^[+] ", "", paste(relation_terms, collapse = " "))
cat(relation_text, "~ I(0)\n")



# Sensitivity to the deterministic specification, with the same lag order.
joh_const <- ca.jo(y_ts, type="trace", ecdet="const", K=p_opt, spec="transitory")
summary(joh_const)
