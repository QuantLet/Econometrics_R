# 加载必要的库
library(ggplot2)
library(forecast)

folder <- c("/Users/sunjiajing/Desktop/Hong2020/金融计量经济学：理论、案例与R语言/R代码/第三章")
setwd(folder)

# 设置种子以保证结果的可重现性
set.seed(123)

# 模拟AR(1)过程
n_samples <- 500
alpha <- 0.9
y <- rep(0, n_samples)
epsilon <- rnorm(n_samples, 0, 1)

for (t in 2:n_samples) {
  y[t] <- alpha * y[t-1] + epsilon[t]
}

# 时间序列图
ts_plot <- ggplot(data.frame(t=1:n_samples, y=y), aes(x=t, y=y)) +
  geom_line() +
  ggtitle(expression("Simulated series for "~y[t]==0.9*y[t-1]+epsilon[t])) +
  xlab("t") + ylab(expression(y[t]))

# 保存时间序列图为PNG
ggsave("AR1_plot.png", ts_plot, width = 7, height = 5)

# ACF 和 PACF 图
png("AR1_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)

par(mfrow=c(1, 2))
Acf(y, main=expression("ACF for " ~ y[t] == 0.9 * y[t-1] + epsilon[t]))
Pacf(y, main=expression("PACF for " ~ y[t] == 0.9 * y[t-1] + epsilon[t]))
dev.off()



