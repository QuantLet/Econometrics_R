## =====================================================
## 1. Housekeeping and setup
## =====================================================

rm(list = ls())              # Clear workspace
set.seed(123456789)          # Reproducibility

# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Load packages
## =====================================================

# install.packages("ggplot2") # run once if needed
# install.packages("xtable")  # run once if needed

library(ggplot2)
library(xtable)

## =====================================================
## 3. Simulation design
## =====================================================

numrep      <- 10000   # Number of Monte Carlo replications
sample.size <- 200000  # Number of time steps in [0, 1]

# Storage for simulated statistics
Hong.M.test     <- numeric(numrep)
Shao.S.test     <- numeric(numrep)
standard.normal <- numeric(numrep)

## =====================================================
## 4. Monte Carlo simulation
## =====================================================

for (i in 1:numrep) {
  # Discrete time grid on [0, 1]
  times <- seq(0, 1, length.out = sample.size)
  dt    <- times[2] - times[1]
  
  # Standard Brownian motion via normalized Gaussian increments
  dB <- rnorm(sample.size) / sqrt(sample.size)
  B  <- cumsum(dB)
  
  # Brownian bridge on [0, 1]
  B_bridge <- B - times * B[sample.size]
  
  # Adjusted-range self-normalizer (Hong et al.'s M)
  adjusted_range <- max(B_bridge) - min(B_bridge)
  B1 <- sum(dB)  # B(1), should be approximately N(0,1)
  Hong.M.test[i] <- B1 / adjusted_range
  
  # Self-normalized statistic based on Shao (2010)
  bridge_int <- sum(B_bridge^2) * dt
  Shao.S.test[i] <- B1 / sqrt(bridge_int)
  
  # Standard normal benchmark N(0,1)
  standard.normal[i] <- B1
  
  if (i %% 1000 == 0) print(i)
}

## =====================================================
## 5. Critical values and LaTeX table
## =====================================================

# Upper-tail levels
cv.list  <- c(5, 2.5, 1, 0.5, 0.1) / 100
cv.index <- round(numrep * (1 - cv.list))

result <- rbind(
  alpha                    = cv.list,
  "Hong et al.'s (2024) M" = sort(Hong.M.test)[cv.index],
  "Shao's (2010) S"        = sort(Shao.S.test)[cv.index],
  "N(0,1)"                 = sort(standard.normal)[cv.index]
)

result <- t(result)

# Export as LaTeX table (to cv.tex)
result.xtable <- xtable(result, digits = 4)
print(result.xtable, file = "cv.tex")

## =====================================================
## 6. Density comparison plot (M, S, N(0,1))
## =====================================================

# Kernel density estimates
dens_M <- density(Hong.M.test,     adjust = 2)
dens_S <- density(Shao.S.test,     adjust = 2)
dens_N <- density(standard.normal, adjust = 2)

dens_df <- rbind(
  data.frame(x = dens_M$x, y = dens_M$y,
             dist = "Hong et al.'s (2024) M"),
  data.frame(x = dens_S$x, y = dens_S$y,
             dist = "Shao's (2010) S"),
  data.frame(x = dens_N$x, y = dens_N$y,
             dist = "N(0,1)")
)

p_dist <- ggplot(dens_df, aes(x = x, y = y, colour = dist)) +
  geom_line(size = 1) +
  labs(x = "", y = "", colour = "") +
  theme_minimal() +
  theme(legend.position = "top")

# Save figure: 6 x 4 inches, 300 dpi
ggsave(filename = "dist-m-hat.png", plot = p_dist, width  = 6, height = 4, dpi = 300)