## =====================================================
## Heteroskedasticity: tests and corrections
## =====================================================

## -----------------------------------------------------
## 0. Preparation
## -----------------------------------------------------

# Clear workspace (optional)
rm(list = ls())

# Load required packages
# install.packages(c("lmtest", "sandwich", "quantreg"))
library(lmtest)
library(sandwich)
library(quantreg)

## =====================================================
## 1. Food expenditure and income (Engel data)
## =====================================================

# Load Engel data (income and food expenditure)
data("engel")   # loads data frame 'engel'

## -----------------------------------------------------
## 1.1 OLS regression: food expenditure on income
## -----------------------------------------------------

fit_food <- lm(foodexp ~ income, data = engel)

summary(fit_food)

# Store residuals and squared residuals
engel$u_hat  <- residuals(fit_food)
engel$u_hat2 <- engel$u_hat^2

# Sample size
n <- nrow(engel)

## =====================================================
## 2. Breusch–Pagan / Lagrange Multiplier test
## =====================================================

## Here we choose z_{i2} = income and test H0: alpha_2 = 0.

# Auxiliary regression: u_hat^2 on constant and income
aux_BP <- lm(u_hat2 ~ income, data = engel)

R2_BP <- summary(aux_BP)$r.squared
LM_BP <- n * R2_BP        # LM statistic
df_BP <- 1                # one restriction
p_BP  <- 1 - pchisq(LM_BP, df = df_BP)

cat("========================================\n")
cat("Breusch–Pagan LM test (foodexp ~ income)\n")
cat("========================================\n")
cat("LM statistic : ", LM_BP, "\n")
cat("df           : ", df_BP, "\n")
cat("p-value      : ", p_BP,  "\n\n")

## (Optional) comparison with lmtest::bptest
# bptest(fit_food, ~ income, data = engel)

## =====================================================
## 3. White test (regressor and its square)
## =====================================================

# Add squared income
engel$income_sq <- engel$income^2

# Auxiliary regression: u_hat^2 on constant, income, income^2
aux_White <- lm(u_hat2 ~ income + income_sq, data = engel)

R2_White <- summary(aux_White)$r.squared
LM_White <- n * R2_White   # White statistic
df_White <- 2              # restrictions: income, income^2
p_White  <- 1 - pchisq(LM_White, df = df_White)

cat("========================================\n")
cat("White test (foodexp ~ income)\n")
cat("========================================\n")
cat("LM statistic : ", LM_White, "\n")
cat("df           : ", df_White, "\n")
cat("p-value      : ", p_White,  "\n\n")

## (Optional) White-style test via bptest
# bptest(fit_food, ~ income + I(income^2), data = engel)

## =====================================================
## 4. White's heteroskedasticity-consistent standard errors
## =====================================================

## HC1 corresponds to the n/(n-K) adjustment discussed in the text.

robust_table <- coeftest(fit_food, vcov = vcovHC(fit_food, type = "HC1"))

cat("========================================\n")
cat("White's HC1 robust standard errors (Engel data)\n")
cat("========================================\n")
print(robust_table)
cat("\n")

# Robust standard errors as a vector
robust_se <- sqrt(diag(vcovHC(fit_food, type = "HC1")))
robust_se

## =====================================================
## 5. GLS with known variance function Var(u_i | x_i) = sigma^2 * income_i
## =====================================================

## Transform y and regressors by 1 / sqrt(income_i).

engel$check_y   <- engel$foodexp / sqrt(engel$income)
engel$check_x1  <- 1 / sqrt(engel$income)
engel$check_x2  <- sqrt(engel$income)

fit_GLS_known <- lm(check_y ~ check_x1 + check_x2 - 1, data = engel)

cat("========================================\n")
cat("GLS with known variance Var(u_i|income_i) ∝ income_i\n")
cat("========================================\n")
summary(fit_GLS_known)

## Coefficients and standard errors
coef(fit_GLS_known)
sqrt(diag(vcov(fit_GLS_known)))

## =====================================================
## 6. Feasible GLS with unknown variance function
##    Var(u_i | income_i) = sigma^2 * income_i^gamma
## =====================================================

