## =====================================================
## 1. Load required packages, set API key and options
## =====================================================

library(quantmod)      # getSymbols.av interface
library(xts)           # time‑series handling
library(ggplot2)       # for plotting
# Optionally:
# library(alphavantager)  # for alternative API interface

# Set your Alpha Vantage API key
api_key <- "Your_Own_Key"
setDefaults(getSymbols.av, api.key = api_key)
# Or if using alphavantager:
# alphavantager::av_api_key(api_key)

## =====================================================
## 2. Download intraday high‑frequency data for a stock
## =====================================================

symbol <- "AAPL"        # Apple inc. 
interval <- "1min"      # high‑frequency interval
output_size <- "full"   # get as many intraday points as available 
getSymbols(symbol, src = "av", periodicity = "intraday",
           interval = interval, output.size = output_size, auto.assign = TRUE)
data <- Cl(get(symbol))  # extract the closing price column

# Remove any missing values
data <- na.omit(data)

## =====================================================
## 3. Compute log‑returns and realized volatilities
## =====================================================

log_returns_1min <- diff(log(data))
rv_1min <- sum(log_returns_1min^2, na.rm = TRUE)

# Aggregate to a coarser interval, e.g. 5‑minute or 10‑minute, for comparison
k <- 10   # number of minutes per aggregated bar
agg_data <- to.period(data, period = "minutes", k = k)
agg_log_returns <- diff(log(Cl(agg_data)))
rv_agg <- sum(agg_log_returns^2, na.rm = TRUE)

cat("Realized Volatility for 1‑min data: ", rv_1min, "\n")
cat(sprintf("Realized Volatility for %d‑min data: ", k), rv_agg, "\n")

## =====================================================
## 4. Plot comparison
## =====================================================

# Create data frame for volatilities comparison
vol_comp <- data.frame(
  Interval = c("1-Minute", paste0(k, "-Minute")),
  RV       = c(rv_1min, rv_agg)
)

# Plot comparison of realized volatilities
vol_plot <- ggplot(vol_comp, aes(x = Interval, y = RV)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  ggtitle("Realized Volatility Comparison") +
  ylab("Realized Volatility")

# Save the volatility comparison plot
ggsave("volatility_comparison.png", plot = vol_plot, width = 6, height = 4, dpi = 300)

## =====================================================
## 5. Plot the log-returns of 1-min data to visualize high-frequency fluctuations
## =====================================================

# Remove NA values in log_returns_1min (which occur due to diff() on the first element)
log_returns_1min_clean <- na.omit(log_returns_1min)

# Construct a data frame for plotting the log-returns
df_lr <- data.frame(
  timestamp = index(log_returns_1min_clean),  # Extract the timestamps
  logret    = as.numeric(coredata(log_returns_1min_clean))  # Convert to numeric
)

# Check the first few rows of the cleaned data frame
head(df_lr)

# Plot the log-returns of 1-minute data
log_ret_plot <- ggplot(df_lr, aes(x = timestamp, y = logret)) +
  geom_line(alpha = 0.6) +
  ggtitle(paste0(symbol, " Log-Returns (", interval, " interval)")) +
  xlab("Time") +
  ylab("Log Return")  

# Save the log-returns plot
ggsave("log_returns_1min.png", plot = log_ret_plot, width = 6, height = 4, dpi = 300)