##########################################################################################
# Fitting Various GARCH-type and Markov-Switching GARCH Models to SSE Log Returns
##########################################################################################

# Set seed for reproducibility
set.seed(123)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required libraries
# install.packages(c("rugarch", "forecast", "zoo", "MSwM"))  # Uncomment if not installed
library(rugarch)
library(forecast)
library(zoo)
library(MSwM)

##########################################################################################
# 1. Load and Prepare SSE Index Data
##########################################################################################

# Load SSE Index data
sse_data <- read.csv("sse.csv", stringsAsFactors = FALSE)
sse_data$Date <- as.Date(sse_data$Date)

# Compute log returns
sse_data$LogReturns <- c(NA, diff(log(sse_data$SSE), lag = 1))
sse_data <- sse_data[-1, ]  # Remove the first NA row

##########################################################################################
# 2. Fit an ARMA Model to Log Returns
##########################################################################################

# Fit ARMA model using auto.arima
arma_fit <- auto.arima(sse_data$LogReturns, seasonal = FALSE, 
                       stepwise = FALSE, approximation = FALSE)

# Output ARMA model summary
summary(arma_fit)

##########################################################################################
# 3. Estimate GARCH-type Models
##########################################################################################

# Standard GARCH(1,1)
spec_garch <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE)
)
garch_fit <- ugarchfit(spec = spec_garch, data = sse_data$LogReturns)

# EGARCH(1,1)
spec_egarch <- ugarchspec(
  variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE)
)
egarch_fit <- ugarchfit(spec = spec_egarch, data = sse_data$LogReturns)

# GJR-GARCH(1,1)
spec_gjrgarch <- ugarchspec(
  variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE)
)
gjrgarch_fit <- ugarchfit(spec = spec_gjrgarch, data = sse_data$LogReturns)

# Threshold GARCH (TGARCH) model
spec_tgarch <- ugarchspec(
  variance.model = list(model = "fGARCH", submodel = "TGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE)
)
tgarch_fit <- ugarchfit(spec = spec_tgarch, data = sse_data$LogReturns)

##########################################################################################
# 4. Fit a Markov Switching GARCH Model
##########################################################################################

# Prepare data
data_df <- data.frame(log_returns = sse_data$LogReturns)

# Define model formula (intercept-only)
formula_ms <- log_returns ~ 1

# Fit the Markov Switching model with 2 regimes
# sw = vector indicating which parameters are allowed to switch
model_ms_garch <- msmFit(formula = formula_ms, data = data_df, k = 2, sw = c(TRUE, TRUE))

##########################################################################################
# 5. Output Model Estimation Results
##########################################################################################

# Display fitted model summaries
show(garch_fit)
show(egarch_fit)
show(gjrgarch_fit)
show(tgarch_fit)
summary(model_ms_garch)
