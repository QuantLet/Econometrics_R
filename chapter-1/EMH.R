
rm(list=ls())  
 
folder <- c("/Users/sunjiajing/Desktop/Hong2020/金融计量经济学：理论、案例与R语言/R代码/第五章/EMH")
setwd(folder)  

library(tseries)

# Load the data
stock.prices <- read.csv("stocks_price_10.csv")

# Use augumented Dickey-Fuller test to test EMH 

# Initialize a vector to store the summary
summary_results <- c()

# Loop through each price series and interpret the ADF test results
for(i in 2:ncol(stock.prices)) {
  # Run the ADF test
  test_result <- adf.test(stock.prices[,i], alternative = "stationary")
  
  # Format the result string with the p-value
  if (test_result$p.value < 0.05) {
    result <- paste(names(stock.prices)[i], ": Stationary. p-value =", round(test_result$p.value, 4)) 
  } else {
    result <- paste(names(stock.prices)[i], ": Random Walk. p-value =", round(test_result$p.value, 4)) 
  }
  
  # Add the result to the summary vector
  summary_results <- c(summary_results, result)
}

# Print the summary results
summary_results
 

# Use Runs tests 


# Calculate the log returns for each column (except the date column)
returns <- as.data.frame(lapply(stock.prices[,-1], function(x) c(NA, diff(log(x)))))

# Rename the columns to indicate they are returns
names(returns) <- paste0(names(returns), "_Return")

# Combine the date and the returns data
stock.returns <- cbind(stock.prices[,1], returns) [-1,]

# View the first few rows of the returns data
head(stock.returns)
 

# Load the randtests package for runs test
library(randtests)

# Assuming you already have the stock.returns data frame with the log returns

# Initialize a vector to store the runs test summary
runs_test_results <- c() 

# Loop through each return series and perform the runs test
for(i in 2:ncol(stock.returns)) {
  # Extract the returns, removing NA values
  return_series <- na.omit(stock.returns[,i])
  
  # Perform the runs test
  test_result <- runs.test(return_series)
  
  # Format the result string with the p-value
  result <- paste(names(stock.returns)[i], ": Runs Test p-value =", round(test_result$p.value, 4))
  
  # Add the result to the runs test summary vector
  runs_test_results <- c(runs_test_results, result)
}

# Print the runs test summary results
runs_test_results


