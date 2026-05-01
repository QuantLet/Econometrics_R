## =====================================================
## 0. Preparation
## =====================================================

# Clear workspace (optional)
rm(list = ls())

# Load required packages
# install.packages(c("car", "lmtest", "sandwich"))  # run once if needed
library(car)       # vif(), ncvTest()
library(lmtest)    # bptest(), resettest(), coeftest()
library(sandwich)  # vcovHC()

## =====================================================
## 1. Load data and define variables (mtcars)
## =====================================================

data(mtcars)
df <- mtcars

## -----------------------------------------------------
## 1.1 Treat some variables as factors
## -----------------------------------------------------

df$cyl  <- factor(df$cyl)                       # cylinders
df$am   <- factor(df$am, labels = c("Auto","Manual"))
df$vs   <- factor(df$vs)
df$gear <- factor(df$gear)
df$carb <- factor(df$carb)

## =====================================================
## 2. Estimate multiple regression model
## =====================================================

fit <- lm(mpg ~ wt + hp + disp + drat + qsec + cyl + am, data = df)
summary(fit)

## =====================================================
## 3. Multicollinearity diagnostics
## =====================================================

cat("\n--- VIF / GVIF ---\n")
v <- vif(fit)
print(v)
if (is.matrix(v) && "GVIF^(1/(2*Df))" %in% colnames(v)) {
  cat("\nAdjusted GVIF^(1/(2*Df)) (comparable to VIF):\n")
  print(v[, "GVIF^(1/(2*Df))"])
}

cat("\n--- Condition Number (scaled X) ---\n")
X   <- model.matrix(fit)[, -1, drop = FALSE]    # drop intercept
Xz  <- scale(X, center = TRUE, scale = TRUE)
sv  <- svd(Xz)
kcn <- max(sv$d) / min(sv$d)
print(kcn)

## =====================================================
## 4. Heteroskedasticity diagnostics
## =====================================================

cat("\n--- Breusch–Pagan test (baseline) ---\n")
print(bptest(fit))  # default varformula = ~ fitted.values

cat("\n--- Non-constant variance score test (ncvTest) ---\n")
print(ncvTest(fit)) # vs fitted values by default

cat("\n--- 'White-like' BP using fitted and fitted^2 (explicit data) ---\n")
z <- fitted(fit)                                # numeric fitted values
print(bptest(fit, ~ z + I(z^2), data = data.frame(z = z)))

## =====================================================
## 5. Robust (heteroskedasticity-consistent) standard errors
## =====================================================

cat("\n--- HC3 Robust SE (coeftest) ---\n")
rob_vcov <- vcovHC(fit, type = "HC3")
print(coeftest(fit, vcov = rob_vcov))

## =====================================================
## 6. Functional-form check (Ramsey RESET)
## =====================================================

cat("\n--- Ramsey RESET (powers of fitted) ---\n")
print(resettest(fit, power = 2:3, type = "regressor"))

## =====================================================
## 7. Residual and influence diagnostics
## =====================================================

# Standard residual plots
par(mfrow = c(2, 2))
plot(fit)   # residuals vs fitted, QQ, scale-location, Cook's distance
par(mfrow = c(1, 1))

# Top 5 Cook's distances
cat("\n--- Top 5 Cook's distances ---\n")
cd <- cooks.distance(fit)
print(head(sort(cd, decreasing = TRUE), 5))

## =====================================================
## 8. Correlation matrix (numeric predictors)
## =====================================================

nums <- df[, sapply(df, is.numeric), drop = FALSE]
cat("\n--- Correlation (numeric predictors) ---\n")
print(round(cor(nums), 2))