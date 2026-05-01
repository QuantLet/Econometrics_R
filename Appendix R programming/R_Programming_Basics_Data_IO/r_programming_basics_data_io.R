## =====================================================
## Basic arithmetic and constants
## =====================================================

5 + 9
15 - 7
6 * 8
45 / 9
2^5
sqrt(49)
pi
exp(1)
log(exp(1))

## =====================================================
## Loops and apply-family examples
## =====================================================

for (i in 1:6) {
  print(i)
}

i <- 0
while (i < 5) {
  i <- i + 1
  print(i)
}

i <- 0
repeat {
  i <- i + 1
  print(i)
  if (i >= 5) break
}

lapply(0:5, function(a) { a + 1 })
sapply(0:5, function(a) { a + 1 })

add_fun <- function(a) { a + 1 }
add_fun(5)

## =====================================================
## Data structures
## =====================================================

vec <- c(1, 2, 3, 4, 5)
print(vec)

lst <- list(name = "Alice", age = 30, scores = c(85, 90, 95))
print(lst)

df <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(30, 25, 35),
  score = c(85, 90, 95)
)
print(df)

mat <- matrix(1:9, nrow = 3, ncol = 3)
print(mat)

arr <- array(1:12, dim = c(2, 3, 2))
print(arr)

fctr <- factor(c("low", "medium", "high", "medium"),
               levels = c("low", "medium", "high"))
print(fctr)

## =====================================================
## Local files and external file formats
## =====================================================

getwd()

# Replace this with the folder containing your data file.
# setwd("/path/to/your/project")

# macro_data <- read.csv("macro_panel.csv")

# install.packages("readxl")
# library(readxl)
# survey2 <- read_excel("household_survey.xlsx", sheet = "Wave1")

# install.packages("haven")
# library(haven)
# stata_df <- read_dta("macro_panel.dta")
# spss_df <- read_sav("experiment_data.sav")

## =====================================================
## Subsetting, aggregation, and saving objects
## =====================================================

AirPassengers[2:4]
mdeaths[mdeaths > 1500]

avg_mpg_by_cyl <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
print(avg_mpg_by_cyl)

avg_mpg_hp_by_cyl_gear <- aggregate(cbind(mpg, hp) ~ cyl + gear,
                                    data = mtcars, FUN = mean)
print(avg_mpg_hp_by_cyl_gear)

avg_mdeaths <- mean(mdeaths)
print(avg_mdeaths)

fit <- lm(mpg ~ wt + hp, data = mtcars)
saveRDS(fit, file = "reg_mpg_model.rds")
fit2 <- readRDS("reg_mpg_model.rds")
print(summary(fit2))

residuals_fit <- resid(fit)
coef_fit <- coef(fit)
save(fit, residuals_fit, coef_fit, file = "reg_outputs.RData")

example_df <- data.frame(x = 1:5, y = c(2, 4, 6, 8, 10))
write.csv(example_df, file = "example_output.csv", row.names = FALSE)

## =====================================================
## Basic graphics with built-in data
## =====================================================

co2
plot(co2)

png("co2_plot.png", width = 800, height = 600, res = 120)
plot(co2, main = "Atmospheric CO2 Concentration",
     ylab = "ppm", xlab = "Year")
dev.off()

head(iris)

png("hist-iris.png", width = 800, height = 600, res = 120)
hist(iris$Sepal.Length, main = "Histogram of Sepal Length",
     xlab = "Sepal length")
dev.off()

png("scatter-iris.png", width = 800, height = 600, res = 120)
plot(iris$Sepal.Length, iris$Sepal.Width,
     col = iris$Species, pch = 19,
     xlab = "Sepal length", ylab = "Sepal width")
dev.off()

png("box-plot-iris.png", width = 800, height = 600, res = 120)
boxplot(Sepal.Length ~ Species, data = iris,
        main = "Sepal Length by Species")
dev.off()
