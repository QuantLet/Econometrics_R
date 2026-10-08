# Create the output directory when this example is run on its own.
dir.create("figures", recursive = TRUE, showWarnings = FALSE)

## =====================================================
## 1. Load libraries for time-indexed data
##    and kernel density estimation
## =====================================================
library(quantmod)     # for time-indexed data
library(ks)           # provides multivariate kernel density estimation

## =====================================================
## 2. Read saved FTSE 100 and DAX data for 2024
## =====================================================
ftse <- read.csv("FTSE_close_2015_2024.csv")
ftse <- ftse[ftse$date >= "2024-01-01", ]
dax <- read.csv("DAX_close_2024.csv")
ftse_prices <- xts(ftse$close,as.Date(ftse$date))
dax_prices <- xts(dax$close,as.Date(dax$date))
# Daily log returns in percent. Missing returns are omitted.
ftse_returns <- na.omit(diff(log(ftse_prices))) * 100
dax_returns <- na.omit(diff(log(dax_prices))) * 100

# Convert to data frames with correct date index names
ftse_returns_df <- data.frame(Date = index(ftse_returns),
                   FTSE_Returns = coredata(ftse_returns))
dax_returns_df <- data.frame(Date = index(dax_returns),
                  DAX_Returns = coredata(dax_returns))

# Merge the data by date (ensure both data frames have the same Date column)
market_returns <- merge(ftse_returns_df, dax_returns_df, by = "Date", all = TRUE)

# Remove rows with NA values
market_returns_clean <- na.omit(market_returns)

# Rename columns to match the desired names
colnames(market_returns_clean) <- c("Date", "FTSE_Returns", "DAX_Returns")

## =====================================================
## 3. Perform Multivariate Kernel Density Estimation
## =====================================================
# Convert the cleaned data frame to a matrix for multivariate analysis
data_matrix <- as.matrix(market_returns_clean[, c("FTSE_Returns", "DAX_Returns")])

# Perform multivariate kernel density estimation explicitly with ks::kde()
kde_result <- ks::kde(x = data_matrix)

## =====================================================
## 4. 2D and 3D Visualization using ks package
## =====================================================

# Save both views of the same fitted density.
png("figures/2d-density.png",width=1600,height=1200,res=200)
plot(kde_result,display="filled.contour",xlab="FTSE return (%)",
     ylab="DAX return (%)",main="Joint return density, 2024")
dev.off()
png("figures/3d-density.png",width=1600,height=1200,res=200)
plot(kde_result,display="persp",xlab="FTSE return (%)",
     ylab="DAX return (%)",zlab="Density",theta=35,phi=25)
dev.off()
