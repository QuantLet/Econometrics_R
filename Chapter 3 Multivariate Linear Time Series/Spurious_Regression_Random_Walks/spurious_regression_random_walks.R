## =====================================================
## 1. Simulate two independent random walks
##    and run a "spurious" regression
## =====================================================

rm(list = ls())
set.seed(123)

# Number of observations
n <- 100

# Random Walk 1: RW1
RW1 <- cumsum(rnorm(n))

# Random Walk 2: RW2
RW2 <- cumsum(rnorm(n))

# Linear regression of RW1 on RW2
model <- lm(RW1 ~ RW2)

# Output the summary of the regression model
summary(model)

## =====================================================
## 2. Plot RW1 vs RW2 with fitted regression line (ggplot2)
##    Save as 6 x 4 inch figure at 300 dpi: rw1-rw2.png
## =====================================================

library(ggplot2)

# Data frame for plotting
df_rw <- data.frame(
  RW1 = RW1,
  RW2 = RW2
)

# Scatter plot with OLS regression line
p_rw <- ggplot(df_rw, aes(x = RW2, y = RW1)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, colour = "red") +
  labs(
    title = "Spurious regression between two random walks",
    x = "RW2",
    y = "RW1"
  )

# Save plot (6:4 ratio, 300 dpi)
ggsave(filename = "rw1-rw2.png", plot = p_rw, width = 6,
  height = 4, dpi = 300)
