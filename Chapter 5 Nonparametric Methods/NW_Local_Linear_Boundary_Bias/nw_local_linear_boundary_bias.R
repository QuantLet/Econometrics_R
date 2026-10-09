## =====================================================
## 1. Packages and simulation design
## =====================================================

# Run from this script's directory. No external data or API key is needed.
library(ggplot2)
library(patchwork)

set.seed(20261009)
n <- 400L
repetitions <- 5000L
h <- 0.25
sigma <- 0.20
x0 <- 0
x <- sort(runif(n, 0, 1))
regression <- function(x) 1 + 4 * x - 4 * x^2
truth <- regression(x0)
mu <- regression(x)
kernel <- function(u) 0.75 * pmax(1 - u^2, 0)
k <- kernel((x - x0) / h)

## =====================================================
## 2. Local constant and local linear weights at x0 = 0
## =====================================================

# The common factor 1/h cancels from both weighted regressions.
z <- x - x0
s0 <- sum(k)
s1 <- sum(k * z)
s2 <- sum(k * z^2)
determinant <- s0 * s2 - s1^2
stopifnot(s0 > 0, determinant > 0)
w_nw <- k / s0
w_ll <- k * (s2 - s1 * z) / determinant
w_slope <- k * (s0 * z - s1) / determinant

# Local linear weights reproduce constants and linear functions exactly.
stopifnot(abs(sum(w_nw) - 1) < 1e-12,
          abs(sum(w_ll) - 1) < 1e-12,
          abs(sum(w_ll * z)) < 1e-12)

## =====================================================
## 3. Repeat responses while holding the simulated design fixed
## =====================================================

errors <- matrix(rnorm(n * repetitions, sd = sigma), nrow = n)
responses <- errors + mu
estimates <- rbind(NW = as.numeric(w_nw %*% responses),
                  LL = as.numeric(w_ll %*% responses))
y <- responses[, 1L]  # The first replication, without selecting a sample.
sample_nw <- unname(estimates["NW", 1L])
sample_ll <- unname(estimates["LL", 1L])
sample_slope <- sum(w_slope * y)

# With E[errors | x] = 0, these are exact conditional means and biases.
# A single estimation error is not a bias estimate.
expected <- c(NW = sum(w_nw * mu), LL = sum(w_ll * mu))
bias <- expected - truth
sampling_sd <- sigma * sqrt(c(NW = sum(w_nw^2), LL = sum(w_ll^2)))
summary_table <- data.frame(
  estimator = c("Nadaraya-Watson", "Local linear"),
  conditional_mean = as.numeric(expected),
  conditional_bias = as.numeric(bias),
  conditional_sd = as.numeric(sampling_sd),
  monte_carlo_mean = rowMeans(estimates),
  monte_carlo_sd = apply(estimates, 1L, sd),
  monte_carlo_se_of_mean = as.numeric(sampling_sd / sqrt(repetitions)),
  first_replication = estimates[, 1L]
)

# An independent weighted least-squares calculation checks the intercept.
fit <- lm.wfit(cbind(1, z), y, w = k)
stopifnot(abs(fit$coefficients[1L] - sample_ll) < 1e-12,
          abs(fit$coefficients[2L] - sample_slope) < 1e-12,
          all(abs(rowMeans(estimates) - expected) <
                5 * sampling_sd / sqrt(repetitions)))

write.csv(data.frame(x, y, mean = mu, kernel_weight = k),
          "simulated_sample.csv", row.names = FALSE)
write.csv(data.frame(replication = seq_len(repetitions),
                     NW = estimates["NW", ], LL = estimates["LL", ]),
          "boundary_estimates.csv", row.names = FALSE)
write.csv(summary_table, "bias_summary.csv", row.names = FALSE)
write.csv(data.frame(n, repetitions, h, sigma, seed = 20261009,
                     observations_in_window = sum(k > 0)),
          "simulation_design.csv", row.names = FALSE)
print(summary_table, digits = 7, row.names = FALSE)

## =====================================================
## 4. One sample: local fits at the boundary
## =====================================================

colours <- c("True regression" = "#222222",
             "Nadaraya-Watson" = "#D55E00", "Local linear" = "#0072B2")
line_types <- c("True regression" = "solid",
                "Nadaraya-Watson" = "solid", "Local linear" = "22")
plot_theme <- theme_gray(base_size = 11) +
  theme(plot.title = element_text(size = 11, face = "bold"),
        plot.subtitle = element_text(size = 9, colour = "grey30"),
        axis.text = element_text(size = 9),
        panel.grid.minor = element_blank(),
        legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(size = 10),
        legend.key.width = grid::unit(1.35, "cm"),
        plot.margin = margin(6, 8, 5, 6))

curve_grid <- seq(0, 1, length.out = 501)
local_grid <- seq(0, h, length.out = 101)
curves <- rbind(
  data.frame(x = curve_grid, value = regression(curve_grid),
             estimator = "True regression"),
  data.frame(x = local_grid, value = sample_nw,
             estimator = "Nadaraya-Watson"),
  data.frame(x = local_grid, value = sample_ll + sample_slope * local_grid,
             estimator = "Local linear")
)
sample_data <- data.frame(x, y, inside = k > 0)
intercepts <- data.frame(x = 0, value = c(truth, sample_nw, sample_ll),
                        estimator = names(colours))

