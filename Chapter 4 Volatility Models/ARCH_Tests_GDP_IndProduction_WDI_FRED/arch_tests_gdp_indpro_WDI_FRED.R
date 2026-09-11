## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required packages
# install.packages("WDI")
# install.packages("quantmod")
# install.packages("lmtest")
library(WDI)
library(quantmod)
library(lmtest)

arch_lm_test <- function(residuals, p) {
  z <- embed(residuals^2, p + 1)
  aux_data <- as.data.frame(z)
  names(aux_data) <- c("current", paste0("lag", 1:p))
  aux_fit <- lm(current ~ ., data = aux_data)
  statistic <- nrow(aux_data) * summary(aux_fit)$r.squared
  list(
    statistic = statistic,
    parameter = p,
    p.value = pchisq(statistic, df = p, lower.tail = FALSE)
  )
}

mcleod_li_test <- function(residuals, p) {
  Box.test(residuals^2, lag = p, type = "Ljung-Box")
}

## =====================================================
## 2. Annual U.S. GDP growth (WDI)
##    LM and McLeod–Li tests
## =====================================================

# WDI indicator: NY.GDP.MKTP.KD.ZG = GDP growth (annual %)
gdp_raw <- WDI(
  country   = "US",
  indicator = "NY.GDP.MKTP.KD.ZG",
  start     = 1960,
  end       = 2023
)

# Keep year and indicator, remove missing values, sort by year
gdp_data <- gdp_raw[order(gdp_raw$year), c("year", "NY.GDP.MKTP.KD.ZG")]
gdp_data <- na.omit(gdp_data)

Y_gdp <- as.numeric(gdp_data$NY.GDP.MKTP.KD.ZG)
n_gdp <- length(Y_gdp)

# AR(1) mean model for annual GDP growth
mean_model_gdp <- lm(Y_gdp[2:n_gdp] ~ Y_gdp[1:(n_gdp - 1)])

res_gdp   <- mean_model_gdp$residuals
T_gdp     <- length(res_gdp)
res_gdp2  <- res_gdp^2

# Choose lag order p for annual data (e.g. 4 lags)
p_gdp <- 4

# --- LM test (Engle) on annual GDP growth ---

lm_gdp <- arch_lm_test(res_gdp, p_gdp)
lm_stat_gdp <- lm_gdp$statistic

cat("GDP: LM test statistic for ARCH effects:", lm_stat_gdp, "\n")
cat("GDP: Asymptotic reference: Chi-squared with", p_gdp, "df.\n")
cat("GDP: LM p-value:", lm_gdp$p.value, "\n")

# --- McLeod–Li test on annual GDP growth ---

ml_gdp <- mcleod_li_test(res_gdp, p_gdp)
ml_stat_gdp <- unname(ml_gdp$statistic)

cat("GDP: McLeod-Li statistic ML(p):", ml_stat_gdp, "\n")
cat("GDP: Asymptotic reference: Chi-squared with", p_gdp, "df.\n")
cat("GDP: McLeod-Li p-value:", ml_gdp$p.value, "\n")

## =====================================================
## 3. Monthly U.S. industrial production (FRED)
##    LM and McLeod–Li tests
## =====================================================

# INDPRO: Industrial Production Index (U.S.)
getSymbols("INDPRO", src = "FRED",
           from = "1960-01-01", to = "2023-12-31")

# Monthly growth rate (log difference * 100)
ip  <- na.omit(INDPRO)
ip_g <- diff(log(ip)) * 100   # monthly IP growth in percent

Y_ip <- as.numeric(ip_g)
n_ip <- length(Y_ip)

# AR(1) mean model for monthly IP growth
mean_model_ip <- lm(Y_ip[2:n_ip] ~ Y_ip[1:(n_ip - 1)])

res_ip   <- mean_model_ip$residuals
T_ip     <- length(res_ip)
res_ip2  <- res_ip^2

# Choose lag order p for monthly data (e.g. 12 lags: one year)
p_ip <- 12

# --- LM test (Engle) on monthly IP growth ---

lm_ip <- arch_lm_test(res_ip, p_ip)
lm_stat_ip <- lm_ip$statistic

cat("IP: LM test statistic for ARCH effects:", lm_stat_ip, "\n")
cat("IP: Asymptotic reference: Chi-squared with", p_ip, "df.\n")
cat("IP: LM p-value:", lm_ip$p.value, "\n")

# --- McLeod–Li test on monthly IP growth ---

ml_ip <- mcleod_li_test(res_ip, p_ip)
ml_stat_ip <- unname(ml_ip$statistic)

cat("IP: McLeod-Li statistic ML(p):", ml_stat_ip, "\n")
cat("IP: Asymptotic reference: Chi-squared with", p_ip, "df.\n")
cat("IP: McLeod-Li p-value:", ml_ip$p.value, "\n")
