# =====================================================
## 1. Install and Load Required Libraries
## =====================================================
# install.packages(c("gmm", "quantmod", "fredr", "zoo", "xts"))

# Load libraries
library(gmm)
library(quantmod)
library(fredr)
library(zoo)
library(xts)

# Set FRED API key
fredr_set_key("Your_Own_Key")

# =====================================================
## 2. Download and Prepare Data
## =====================================================
# Download Real Personal Consumption Expenditures (monthly by default)
consumption <- fredr(
  series_id = "PCECC96",
  observation_start = as.Date("2000-01-01")
)

# Download 3-Month Treasury Bill rate (monthly by default)
rf <- fredr(
  series_id = "TB3MS",
  observation_start = as.Date("2000-01-01")
)

# Convert to xts (time-series format)
cons_xts <- xts(consumption$value, order.by = consumption$date)
rf_xts <- xts(rf$value / 100 / 12, order.by = rf$date)  # Convert to monthly rate
colnames(cons_xts) <- "consumption"
colnames(rf_xts) <- "rf"

# Download S&P 500 data
getSymbols("^GSPC", src = "yahoo", from = "2000-01-01", periodicity = "monthly")
sp500_returns <- monthlyReturn(Cl(GSPC))
colnames(sp500_returns) <- "r_m"

# Merge the first two series (consumption and risk-free rate)
data <- merge.xts(cons_xts, rf_xts, join = "inner")

# Then merge with the third series (S&P 500 returns)
data <- merge.xts(data, sp500_returns, join = "inner")

# =====================================================
## 3. Data Processing and Moment Conditions Function
## =====================================================
# Compute log consumption growth and excess returns
data$dc <- diff(log(data$consumption))  # Log difference of consumption to get growth rate
data$rx <- dplyr::lead(data$r_m - data$rf, n = 1)  # Lead excess return to match timing

# Drop NA rows due to lag and diff
data <- na.omit(data)

# Add constant instrument for identification
data$z1 <- 1  # Constant instrument (useful for identification)
data$z2 <- data$dc  # Use consumption growth as an instrument
data$z3 <- data$rx  # Or lagged returns (if available)

# GMM moment conditions function (at least two moments)
C_CAPM_moments <- function(theta, x) {
  beta <- theta[1]   # Parameter for risk aversion
  gamma <- theta[2]  # Parameter for consumption elasticity
  m <- beta * (1 + x$rx) * exp(-gamma * x$dc) - 1  # Moment condition
  g1 <- m * x$z1  # Multiply by instrument z1
  g2 <- m * x$z2  # Multiply by instrument z2
  g3 <- m * x$z3  # Multiply by instrument z3
  return(cbind(g1, g2, g3))  # Return a matrix of moment conditions
}

# =====================================================
## 4. Model Estimation and J-statistic Calculation
## =====================================================
# Initial parameter guess for beta and gamma
theta0 <- c(beta = 0.99, gamma = 2)

# Estimate the model using GMM
gmm_result <- gmm(g = C_CAPM_moments, x = data, t0 = theta0)

# Display the results of the GMM estimation
summary(gmm_result)

# Calculate J-statistic for over-identifying restrictions
j_statistic <- gmm_result$objective * gmm_result$n  # Multiply objective by sample size

# Compute degrees of freedom: r - a (number of moment conditions - number of parameters)
df <- gmm_result$q - gmm_result$k

# Calculate p-value from the chi-squared distribution
p_value <- 1 - pchisq(j_statistic, df)

# Print the results: J-statistic, degrees of freedom, and p-value
cat("J-statistic:", j_statistic, "\n")
cat("Degrees of freedom:", df, "\n")
cat("P-value:", p_value, "\n")