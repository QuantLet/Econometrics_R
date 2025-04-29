# Load necessary libraries
library(ggplot2)
library(xts)
library(rstudioapi)

# Set the working directory to the folder where the current R script is located
setwd(dirname(getActiveDocumentContext()$path))


# Perform regression
model <- lm(mpg ~ wt, data=mtcars)

# Print the regression model summary
summary(model)

# Plot the data and regression line
ggplot(mtcars, aes(x=wt, y=mpg)) + 
  geom_point() +
  geom_smooth(method="lm", se=FALSE, color="blue")


# Perform ANOVA on the regression model
anova_result <- anova(model)

# Print the results
print(anova_result)