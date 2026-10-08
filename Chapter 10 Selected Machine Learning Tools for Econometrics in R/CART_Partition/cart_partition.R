# Figure 10.1: a four-region regression-tree partition.
# If needed: install.packages("ggplot2")
library(ggplot2)
boundaries <- data.frame(x = c(0, 3), y = c(2, 0),
  xend = c(5, 3), yend = c(2, 5),
  split = factor(c("x[2] == 2", "x[1] == 3"),
                 levels = c("x[2] == 2", "x[1] == 3")))
regions <- data.frame(x = c(1, 1, 4, 4), y = c(0.8, 3.2, 0.8, 3.2),
                     label = paste0("hat(y) == beta[", 1:4, "]"))
p <- ggplot() +
  geom_segment(data = boundaries, aes(x, y, xend = xend, yend = yend,
                                     colour = split), linewidth = 0.6) +
  geom_text(data = regions, aes(x, y, label = label), parse = TRUE,
            colour = "blue", size = 5) +
  scale_colour_manual(values = c("#377EB8", "#FF9800"),
                      labels = c(expression(x[2] == 2), expression(x[1] == 3))) +
  scale_x_continuous(breaks = 0:5, limits = c(0, 5), expand = c(0, 0)) +
  scale_y_continuous(breaks = 0:5, limits = c(0, 5), expand = c(0, 0)) +
  labs(x = expression(x[1]), y = expression(x[2]), colour = NULL) +
  theme_minimal(base_size = 13) +
  theme(panel.grid.minor = element_blank(), legend.position = "bottom",
        legend.key.width = grid::unit(1.3, "cm"))
dir.create("figures", showWarnings = FALSE)
ggsave("figures/cart_partition.png", p, width = 6, height = 4.8, dpi = 300)
ggsave("figures/cart_partition.pdf", p, width = 6, height = 4.8)
