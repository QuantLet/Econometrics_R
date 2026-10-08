## =====================================================
## 1. Load required packages, clear environment, set API
## =====================================================

# Clear environment
rm(list = ls())

# Set random seed for reproducibility
set.seed(123)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required packages
library(quantmod)  # getSymbols.av interface
library(xts)       # time-series handling

# Read the Alpha Vantage API key from the environment
api_key <- Sys.getenv("ALPHAVANTAGE_API_KEY")
if (!nzchar(api_key)) {
  stop("Please set the ALPHAVANTAGE_API_KEY environment variable.")
}
setDefaults(getSymbols.av, api.key = api_key)

## =====================================================
## 2. Download intraday data and define TSRV function
## =====================================================

# Choose stock symbol and intraday frequency
symbol       <- "AAPL"       # example ticker (Apple Inc.)
interval     <- "1min"       # high-frequency interval
output_size  <- "full"       # request as many intraday points as allowed

# Download intraday data from Alpha Vantage
getSymbols(symbol,
           src          = "av",
           periodicity  = "intraday",
           interval     = interval,
           output.size  = output_size,
           auto.assign  = TRUE)

# Keep positive regular-session observations on one trading day.
data_xts <- na.omit(Cl(get(symbol)))
data_xts <- data_xts[order(index(data_xts))]
data_xts <- data_xts[!duplicated(index(data_xts)) & as.numeric(data_xts)>0]
# quantmod supplies the exchange timestamps; inspect their time zone.
stamp <- index(data_xts)
if (!nzchar(xts::tzone(data_xts))) stop("Set the exchange time zone first.")
clock <- format(stamp,"%H:%M:%S",tz="America/New_York")
data_xts <- data_xts[clock>="09:30:00" & clock<="16:00:00"]
day <- as.Date(index(data_xts),tz="America/New_York")
if (!length(day)) stop("No regular-session observations were returned.")
data_xts <- data_xts[day==max(day)]
priceX <- as.numeric(data_xts)
if (length(priceX)<30) stop("Insufficient observations in the selected day.")
if (any(abs(diff(log(priceX)))>.10)) {
  stop("Inspect large intraday changes against the source before estimation.")
}
cat("Trading day:",as.character(max(day)),"prices:",length(priceX),"\n")

# Define TSRV function (input: price vector and number of subsamples K)
TSRV <- function(priceX, K) {
  lprice <- log(priceX)
  n <- length(lprice) - 1L  # number of return intervals

  if (K < 1L || K > n) stop("K must lie between 1 and n.")

  RV_sub <- numeric(K)
  m_j <- integer(K)

  for (j in seq_len(K)) {
    idx <- seq.int(from = j, to = length(lprice), by = K)
    m_j[j] <- length(idx) - 1L
    RV_sub[j] <- sum(diff(lprice[idx])^2)
  }

  m_bar <- mean(m_j)
  RV_n <- sum(diff(lprice)^2)

  list(
    TSRV = mean(RV_sub) - (m_bar / n) * RV_n,
    K = K,
    m_j = m_j,
    m_bar = m_bar,
    n_returns = n
  )
}

## =====================================================
## 3. Apply the TSRV function to the Alpha Vantage data
## =====================================================

# Use the canonical TSRV order K proportional to n^(2/3)
n_returns <- length(priceX) - 1L
K <- max(1L, as.integer(floor(n_returns^(2 / 3))))

# Compute TSRV estimate
tsrv_result <- TSRV(priceX, K)

# Print the TSRV estimate
tsrv_result$TSRV
