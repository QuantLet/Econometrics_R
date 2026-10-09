# Different decisions from two affine-equivariant self-normalizers.
# Chapter 6, Econometrics and Time Series Methods.
# Run from this directory. All data are simulated; no download is required.
# install.packages("aersn")
library(aersn)
stopifnot(packageVersion("aersn") >= "0.2.3")

# Reproduce the preceding example without rerunning its plots and references.
set.seed(61009)
n <- 300L
burn <- 500L
A <- matrix(c(0.45, 0.25, -0.15, 0.30), 2, byrow = TRUE)
C <- matrix(c(1, 0, 0.6, 0.8), 2, byrow = TRUE)
mu <- c(0.12, -0.06)
x <- matrix(0, n + burn, 2)
e <- matrix(rnorm(2 * (n + burn)), n + burn, 2) %*% t(C)
for (i in 2:nrow(x)) x[i, ] <- A %*% x[i - 1L, ] + e[i, ]
Y <- sweep(x[(burn + 1L):(burn + n), ], 2, mu, "+")

# BEGIN BOOK DIFFERENT DECISIONS
## =====================================================
## 1. Shift the first mean and calibrate both tests
## =====================================================
# Raise the first population mean from 0.12 to 0.22.
Y2 <- sweep(Y, 2, c(0.10, 0), "+")
fit2 <- aersn_mean(Y2, names = c("mu1", "mu2"))
ref_h2 <- aersn_reference(fit2, draws = 100000, seed = 61012,
  statistic = "hull_gauge")
ref_s2 <- aersn_reference(fit2, draws = 100000, seed = 61012,
  statistic = "shao_sq2",
  args = list(integration = "calendar"))
## =====================================================
## 2. Compare the two decisions at the same null
## =====================================================

h2 <- aersn_test(fit2, null = c(0, 0), reference = ref_h2)
s2 <- aersn_test(fit2, null = c(0, 0), method = "shao",
  reference = ref_s2)
comparison2 <- data.frame(
  method = c("Adjusted range", "Shao quadratic"),
  statistic = c(h2$statistic, s2$statistic),
  critical_95 = c(h2$critical.value, s2$critical.value),
  p_value = c(h2$p.value, s2$p.value),
  reject_5pct = c(h2$reject, s2$reject))
print(comparison2, row.names = FALSE, digits = 5)
# END BOOK DIFFERENT DECISIONS

# BEGIN BOOK DECISION AFFINE CHECK
H <- rbind(c(1, 1), c(1, -1))
b <- c(0.4, -0.2)
Y2_new <- sweep(Y2 %*% t(H), 2, b, "+")
fit2_new <- aersn_mean(Y2_new)
h2_new <- aersn_test(fit2_new, null = b, reference = ref_h2)
s2_new <- aersn_test(fit2_new, null = b, method = "shao",
                     reference = ref_s2)
stopifnot(abs(h2$statistic - h2_new$statistic) < 1e-8,
          abs(s2$statistic - s2_new$statistic) < 1e-8,
          h2$reject == h2_new$reject,
          s2$reject == s2_new$reject)
# END BOOK DECISION AFFINE CHECK

# A constant shift changes the estimate but not the centred influence path.
centred <- function(y) sweep(y, 2, colMeans(y))
stopifnot(max(abs(centred(Y2) - centred(Y))) < 1e-12)
G <- rbind(c(0, 0), apply(centred(Y2), 2, cumsum)) / sqrt(n)
z <- sqrt(n) * colMeans(Y2)
V <- crossprod(G) / n
shao_direct <- drop(crossprod(z, solve(V, z)))
P <- G[chull(G), , drop = FALSE]
D <- do.call(rbind, lapply(seq_len(nrow(P)), function(j) sweep(P, 2, P[j, ])))
K <- D[chull(D), , drop = FALSE]
edges <- K[c(2:nrow(K), 1), , drop = FALSE] - K
normal <- cbind(-edges[, 2], edges[, 1])
ranges <- apply(G %*% t(normal), 2, function(v) diff(range(v)))
hull_direct <- max(abs(drop(normal %*% z)) / ranges)
stopifnot(abs(shao_direct - s2$statistic) < 1e-8,
          abs(hull_direct - h2$statistic) < 1e-8,
          h2$reject, !s2$reject)

