# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# =====================================================
## 1. Load Libraries and Set Parameters
## =====================================================
library(dlm)        # For Dynamic Linear Models (DLM)
library(ggplot2)    # For plotting graphs
library(reshape2)   # For reshaping data for ggplot

# Set seed for reproducibility
set.seed(123)

# Parameters for simulation
N <- 100            # Sample size
sigma_eta <- 0.5    # State noise (sd)
sigma_e   <- 1.0    # Observation noise (sd)

# =====================================================
## 2. Simulate Local Level Model Data
## =====================================================
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

# =====================================================
## 3. Model Building Function and MLE Estimation
## =====================================================
build_model <- function(theta) {
  dlmModPoly(order = 1, dV = exp(theta[1]), dW = exp(theta[2]))
}

init_theta   <- log(c(var(y_missing, na.rm = TRUE),
                      var(y_missing, na.rm = TRUE) / 10))
fit          <- dlmMLE(y_missing, parm = init_theta, build = build_model)
fitted_model <- build_model(fit$par)

# =====================================================
## 4. Kalman Filtering and Smoothing
## =====================================================
filtered  <- dlmFilter(y_missing, fitted_model)
smoothed  <- dlmSmooth(filtered)

# Interpolate missing values using the Kalman filter
y_interpolated <- y_missing
y_interpolated[missing_indices] <- dropFirst(filtered$m)[missing_indices]

# =====================================================
## 5. Investigate Initialization Effects
## =====================================================
# Diffuse initialization (default)
filtered_diffuse <- filtered

# Informed initialization (tight prior)
informed_model      <- fitted_model
informed_model$m0   <- mean(y_missing, na.rm = TRUE)
informed_model$C0   <- 0.01
filtered_informed   <- dlmFilter(y_missing, informed_model)

# =====================================================
## 6. Prepare Data for Plotting
## =====================================================
data_plot <- data.frame(
  Time             = 1:N,
  Observed         = y,
  True_State       = alpha,
  Filtered_Diffuse = dropFirst(filtered_diffuse$m),
  Filtered_Informed= dropFirst(filtered_informed$m),
  Smoothed         = dropFirst(smoothed$s),
  Interpolated     = y_interpolated
)

# Data for main plot (no filtered lines)
plot_data_main <- melt(
  data_plot[, c("Time", "Observed", "True_State", "Smoothed", "Interpolated")],
  id.vars = "Time"
)

# Data for filter comparison plot (only diffuse vs informed)
plot_data_filter <- melt(
  data_plot[, c("Time", "Filtered_Diffuse", "Filtered_Informed")],
  id.vars = "Time"
)

# =====================================================
## 7. Plot 1: Main illustration (observed, true, smoother, interpolated)
## =====================================================
p1 <- ggplot(plot_data_main,
             aes(x = Time, y = value, colour = variable, linetype = variable)) +
  geom_line(linewidth = 1) +
  scale_color_manual(
    breaks = c("Observed", "True_State", "Smoothed", "Interpolated"),
    values = c("grey70", "blue", "darkgreen", "purple"),
    labels = c("Observed", "True State", "Smoothed", "Interpolated")
  ) +
  scale_linetype_manual(
    breaks = c("Observed", "True_State", "Smoothed", "Interpolated"),
    values = c("solid", "solid", "solid", "solid"),
    labels = c("Observed", "True State", "Smoothed", "Interpolated")
  ) +
  labs(title = "Local Level Model: Kalman Filter and Smoother",
       y = "Value", x = "Time") +
  theme_minimal() +
  theme(legend.title = element_blank())

# Add vertical grey lines at missing observations
p1 <- p1 + geom_vline(xintercept = missing_indices,
                      colour = "grey80", linetype = "dotted")

print(p1)
ggsave(filename = "local_level_kalman_main.png",
       plot = p1, width = 6, height = 4, dpi = 300)

# =====================================================
## 8. Plot 2: Comparison of filtered (diffuse vs informed)
## =====================================================
# Optionally zoom in on the first 20 observations to emphasise differences
plot_data_filter_zoom <- subset(plot_data_filter, Time <= 20)

p2 <- ggplot(plot_data_filter_zoom,
             aes(x = Time, y = value, colour = variable, linetype = variable)) +
  geom_line(linewidth = 1) +
  scale_color_manual(
    breaks = c("Filtered_Diffuse", "Filtered_Informed"),
    values = c("blue", "orange"),
    labels = c("Filtered (Diffuse)", "Filtered (Informed)")
  ) +
  scale_linetype_manual(
    breaks = c("Filtered_Diffuse", "Filtered_Informed"),
    values = c("dashed", "dotdash"),
    labels = c("Filtered (Diffuse)", "Filtered (Informed)")
  ) +
  labs(title = "Initialization Effect: Filtered States (First 20 Periods)",
       y = "Filtered State", x = "Time") +
  theme_minimal() +
  theme(legend.title = element_blank())

print(p2)
ggsave(filename = "local_level_kalman_filters.png",
       plot = p2, width = 6, height = 4, dpi = 300)

# =====================================================
## 9. Numeric Comparison Between Initialization Methods
## =====================================================
diff_init_effect <- mean(
  abs(data_plot$Filtered_Diffuse - data_plot$Filtered_Informed),
  na.rm = TRUE
)
cat("Mean absolute difference between diffuse and informed initialization filtering:",
    round(diff_init_effect, 4), "\n")
