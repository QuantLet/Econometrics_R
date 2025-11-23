## =====================================================
## 1. Prepare environment & set working directory
## =====================================================

# Set working directory (optional for RStudio users)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Load required packages
# install.packages("WDI")
# install.packages("quantmod")
# install.packages("lmtest")
library(WDI)
library(quantmod)
library(lmtest)

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

aux_gdp <- lm(
  res_gdp2[(p_gdp + 1):T_gdp] ~ res_gdp2[1:(T_gdp - p_gdp)]
)

lm_stat_gdp <- summary(aux_gdp)$r.squared * (T_gdp - p_gdp)

cat("GDP: LM test statistic for ARCH effects:", lm_stat_gdp, "\n")
cat("GDP: Asymptotic reference: Chi-squared with", p_gdp, "df.\n")

# --- McLeod–Li test on annual GDP growth ---

sigma2_gdp    <- mean(res_gdp2)
res_gdp2_dm   <- res_gdp2 - sigma2_gdp
gamma0_gdp    <- var(res_gdp2_dm)

gammaj_gdp <- sapply(1:p_gdp, function(j) {
  mean(res_gdp2_dm[(j + 1):T_gdp] * res_gdp2_dm[1:(T_gdp - j)], na.rm = TRUE)
})

rho_gdp  <- gammaj_gdp / gamma0_gdp
ml_stat_gdp <- T_gdp * sum(rho_gdp^2)

cat("GDP: McLeod–Li statistic ML(p):", ml_stat_gdp, "\n")
cat("GDP: Asymptotic reference: Chi-squared with", p_gdp, "df.\n")

## =====================================================
## 3. Monthly U.S. industrial production (FRED)
##    LM and McLeod–Li tests
## =====================================================

# INDPRO: Industrial Production Index (U.S.)
getSymbols("INDPRO", src = "FRED")

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

aux_ip <- lm(
  res_ip2[(p_ip + 1):T_ip] ~ res_ip2[1:(T_ip - p_ip)]
)

lm_stat_ip <- summary(aux_ip)$r.squared * (T_ip - p_ip)

cat("IP: LM test statistic for ARCH effects:", lm_stat_ip, "\n")
cat("IP: Asymptotic reference: Chi-squared with", p_ip, "df.\n")

# --- McLeod–Li test on monthly IP growth ---

sigma2_ip   <- mean(res_ip2)
res_ip2_dm  <- res_ip2 - sigma2_ip
gamma0_ip   <- var(res_ip2_dm)

gammaj_ip <- sapply(1:p_ip, function(j) {
  mean(res_ip2_dm[(j + 1):T_ip] * res_ip2_dm[1:(T_ip - j)], na.rm = TRUE)
})

rho_ip    <- gammaj_ip / gamma0_ip
ml_stat_ip <- T_ip * sum(rho_ip^2)

cat("IP: McLeod–Li statistic ML(p):", ml_stat_ip, "\n")
cat("IP: Asymptotic reference: Chi-squared with", p_ip, "df.\n")