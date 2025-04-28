
library(scatterplot3d)

# Set seed for reproducibility
set.seed(42)

# Generate some example data
x1 <- rnorm(100)
x2 <- rnorm(100)
y <- 1.5 * x1 - 2 * x2 + rnorm(100)*2

# Create a PNG file to save the plot
png("ols3d.png", width=800, height=600)

# Plot with scatterplot3d
s3d <- scatterplot3d(x1, x2, y, color="blue", pch=16, main="3D Scatterplot")

# Fit a linear model
fit <- lm(y ~ x1 + x2)

# Add a regression plane to the plot
s3d$plane3d(fit)

# Add points and lines
for(i in 1:100) {
  # Convert points from 3D to 2D projection
  point3d <- s3d$xyz.convert(x1[i], x2[i], fitted(fit)[i])
  point2d <- s3d$xyz.convert(x1[i], x2[i], y[i])
  
  # Add the points and the lines to the plot
  points(point3d$x, point3d$y, col="red", pch=16)
  segments(point2d$x, point2d$y, point3d$x, point3d$y, col="blue")
}

# Close the PNG device
dev.off()