p_left <- ggplot() +
  annotate("rect", xmin = 0, xmax = h, ymin = -Inf, ymax = Inf,
           fill = "grey75", alpha = 0.36) +
  geom_point(data = subset(sample_data, !inside), aes(x, y),
             colour = "grey50", size = 0.85, alpha = 0.40) +
  geom_point(data = subset(sample_data, inside), aes(x, y),
             colour = "grey30", size = 1.0, alpha = 0.65) +
  geom_vline(xintercept = c(0, h), colour = "grey45", linetype = "dotted",
             linewidth = 0.35) +
  geom_line(data = curves, aes(x, value, colour = estimator,
                             linetype = estimator), linewidth = 0.85) +
  geom_point(data = intercepts, aes(x, value, colour = estimator),
             size = 2.2, show.legend = FALSE) +
  annotate("text", x = h / 2, y = 2.60, label = "Local window [0, h]",
           size = 2.7, colour = "grey30") +
  scale_colour_manual(values = colours, breaks = names(colours)) +
  scale_linetype_manual(values = line_types, breaks = names(colours)) +
  scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1),
                     expand = expansion(mult = c(0.035, 0.025))) +
  coord_cartesian(ylim = c(0.55, 2.65)) +
  labs(title = "(a) Local fits at x = 0",
       subtitle = "First simulated sample",
       x = "x", y = "Response") + plot_theme

## =====================================================
## 5. Repeated samples: bias rather than one estimation error
## =====================================================

densities <- lapply(seq_len(2L), function(j) {
  # The density is only a visual summary of the simulated estimates.
  d <- density(estimates[j, ], n = 1024)
  data.frame(estimate = d$x, density = d$y,
             estimator = c("Nadaraya-Watson", "Local linear")[j])
})
density_data <- do.call(rbind, densities)
peak <- max(density_data$density)
arrow_y <- c(NW = 1.21, LL = 1.04) * peak
means <- data.frame(value = as.numeric(expected),
                   estimator = c("Nadaraya-Watson", "Local linear"))

p_right <- ggplot(density_data, aes(estimate, density,
                                   colour = estimator, linetype = estimator)) +
  geom_line(linewidth = 0.85) +
  geom_vline(xintercept = truth, colour = colours[["True regression"]],
             linewidth = 0.65) +
  geom_segment(data = means,
               aes(x = value, xend = value, y = 0, yend = 0.98 * peak,
                   colour = estimator),
               inherit.aes = FALSE, linetype = "dotted", linewidth = 0.40) +
  annotate("segment", x = truth, xend = expected["NW"],
           y = arrow_y["NW"], yend = arrow_y["NW"],
           colour = colours[["Nadaraya-Watson"]], linewidth = 0.5,
           arrow = grid::arrow(length = grid::unit(1.7, "mm"), ends = "both")) +
  annotate("text", x = mean(c(truth, expected["NW"])),
           y = arrow_y["NW"] + 0.065 * peak,
           label = sprintf("NW bias: %+.3f", bias["NW"]),
           colour = colours[["Nadaraya-Watson"]], size = 3.0) +
  annotate("segment", x = truth, xend = expected["LL"],
           y = arrow_y["LL"], yend = arrow_y["LL"],
           colour = colours[["Local linear"]], linewidth = 0.5,
           arrow = grid::arrow(length = grid::unit(1.2, "mm"), ends = "both")) +
  annotate("text", x = truth - 0.012, y = arrow_y["LL"],
           hjust = 1, label = sprintf("LL bias:\n%+.3f", bias["LL"]),
           colour = colours[["Local linear"]], size = 2.8) +
  annotate("text", x = 0.845, y = 0.10 * peak,
           hjust = 0, label = "r(0) = 1", colour = "grey20", size = 3.0) +
  scale_colour_manual(values = colours, breaks = names(colours)) +
  scale_linetype_manual(values = line_types, breaks = names(colours)) +
  scale_x_continuous(breaks = seq(0.8, 1.6, by = 0.1),
                     expand = expansion(mult = c(0.025, 0.025))) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.025))) +
  coord_cartesian(xlim = c(0.83, max(density_data$estimate)),
                  ylim = c(0, 1.36 * peak), clip = "on") +
  labs(title = "(b) Sampling distributions at x = 0",
       subtitle = "5,000 repetitions; fixed x values",
       x = expression(hat(r)(0)), y = "Density") +
  plot_theme + guides(colour = "none", linetype = "none")

figure <- (p_left | p_right) +
  plot_layout(widths = c(1.1, 1), guides = "collect") &
  theme(legend.position = "bottom")
ggsave("nw_local_linear_boundary_bias.png", figure,
       width = 7.8, height = 3.9, units = "in", dpi = 360, bg = "white")
ggsave("nw_local_linear_boundary_bias.pdf", figure,
       width = 7.8, height = 3.9, units = "in", device = "pdf",
       family = "Helvetica", useDingbats = FALSE, bg = "white")
capture.output(sessionInfo(), file = "session_info.txt")
