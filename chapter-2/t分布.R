# 加载必要的库
library(ggplot2)

# 创建一个用于计算概率密度的值的序列
x <- seq(-4, 4, length.out = 100)

# 定义不同的自由度
dfs <- c(1, 5, 10, 30)

# 初始化一个空的数据框来存储结果
data <- data.frame()

# 计算每个自由度的概率密度，并将其添加到数据框中
for (df in dfs) {
  data <- rbind(data, data.frame(x = x, density = dt(x, df), df = as.factor(df)))
}

# 计算正态分布的概率密度并添加到数据框中
data <- rbind(data, data.frame(x = x, density = dnorm(x), df = 'Normal'))

# 绘制图形
p <- ggplot(data, aes(x = x, y = density, color = df)) +
  geom_line(aes(linetype = df)) +  # Use different line types for different dfs
  scale_linetype_manual(values = c("dashed", "dashed", "dashed", "dashed", "solid")) +  # t-distributions in dashed lines
  labs(title = 't-Distributions with Different Degrees of Freedom and Normal Distribution',
       x = 'Value',
       y = 'Probability Density') +
  theme_light() +  # Light theme with soft grey background
  scale_color_brewer(palette = "Dark2")

# 显示图形
print(p)

# 保存图形
ggsave("t_distributions.png", plot = p, width = 10, height = 6)
