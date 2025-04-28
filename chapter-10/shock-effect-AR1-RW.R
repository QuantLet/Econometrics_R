library(ggplot2)
library(forecast)

# 设置种子以保证结果的可重现性
set.seed(123)
folder <- c("/Users/sunjiajing/Desktop/Hong2020/金融计量经济学：理论、案例与R语言/R代码/第三章")
setwd(folder) 

# 模拟AR(1)过程和Random Walk过程
n_samples <- 250
alpha_ar1 <- 0.9
y_ar1 <- rep(0, n_samples)
y_ar1_no_shock <- rep(0, n_samples)
y_rw <- rep(0, n_samples)
y_rw_no_shock <- rep(0, n_samples)
epsilon <- rnorm(n_samples, 0, 1)

# 引入一个负冲击在第100个观测
shock <- -10
epsilon_shock <- epsilon
epsilon_shock[100] <- shock

for (t in 2:n_samples) {
  y_ar1[t] <- alpha_ar1 * y_ar1[t-1] + epsilon_shock[t]
  y_ar1_no_shock[t] <- alpha_ar1 * y_ar1_no_shock[t-1] + epsilon[t]
  y_rw[t] <- y_rw[t-1] + epsilon_shock[t]
  y_rw_no_shock[t] <- y_rw_no_shock[t-1] + epsilon[t]
}

# 绘制AR(1)过程的时间序列图比较有无冲击的效果
ts_plot_ar1 <- ggplot() +
  geom_line(aes(x=1:n_samples, y=y_ar1, color="With Shock"), size=1) +
  geom_line(aes(x=1:n_samples, y=y_ar1_no_shock, color="Without Shock"), linetype="dashed", size=1) +
  ggtitle("AR(1) Process with and without a Negative Shock") +
  xlab("Time") + ylab("Series Value") +
  scale_color_manual(name="", values=c("With Shock"="blue", "Without Shock"="red")) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80"), # 修改主要网格线颜色
    panel.grid.minor = element_blank(), # 移除次要网格线
    panel.background = element_rect(fill = "white"), # 修改背景为白色
    plot.background = element_rect(fill = "white", colour = NA), # 修改绘图区域背景为白色
    axis.line = element_line(color = "black") # 增加轴线 
  )

ggsave("ar1_comparison_plot.png", ts_plot_ar1, width = 7, height = 5)

# 绘制Random Walk过程的时间序列图比较有无冲击的效果
ts_plot_rw <- ggplot() +
  geom_line(aes(x=1:n_samples, y=y_rw, color="With Shock"), size=1) +
  geom_line(aes(x=1:n_samples, y=y_rw_no_shock, color="Without Shock"), linetype="dashed", size=1) +
  ggtitle("Random Walk with and without a Negative Shock") +
  xlab("Time") + ylab("Series Value") +
   scale_color_manual(name="", values=c("With Shock"="blue", "Without Shock"="red")) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80"), # 修改主要网格线颜色
    panel.grid.minor = element_blank(), # 移除次要网格线
    panel.background = element_rect(fill = "white"), # 修改背景为白色
    plot.background = element_rect(fill = "white", colour = NA), # 修改绘图区域背景为白色
    axis.line = element_line(color = "black") # 增加轴线 
    )

ggsave("rw_comparison_plot.png", ts_plot_rw, width = 7, height = 5)