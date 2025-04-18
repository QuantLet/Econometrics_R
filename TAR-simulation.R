set.seed(123) # For reproducibility
n <- 200 # Number of observations
y <- numeric(n) # Initialize the time series vector
y[1] <- rnorm(1) # Starting value of the series

for (t in 2:n) {
  epsilon_t <- rnorm(1, mean = 0, sd = 1) # Generate a random shock from N(0,1)
  if (y[t-1] < 0) {
    y[t] <- -1.5 * y[t-1] + epsilon_t
  } else {
    y[t] <- 0.5 * y[t-1] + epsilon_t
  }
}

library(ggplot2)

# Convert the time series into a dataframe
data <- data.frame(Time = 1:n, Value = y)

ggplot_object <- ggplot(data, aes(x = Time, y = Value)) +
  geom_line() + 
  theme_minimal() + 
  labs(title = "Simulated TAR(1) Process with 200 Observations",
       x = "Time", y = "Value")

# Display the plot
print(ggplot_object)

# Save the plot as a PNG file
ggsave("TAR_Process_Simulation.png", plot = ggplot_object, width = 10, height = 6, dpi = 300)