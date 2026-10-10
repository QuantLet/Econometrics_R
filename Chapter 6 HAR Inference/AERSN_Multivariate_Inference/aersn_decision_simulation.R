# Repeated-sample comparison for the fixed VAR design in Chapter 6.
# Continue from the printed comparison or read its saved reference draws.
# Calibration and evaluation use independent samples.

## =====================================================
## 1. Reuse the preceding Brownian reference draws
## =====================================================
library(aersn)
if (exists("ref_h2") && exists("ref_s2")) {
  ref <- list(hull = ref_h2, shao = ref_s2)
} else {
  ref <- readRDS("decision_reference_draws.rds")
}
critical <- c(
  hull = quantile(ref$hull$draws, .95, type = 8),
  shao = quantile(ref$shao$draws, .95, type = 8))
names(critical) <- c("hull", "shao")

## =====================================================
## 2. Simulate the same VAR at three population means
## =====================================================
n <- 300L
burn <- 500L
replications <- 5000L
A <- matrix(c(0.45, 0.25, -0.15, 0.30), 2, byrow = TRUE)
C <- matrix(c(1, 0, 0.6, 0.8), 2, byrow = TRUE)
means <- rbind(null = c(0, 0), baseline = c(.12, -.06),
               shifted = c(.22, -.06))
stopifnot(max(Mod(eigen(A)$values)) < 1)
generate_errors <- function() {
  x <- matrix(0, n + burn, 2)
  e <- matrix(rnorm(2 * (n + burn)), n + burn, 2) %*% t(C)
  for (i in 2:nrow(x)) x[i, ] <- A %*% x[i - 1L, ] + e[i, ]
  x[(burn + 1L):(burn + n), , drop = FALSE]
}

## =====================================================
## 3. Compute both statistics on each centred path
## =====================================================
# Hull edge normals give the exact two-dimensional gauge.
statistics <- function(x, means) {
  G <- rbind(c(0, 0),
    apply(sweep(x, 2, colMeans(x)), 2, cumsum)) / sqrt(n)
  Z <- sqrt(n) * t(sweep(means, 2, colMeans(x), "+"))
  V <- crossprod(G) / n
  P <- G[chull(G), , drop = FALSE]
  D <- do.call(rbind, lapply(seq_len(nrow(P)),
    function(j) sweep(P, 2, P[j, ])))
  K <- D[chull(D), , drop = FALSE]
  edges <- K[c(2:nrow(K), 1), , drop = FALSE] - K
  normals <- cbind(-edges[, 2], edges[, 1])
  ranges <- apply(G %*% t(normals), 2,
    function(v) diff(range(v)))
  ans <- rbind(
    hull = apply(abs(normals %*% Z) / ranges, 2, max),
    shao = colSums(Z * solve(V, Z)))
  colnames(ans) <- rownames(means)
  stopifnot(all(is.finite(ans)), all(ans >= 0))
  ans
}

## =====================================================
## 4. Calibrate with independent zero-mean samples
## =====================================================
set.seed(61013)
calibration <- t(replicate(replications,
  statistics(generate_errors(), means[1, , drop = FALSE])[, 1]))
calibrated_critical <- apply(calibration, 2, quantile,
  probs = .95, type = 8)

## =====================================================
## 5. Evaluate both tests on fresh samples
## =====================================================
set.seed(61014)
evaluation <- array(NA_real_, c(replications, 2, 3),
  dimnames = list(NULL, c("hull", "shao"), rownames(means)))
checks <- numeric(0)
for (i in seq_len(replications)) {
  x <- generate_errors()
  evaluation[i, , ] <- statistics(x, means)
  if (i <= 5L) {
    for (j in seq_len(nrow(means))) {
      f <- aersn_mean(sweep(x, 2, means[j, ], "+"))
      h <- aersn_test(f, null = c(0, 0),
        reference = ref$hull)$statistic
      s <- aersn_test(f, null = c(0, 0), method = "shao",
        reference = ref$shao)$statistic
      checks <- c(checks,
        abs(h - evaluation[i, "hull", j]),
        abs(s - evaluation[i, "shao", j]))
    }
  }
}
stopifnot(max(checks) < 1e-7)

## =====================================================
## 6. Report rejection frequencies and simulation errors
## =====================================================
summarise <- function(cutoff, calibration_name) {
  do.call(rbind, lapply(seq_len(nrow(means)), function(j) {
    reject <- sweep(evaluation[, , j], 2, cutoff, ">")
    p <- colMeans(reject)
    se <- sqrt(p * (1 - p) / replications)
    difference <- as.numeric(reject[, 1]) -
      as.numeric(reject[, 2])
    data.frame(calibration = calibration_name,
      scenario = rownames(means)[j],
      mu1 = means[j, 1], mu2 = means[j, 2],
      hull = p[1], shao = p[2],
      hull_mcse = se[1], shao_mcse = se[2],
      hull_only = mean(reject[, 1] & !reject[, 2]),
      shao_only = mean(!reject[, 1] & reject[, 2]),
      difference = mean(difference),
      paired_mcse = sd(difference) / sqrt(replications),
      row.names = NULL)
  }))
}
results <- rbind(summarise(critical, "Brownian"),
  summarise(calibrated_critical, "VAR null simulation"))
print(results, row.names = FALSE, digits = 5)
print(rbind(Brownian = critical, VAR_null = calibrated_critical))

## =====================================================
## 7. Save numerical results and checks
## =====================================================
write.csv(results, "decision_size_power.csv", row.names = FALSE)
write.csv(data.frame(method = names(critical), Brownian = critical,
                     VAR_null = calibrated_critical), "decision_cutoffs.csv", row.names = FALSE)
write.csv(calibration, "decision_null_calibration.csv", row.names = FALSE)
flat <- data.frame(replication = seq_len(replications))
for (j in seq_len(nrow(means))) for (method in c("hull", "shao"))
  flat[[paste(rownames(means)[j], method, sep = "_")]] <- evaluation[, method, j]
write.csv(flat, "decision_evaluation_statistics.csv", row.names = FALSE)
writeLines(c("All 5000 calibration and 5000 evaluation replications retained.",
  "Calibration seed 61013; independent evaluation seed 61014.",
  "All three prespecified means evaluated on every new dataset.",
  sprintf("Maximum direct-versus-package discrepancy: %.3g", max(checks)),
  "Size-adjusted power uses separate VAR null simulations, not the evaluation data.",
  "Monte Carlo standard errors condition on the simulated critical values."),
  "decision_simulation_validation.txt")
