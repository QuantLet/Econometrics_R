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
fred_api_key <- Sys.getenv("FRED_API_KEY")
if (!nzchar(fred_api_key)) {
  stop("Please set the FRED_API_KEY environment variable before running this script.")
}
fredr_set_key(fred_api_key)

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

# FRED uses month-start dates whereas Yahoo uses month-end dates.
# Normalize all indexes to year-month before taking the inner merge.
index(cons_xts) <- zoo::as.yearmon(index(cons_xts))
index(rf_xts) <- zoo::as.yearmon(index(rf_xts))
index(sp500_returns) <- zoo::as.yearmon(index(sp500_returns))

# Merge the first two series (consumption and risk-free rate)
data <- merge.xts(cons_xts, rf_xts, join = "inner")

# Then merge with the third series (S&P 500 returns)
data <- merge.xts(data, sp500_returns, join = "inner")
if (NROW(data) == 0L) stop("The monthly series did not overlap after alignment.")

# =====================================================
## 3. Data Processing and Moment Conditions Function
## =====================================================
# Compute current consumption growth and the gross market return
data$dc <- diff(log(data$consumption))
data$gross_m <- 1 + data$r_m

# Predetermined instruments must be measurable before the priced return
data$z1 <- 1
data$z2 <- xts::lag.xts(data$dc, k = 1)
data$z3 <- xts::lag.xts(data$r_m - data$rf, k = 1)

# Drop observations lost to differencing and lagging
data <- na.omit(data)

# GMM moment conditions function (at least two moments)
C_CAPM_moments <- function(theta, x) {
  beta <- theta[1]   # Subjective discount factor
  gamma <- theta[2]  # Coefficient of relative risk aversion
  euler_error <- beta * x$gross_m * exp(-gamma * x$dc) - 1
  cbind(
    euler_error * x$z1,
    euler_error * x$z2,
    euler_error * x$z3
  )
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
