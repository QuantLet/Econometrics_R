library(ggplot2)
library(forecast)

##########################################################################################
# 1. Setup and Configuration
##########################################################################################

# Set seed for reproducibility
set.seed(123)

# Set working directory to the folder where this script is saved (only works in RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

##########################################################################################
# 2. Simulate AR(1) Process and Random Walk Process
##########################################################################################

# Parameters
n_samples <- 250
alpha_ar1 <- 0.9

# Initialize vectors
y_ar1 <- rep(0, n_samples)
y_ar1_no_shock <- rep(0, n_samples)
y_rw <- rep(0, n_samples)
y_rw_no_shock <- rep(0, n_samples)

# Generate white noise
epsilon <- rnorm(n_samples, mean = 0, sd = 1)

# Introduce a negative shock at the 100th observation
shock <- -10
epsilon_shock <- epsilon
epsilon_shock[100] <- shock

# Simulate the AR(1) and Random Walk processes
for (t in 2:n_samples) {
  y_ar1[t] <- alpha_ar1 * y_ar1[t - 1] + epsilon_shock[t]
  y_ar1_no_shock[t] <- alpha_ar1 * y_ar1_no_shock[t - 1] + epsilon[t]
  y_rw[t] <- y_rw[t - 1] + epsilon_shock[t]
  y_rw_no_shock[t] <- y_rw_no_shock[t - 1] + epsilon[t]
}

##########################################################################################
# 3. Plot AR(1) Process with and without Shock
##########################################################################################

ts_plot_ar1 <- ggplot() +
  geom_line(aes(x = 1:n_samples, y = y_ar1, color = "With Shock"), size = 1) +
  geom_line(aes(x = 1:n_samples, y = y_ar1_no_shock, color = "Without Shock"), 
            linetype = "dashed", size = 1) +
  ggtitle("AR(1) Process with and without a Negative Shock") +
  xlab("Time") + ylab("Series Value") +
  scale_color_manual(name = "", values = c("With Shock" = "blue", "Without Shock" = "red")) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80"),  # Change major gridline color
    panel.grid.minor = element_blank(),                 # Remove minor gridlines
    panel.background = element_rect(fill = "white"),    # Set panel background to white
    plot.background = element_rect(fill = "white", colour = NA),  # Set plot background to white
    axis.line = element_line(color = "black")           # Add axis lines
  )

# Save AR(1) plot
ggsave("ar1_comparison_plot.png", ts_plot_ar1, width = 7, height = 5)

##########################################################################################
# 4. Plot Random Walk Process with and without Shock
##########################################################################################

ts_plot_rw <- ggplot() +
  geom_line(aes(x = 1:n_samples, y = y_rw, color = "With Shock"), size = 1) +
  geom_line(aes(x = 1:n_samples, y = y_rw_no_shock, color = "Without Shock"), 
            linetype = "dashed", size = 1) +
  ggtitle("Random Walk with and without a Negative Shock") +
  xlab("Time") + ylab("Series Value") +
  scale_color_manual(name = "", values = c("With Shock" = "blue", "Without Shock" = "red")) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80"),  # Change major gridline color
    panel.grid.minor = element_blank(),                 # Remove minor gridlines
    panel.background = element_rect(fill = "white"),    # Set panel background to white
    plot.background = element_rect(fill = "white", colour = NA),  # Set plot background to white
    axis.line = element_line(color = "black")           # Add axis lines
  )

# Save Random Walk plot
ggsave("rw_comparison_plot.png", ts_plot_rw, width = 7, height = 5)
