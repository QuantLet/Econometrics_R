## =====================================================
## 1. Prepare data
## =====================================================

# install.packages("rugarch")  # if not already installed
library(rugarch)

# The manuscript version assumes that a univariate return series called
# "data" is already available. The fallback below makes this script
# directly runnable for illustration.
if (!exists("data")) {
  set.seed(123)
  data <- rnorm(1000, mean = 0, sd = 0.01)
}

## =====================================================
## 2. Specify IGARCH(1,1) model
## =====================================================

spec_igarch <- ugarchspec(
  variance.model     = list(model = "iGARCH", garchOrder = c(1, 1)),
  mean.model         = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)

## =====================================================
## 3. Fit IGARCH(1,1) model to the data
## =====================================================

igarch_fit <- ugarchfit(spec = spec_igarch, data = data)

# Print estimation results
show(igarch_fit)
