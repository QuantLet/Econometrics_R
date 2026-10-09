# Joint inference for two time-series means.
# Econometrics and Time Series Methods, Chapter 6. Tested with aersn 0.2.3.
# Run from this script's directory.
# install.packages("aersn", repos = "https://cloud.r-project.org")
library(aersn)
stopifnot(packageVersion("aersn") >= "0.2.3")

# BEGIN BOOK EXAMPLE
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
fit <- aersn_mean(Y, names = c("mu1", "mu2"))

# Reuse a separate reference for each method, on the sample grid.
ref_h <- aersn_reference(fit, draws = 10000, seed = 61010,
                         statistic = "hull_gauge")
ref_s <- aersn_reference(fit, draws = 10000, seed = 61010,
                         statistic = "shao_sq2",
                         args = list(integration = "calendar"))
test_h <- aersn_test(fit, null = c(0, 0), reference = ref_h)
test_s <- aersn_test(fit, null = c(0, 0), method = "shao",
                     reference = ref_s)
print(test_h)
print(test_s)
region_h <- aersn_region(fit, reference = ref_h)
region_s <- aersn_region(fit, method = "shao", reference = ref_s)
L <- rbind(mu1 = c(1, 0), mu2 = c(0, 1),
           difference = c(1, -1), average = c(0.5, 0.5))
intervals <- aersn_contrast(fit, L, type = "simultaneous",
                           reference = ref_h)
print(intervals)
# END BOOK EXAMPLE

# BEGIN BOOK AFFINE CHECK
# Transform individual means to their sum and difference, with a shift.
H <- rbind(c(1, 1), c(1, -1))
b <- c(0.4, -0.2)
Y_new <- sweep(Y %*% t(H), 2, b, "+")
fit_new <- aersn_mean(Y_new)
null_new <- b  # H %*% c(0, 0) + b
check_h <- aersn_test(fit_new, null = null_new, reference = ref_h)
check_s <- aersn_test(fit_new, null = null_new, method = "shao",
                      reference = ref_s)
stopifnot(isTRUE(all.equal(as.numeric(test_h$statistic),
                          as.numeric(check_h$statistic),
                          tolerance = 1e-8)),
          isTRUE(all.equal(as.numeric(test_s$statistic),
                          as.numeric(check_s$statistic),
                          tolerance = 1e-8)))
# END BOOK AFFINE CHECK

# Independent calculations verify the definitions in the text.
G <- rbind(c(0, 0), apply(sweep(Y, 2, colMeans(Y)), 2, cumsum)) / sqrt(n)
z <- sqrt(n) * colMeans(Y)
V <- crossprod(G) / n
quadratic_direct <- drop(crossprod(z, solve(V, z)))
stopifnot(isTRUE(all.equal(quadratic_direct,
                          as.numeric(test_s$statistic), tolerance = 1e-8)))
# Direct two-dimensional convex hull and its supporting edges.
P <- G[chull(G), , drop = FALSE]
D <- do.call(rbind, lapply(seq_len(nrow(P)), function(j) sweep(P, 2, P[j, ])))
K <- D[chull(D), , drop = FALSE]
edge <- K[c(2:nrow(K), 1), , drop = FALSE] - K
normal <- cbind(-edge[, 2], edge[, 1])
ranges <- apply(G %*% t(normal), 2, function(v) diff(range(v)))
gauge_direct <- max(abs(drop(normal %*% z)) / ranges)
stopifnot(abs(gauge_direct - as.numeric(test_h$statistic)) < 1e-8)
crit <- as.numeric(region_h$critical.value)
half_width <- crit / sqrt(n) * apply(G %*% t(L), 2, function(v) diff(range(v)))
stopifnot(max(abs(intervals$upper - drop(L %*% colMeans(Y)) - half_width)) < 1e-8)

# BEGIN BOOK REGION PLOT
G <- rbind(c(0, 0), apply(sweep(Y, 2, colMeans(Y)), 2, cumsum)) / sqrt(n)
V <- crossprod(G) / n
vertices_h <- aersn_vertices(region_h)
transformed <- sweep(vertices_h %*% t(H), 2, b, "+")

