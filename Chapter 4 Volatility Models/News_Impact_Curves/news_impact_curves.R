# News impact curves for symmetric ARCH/GARCH and asymmetric EGARCH.
# Run this script from its folder. Requires ggplot2; no external data are used.
library(ggplot2)

# Hold the lagged conditional variance at one, so the innovation is also
# the standardized innovation. Use the EGARCH notation in the chapter:
# log(h_t) = omega + beta * log(h_previous) + gamma * z + alpha * abs(z).
epsilon <- seq(-3, 3, length.out = 601)
h_previous <- 1
omega <- -0.2
alpha <- 0.6
gamma <- -0.3
beta <- 0.9
z <- epsilon / sqrt(h_previous)

h_egarch <- exp(omega + beta * log(h_previous) + gamma * z + alpha * abs(z))
# With the lagged variance fixed, the symmetric curve is a constant plus
# alpha_arch * epsilon^2. Match its zero-shock level to the EGARCH curve.
alpha_arch <- 0.25
baseline <- exp(omega + beta * log(h_previous))
h_arch <- baseline + alpha_arch * epsilon^2

values <- data.frame(epsilon, ARCH_GARCH = h_arch, EGARCH = h_egarch)
curves <- rbind(
  data.frame(epsilon, variance = h_arch, model = "ARCH/GARCH"),
  data.frame(epsilon, variance = h_egarch, model = "EGARCH")
)
models <- c("ARCH/GARCH", "EGARCH")
curves$model <- factor(curves$model, levels = models)
colours <- c("ARCH/GARCH" = "#111111", "EGARCH" = "#005AB5")
line_types <- c("ARCH/GARCH" = "solid", "EGARCH" = "dashed")

p <- ggplot(curves, aes(epsilon, variance, colour = model, linetype = model)) +
  geom_hline(yintercept = 0, colour = "grey65", linewidth = 0.35) +
  geom_vline(xintercept = 0, colour = "grey65", linewidth = 0.35) +
  geom_line(linewidth = 0.9) +
  scale_colour_manual(name = NULL, values = colours, breaks = models) +
  scale_linetype_manual(name = NULL, values = line_types, breaks = models) +
  scale_x_continuous(breaks = seq(-3, 3), expand = expansion(mult = 0.02)) +
  scale_y_continuous(breaks = seq(0, 12.5, 2.5),
                     expand = expansion(mult = c(0.015, 0.04))) +
  labs(x = expression(epsilon[t - 1]), y = expression(sigma[t]^2)) +
  guides(colour = guide_legend(nrow = 1), linetype = guide_legend(nrow = 1)) +
  theme_classic(base_size = 13) +
  theme(
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_text(colour = "grey25"),
    axis.title = element_text(size = 15),
    legend.position = "bottom",
    legend.key.width = grid::unit(1.8, "cm"),
    legend.key.height = grid::unit(0.45, "cm"),
    legend.text = element_text(size = 12),
    legend.margin = margin(t = 4),
    plot.margin = margin(8, 12, 4, 8)
  )

ggsave("news_impact_curve.png", p, width = 6.6, height = 4.4, dpi = 400, bg = "white")
ggsave("news_impact_curve.pdf", p, width = 6.6, height = 4.4,
       device = grDevices::pdf, useDingbats = FALSE, bg = "white")
write.csv(values, "news_impact_curve_values.csv", row.names = FALSE)
