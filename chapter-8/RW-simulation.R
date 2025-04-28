library(ggplot2)
library(forecast)

# 设置种子以保证结果的可重现性
set.seed(123)
folder <- c("/Users/sunjiajing/Desktop/Hong2020/金融计量经济学：理论、案例与R语言/R代码/第三章")
setwd(folder)
# 模拟Random Walk过程
n_samples <- 500
y <- rep(0, n_samples)
epsilon <- rnorm(n_samples, 0, 1)

# 随机游走模型不需要前一个状态的权重，因此alpha被设为1
for (t in 2:n_samples) {
  y[t] <- y[t-1] + epsilon[t]
}

# 时间序列图
ts_plot <- ggplot(data.frame(t=1:n_samples, y=y), aes(x=t, y=y)) +
  geom_line() +
  ggtitle(expression("Simulated series for "~y[t]==y[t-1]+epsilon[t])) +
  xlab("t") + ylab(expression(y[t]))

# 保存时间序列图为PNG
ggsave("random_walk_plot.png", ts_plot, width = 7, height = 5)

# ACF 和 PACF 图
png("rw_acf_pacf_plot.png", width = 14, height = 7, units = "in", res = 300)
par(mfrow=c(1, 2))
Acf(y, main=expression("ACF for " ~ y[t] ==  y[t-1] + epsilon[t]))
Pacf(y, main=expression("PACF for " ~ y[t] ==  y[t-1] + epsilon[t]))
dev.off()
