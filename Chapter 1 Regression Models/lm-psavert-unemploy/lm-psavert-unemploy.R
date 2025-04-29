# Install required packages if not already installed
# install.packages("ggplot2")
# install.packages("xts")
# install.packages("rstudioapi")

# Load necessary libraries
library(ggplot2)
library(xts)
library(rstudioapi)

# Set the working directory to the folder where the current R script is located
setwd(dirname(getActiveDocumentContext()$path))

# Load the built-in 'economics' dataset
data("economics")

# Explore the structure of the dataset
str(economics)

# Select personal savings rate and number of unemployed as variables
data <- economics[, c("psavert", "unemploy")]

# Build a simple regression model
model <- lm(psavert ~ unemploy, data = data)

# View the summary of the model
summary(model)

# Create a scatter plot with regression line
plot1 <- ggplot(data, aes(x = unemploy, y = psavert)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Regression of Personal Savings Rate on Unemployment",
       x = "Number of Unemployed",
       y = "Personal Savings Rate") +
  theme_minimal()

# Display the plot
print(plot1)

# Save the plot as a PNG file in the same folder
ggsave("regression_plot.png", plot = plot1, width = 8, height = 6) 



# Multivariate regression 
data("economics")
# Construct the multivariate regression model
model <- lm(psavert ~ pce + pop + uempmed + unemploy, data = economics)
# View the model summary
summary(model)

# Calculate VIF
vif_values <- vif(model)
print(vif_values)


# Construct a new multivariate regression model
model <- lm(psavert ~ pop + uempmed, data = economics)

# View the model summary
summary(model)

# Variance Inflation Factor
vif(model)

