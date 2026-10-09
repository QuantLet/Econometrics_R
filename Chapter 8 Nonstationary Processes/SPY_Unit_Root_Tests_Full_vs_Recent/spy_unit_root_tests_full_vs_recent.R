## =====================================================
## 1. Read prices and construct log returns
## =====================================================
library(urca)
d <- read.csv("SPY_adjusted_20000103_20241230.csv")
d$date <- as.Date(d$date)
d$log_price <- log(d$adjusted)
d$log_return <- c(NA_real_, diff(d$log_price))

## =====================================================
## 2. Define the ADF and KPSS comparisons
## =====================================================
test_one <- function(x, sample, price = TRUE) {
  x <- as.numeric(na.omit(x))
  ans <- data.frame()
  for (kind in if (price) c("drift", "trend") else "none") {
    a <- ur.df(x, type = kind, lags = 1, selectlags = "AIC")
    tau <- switch(kind, none = "tau1", drift = "tau2",
      trend = "tau3")
    ans <- rbind(ans, data.frame(sample = sample,
      series = if (price) "Log price" else "Return",
      n = length(x),
      test = paste("ADF", kind),
      stat = unname(a@teststat[1, tau]),
      critical5 = unname(a@cval[tau, "5pct"]),
      reject5 = a@teststat[1, tau] < a@cval[tau, "5pct"]))
  }
  for (kind in if (price) c("mu", "tau") else "mu") {
    k <- ur.kpss(x, type = kind, lags = "short")
    ans <- rbind(ans, data.frame(sample = sample,
      series = if (price) "Log price" else "Return",
      n = length(x),
      test = paste("KPSS", kind),
      stat = as.numeric(k@teststat),
      critical5 = as.numeric(k@cval[1, "5pct"]),
      reject5 = k@teststat > k@cval[1, "5pct"]))
  }
  ans
}

## =====================================================
## 3. Run both tests on the full and recent samples
## =====================================================
recent <- subset(d, date >= as.Date("2024-01-01"))
results <- rbind(test_one(d$log_price, "2000--2024"),
  test_one(recent$log_price, "2024"),
  test_one(d$log_return, "2000--2024", FALSE),
  test_one(recent$log_return, "2024", FALSE))
print(results, row.names = FALSE, digits = 6)
write.csv(results, "unit_root_case_results.csv",
  row.names = FALSE)
