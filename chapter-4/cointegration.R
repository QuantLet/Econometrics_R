rm(list = ls())  
library(tidyverse)
library(ggplot2)

# Load the dataset
data("EuStockMarkets")
 
# Convert the EuStockMarkets data to a tibble and then to long format
eu_stocks_long <- as_tibble(EuStockMarkets) %>% 
  mutate(Date = as.Date(1:nrow(.), origin = "1991-01-01")) %>% 
  gather(key = "Index", value = "Value", -Date)

# Use ggplot2 to plot the data
ggplot(data = eu_stocks_long, aes(x = Date, y = Value, color = Index)) + 
  geom_line() +
  theme_minimal() +
  labs(title = "EuStockMarkets Time Series",
       x = "Date",
       y = "Index Value",
       color = "Index")

#################################################################################
 
# Load packages
library(quantmod)
library(urca)


# Load packages
library(quantmod)
library(urca)

# Fetch macroeconomic data from FRED
getSymbols("GDPC1", src = "FRED")  # Real GDP
getSymbols("UNRATE", src = "FRED")  # Unemployment Rate

# Combine data into one data frame
macro_data <- na.omit(merge(GDPC1, UNRATE))

# Look at the structure
head(macro_data)
# Prepare the data for cointegration test
data_diff <- diff(as.matrix(macro_data))

# Phillips-Ouliaris test
ptest <- po.test(macro_data, demean = "constant")
summary(ptest)


# Johansen test
jtest <- ca.jo(data_diff, type = "trace", ecdet = "const", spec = "longrun", K = 2)
summary(jtest)





