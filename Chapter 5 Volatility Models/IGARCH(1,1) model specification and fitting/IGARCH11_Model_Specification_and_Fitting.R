##########################################################################################
# Specifying and Fitting an IGARCH(1,1) Model
##########################################################################################

# Load required library
# install.packages("rugarch")  # Uncomment if not already installed
library(rugarch)

# Define the IGARCH(1,1) specification
spec <- ugarchspec(
  variance.model = list(model = "iGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"  # Assume normal innovations
)

# Fit the IGARCH(1,1) model to the data
# (Make sure your "data" object exists, containing the time series to fit.)
fit <- ugarchfit(spec = spec, data = data)

# Display model summary
show(fit)
