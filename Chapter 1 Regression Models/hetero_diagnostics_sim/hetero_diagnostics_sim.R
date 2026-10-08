## =====================================================
## 1. Generate synthetic data with heteroskedasticity
## =====================================================

# Set the random seed for reproducibility
set.seed(123456)

# Number of observations
n <- 200

# Regressor x on [0, 1]
x <- seq(1, n) / n

# Generate i.i.d. N(0, 1) disturbances
e <- rnorm(n, mean = 0, sd = 1)

# Reassign the same draws so that larger absolute values
# tend to be paired with larger x-values
i <- order(runif(n, max = dnorm(e)))
y <- 1 + 4 * x + e[rev(i)]

# Put data in a data frame
dat <- data.frame(x = x, y = y)

## =====================================================
## 2. Estimate OLS regression
## =====================================================

fit <- lm(y ~ x, data = dat)

# Add fitted values and residuals
dat$fit   <- fitted(fit)
dat$resid <- residuals(fit)

## =====================================================
## 3. Plots using ggplot2
## =====================================================

library(ggplot2)
library(patchwork)   # for arranging multiple ggplots

# (a) Data and fitted line
p1 <- ggplot(dat, aes(x = x, y = y)) +
  geom_point(size = 1.2) +
  geom_smooth(method = "lm", se = FALSE,
              linewidth = 0.6, colour = "red") +
  labs(title = "Data", x = "x", y = "y")

# (b) Histogram of residuals
p2 <- ggplot(dat, aes(x = resid)) +
  geom_histogram(colour = "black", fill = "grey80") +
  labs(title = "Residuals",
       x = "residuals(fit)", y = "Frequency")

# (c) Residuals vs predicted values
p3 <- ggplot(dat, aes(x = fit, y = resid)) +
  geom_point(size = 1.2) +
  labs(title = "Residual spread",
       x = "predict(fit)", y = "residuals(fit)")

# Arrange the three plots in one row
heter_sim_plot <- (p1 + p2 + p3 + plot_layout(nrow = 1)) &
  theme(plot.title = element_text(size = 10))

## =====================================================
## 4. Save figure (6 x 4 inches, 300 dpi)
## =====================================================

ggsave("heter_sim.png", heter_sim_plot, width = 6, height = 4, dpi = 300)
