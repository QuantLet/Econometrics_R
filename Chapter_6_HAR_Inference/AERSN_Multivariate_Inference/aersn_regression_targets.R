# Run aersn_multivariate_inference.R first to create the saved inputs.
library(aersn)
stopifnot(file.exists("simulated_vector_series.csv"), file.exists("reference_draws.rds"))
Y <- as.matrix(read.csv("simulated_vector_series.csv"))
refs <- readRDS("reference_draws.rds")
ref_h <- refs$hull
ref_s <- refs$shao
n <- nrow(Y)
# BEGIN BOOK REGRESSION
set.seed(61011)
u <- as.numeric(arima.sim(list(ar = 0.5), n = n))
dat <- data.frame(x1 = Y[, 1], x2 = Y[, 2])
dat$y <- 1 + 0.8 * dat$x1 - 0.4 * dat$x2 + u
ols <- lm(y ~ x1 + x2, data = dat)
slopes <- aersn_lm(ols, target = c("x1", "x2"))
aersn_test(slopes, null = c(0.8, -0.4), reference = ref_h)
aersn_contrast(slopes, rbind(sum = c(1, 1)),
               type = "simultaneous", reference = ref_h)
# END BOOK REGRESSION

# Independently construct all OLS influences before selecting slopes.
X <- model.matrix(ols)
Q <- crossprod(X) / n
psi <- (X * residuals(ols)) %*% solve(Q)
psi <- psi[, c("x1", "x2"), drop = FALSE]
G <- rbind(c(0, 0), apply(sweep(psi, 2, colMeans(psi)), 2, cumsum)) / sqrt(n)
z <- sqrt(n) * (coef(ols)[c("x1", "x2")] - c(0.8, -0.4))
V <- crossprod(G) / n
stat <- drop(crossprod(z, solve(V, z)))
result <- aersn_test(slopes, null = c(0.8, -0.4), method = "shao", reference = ref_s)
stopifnot(abs(as.numeric(result$statistic) - stat) < 1e-8)
write.csv(dat, "simulated_regression_data.csv", row.names = FALSE)
writeLines(sprintf("OLS influence calculation agrees to %.3g.",
                   abs(as.numeric(result$statistic) - stat)), "regression_validation.txt")
