## =====================================================
## 0. Set Random Seed and Define Small Epsilon for Numerical Stability
## =====================================================

set.seed(22)
epsilon <- 1e-3
args <- list()
args$plot <- TRUE

args$nloptr <- list(maxiter = 100,
                    method = "NLOPT_LD_MMA", #'NLOPT_LD_TNEWTON', 'NLOPT_LN_COBYLA'
                    l = c(epsilon, 0.1 + epsilon),         #mu, sigma
                    u = c(1.0 - epsilon, 1.0 - epsilon),   #mu, sigma
                    eval_g_ineq = NULL,
                    eval_jac_g_ineq = NULL,
                    check_derivatives = TRUE,
                    check_derivatives_print = "all",
                    ftol_abs = 1e-16,
                    xtol_rel = 1e-16,
                    ftol_rel = 1e-16,
                    print_level = 3)

args$DEoptim$maxiter <- 0
args$DEoptim$population <- 100
args$DEoptim$strategy <- 2

args$mode <- 'direct'

## =====================================================
## 1. Simulating GBM Data
## =====================================================

mu <- 0.5
sigma <- 0.2

initial_value <- 10
params_0 <- c(mu, sigma)
time_step <- 1 / 252  # Weekly data: time_step = 1/52

# Simulate a series from the GBM model instead of using actual data
num_points <- 10000
burn_in <- 500
factor <- 100
num_simulations <- factor * (num_points + burn_in)
delta <- time_step / factor
params <- params_0

random_noise <- rnorm(num_simulations)
simulated_values <- rep(num_simulations, 0)
simulated_values[1] <- initial_value
for (i in 2:num_simulations) {
  simulated_values[i] <- simulated_values[i - 1] + 
    (mu * simulated_values[i - 1]) * delta + sigma * simulated_values[i - 1] * sqrt(delta) * random_noise[i]
}

x <- rep(num_points, 0)
for (i in 1:num_points) {
  x[i] <- simulated_values[burn_in * factor + 1 + (i - 1) * factor]
}

## =====================================================
## 2. Optionally Change Initial Parameter to Test Stability of Calibration
## =====================================================

num_trials <- 1 # 1000  # Number of simulations
estimated_params <- matrix(0, num_trials, length(params))

for (i in 1:num_trials) {
  for (j in 1:length(params)) {
    params[j] <- runif(1, args$nloptr$l[j], args$nloptr$u[j])
  }
  print(i)
  
  ## =====================================================  
  ## 3. Estimate the MLE Parameters
  ## =====================================================
  
  output <- mle(ModelU2, x, time_step, params, args)
  estimated_params[i, ] <- output$solution
}

## =====================================================
## 4. Compute Diagnostic Information and Plot Log Likelihood Function
## =====================================================

diagnostic_results <- summary(ModelU2, x, time_step, output$solution, args)

## =====================================================
# 5. Perform Additional Diagnostics Comparing Approximate Likelihood with Exact Value
## =====================================================

objective_function <- function(params) {
  log_likelihood <- logdensity2loglik(ModelU2, x, time_step, params, args)$llk
  return(log_likelihood)
}

exact_log_likelihood <- objective_function(params_0)
grad(objective_function, params_0)
hessian(objective_function, params_0)

print(paste("Maximum log likelihood is ", exact_log_likelihood))
print(paste("Standard Error Estimate ", diagnostic_results$se))
print(paste("Huber Sandwich Error Estimate ", diagnostic_results$se_robust))

exact <- list()
exact$score <- exactscore(x, time_step, output$solution)
exact$InfoMatrix <- exactinformationmatrix(x, time_step, output$solution)
exact$H <- exacthessian(x, time_step, output$solution)
variance <- solve(exact$InfoMatrix)
inv_hessian <- solve(exact$H)
variance_robust <- inv_hessian %*% exact$InfoMatrix %*% t(inv_hessian)

exact$se <- sqrt(diag(variance))
exact$se_robust <- sqrt(diag(variance_robust))
print(paste("Exact Standard Error ", diagnostic_results$se))
print(paste("Exact Huber Sandwich Error ", diagnostic_results$se_robust))

print(paste("Error in S.E. Estimate ", 
            norm(as.matrix(diagnostic_results$se - exact$se))))
print(paste("Error in H.S.E. Estimate ", 
            norm(as.matrix(diagnostic_results$se_robust - exact$se_robust))))
print(paste("L2 Norm of Score Error ", 
            norm(as.matrix(diagnostic_results$score - exact$score))))
print(paste("L2 Norm of Hessian Error ", 
            norm(as.matrix(diagnostic_results$H - exact$H))))
print(paste("L2 Norm of Information Matrix Error ", 
            norm(as.matrix(diagnostic_results$InfoMatrix - exact$InfoMatrix))))
 