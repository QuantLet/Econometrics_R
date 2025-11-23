## =====================================================
## 1. Load data and construct variables
## =====================================================
# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# install.packages("quantreg")   # run once if quantreg is not installed
library(quantreg)

# Load Engel data (income and food expenditure)
data("engel")           # loads data frame 'engel'

## =====================================================
## 2. Estimate OLS regression
## =====================================================

fit_food <- lm(foodexp ~ income, data = engel)

# Add fitted values and residuals (useful for later diagnostics)
engel$fit   <- fitted(fit_food)
engel$resid <- residuals(fit_food)

summary(fit_food)

## =====================================================
## 3. Plot food expenditure vs income using ggplot2
## =====================================================

library(ggplot2)

p_food <- ggplot(engel, aes(x = income, y = foodexp)) +
  geom_point(size = 1.1) +
  geom_smooth(method = "lm", se = FALSE,
              linewidth = 0.6, colour = "red") +
  labs(title = "Food expenditure vs household income",
       x     = "Household income",
       y     = "Food expenditure")  

## =====================================================
## 4. Save figure (6 x 4 inches, 300 dpi)
## =====================================================

ggsave("foodincome.png", p_food, width = 6, height = 4, dpi = 300)