phi <- seq(0, 2 * pi, length.out = 401)
circle <- cbind(cos(phi), sin(phi))
eig <- eigen(V, symmetric = TRUE)
root <- eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)
vertices_s <- sweep(sqrt(as.numeric(region_s$critical.value) / n) *
                      circle %*% root, 2, colMeans(Y), "+")
vertices_s_new <- sweep(vertices_s %*% t(H), 2, b, "+")

draw_regions <- function() {
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  par(mfrow = c(1, 2), mar = c(3.4, 3.4, 2.5, 0.7),
      oma = c(3.3, 0, 0, 0), mgp = c(2, 0.65, 0), tcl = -0.25)
  panel <- function(h, s, center, truth, null, title, xlab, ylab) {
    all <- rbind(h, s, center, truth, null)
    plot(all, type = "n", asp = 1, xlab = xlab, ylab = ylab,
         main = title, cex.main = 0.95, bty = "l")
    polygon(h, col = adjustcolor("#147D64", 0.15), border = "#147D64", lwd = 1.8)
    lines(s, col = "#405D89", lty = 2, lwd = 1.8)
    points(center[1], center[2], pch = 19, cex = 0.7)
    points(truth[1], truth[2], pch = 3, cex = 0.9)
    points(null[1], null[2], pch = 5, cex = 0.9, col = "#9D4438")
  }
  panel(vertices_h, vertices_s, colMeans(Y), mu, c(0, 0),
        "(a) Original parameters", expression(mu[1]), expression(mu[2]))
  panel(transformed, vertices_s_new, drop(H %*% colMeans(Y)) + b,
        drop(H %*% mu) + b, b, "(b) Affine transformation",
        expression(mu[1] + mu[2] + 0.4), expression(mu[1] - mu[2] - 0.2))
  par(fig = c(0, 1, 0, 1), mar = rep(0, 4), oma = rep(0, 4), new = TRUE)
  plot.new()
  legend("bottom", inset = 0.012, bty = "n", ncol = 3, cex = 0.83,
         legend = c("Increment hull", "Shao's ellipse", "Estimate", "True mean", "Null"),
         col = c("#147D64", "#405D89", "black", "black", "#9D4438"),
         lty = c(1, 2, NA, NA, NA), pch = c(NA, NA, 19, 3, 5),
         lwd = c(1.8, 1.8, NA, NA, NA))
}
pdf("aersn_joint_regions.pdf", width = 7.2, height = 4.1, pointsize = 12,
    useDingbats = FALSE)
draw_regions(); dev.off()
png("aersn_joint_regions.png", width = 2160, height = 1230, res = 300,
    pointsize = 12)
draw_regions(); dev.off()
# END BOOK REGION PLOT

new_vertices <- aersn_vertices(aersn_region(fit_new, reference = ref_h))
hausdorff_vertices <- max(vapply(seq_len(nrow(transformed)), function(j)
  min(sqrt(rowSums(sweep(new_vertices, 2, transformed[j, ])^2))), numeric(1)))
stopifnot(hausdorff_vertices < 1e-8)
# Scalar reduction to the absolute adjusted-range statistic.
one <- aersn_mean(Y[, 1])
test_one <- aersn_test(one, null = 0, reference = "continuous")
scalar_direct <- abs(sqrt(n) * mean(Y[, 1])) / diff(range(G[, 1]))
stopifnot(abs(as.numeric(test_one$statistic) - scalar_direct) < 1e-8)

comparison <- data.frame(method = c("Increment hull", "Shao quadratic"),
  statistic = c(test_h$statistic, test_s$statistic),
  critical_value = c(region_h$critical.value, region_s$critical.value),
  p_value = c(test_h$p.value, test_s$p.value))
write.csv(comparison, "method_comparison.csv", row.names = FALSE)
write.csv(intervals, "simultaneous_intervals.csv")
write.csv(Y, "simulated_vector_series.csv", row.names = FALSE)
saveRDS(list(hull = ref_h, shao = ref_s), "reference_draws.rds")
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
writeLines(c("All mathematical checks passed.",
  sprintf("Direct quadratic discrepancy: %.3g", abs(quadratic_direct - test_s$statistic)),
  sprintf("Direct hull gauge discrepancy: %.3g", abs(gauge_direct - test_h$statistic)),
  sprintf("Affine polygon vertex discrepancy: %.3g", hausdorff_vertices)), "validation.txt")
print(comparison, row.names = FALSE)
