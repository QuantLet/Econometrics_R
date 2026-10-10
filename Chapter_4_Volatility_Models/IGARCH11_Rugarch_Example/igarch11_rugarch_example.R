## =====================================================
## 1. Prepare data
## =====================================================

# install.packages("rugarch")  # if not already installed
library(rugarch)

# Simulate a finite IGARCH path, then discard the first 1,000 values.
set.seed(123)
z_igarch <- rnorm(3000)
e_igarch <- numeric(length(z_igarch))
h_igarch <- 0.0001
for (t in seq_along(z_igarch)) {
  e_igarch[t] <- sqrt(h_igarch) * z_igarch[t]
  h_igarch <- 1e-6 + 0.08 * e_igarch[t]^2 + 0.92 * h_igarch
}
returns_igarch <- tail(e_igarch, 2000)


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

igarch_fit <- ugarchfit(spec = spec_igarch, data = returns_igarch)

# Print estimation results
show(igarch_fit)
