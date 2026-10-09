## =====================================================
## 1. (Optional) Set working directory to script location
## =====================================================
if (requireNamespace("rstudioapi",
  quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Load required package
## =====================================================
# install.packages("ggplot2")
library(ggplot2)

## =====================================================
## 3. Simulate the AR(1) recursion from a zero initial value
## =====================================================
set.seed(123)           # For reproducibility

n   <- 1000             # Number of observations
phi <- 0.9              # AR(1) coefficient

epsilon <- rnorm(n)     # White noise innovations
Y       <- numeric(n)   # Preallocate the series

# Initialize and generate the AR(1) recursion
Y[1] <- epsilon[1]
for (t in 2:n) {
  Y[t] <- phi * Y[t - 1] + epsilon[t]
}

## =====================================================
## 4. Construct the ten-lag Wold truncation directly
## =====================================================
J <- 10
wold_approx <- numeric(n)
for (t in 1:n) {
  lags <- 0:min(J, t - 1)
  wold_approx[t] <- sum(phi^lags * epsilon[t - lags])
}

## =====================================================
## 5. Prepare data for plotting
## =====================================================
df_wold <- data.frame(
  Time    = 1:n,
  Original = as.numeric(Y),
  Truncated = wold_approx
)

## =====================================================
## 6. Plot: Original AR(1) vs ten-lag Wold truncation
## =====================================================
p_wold <- ggplot(df_wold, aes(x = Time)) +
  geom_line(aes(y = Original, colour = "Original series",
    linetype = "Original series")) +
  geom_line(aes(y = Truncated,
    colour = "Ten-lag Wold truncation",
    linetype = "Ten-lag Wold truncation")) +
  scale_linetype_manual(values = c("Original series" = "solid",
    "Ten-lag Wold truncation" = "dashed")) +
  labs(
    title = "AR(1) Series and Its Ten-Lag Wold Truncation",
    x     = "Time",
    y     = "Value",
    colour = NULL,
    linetype = NULL
  ) +
  theme_gray(base_size = 12) +
  theme(axis.text = element_text(size = 10),
    legend.text = element_text(size = 10)) +
  guides(
    colour = guide_legend(nrow = 1),
    linetype = guide_legend(nrow = 1)
  ) +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.key.width = grid::unit(1.1, "cm"),
    legend.text = element_text(size = 10),
    plot.title = element_text(size = 12)
  )

# Save the figure
ggsave(filename = "Wold_decomposition.png", plot = p_wold,
  width = 7,
  height = 3.8, dpi = 300)
