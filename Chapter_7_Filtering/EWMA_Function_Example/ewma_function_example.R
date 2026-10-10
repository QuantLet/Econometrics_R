## =====================================================
## 1. Define the Exponentially Weighted Moving Average (EWMA) Function
## =====================================================
ewma <- function(x, alpha = 0.1) {
  if (length(alpha) != 1L || !is.finite(alpha) ||
      alpha <= 0 || alpha >= 1) {
    stop("alpha must be a finite number strictly between 0 and 1")
  }
  if (length(x) == 0L) {
    return(numeric(0))
  }

  # Initialize the EWMA vector with the same length as input
  ewma_values <- numeric(length(x))

  # Set the first value of EWMA to the first value of the input
  ewma_values[1] <- x[1]

  # Loop through the data starting from the second element, when present
  if (length(x) > 1L) {
    for (i in seq.int(2L, length(x))) {
      ewma_values[i] <- (1 - alpha) * x[i] + alpha * ewma_values[i - 1]
    }
  }

  return(ewma_values)
}

# =====================================================
## 2. Example Usage of EWMA Function
## =====================================================
data <- c(20, 22, 24, 23, 25, 28, 27, 26, 30, 29)  # Example input data
alpha <- 0.2  # Smoothing parameter for the EWMA

# Apply EWMA function to the data
ewma_data <- ewma(data, alpha)

# Print the EWMA Values
print(ewma_data)
