## =====================================================
## 1. Load necessary libraries
## =====================================================
library(ggplot2)
library(KernSmooth)

## =====================================================
## 2. Load the built-in mtcars dataset and extract variables
## =====================================================
data(mtcars)

# Extract variables
x <- mtcars$hp  # Horsepower
y <- mtcars$mpg # Miles per Gallon

## =====================================================
## 3. Select optimal bandwidth using dpill
## =====================================================
bw <- dpill(x, y)

## =====================================================
## 4. Perform Nadaraya–Watson kernel regression using locpoly
## =====================================================
fit <- locpoly(x, y, bandwidth = bw, degree = 0, kernel = "normal", gridsize = 100)

## =====================================================
## 5. Create a fine grid for plotting
## =====================================================
# Fine grid for smooth interpolation
x_fine <- seq(min(x), max(x), length.out = 100)

# Interpolate the predicted values for the fine grid
y_pred <- approx(fit$x, fit$y, xout = x_fine)$y

# Combine into a data frame for ggplot
fit_df <- data.frame(x_fine = x_fine, y_pred = y_pred)

## =====================================================
## 6. Plot the results using ggplot2
## =====================================================
p <- ggplot() +
  geom_point(data = data.frame(x, y), aes(x, y)) +
  geom_line(data = fit_df, aes(x_fine, y_pred), color = "blue", size = 1) +
  labs(title = "Nadaraya–Watson Estimation",
       x = "Horsepower", y = "Miles per Gallon") 

# Save the plot as a PNG file
ggsave(filename = "Nadaraya_Watson_Estimation.png", plot = p,
       width = 6, height = 4, dpi = 300)