# Create the output directory when this example is run on its own.
dir.create("figures", recursive = TRUE, showWarnings = FALSE)

## =====================================================
## 1. Define the scalar upper-tail probabilities
## =====================================================
# S_tail(x) and M_tail(x) give P(S > x) and P(M > x).
S_tail <- function(x) {
  if (x == 0) return(.5)
  integrate(function(th) {
    z <- x / sin(th)
    exp(.5 * (log(2 * z) - z - log1p(-exp(-2 * z))))
  }, 0, pi / 2, rel.tol = 1e-10)$value / pi
}
range_cdf <- function(r) vapply(r, function(x) {
  if (x <= 0) return(0)
  j <- 1:80
  if (x < 1) sqrt(2 * pi) * pi^2 / x^3 *
    sum(j^2 * exp(-pi^2 * j^2 / (2 * x^2)))
  else 1 - 2 * sum((4 * j^2 * x^2 - 1) * exp(-2 * j^2 * x^2))
}, numeric(1))
M_tail <- function(x) {
  if (x == 0) return(.5)
  integrate(function(r) x * dnorm(x * r) * range_cdf(r), 0, 8,
    rel.tol = 1e-10, subdivisions = 300)$value + pnorm(-8 * x)
}

## =====================================================
## 2. Invert the tails to obtain scalar critical values
## =====================================================
# For squared statistics, use alpha / 2 in each signed tail.
quant <- function(alpha,
  fun) uniroot(function(x) fun(x) - alpha,
  c(.001, 50), tol = 1e-9)$root
alpha <- c(.1, .05, .025, .01, .005, .001)
scalar <- data.frame(alpha = alpha,
  S = sapply(alpha, quant, fun = S_tail),
  M = sapply(alpha, quant, fun = M_tail),
  U1 = sapply(alpha / 2, quant, fun = S_tail)^2,
  M1sq = sapply(alpha / 2, quant, fun = M_tail)^2)
print(scalar, digits = 10)
write.csv(scalar, "critical_scalar.csv", row.names = FALSE)

## =====================================================
## 3. Tabulate the bridge-range inverse distribution
## =====================================================
# The grid converts uniform draws to bridge-range draws.
rgrid <- seq(.15, 5, length.out = 60001)
Fgrid <- range_cdf(rgrid)
use <- !duplicated(Fgrid) & Fgrid > 0 & Fgrid < 1
qrange <- approxfun(c(0, Fgrid[use], 1),
  c(0, rgrid[use], 8), rule = 2)

## =====================================================
## 4. Simulate the multivariate reference statistics
## =====================================================
# B is the number of draws; K is the truncation; qmax is
# dimension.
# Approximate the omitted bridge covariance by its
# expectation.
set.seed(61008)
B <- 100000L
K <- 512L
qmax <- 10L
weights <- 1 / (pi * seq_len(K))
tailmean <- trigamma(K + 1) / pi^2
U <- M2 <- matrix(NA_real_, B, qmax)
for (i in seq_len(B)) {
  A <- matrix(rnorm(K * qmax), K, qmax) * weights
  V <- crossprod(A) + diag(tailmean, qmax)
  Z <- rnorm(qmax)
  w <- forwardsolve(t(chol(V)), Z)
  U[i, ] <- cumsum(w^2)
  ranges <- qrange(runif(qmax))
  M2[i, ] <- cumsum((Z / ranges)^2)
  if (i %% 10000L == 0L) cat("replications", i, "\n")
}

## =====================================================
## 5. Compute multivariate critical values
## =====================================================
# Use numerical integration for the first, scalar column.
Ucv <- apply(U, 2, quantile, probs = 1 - alpha, type = 8)
Mcv <- apply(M2, 2, quantile, probs = 1 - alpha, type = 8)
Ucv[, 1] <- scalar$U1
Mcv[, 1] <- scalar$M1sq
rownames(Ucv) <- rownames(Mcv) <- alpha
write.csv(Ucv, "critical_U.csv")
write.csv(Mcv, "critical_M2.csv")

## =====================================================
## 6. Estimate Monte Carlo error and save the results
## =====================================================
# Twenty independent batches quantify simulation uncertainty.
mcse <- function(z) {
  arr <- sapply(split(seq_len(B), rep(1:20, each = B / 20)),
    function(ii)
      as.vector(apply(z[ii, , drop = FALSE], 2, quantile,
        probs = 1 - alpha, type = 8)))
  matrix(apply(arr, 1, sd) / sqrt(20), length(alpha), qmax)
}
write.csv(mcse(U), "critical_U_mcse.csv")
write.csv(mcse(M2), "critical_M2_mcse.csv")
saveRDS(list(S = scalar, U = Ucv, M2 = Mcv, B = B, K = K,
  seed = 61008,
  scalar_MC = data.frame(alpha,
    S = quantile(sqrt(U[, 1]), 1 - 2 * alpha, type = 8),
    M = quantile(sqrt(M2[, 1]), 1 - 2 * alpha, type = 8))),
"critical_checks.rds")
print(Ucv)
print(Mcv)

## =====================================================
## 7. Compare the signed densities and save the figure
## =====================================================
# Random signs recover the symmetric scalar distributions.
sgn <- sample(c(-1, 1), B, replace = TRUE)
ds <- density(sgn * sqrt(U[, 1]), from = -12, to = 12,
  n = 2048)
dm <- density(sgn * sqrt(M2[, 1]), from = -12, to = 12,
  n = 2048)
draw_densities <- function() {
  oldpar <- par(no.readonly = TRUE)
  on.exit({
    layout(1)
    par(oldpar)
  })
  layout(matrix(1:2, ncol = 1), heights = c(1, 0.16))
  par(mar = c(4.2, 4.2, 0.8, 0.8))
  plot(dm, lwd = 2, col = "#184e77", xlab = "Statistic",
    main = "",
    ylim = c(0, max(dm$y)))
  lines(ds, lwd = 2, col = "#9d4c3c")
  curve(dnorm(x), add = TRUE, lty = 2)
  par(mar = rep(0, 4))
  plot.new()
  legend("center",
    c("Range M", "Self-normalised S", "Standard normal"),
    col = c("#184e77", "#9d4c3c", "black"), lty = c(1, 1, 2),
    lwd = c(2, 2, 1),
    bty = "n", horiz = TRUE, cex = 0.9, seg.len = 3)
}
pdf("figures/dist-m-hat.pdf", width = 7, height = 4.5)
draw_densities()
dev.off()
png("figures/dist-m-hat.png", width = 2100, height = 1350,
  res = 300)
draw_densities()
dev.off()
