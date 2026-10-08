# Figure 1.1: analytic standard normal and Student t densities.
# If needed: install.packages("ggplot2")
library(ggplot2)
x <- seq(-5, 5, length.out = 1001)
labels <- c("Standard normal", "t, df = 1", "t, df = 5", "t, df = 30")
densities <- data.frame(x = rep(x, 4),
  density = c(dnorm(x), dt(x, 1), dt(x, 5), dt(x, 30)),
  distribution = factor(rep(labels, each = length(x)), levels = labels))
p <- ggplot(densities, aes(x, density, colour = distribution,
                         linetype = distribution)) +
  geom_line(linewidth = 0.65) +
  scale_colour_manual(values = c("black", "#0072B2", "#D55E00", "#009E73")) +
  scale_linetype_manual(values = c("solid", "dashed", "dotdash", "dotted")) +
  labs(x = "x", y = "Density", colour = NULL, linetype = NULL) +
  theme_minimal(base_size = 13) +
  guides(colour = guide_legend(nrow = 2, byrow = TRUE),
         linetype = guide_legend(nrow = 2, byrow = TRUE)) +
  theme(panel.grid.minor = element_blank(), legend.position = "bottom",
        legend.key.width = grid::unit(1.3, "cm"))
dir.create("figures", showWarnings = FALSE)
ggsave("figures/probability_densities.png", p, width = 7, height = 4.8, dpi = 300)
ggsave("figures/probability_densities.pdf", p, width = 7, height = 4.8)
write.csv(densities, "density_values.csv", row.names = FALSE)
