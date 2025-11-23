## =====================================================
## 1. Setup environment & load packages
## =====================================================

# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required package
# install.packages("ggplot2")
library(ggplot2)

## =====================================================
## 2. Load data and estimate OLS regression
## =====================================================

# Load the mtcars dataset
data(mtcars)

# Estimate OLS regression of mpg on wt
model <- lm(mpg ~ wt, data = mtcars)

# Print regression summary
summary(model)

## =====================================================
## 3. Create ggplot object (scatter + fitted line)
## =====================================================

p_ols <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    title = "OLS fit: mpg on weight"
  )  

## =====================================================
## 4. Save 6x4 inch figure to figures/ols-mtcars
## =====================================================

ggsave(filename = "ols-mtcars.png", 
       plot = p_ols, width = 6, height = 4, units = "in")

## =====================================================
## 5. Perform ANOVA on the regression model
## =====================================================


anova_result <- anova(model)

# Print the results
print(anova_result)