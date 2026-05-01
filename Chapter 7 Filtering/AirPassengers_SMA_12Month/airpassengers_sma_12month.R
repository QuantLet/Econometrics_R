
# Optional: set working directory to current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}
# =====================================================
## 1. Load Libraries, Data, and Calculate SMA
# =====================================================
library(ggplot2)

# Load the AirPassengers dataset
data("AirPassengers")

# Convert AirPassengers time series to a numeric vector
airpassengers_data <- as.numeric(AirPassengers)

# Define the window size for the SMA (12 months)
window_size <- 12

# Calculate the SMA using the 'filter' function from the 'stats' package
sma <- stats::filter(airpassengers_data, rep(1/window_size, window_size), sides = 2)

# Create a data frame for ggplot2
df <- data.frame(
  Year = time(AirPassengers)[!is.na(sma)],
  Original = airpassengers_data[!is.na(sma)],
  SMA = sma[!is.na(sma)]
)

# =====================================================
## 2. Plot the Data with ggplot2
# =====================================================
ggplot(df, aes(x = Year)) +
  geom_line(aes(y = Original, linetype = "Original"), color = "blue", size = 1) +
  geom_line(aes(y = SMA, linetype = "12-month SMA"), color = "red", size = 1.2) +
  scale_linetype_manual(values = c("Original" = "solid",
                                   "12-month SMA" = "dashed"),
                        name = NULL) +
  labs(title = "AirPassengers Data with 12-Month SMA", 
       y = "Number of Passengers", x = "Year")  

ggsave("sma_airpassenger.png", dpi = 300, width = 6, height = 4) 