## Step 1: estimate gamma from log(e_i^2) on constant and log(income_i).

e_ols <- residuals(fit_food)
z     <- log(engel$income)

aux_var <- lm(log(e_ols^2) ~ z)

cat("========================================\n")
cat("Auxiliary variance regression: log(e_i^2) on log(income_i)\n")
cat("========================================\n")
summary(aux_var)

alpha_hat <- coef(aux_var)  # alpha_1 = log(sigma^2), alpha_2 = gamma_hat

# Fitted variances sigma_hat_i^2
sigma_hat_sq <- exp(alpha_hat[1] + alpha_hat[2] * z)

## Step 2: GLS-type regression using weights w_i = 1 / sqrt(sigma_hat_i^2)

w <- 1 / sqrt(sigma_hat_sq)

fit_GLS_unknown <- lm(foodexp * w ~ I(w) + I(income * w) - 1,
                      data = engel)

cat("========================================\n")
cat("Feasible GLS with estimated variance function (Engel data)\n")
cat("========================================\n")
summary(fit_GLS_unknown)

## =====================================================
## 7. Wage example: Goldfeld–Quandt and groupwise FGLS
##    using CPS1985 data from carData
## =====================================================

## -----------------------------------------------------
## 7.1 Load wage data and estimate OLS model
## -----------------------------------------------------

# install.packages("carData")   # run once if not installed
library(carData)

data("CPS1985")   # loads data frame 'CPS1985'

# Inspect variable names (optional)
# names(CPS1985)

# OLS wage equation: wage on education and experience
fit_wage_OLS <- lm(wage ~ education + experience, data = CPS1985)

cat("========================================\n")
cat("OLS wage equation (wage ~ education + experience, CPS1985)\n")
cat("========================================\n")
summary(fit_wage_OLS)

## -----------------------------------------------------
## 7.2 Goldfeld–Quandt-type test: male vs female
## -----------------------------------------------------

## Implement the Goldfeld–Quandt idea by splitting the sample
## into two groups (male vs female) and comparing residual variances.

male_data   <- subset(CPS1985, gender == "male")
female_data <- subset(CPS1985, gender == "female")

fit_male   <- lm(wage ~ education + experience, data = male_data)
fit_female <- lm(wage ~ education + experience, data = female_data)

sigma2_male   <- var(residuals(fit_male))
sigma2_female <- var(residuals(fit_female))

# F-statistic for equality of variances (male vs female)
F_GQ <- sigma2_male / sigma2_female
df1  <- df.residual(fit_male)
df2  <- df.residual(fit_female)

# Two-sided p-value (reject for very large or very small F)
p_upper <- pf(F_GQ, df1 = df1, df2 = df2, lower.tail = FALSE)
p_GQ    <- 2 * min(p_upper, 1 - p_upper)

cat("========================================\n")
cat("Goldfeld–Quandt-type test (male vs female, CPS1985)\n")
cat("========================================\n")
cat("F statistic = ", F_GQ, "\n")
cat("df1        = ", df1,  "\n")
cat("df2        = ", df2,  "\n")
cat("p-value    = ", p_GQ, "\n\n")

## -----------------------------------------------------
## 7.3 Groupwise FGLS using gender-based variances
## -----------------------------------------------------

sigma_male   <- sqrt(sigma2_male)
sigma_female <- sqrt(sigma2_female)

# Construct estimated sigma_i for each observation
CPS1985$sigma_i <- ifelse(CPS1985$gender == "male", sigma_male, sigma_female)

# FGLS regression: divide both sides and all regressors by sigma_i
fit_wage_FGLS <- lm(wage / sigma_i ~
                      I(1 / sigma_i) +
                      I(education / sigma_i) +
                      I(experience / sigma_i) - 1,
                    data = CPS1985)

cat("========================================\n")
cat("Groupwise FGLS (wage equation, CPS1985)\n")
cat("========================================\n")
summary(fit_wage_FGLS)

## Compare OLS and FGLS coefficients
coef(fit_wage_OLS)
coef(fit_wage_FGLS)