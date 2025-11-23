## =====================================================
## 1. Prepare environment & (optionally) set working directory
## =====================================================
library(ggplot2)
library(ggpubr)

if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

## =====================================================
## 2. Simulate a simple sinusoidal time series
## =====================================================
t <- seq(0, 100, by = 0.1)

x <- cos(2 * pi * t / 10) +      # 10-period cosine component
  0.75 * sin(2 * pi * t / 5)  # 5-period sine component

ts_df <- data.frame(
  Time = t,
  Value = x
)

## =====================================================
## 3. Compute the spectrum (periodogram) without plotting
## =====================================================
sp <- spectrum(x, plot = FALSE)   # use base 'spectrum' but suppress plot

spec_df <- data.frame(
  Frequency = sp$freq,
  Spectrum  = sp$spec
)

## =====================================================
## 4. Build ggplot2 time-series and spectrum plots
## =====================================================
p_ts <- ggplot(ts_df, aes(x = Time, y = Value)) +
  geom_line() +
  labs(\input{Machine-Learning}
       title = "Simulated Time Series",
       x     = "Time",
       y     = "x(t)"
  )  

p_spec <- ggplot(spec_df, aes(x = Frequency, y = Spectrum)) +
  geom_line() +
  labs(
    title = "Estimated Spectrum",
    x     = "Frequency",
    y     = "Spectral Density"
  )  

## =====================================================
## 5. Arrange the two panels and save as a single PNG
## =====================================================
p_both <- ggpubr::ggarrange(
  p_ts, p_spec,
  ncol = 1, nrow = 2
)

ggsave(filename = "spectral.png", plot = p_both, width = 6, height = 4, dpi = 300)