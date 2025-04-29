##########################################################################################
# Exponentially Weighted Moving Average (EWMA) Computation
##########################################################################################

# Define the EWMA function
ewma <- function(x, alpha = 0.1) {
  # Initialize output vector
  ewma_values <- numeric(length(x))
  
  # Set the first value of the EWMA to the first input value
  ewma_values[1] <- x[1]
  
  # Iteratively compute EWMA values
  for (i in 2:length(x)) {
    ewma_values[i] <- alpha * x[i] + (1 - alpha) * ewma_values[i - 1]
  }
  
  return(ewma_values)
}

##########################################################################################
# Example Usage
##########################################################################################

# Sample input data
data <- c(20, 22, 24, 23, 25, 28, 27, 26, 30, 29)

# Set smoothing parameter
alpha <- 0.2

# Compute EWMA
ewma_data <- ewma(data, alpha)

# Print the EWMA results
print(ewma_data)
