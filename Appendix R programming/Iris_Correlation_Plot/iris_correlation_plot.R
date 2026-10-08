# Correlation panel in Figure A.3, using the built-in iris data.
# If needed: install.packages("corrplot")
library(corrplot)
numeric_iris <- iris[, 1:4]
correlations <- cor(numeric_iris)
dir.create("figures", showWarnings = FALSE)
png("figures/correlation-iris.png", width = 800, height = 600, res = 120)
corrplot(correlations, method = "circle", cl.pos = "b")
dev.off()
write.csv(correlations, "iris_correlations.csv")
