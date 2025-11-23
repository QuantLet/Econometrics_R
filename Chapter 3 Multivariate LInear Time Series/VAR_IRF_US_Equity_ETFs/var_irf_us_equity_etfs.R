## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

rm(list = ls())
set.seed(123)

library(quantmod)  # getSymbols() and price series from Yahoo
library(vars)      # VAR estimation and impulse responses

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Download daily ETF prices from Yahoo Finance
## =====================================================

symbols <- c("SPY", "QQQ", "IWM", "EFA")

getSymbols(
  Symbols     = symbols,
  src         = "yahoo",
  from        = "2024-01-01",
  to          = "2024-12-31",
  auto.assign = TRUE
)

# Merge adjusted close prices into a single xts object
prices <- na.omit(merge(
  Ad(SPY), Ad(QQQ), Ad(IWM), Ad(EFA)
))
colnames(prices) <- symbols

## =====================================================
## 3. Compute logarithmic returns
##    r_t = log(P_t) - log(P_{t-1})
## =====================================================

returns_xts <- na.omit(diff(log(prices)))

# Convert to a data frame for VAR()
returns <- as.data.frame(returns_xts)

## =====================================================
## 4. Select lag order using AIC and estimate VAR
## =====================================================

lag_selection <- VARselect(
  returns,
  lag.max = 10,
  type    = "const"
)

optimal_lag <- lag_selection$selection["AIC(n)"]

var_model <- VAR(
  returns,
  p    = optimal_lag,
  type = "const"
)

## =====================================================
## 5. Generate orthogonal impulse response plots
##    (Cholesky-based IRFs with bootstrap CIs)
## =====================================================

# Create an output folder for figures (if it does not exist)
dir.create("figures", showWarnings = FALSE)

var_names <- colnames(returns)

for (impulse_var in var_names) {
  for (response_var in var_names) {
    
    # File name for each IRF plot
    file_name <- file.path(
      "figures",
      paste0("IRF_", impulse_var, "_to_", response_var, ".png")
    )
    
    # Open a PNG device
    png(file_name, width = 400, height = 300)
    
    # Plot the orthogonal IRF (Cholesky-based)
    plot(
      irf(
        var_model,
        impulse = impulse_var,
        response = response_var,
        ortho = TRUE,
        n.ahead = 10,
        boot = TRUE
      ),
      main = paste(impulse_var, "to", response_var)
    )
    
    # Close the device (saves the file)
    dev.off()
  }
}