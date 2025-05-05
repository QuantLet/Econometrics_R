# ======================
# C-CAPM GMM Estimation
# ======================

# Load necessary libraries
library(gmm)
library(quantmod)
library(fredr)
library(zoo)
library(xts)

# Set your FRED API key
fredr_set_key("Insert your own API key")

# -----------------------------
# Step 1: Download Economic Data
# -----------------------------

# Real Personal Consumption Expenditures
consumption <- fredr(
  series_id = "PCECC96",
  observation_start = as.Date("2000-01-01")
)

# 3-Month Treasury Bill rate (risk-free rate)
rf <- fredr(
  series_id = "TB3MS",
  observation_start = as.Date("2000-01-01")
)

# Convert to xts and process
cons_xts <- xts(consumption$value, order.by = consumption$date)
rf_xts <- xts(rf$value / 100 / 12, order.by = rf$date)  # convert annual % to monthly decimal
colnames(cons_xts) <- "consumption"
colnames(rf_xts) <- "rf"

# -----------------------------
# Step 2: Download Financial Data
# -----------------------------

# S&P 500 index from Yahoo Finance
getSymbols("^GSPC", src = "yahoo", from = "2000-01-01", periodicity = "monthly")
sp500_returns <- monthlyReturn(Cl(GSPC))
colnames(sp500_returns) <- "r_m"

# -----------------------------
# Step 3: Prepare and Merge Data
# -----------------------------

# Merge all series
data <- merge.xts(cons_xts, rf_xts, sp500_returns, join = "inner")
data <- na.omit(data)

# Compute log consumption growth and excess returns
data$dc <- diff(log(data$consumption))
data$rx <- lag(data$r_m - data$rf, k = -1)  # lead excess return

# Final cleanup
data <- na.omit(data)

# Add instruments
data$z1 <- 1
data$z2 <- data$dc
data$z3 <- data$rx

# -----------------------------
# Step 4: Define GMM Moments
# -----------------------------

ccapm_moments <- function(theta, x) {
  beta <- theta[1]
  gamma <- theta[2]
  m <- beta * (1 + x$rx) * exp(-gamma * x$dc) - 1
  g1 <- m * x$z1
  g2 <- m * x$z2
  g3 <- m * x$z3
  return(cbind(g1, g2, g3))
}

# -----------------------------
# Step 5: Estimate Model
# -----------------------------

# Initial guess
theta0 <- c(beta = 0.99, gamma = 2)

# GMM estimation
gmm_result <- gmm(g = ccapm_moments, x = data, t0 = theta0)

# Summary output
gmm_summary <- summary(gmm_result)
print(gmm_summary)

# -----------------------------
# Step 6: Hansen J-Test
# -----------------------------

# Extract J-test statistic
j_stat <- gmm_summary$stest$test[1]  # J-statistic
df <- 1  # degrees of freedom = (moments - parameters)
p_val <- 1 - pchisq(j_stat, df)

# Display test result
cat(sprintf("\nHansen J-test statistic: %.3f", j_stat))

cat(sprintf("\nDegrees of freedom: %d", df))

cat(sprintf("\nP-value: %.5f\n", p_val))
