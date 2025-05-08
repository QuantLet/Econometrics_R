# Load libraries
library(dlm)
library(ggplot2)
library(reshape2)

# Set seed for reproducibility
set.seed(123)

# Parameters
N <- 100  # Sample size
sigma_eta <- 0.5  # State noise (sd)
sigma_e <- 1.0    # Observation noise (sd)

# Simulate local level model data
alpha <- numeric(N)
alpha[1] <- rnorm(1, 0, 10)

for (t in 2:N) {
  alpha[t] <- alpha[t - 1] + rnorm(1, 0, sigma_eta)
}
y <- alpha + rnorm(N, 0, sigma_e)

# Introduce missing observations (~10% random)
missing_indices <- sort(sample(1:N, size = round(0.1 * N), replace = FALSE))
y_missing <- y
y_missing[missing_indices] <- NA

# Model building function
build_model <- function(theta) {
  dlmModPoly(order = 1, dV = exp(theta[1]), dW = exp(theta[2]))
}

# MLE estimation of model parameters
init_theta <- log(c(var(y_missing, na.rm=TRUE), var(y_missing, na.rm=TRUE)/10))
fit <- dlmMLE(y_missing, parm = init_theta, build = build_model)

# Estimated model parameters
fitted_model <- build_model(fit$par)

# Kalman filtering and smoothing
filtered <- dlmFilter(y_missing, fitted_model)
smoothed <- dlmSmooth(filtered)

# Interpolate missing values
y_interpolated <- y_missing
y_interpolated[missing_indices] <- dropFirst(filtered$m)[missing_indices]

# Investigate initialization effects
# Diffuse initialization (default)
filtered_diffuse <- filtered

# Informed initialization (tight prior)
informed_model <- fitted_model
informed_model$m0 <- mean(y_missing, na.rm=TRUE)
informed_model$C0 <- 0.01
filtered_informed <- dlmFilter(y_missing, informed_model)

# Prepare data for plotting
data_plot <- data.frame(
  Time = 1:N,
  Observed = y,
  True_State = alpha,
  Filtered_Diffuse = dropFirst(filtered_diffuse$m),
  Filtered_Informed = dropFirst(filtered_informed$m),
  Smoothed = dropFirst(smoothed$s),
  Interpolated = y_interpolated
)

# Melt data for ggplot
plot_data <- melt(data_plot, id.vars = "Time")

# Plot results
p <- ggplot(plot_data, aes(x = Time, y = value, color = variable, linetype = variable)) +
  geom_line(linewidth = 1) +
  scale_color_manual(
    values = c("black", "blue", "red", "orange", "darkgreen", "purple"),
    breaks = c("Observed", "True_State", "Filtered_Diffuse",
               "Filtered_Informed", "Smoothed", "Interpolated"),
    labels = c("Observed", "True State", "Filtered (Diffuse)",
               "Filtered (Informed)", "Smoothed", "Interpolated")
  ) +
  scale_linetype_manual(
    values = c("solid", "solid", "dashed", "dotdash", "solid", "solid"),
    breaks = c("Observed", "True_State", "Filtered_Diffuse",
               "Filtered_Informed", "Smoothed", "Interpolated"),
    labels = c("Observed", "True State", "Filtered (Diffuse)",
               "Filtered (Informed)", "Smoothed", "Interpolated")
  ) +
  labs(title = "Local Level Model: Kalman Filter and Smoother",
       y = "Value", x = "Time") +
  theme_minimal() +
  theme(legend.title = element_blank())

# Add vertical grey lines at missing observations
p <- p + geom_vline(xintercept = missing_indices, color = "grey", linetype = "dotted")

# Save plot
ggsave(filename = "local_level_kalman_plot.png", plot = p, width = 10, height = 6)

# Display plot
print(p)

# Numeric comparison between initialization methods
diff_init_effect <- mean(abs(data_plot$Filtered_Diffuse - data_plot$Filtered_Informed), na.rm=TRUE)
cat("Mean absolute difference between diffuse and informed initialization filtering:", 
    round(diff_init_effect, 4), "\n")