baseline <- aersn_mean(Y)
base_h <- aersn_test(baseline, null = c(0, 0), reference = ref_h2)
base_s <- aersn_test(baseline, null = c(0, 0), method = "shao", reference = ref_s2)
stopifnot(!base_h$reject, !base_s$reject)
# BEGIN BOOK DECISION PLOT
## =====================================================
## 1. Construct the two confidence-region boundaries
## =====================================================
G <- rbind(c(0, 0),
  apply(sweep(Y2, 2, colMeans(Y2)), 2, cumsum)) / sqrt(n)
V <- crossprod(G) / n
region2_h <- aersn_region(fit2, reference = ref_h2)
polygon2 <- aersn_vertices(region2_h)
phi <- seq(0, 2 * pi, length.out = 501)
circle <- cbind(cos(phi), sin(phi))
eg <- eigen(V, symmetric = TRUE)
root <- eg$vectors %*% diag(sqrt(eg$values)) %*% t(eg$vectors)
ellipse2 <- sweep(sqrt(as.numeric(s2$critical.value) / n) * circle %*% root,
  2, colMeans(Y2), "+")

## =====================================================
## 2. Plot the regions before and after the mean shift
## =====================================================
draw_decisions <- function() {
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  par(mfrow = c(1, 2), mar = c(3.6, 3.5, 2.4, 0.7),
    oma = c(2.9, 0, 0, 0), mgp = c(2, 0.65, 0), tcl = -0.25)
  both <- rbind(polygon2, ellipse2,
    sweep(polygon2, 2, c(0.10, 0)),
    sweep(ellipse2, 2, c(0.10, 0)), c(0, 0))
  xlimits <- range(both[, 1])
  ylimits <- range(both[, 2])
  panel <- function(shift, title) {
    h <- sweep(polygon2, 2, shift)
    s <- sweep(ellipse2, 2, shift)
    center <- colMeans(Y2) - shift
    all <- rbind(h, s, center, c(0, 0))
    plot(all, type = "n", asp = 1, xlim = xlimits, ylim = ylimits,
      xlab = expression(mu[1]),
      ylab = expression(mu[2]), main = title, cex.main = 0.9, bty = "l")
    abline(h = 0, v = 0, col = "grey85", lwd = 0.7)
    polygon(h, col = adjustcolor("#147D64", 0.14), border = "#147D64",
      lwd = 1.8)
    lines(s, col = "#405D89", lty = 2, lwd = 1.8)
    points(center[1], center[2], pch = 19, cex = 0.75)
    points(0, 0, pch = 5, cex = 1.2, lwd = 1.5, col = "#9D4438")
  }
  panel(c(0.10, 0), "(a) First mean = 0.12")
  panel(c(0, 0), "(b) First mean = 0.22")
  par(fig = c(0, 1, 0, 1), mar = rep(0, 4), oma = rep(0, 4), new = TRUE)
  plot.new()
  legend("bottom", inset = 0.012, bty = "n", ncol = 2, cex = 0.87,
    legend = c("Adjusted-range region", "Shao's ellipse", "Estimate",
      "Null (0, 0)"),
    col = c("#147D64", "#405D89", "black", "#9D4438"),
    lty = c(1, 2, NA, NA), pch = c(NA, NA, 19, 5),
    lwd = c(1.8, 1.8, NA, NA))
}

## =====================================================
## 3. Save the comparison figure
## =====================================================
pdf("aersn_different_decisions.pdf", width = 7.2, height = 4.1,
  pointsize = 12, useDingbats = FALSE)
draw_decisions()
dev.off()
png("aersn_different_decisions.png", width = 2160, height = 1230,
  res = 300, pointsize = 12)
draw_decisions()
dev.off()
# END BOOK DECISION PLOT

write.csv(comparison2, "different_decisions.csv", row.names = FALSE)
write.csv(Y2, "shifted_vector_series.csv", row.names = FALSE)
write.csv(data.frame(method = comparison2$method,
  statistic_before = comparison2$statistic,
  statistic_after = c(h2_new$statistic, s2_new$statistic),
  p_mcse = c(h2$p.mcse, s2$p.mcse)), "decision_affine_check.csv", row.names = FALSE)
saveRDS(list(hull = ref_h2, shao = ref_s2), "decision_reference_draws.rds")
writeLines(c("Both direct formula checks passed.",
  "Centred influence paths agree before and after the fixed mean shift.",
  "Both affine-transformation checks passed.",
  sprintf("Direct hull discrepancy: %.3g", abs(hull_direct-h2$statistic)),
  sprintf("Direct quadratic discrepancy: %.3g", abs(shao_direct-s2$statistic))),
  "decision_validation.txt")
writeLines(capture.output(sessionInfo()), "decision_sessionInfo.txt")
