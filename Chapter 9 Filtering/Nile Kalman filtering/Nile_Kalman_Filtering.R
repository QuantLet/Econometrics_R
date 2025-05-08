# Load libraries
library(dlm)
library(ggplot2)
library(reshape2)

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load built-in Nile River dataset
data("Nile")
y <- as.numeric(Nile)
N <- length(y)

# Model-building function for the local level model
build_model <- function(theta) {
  dlmModPoly(order = 1, dV = exp(theta[1]), dW = exp(theta[2]))
}

# MLE estimation of model parameters using full data
init_theta <- log(c(var(y), var(y) / 10))
fit <- dlmMLE(y, parm = init_theta, build = build_model)
fitted_model <- build_model(fit$par)

# Kalman filter and smoother with default (diffuse) initialization
filtered_diffuse <- dlmFilter(y, fitted_model)
smoothed <- dlmSmooth(filtered_diffuse)

# Informed initialization (tight prior on the first state)
informed_model <- fitted_model
informed_model$m0 <- mean(y)
informed_model$C0 <- 0.01
filtered_informed <- dlmFilter(y, informed_model)

# Prepare data for plotting
data_plot <- data.frame(
  Time = time(Nile),
  Observed = y,
  Filtered_Diffuse = dropFirst(filtered_diffuse$m),
  Filtered_Informed = dropFirst(filtered_informed$m),
  Smoothed = dropFirst(smoothed$s)
)

# Reshape for plotting
plot_data <- melt(data_plot, id.vars = "Time")

# Plot
p <- ggplot(plot_data, aes(x = Time, y = value, color = variable, linetype = variable)) +
  geom_line(size = 1) +
  scale_color_manual(
    values = c("red", "blue", "orange", "darkgreen"),
    labels = c("Observed", "Filtered (Diffuse)", "Filtered (Informed)", "Smoothed")
  ) +
  scale_linetype_manual(
    values = c("solid", "dashed", "dotdash", "solid"),
    labels = c("Observed", "Filtered (Diffuse)", "Filtered (Informed)", "Smoothed")
  ) +
  labs(title = "Nile River Flow: Kalman Filtering and Smoothing",
       y = "Flow (10^8 m³)", x = "Year") +
  theme_minimal() +
  theme(legend.title = element_blank())

# Display plot
print(p)

# Compare the filtered results from both initializations
diff_init_effect <- mean(abs(data_plot$Filtered_Diffuse - data_plot$Filtered_Informed), na.rm = TRUE)
cat("Mean absolute difference between diffuse and informed filtering: ", 
    round(diff_init_effect, 4), "\n")
