## =====================================================
## 1. Read and synchronise the fixed intraday sample
## =====================================================
trades <- read.csv("sample_trades_20140917.csv")
trades$DT <- as.POSIXct(trades$DT,
  format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
assets <- c("AAA", "BBB", "ETF")
stopifnot(nrow(trades) == 43581L,
  all(is.finite(trades$PRICE)), all(trades$PRICE > 0),
  !anyNA(trades$DT))
# Preserve the sample's recorded clock; do not convert its time zone.
series <- lapply(assets, function(a) {
  x <- trades[trades$SYMBOL == a, c("DT", "PRICE")]
  x <- x[order(x$DT), ]
  x[!duplicated(x$DT, fromLast = TRUE), ]
})
first <- max(vapply(series, function(x)
  as.numeric(min(x$DT)), numeric(1)))
last <- min(vapply(series, function(x)
  as.numeric(max(x$DT)), numeric(1)))
grid <- seq(ceiling(first / 10) * 10,
            floor(last / 10) * 10, by = 10)
# At each grid time use the most recent preceding trade.
prices <- vapply(series, function(x) {
  i <- findInterval(grid, as.numeric(x$DT))
  stopifnot(all(i > 0L))
  x$PRICE[i]
}, numeric(length(grid)))
colnames(prices) <- assets
grid_time <- as.POSIXct(grid, origin = "1970-01-01", tz = "UTC")
stopifnot(nrow(prices) == 2339L, all(is.finite(prices)))
