## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Load packages
library(ggplot2)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate AR(1) process with and without a shock
## =====================================================

set.seed(123)

n      <- 250               # number of observations
phi    <- 0.8               # AR(1) coefficient
shock_t <- 100              # time of the negative shock
shock_size <- -5            # size of the shock

# Innovations (same for both series)
eps_ar <- rnorm(n)

# AR(1) without shock
Y_ar_noshock <- numeric(n)
Y_ar_noshock[1] <- eps_ar[1]
for (t in 2:n) {
  Y_ar_noshock[t] <- phi * Y_ar_noshock[t - 1] + eps_ar[t]
}

# AR(1) with a negative shock at time shock_t
Y_ar_shock <- numeric(n)
Y_ar_shock[1] <- eps_ar[1]
for (t in 2:n) {
  e_t <- eps_ar[t]
  if (t == shock_t) e_t <- e_t + shock_size
  Y_ar_shock[t] <- phi * Y_ar_shock[t - 1] + e_t
}

# Data frame for plotting
df_ar <- data.frame(
  Time  = rep(1:n, times = 2),
  Value = c(Y_ar_shock, Y_ar_noshock),
  Series = factor(rep(c("With Shock", "Without Shock"),
                      each = n))
)

## =====================================================
## 3. Plot AR(1) process with and without a negative shock
## =====================================================

p_ar <- ggplot(df_ar, aes(x = Time, y = Value, colour = Series, linetype = Series)) +
  geom_line(linewidth = 0.7) +
  scale_colour_manual(values = c("With Shock" = "blue",
                                 "Without Shock" = "red")) +
  scale_linetype_manual(values = c("With Shock" = "solid",
                                   "Without Shock" = "dashed")) +
  labs(title = "AR(1) process with and without a negative shock",
       x = "Time",
       y = "Series value") + 
  theme(legend.title = element_blank())

ggsave("ar1_comparison_plot.png", p_ar,
       width = 6, height = 4, dpi = 300)

## =====================================================
## 4. Simulate random walk with and without a shock
## =====================================================

# Innovations (same for both series)
eps_rw <- rnorm(n)

# Random walk without shock: X_t = X_{t-1} + eps_t
X_rw_noshock <- numeric(n)
X_rw_noshock[1] <- eps_rw[1]
for (t in 2:n) {
  X_rw_noshock[t] <- X_rw_noshock[t - 1] + eps_rw[t]
}

# Random walk with a negative shock at time shock_t
X_rw_shock <- numeric(n)
X_rw_shock[1] <- eps_rw[1]
for (t in 2:n) {
  e_t <- eps_rw[t]
  if (t == shock_t) e_t <- e_t + shock_size
  X_rw_shock[t] <- X_rw_shock[t - 1] + e_t
}

df_rw <- data.frame(
  Time  = rep(1:n, times = 2),
  Value = c(X_rw_shock, X_rw_noshock),
  Series = factor(rep(c("With Shock", "Without Shock"),
                      each = n))
)

## =====================================================
## 5. Plot random walk with and without a negative shock
## =====================================================

p_rw <- ggplot(df_rw, aes(x = Time, y = Value, colour = Series, linetype = Series)) +
  geom_line(linewidth = 0.7) +
  scale_colour_manual(values = c("With Shock" = "blue",
                                 "Without Shock" = "red")) +
  scale_linetype_manual(values = c("With Shock" = "solid",
                                   "Without Shock" = "dashed")) +
  labs(title = "Random walk with and without a negative shock",
       x = "Time",
       y = "Series value") +
  theme(legend.title = element_blank())

ggsave("rw_comparison_plot.png", p_rw,
       width = 6, height = 4, dpi = 300)